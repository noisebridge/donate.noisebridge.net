FROM ubuntu:latest

ENV LANG C.UTF-8
RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential \
	git \
	libpq-dev \
	nodejs \
	ruby-full \
	tzdata \
	zlib1g-dev
RUN gem install bundler

ENV PROJROOT /home/noisebridge
WORKDIR ${PROJROOT}
RUN mkdir -p ${PROJROOT}
COPY . ${PROJROOT}
RUN mkdir -p ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && git archive master | tar -x -C ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)

RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && bundle install
RUN cd ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD) && RAILS_ENV=production bin/rake assets:precompile

CMD ["passanger-config", "restart-app", ${PROJROOT}/noisebridge-donate-$(git rev-parse HEAD)]
