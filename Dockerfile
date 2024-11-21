# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=2-buster
FROM ruby:$RUBY_VERSION as base

# Rails app lives here
WORKDIR /rails

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
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rake assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y default-mysql-client libsqlite3-0 libvips postgresql-client nodejs && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --home /rails --shell /bin/bash && \
  chown rails:rails . && \
  chown -R rails:rails db log tmp $BUNDLE_PATH
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bundle", "exec", "foreman", "start"]
