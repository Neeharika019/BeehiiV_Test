# Docker Deployment Guide

This guide explains how to deploy the Newsletter Application using Docker.

## Prerequisites

- Docker installed on your system
- Docker Compose installed
- At least 2GB of available RAM

## Quick Start (Development)

### 1. Build and Run with Docker Compose

```bash
# Build and start all services
docker-compose up --build

# Run in background
docker-compose up -d --build
```

### 2. Access the Application

- **Application**: http://localhost:2000
- **Database**: localhost:5432
- **Credentials**: 
  - Username: `admin`
  - Password: `secure_password_123`

### 3. View Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs web
docker-compose logs db
```

### 4. Stop the Application

```bash
docker-compose down
```

## Production Deployment

### 1. Build Production Image

```bash
# Build production image
docker build -f Dockerfile.production -t newsletter-app:production .

# Or build with custom tag
docker build -f Dockerfile.production -t your-registry/newsletter-app:latest .
```

### 2. Set Environment Variables

Create a `.env` file for production:

```bash
# Database
DATABASE_URL=postgresql://postgres:password@db:5432/newsletter_app_production

# Authentication
AUTH_USERNAME=your_secure_username
AUTH_PASSWORD=your_secure_password

# Rails
RAILS_ENV=production
SECRET_KEY_BASE=your_generated_secret_key_base

# Generate secret key base
# bundle exec rake secret
```

### 3. Run Production Stack

```bash
# Start production services
docker-compose -f docker-compose.production.yml up -d
```

## Docker Commands Reference

### Building Images

```bash
# Build development image
docker build -t newsletter-app:dev .

# Build production image
docker build -f Dockerfile.production -t newsletter-app:prod .
```

### Running Containers

```bash
# Run with custom environment variables
docker run -p 2000:2000 \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db \
  -e AUTH_USERNAME=admin \
  -e AUTH_PASSWORD=secure \
  newsletter-app:prod

# Run with volume mounts
docker run -p 2000:2000 \
  -v $(pwd)/logs:/app/log \
  -v $(pwd)/tmp:/app/tmp \
  newsletter-app:prod
```

### Database Operations

```bash
# Run database migrations
docker-compose exec web bundle exec rake db:migrate

# Seed the database
docker-compose exec web bundle exec rake db:seed

# Reset database
docker-compose exec web bundle exec rake db:drop db:create db:migrate db:seed
```

### Maintenance

```bash
# View running containers
docker ps

# Execute commands in running container
docker-compose exec web bundle exec rails console

# View container logs
docker-compose logs -f web

# Stop and remove containers
docker-compose down -v

# Remove all images
docker system prune -a
```

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using the port
   netstat -ano | findstr :2000
   
   # Kill the process or change port in docker-compose.yml
   ```

2. **Database connection issues**
   ```bash
   # Check if database is running
   docker-compose ps
   
   # Restart database service
   docker-compose restart db
   ```

3. **Permission issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   ```

4. **Build failures**
   ```bash
   # Clean Docker cache
   docker system prune -a
   
   # Rebuild without cache
   docker-compose build --no-cache
   ```

### Health Checks

```bash
# Check application health
curl http://localhost:2000/api/subscribers

# Check database connection
docker-compose exec web bundle exec rake db:version
```

## Security Considerations

1. **Change default passwords** in production
2. **Use secrets management** for sensitive data
3. **Enable HTTPS** in production
4. **Regular security updates** for base images
5. **Network isolation** between containers

## Scaling

```bash
# Scale web service
docker-compose up -d --scale web=3

# Use load balancer for multiple instances
```

## Monitoring

```bash
# Monitor resource usage
docker stats

# View container metrics
docker-compose exec web bundle exec rake stats
``` 