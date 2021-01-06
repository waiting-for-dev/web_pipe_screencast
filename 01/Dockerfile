FROM ruby:3.0
RUN gem install rack -v 2.2.3 && \
    gem install web_pipe -v 0.12.1 && \
    gem install rerun -v 0.13.1 && \
    gem install puma -v 5.1.1
ENV APP_USER web_pipe_user
RUN useradd -ms /bin/bash $APP_USER
USER $APP_USER
WORKDIR /home/$APP_USER/app
