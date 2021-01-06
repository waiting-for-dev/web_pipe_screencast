FROM ruby:2.7.1
ENV APP_USER web_pipe_user
RUN useradd -ms /bin/bash $APP_USER
USER $APP_USER
WORKDIR /home/$APP_USER/app
COPY --chown=$APP_USER Gemfile .
