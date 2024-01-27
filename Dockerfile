FROM ruby:latest

RUN gem install rackup sinatra puma

COPY views ./views

COPY api ./api
COPY myapp.rb .

COPY public ./public

COPY data ./data

EXPOSE 80

CMD ["ruby", "myapp.rb", "-o", "0.0.0.0", "-p", "80"]