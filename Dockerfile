FROM ruby:2.5
RUN mkdir /vend
WORKDIR /vend

ADD Gemfile /vend/Gemfile
ADD Gemfile.lock /vend/Gemfile.lock

RUN bundle install
ADD . /vend
