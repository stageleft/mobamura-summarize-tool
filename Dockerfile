FROM ruby:latest

RUN gem install thin sinatra

COPY ui ./ui
COPY tabulator-master.zip ./ui

COPY api ./api
COPY myapp.rb .


EXPOSE 4567

CMD ["ruby", "myapp.rb"]