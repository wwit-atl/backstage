FROM ruby:2-buster

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
  && apt-get purge -y imagemagick imagemagick-6-common

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libffi-dev tzdata postgresql-client yarn

RUN apt update && apt install -y libffi-dev tzdata postgresql-client nodejs npm yarn

WORKDIR /backstage

COPY . .
RUN gem install bundler:1.17.3 && \
  # throw errors if Gemfile has been modified since Gemfile.lock
  bundle config --global frozen 1 &&
RUN bundle package --all

CMD ["foreman start"]
