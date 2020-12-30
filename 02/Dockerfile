FROM ruby:2.7.1
ENV APP_HOME /app/
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile .
RUN bundle
