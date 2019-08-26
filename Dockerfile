FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential postgresql-client

ENV APP_HOME /mentors4me-api
ENV POSTGRES_HOST postgres
ENV POSTGRES_USER postgres

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
