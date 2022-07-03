FROM ruby:latest

RUN gem install thin sinatra
RUN gem install nokogiri

COPY views ./views
COPY tabulator-master.zip ./views
RUN unzip ./views/tabulator-master.zip -d ./views
RUN mv ./views/tabulator-master/dist/js ./views/js

COPY api ./api
COPY myapp.rb .

EXPOSE 80

CMD ["ruby", "myapp.rb", "-p", "80"]