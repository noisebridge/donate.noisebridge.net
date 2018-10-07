FROM ubuntu:latest

ENV LANG C.UTF-8
RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential \
	dirmngr \
	git \
	gnupg \
	libpq-dev \
	nodejs \
	ruby-full \
	tzdata \
	zlib1g-dev
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
RUN apt-get update
RUN apt-get install -y libnginx-mod-http-passenger
RUN gem install bundler

ENV PROJROOT /home/noisebridge
WORKDIR ${PROJROOT}
RUN mkdir -p ${PROJROOT}
COPY . ${PROJROOT}
RUN mkdir -p ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && git archive master | tar -x -C ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)

RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && bundle install
RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && RAILS_ENV=production bin/rake assets:precompile

CMD ["passenger-config", "restart-app", "${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)"]
