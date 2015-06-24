# Noisebridge-donate

[![Circle CI](https://circleci.com/gh/patrickod/noisebridge-donate/tree/master.svg?style=svg)](https://circleci.com/gh/patrickod/noisebridge-donate/tree/master)

A really simple rails application to accept credit card donations for [Noisebridge](https://noisebridge.net)

## Installation

### Requirements

  * PostgreSQL
  * Ruby 2.2.0
  * foreman `gem install foreman`

If you have `rbenv` and `ruby-build` installed you should be able to do the following
```bash
rbenv install
gem install bundler
rbenv rehash
bundle install
```

### Running with secrets
The secrets for the development environment are kept encrypted in the `.env` file. `git-crypt` will unlock them.

To run the rails server locally with the secrets loaded use `foreman start web`

### Running without secrets
To run the rails server locally without the secrets simply `mv .env .env.foo`
and run as normally `foreman start web`. Be mindful not to commit this move to
git.

### Databases

This setup assumes that you have a PostgreSQL user `noisebridge` locally who is the owner of `noisebridge_donate_development` and `noisebridge_donate_test` databases.

