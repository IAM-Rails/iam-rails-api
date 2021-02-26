# iam-rails-api
Grape API for Iam Rails project

## Prerequisites

* Ruby 2.7.2p137

* Rails 6.0.3.5

* Bundler 2.1.4

* PostgreSQL 13

## Setup development environment

```
git clone https://github.com/iam-rails/iam-rails-api.git
```

```
git co development
```


### Bundle required gems

```
bundle install
```

### Database creation, migration and seeds

```
rails db:create
```

```
rails db:migrate
```

```
rails db:seed
```

### Run unit test

```
rake
```

### Allow overcommit to lint before commits

```
overcommit install
```

```
overcommit --sign
```

## Setup production environment

```
git clone https://github.com/iam-rails/iam-rails-api.git
```

```
git co master
```

```
docker-compose up
```
