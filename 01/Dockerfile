FROM ruby:2.7
ENV APP_HOME /app/
RUN gem install rack web_pipe rerun
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
