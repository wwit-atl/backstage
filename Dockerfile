# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=2-buster
FROM ruby:$RUBY_VERSION as base

# Rails app lives here
WORKDIR /rails

# Debian 10 (buster) is EOL and was removed from deb.debian.org, which breaks
# every apt-get update in this file. Buster still exists on archive.debian.org,
# so repoint there. Applied in `base` so both the build and final stages inherit
# it. Its Release files are past Valid-Until, hence Check-Valid-Until false;
# buster-updates does not exist in the archive at all, so drop it.
#
# This pins us to a distribution that receives no security updates. That is the
# same tradeoff already accepted for Rails 4.2 and the pinned gems -- see
# CLAUDE.md on the frozen stack. Revisit only alongside a base-image move.
RUN sed -i \
      -e 's|deb.debian.org/debian-security|archive.debian.org/debian-security|g' \
      -e 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' \
      -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
      -e '/buster-updates/d' \
      /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development" \
  DB_NAME=${DB_NAME} \
  DB_HOST=${DB_HOST} \
  DB_PORT=${DB_PORT} \
  DB_USERNAME=${DB_USERNAME} \
  DB_PASSWORD=${DB_PASSWORD}

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev libsqlite3-dev git libpq-dev libvips pkg-config libsqlite3-dev nodejs

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:1.17.3
RUN bundle install && rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && bundle exec bootsnap precompile --gemfile


# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
#
# Drop the Sprockets/Sass cache in the same layer it is created. It is 56MB
# across 6,482 files that exist only to speed up compilation, and Kamal mounts a
# volume over /rails/tmp at runtime so it is masked and never read. Removing it
# here rather than in the final stage matters: layers are additive, so deleting
# it later would leave the bytes in the image anyway.
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rake assets:precompile && \
  rm -rf tmp/cache


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y default-mysql-client libsqlite3-0 libvips postgresql-client nodejs && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Create the runtime user before the COPYs so ownership can be applied inline.
RUN useradd rails --home /rails --shell /bin/bash

# Copy built artifacts: gems, application.
#
# --chown on COPY assigns ownership as the layer is written. Doing it afterwards
# with `chown -R` forces overlayfs to copy up every file it touches: on the gem
# bundle that meant ~15 minutes of build time and a second full copy of the
# bundle in the image.
COPY --from=build --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# tmp/ and log/ are excluded from the build context (see .dockerignore), so
# create them empty here. Kamal mounts a volume over /rails/tmp at runtime.
#
# Application code stays root-owned so the running app cannot rewrite itself.
# Only the directories it must write to are handed over.
RUN mkdir -p /rails/tmp /rails/log && \
  chown rails:rails /rails && \
  chown -R rails:rails /rails/db /rails/log /rails/tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bundle", "exec", "foreman", "start"]
