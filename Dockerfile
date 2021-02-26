FROM ruby:2.7.2-alpine as development-stage
LABEL author=luilver@gmail.com

RUN apk add --no-cache --update \
    build-base \
    gmp-dev \
    postgresql-dev \
    tzdata \
    curl

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install --no-document bundler && bundle install

EXPOSE 3000

ENTRYPOINT bundle exec rails

CMD server -b 0.0.0.0 3000
