FROM ruby:2.3.0
MAINTAINER "Patrick O'Doherty <p@trickod.com>"

RUN apt-get update && apt-get install -y build-essential

RUN apt-get install libpq-dev

ENV APP_HOME /srv/donate.noisebridge.net
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_PATH=/bundler_cache

ADD Gemfile* $APP_HOME/

RUN bundle install

ADD . $APP_HOME
