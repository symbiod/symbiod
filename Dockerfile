FROM ruby:2.5.1
MAINTAINER HowToHireMe Team <opensource@howtohireme.ru>
ARG master_key

RUN apt-get -y update
RUN apt-get -y install nodejs netcat

WORKDIR /app
COPY ./ .
ENV RAILS_ENV production
ENV RAILS_MASTER_KEY=$master_key

# Setup ELK logs shipper
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.0-amd64.deb
RUN dpkg -i filebeat-6.4.0-amd64.deb

RUN wget https://raw.githubusercontent.com/logzio/public-certificates/master/COMODORSADomainValidationSecureServerCA.crt
RUN mkdir -p /etc/pki/tls/certs
RUN cp COMODORSADomainValidationSecureServerCA.crt /etc/pki/tls/certs/

RUN gem install foreman
RUN bundle install
# TODO: for some reason official ruby image does not load gems from
# vendor/bundle, where bundler installs gems with --deployment flag
# --deployment --without development test
RUN cp config/database.yml.sample config/database.yml

RUN rails assets:precompile

CMD rm -f /app/tmp/pids/server.pid && rails db:migrate:with_data && foreman start -f Procfile.production
