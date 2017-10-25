FROM ruby:2.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE ${SECRET_KEY_BASE}

ARG JCORU_URL
ENV JCORU_URL ${JCORU_URL}

ARG MYSQL_USER
ENV MYSQL_USER ${MYSQL_USER}

ARG MYSQL_PASSWORD
ENV MYSQL_PASSWORD ${MYSQL_PASSWORD}

ARG MYSQL_SOCKET_PATH
ENV MYSQL_SOCKET_PATH ${MYSQL_SOCKET_PATH}

RUN bundle exec rake db:migrate

CMD ["bundle", "exec", "rackup", "--port", "8080", "-o", "0.0.0.0"]
