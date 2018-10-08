FROM ruby:2.4

ENV LANG C.UTF-8
RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential \
	dirmngr \
	git \
	gnupg \
	libpq-dev \
	nodejs \
	tzdata \
	zlib1g-dev
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
# RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
# RUN apt-get update
# RUN apt-get install -y libnginx-mod-http-passenger
RUN gem install bundler puma

ENV PROJROOT /home/noisebridge
ENV RAILS_ENV production
WORKDIR ${PROJROOT}
RUN mkdir -p ${PROJROOT}
COPY . ${PROJROOT}
RUN mkdir -p ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && git archive master | tar -x -C ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)
# RUN mv ${PROJROOT}/.env ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)/.env

RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && bundle install
RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && bin/rake assets:precompile

CMD ["bundle", "exec", "puma", "${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)"]
