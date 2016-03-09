FROM ruby:2.3.0
MAINTAINER "Patrick O'Doherty <p@trickod.com>"

RUN apt-get update && apt-get install -y build-essential

# postgresql client bindings
RUN apt-get install -y libpq-dev

# javascript runtime for asset pipeline
RUN apt-get install -y nodejs

ENV APP_HOME /srv/donate.noisebridge.net
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

ADD Gemfile* $APP_HOME/

RUN bundle install

ADD . $APP_HOME
