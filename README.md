# Noisebridge-donate

[![CircleCI](https://circleci.com/gh/noisebridge/donate.noisebridge.net/tree/master.svg?style=svg)](https://circleci.com/gh/noisebridge/donate.noisebridge.net/tree/master)

A really simple rails application to accept credit card donations for [Noisebridge](https://noisebridge.net)

## Installation

### Requirements

  * PostgreSQL
  * Ruby 2.3.0
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

**NB: You must be aded to the list of secrets users before you can decrypt the .env file**

If you don't have access to the decrypted `.env` file locally you'll likely see
an error like so when you attempt to attempt to run the Rails console or server
locally. 
```
/home/patrickod/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/dotenv-2.1.1/lib/dotenv/parser.rb:44:in `split': invalid byte sequence in UTF-8 (ArgumentError)
```

This is because `dotenv` is attempting to parse a non-ASCII file (the
encrypted blob). Simply `rm .env` to remove the local copy. If you want to run
with local development Stripe API credentials for the Noisebridge account ask
@patrickod to add you to the list of PGP keys that can decrypt the `.env` file.


#### 

To run the rails server locally with the secrets loaded use `foreman start web`

### Running without secrets
To run the rails server locally without the secrets simply `mv .env .env.foo`
and run as normally `foreman start web`. Be mindful not to commit this move to
git.

### Databases

This setup assumes that you have a PostgreSQL user `noisebridge` locally who is the owner of `noisebridge_donate_development` and `noisebridge_donate_test` databases.

