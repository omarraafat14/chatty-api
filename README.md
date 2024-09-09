# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Chatty API

This repository implements the Instabug Backend Challenge: a chat system using Ruby on Rails with Elasticsearch, Redis, and MySQL.

## Ruby Version
- Ruby 3.x (You can change the version in the `.ruby-version` file)

## System Dependencies
- MySQL 5.7
- Redis (for job queuing)
- Elasticsearch 8.x
- Docker (recommended for containerization)

## Configuration
Before running the project, ensure the following environment variables are set in the `.env` file:

```
MYSQL_ROOT_PASSWORD=<your_mysql_root_password>
DB_NAME=<your_database_name>
DB_USERNAME=<your_database_username>
DB_PASSWORD=<your_database_password>
REDIS_URL=redis://redis:6379/1
DATABASE_URL=mysql2://<DB_USERNAME>:<DB_PASSWORD>@db:3306/<DB_NAME>
ELASTICSEARCH_URL=http://elasticsearch:9200
```

## Database Creation
1. Run the following to create the database:
   ```
   rails db:create
   rails db:migrate
   ```

## How to Run the Application
To run the application using Docker:
1. Build and start the containers:
   ```
   docker-compose up --build
   ```

2. The application will be available at `http://localhost:3000`.

## How to Run the Test Suite
The test suite uses RSpec. To run the tests:
1. Run the following command:
   ```
   docker-compose run web bundle exec rspec
   ```

## Services
- **Elasticsearch**: Used for message search functionality.
- **Redis**: Used for background job processing (Sidekiq).

## Deployment Instructions
- Docker Compose is used to manage services. You can deploy the stack by running `docker-compose up` in any environment that supports Docker.

## Bonus Points
- A Golang microservice can be added for the chat and message creation endpoints (optional).