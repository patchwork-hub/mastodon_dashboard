FROM ruby:3.3.0-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libjemalloc-dev \
    curl \
    gnupg \
    build-essential \
    software-properties-common

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get install -y --no-install-recommends \
    bzip2 \
    git \
    shared-mime-info \
    ca-certificates \
    libffi-dev \
    libpq-dev \
    libgdbm-dev \
    libssl-dev \
    libyaml-dev \
    patch \
    procps \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    default-mysql-client \
    default-libmysqlclient-dev \
    openssl \
    tzdata \
    file \
    imagemagick \
    iproute2 \
    nodejs \
    yarn \
    ffmpeg \
    supervisor \
    libvips42 \
    libxrender1 \
    fonts-wqy-zenhei \
    libjemalloc2 \
    vim \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=noninteractive
ENV app_path=/usr/app
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
# Remove LD_PRELOAD from here, will be set in entrypoint script
ENV RAILS_ENV="production"

# Create patchwork user and group
RUN groupadd -r patchwork && useradd -r -g patchwork -d $app_path -s /bin/bash patchwork

WORKDIR $app_path

# Install Bundler
RUN gem install bundler -v 2.6.6 

# Copy Gemfile first for better caching
COPY Gemfile* ./
RUN bundle config set --local deployment 'true'
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 4

# Copy the rest of the application
ADD . $app_path

# Copy supervisord configuration (as root)
COPY ./supervisord.conf /etc/supervisord.conf

# Create directories that patchwork user needs to write to
RUN mkdir -p $app_path/tmp/pids $app_path/log $app_path/storage

# Set Executable Permission for Entrypoint (as root)
RUN chmod +x /usr/app/docker-entrypoint.sh

# Change ownership to patchwork user
RUN chown -R patchwork:patchwork $app_path

# Switch to patchwork user
USER patchwork

# Precompile Assets (as patchwork user)
RUN bundle exec rake assets:clean
RUN bundle exec rake assets:precompile

ENTRYPOINT ["/usr/app/docker-entrypoint.sh"]

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisord.conf"]