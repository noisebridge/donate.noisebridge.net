# Noisebridge-donate

A really simple rails application to accept credit card donations for [Noisebridge](https://noisebridge.net)

## Installation

### Requirements

  * PostgreSQL
  * Ruby 2.2.0

If you have `rbenv` and `ruby-build` installed you should be able to do the following
```bash
rbenv install
gem install bundler
rbenv rehash
bundle install
```

### Databases

This setup assumes that you have a PostgreSQL user `noisebridge` locally who is the owner of `noisebridge_donate_development` and `noisebridge_donate_test` databases.

