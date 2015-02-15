#!/bin/bash -ex

# Make new directory for release
mkdir -p ~/noisebridge-donate-$(git rev-parse HEAD) && git archive master | tar -x -C ~/noisebridge-donate-$(git rev-parse HEAD)

cd ~/noisebridge-donate-$(git rev-parse HEAD)

# Prepare the release
bundle install && bin/rake assets:precompile


# Update the current symlink
ln -nfs $(pwd) $HOME/current

# restart nginx
sudo passenger-config restart-app ~/current
