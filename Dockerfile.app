FROM ruby:2.7.2

RUN apt -y install libpq-dev
RUN gem install bundler

RUN mkdir /app
ADD . /app
WORKDIR /app

RUN bundle install --deployment --path vender/bundle

EXPOSE 4567
CMD ["bundle", "exec", "ruby", "app.rb", "-o0.0.0.0"]
