# Newsletter Application

A full-stack newsletter application built with Rails and React for managing subscribers.

## Features

- ✅ **Subscriber Management**: Add, view, and update subscriber status
- ✅ **Email Validation**: Unique, case-insensitive email addresses with proper validation
- ✅ **Status Management**: Active/Inactive subscriber status
- ✅ **Server-side Pagination**: Efficient pagination for large subscriber lists
- ✅ **Error Handling**: Comprehensive error notifications and validation
- ✅ **Environment Variables**: Configurable authentication credentials
- ✅ **Database Persistence**: PostgreSQL database with proper migrations
- ✅ **Comprehensive Testing**: Model and controller tests with RSpec

## The Stack

#### Server
- Language
  - Ruby 3.1.2
  - Rails 6.1
  - Node 16
  - PostgreSQL

#### Client
- React 17
- Tailwind CSS
- Axios for API calls

# Development Getting Started

    # Clone and setup repo
    git clone <your-repo-url>
    cd challenge

    # Install and setup server dependencies
    bundle install
    bundle exec rake db:create db:migrate db:seed
    yarn install

    # Set up environment variables (optional)
    # Copy ENVIRONMENT_VARIABLES.md for reference

## Run it

    # Backend (http://localhost:2000)
    bundle exec foreman start

    # Frontend (http://localhost:2001)
    yarn watch:app

    # view at http://localhost:2001, basic auth is username/password (see `config.ru`)

## Test It

    # Setup test DB for testing
    ./scripts/setup_test_db

    # Run tests
    bundle exec rspec

## Lint It

    bundle exec standardrb

## Environment Variables

The application uses environment variables for authentication. See `ENVIRONMENT_VARIABLES.md` for details.

Default credentials:
- Username: `username`
- Password: `password`

## API Endpoints

- `GET /api/subscribers` - List subscribers with pagination
- `POST /api/subscribers` - Create a new subscriber
- `PATCH /api/subscribers/:id` - Update subscriber status

## Database Schema

### Subscribers Table
- `id` (Primary Key)
- `name` (String, optional)
- `email` (String, required, unique, case-insensitive)
- `status` (String, default: 'active', values: 'active'/'inactive')
- `created_at` (Timestamp)
- `updated_at` (Timestamp)

## What it contains

### Index Page

![image](https://user-images.githubusercontent.com/5751986/148653166-031d7c6e-8dc2-4db9-9d28-3db71a8599d9.png)

### Add Subscriber Modal

![image](https://user-images.githubusercontent.com/5751986/148653171-4a30cf43-5f42-435c-bc68-82f44524ee50.png)

### Update Subscriber Status Modal

![image](https://user-images.githubusercontent.com/5751986/148653182-3a282533-dbb8-4d96-a511-5a5008cf3daf.png)

## Deployment

This application is ready for deployment to platforms like Heroku. Make sure to:

1. Set up environment variables in your hosting platform
2. Configure the database
3. Run migrations: `bundle exec rake db:migrate`
4. Seed initial data: `bundle exec rake db:seed`
