FROM ruby:latest

RUN gem install thin sinatra
RUN gem install nokogiri

COPY views ./views

COPY api ./api
COPY myapp.rb .

COPY data ./data

EXPOSE 80

CMD ["ruby", "myapp.rb", "-o", "0.0.0.0", "-p", "80"]