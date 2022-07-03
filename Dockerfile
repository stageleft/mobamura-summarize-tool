FROM ruby:latest

RUN gem install thin sinatra

COPY ui ./ui
RUN cd ./ui && npm install

COPY api ./api
COPY myapp.rb .


EXPOSE 4567

CMD ["ruby", "myapp.rb"]