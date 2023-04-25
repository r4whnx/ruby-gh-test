FROM ruby:3.0-slim

RUN mkdir /app
COPY . ./app
WORKDIR /app
EXPOSE 2000

CMD ["ruby", "./server.rb"]
