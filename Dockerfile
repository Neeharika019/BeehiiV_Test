# Use the official Ruby image as base
FROM ruby:3.1.2

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 16.x
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Copy client directory for yarn install
COPY client/ ./client/

# Install Node.js packages
RUN yarn install

# Copy the rest of the application
COPY . .

# Precompile assets
RUN cd client && yarn build

# Create a non-root user
RUN useradd -m -u 1000 app
RUN chown -R app:app /app
USER app

# Expose port
EXPOSE 2000

# Start the application
CMD ["bundle", "exec", "puma", "-p", "2000", "-C", "./config/puma.rb"] 