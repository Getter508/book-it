# BookIt

BookIt is a book review Rails app that integrates with Google Books and OpenLibrary APIs to import and validate book information. It allows users to track and review the books they have read and track the books they would like to read.

[ ![Codeship Status for Getter508/book-it](https://app.codeship.com/projects/75795590-c1d6-0136-4ecd-36058d66dee7/status?branch=master)](https://app.codeship.com/projects/313753)

## Getting Started
### Prerequisites
- ruby version 2.5.1
- PostgreSQL (to install with Homebrew, `brew install postgresql`)

### Setup
Clone the GitHub repo ([Cloning Instructions](https://help.github.com/articles/cloning-a-repository/)).

Then run `bundle install`.

Note: If you do not have bundler, you will need to run `gem install bundler` before `bundle install`.

### Database Initialization
To create and seed the database:
```
rake db:create
rake db:migrate
rake db:seed
```

### Environment
The `.env.example` file shows the environment variables required for your `.env` file.
- Follow the AWS S3 instructions to [sign up for S3](https://docs.aws.amazon.com/AmazonS3/latest/gsg/SigningUpforS3.html) (and/or an AWS account if you do not already have one) and [create an IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) with 'Programmatic access'. This will generate the Access Key ID and the Secret Access Key.
- Follow the AWS instructions to [create buckets](https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html) for storing objects. Note: You will need a bucket for both development and production.
- Follow the Google Books API [instructions](https://developers.google.com/books/docs/v1/using) for 'Acquiring and using an API key'.

## Testing
BookIt uses RSpec and Capybara for testing. To run the test suite, simply run `rspec`.

## Deployment
Refer to the following sections of [Getting Started on Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby) for setup and deploying:
- Introduction
- Set up
- Deploy the app

Before visiting the app:
- [Migrate your database](https://devcenter.heroku.com/articles/getting-started-with-rails5#migrate-your-database) to Heroku (`heroku run rake db:migrate`)
- [Set your config vars](https://devcenter.heroku.com/articles/config-vars#managing-config-vars) using Heroku's CLI or Dashboard - You will need to do this for all your `.env` variables except the DEVELOPMENT_S3_BUCKET.

## Built With
- [OpenLibrary API](https://openlibrary.org/developers/api)
- [Google Books API](https://developers.google.com/books/)
- [AWS S3](https://aws.amazon.com/s3/)
- [Devise](https://github.com/plataformatec/devise)
- [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
- [Foundation](https://foundation.zurb.com/)

## Authors
- Sarah Getter

## Acknowledgements
I would like to thank my wonderful mentors who helped me build out feature specs and performed code reviews.
