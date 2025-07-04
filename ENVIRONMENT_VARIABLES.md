# Environment Variables

This application requires the following environment variables to be set:

## Authentication
- `AUTH_USERNAME`: Username for basic authentication (default: "username")
- `AUTH_PASSWORD`: Password for basic authentication (default: "password")

## Database
- `DATABASE_URL`: PostgreSQL connection string

## Rails
- `RAILS_ENV`: Rails environment (development, production, test)
- `SECRET_KEY_BASE`: Rails secret key base for session encryption

## Example .env file
```
AUTH_USERNAME=your_username_here
AUTH_PASSWORD=your_secure_password_here
DATABASE_URL=postgresql://localhost/newsletter_app_development
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_base_here
```

## Deployment
For production deployment, make sure to set these environment variables in your hosting platform (Heroku, etc.). 