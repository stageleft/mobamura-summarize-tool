FROM ruby:latest

RUN gem install thin sinatra
RUN gem install nokogiri

COPY views ./views

COPY api ./api
COPY myapp.rb .

EXPOSE 80

CMD ["ruby", "myapp.rb", "-p", "80"]