FROM ruby:latest

RUN gem install thin sinatra

COPY api ./api
COPY ui ./ui
COPY myapp.rb .

EXPOSE 4567

CMD ["ruby", "myapp.rb"]