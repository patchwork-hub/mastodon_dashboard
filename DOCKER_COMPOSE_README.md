# Patchwork Dashboard - Docker Compose Setup

This setup provides separate Docker Compose files for Basic and MVP versions of Patchwork Dashboard. 

## Files Overview

| File | Purpose |
|------|---------|
| `docker-compose.basic.yml` | Basic version with essential features |
| `docker-compose.mvp.yml` | MVP version with advanced features |
| `.env.example` | Environment template (shared by both versions) |

## Quick Start

### Setup Basic Version
```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit .env with your settings (optional)
nano .env

# 3. Start Basic version
docker-compose -f docker-compose.basic.yml up -d

# Access at: http://localhost:3000
```

### Setup MVP Version
```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit .env with your settings (optional)
nano .env

# 3. Start MVP version
docker-compose -f docker-compose.mvp.yml up -d

# Access at: http://localhost:3000
```

## Version Differences

### Basic Version
- **Port**: 3000
- **Container**: patchwork-basic-dashboard
- **Image**: newsmast/patchwork_dashboard_basic:latest
- **Features**: Core functionality only
- **Target**: Small deployments, testing, basic usage

### MVP Version
- **Port**: 3000
- **Container**: patchwork-mvp-dashboard
- **Image**: newsmast/patchwork_dashboard_mvp:latest
- **Features**: All advanced features enabled
- **Target**: Production deployments, full feature set

## Running Both Versions Simultaneously

You can run both versions at the same time since they use different ports and isolated networks:

```bash
# Terminal 1 - Start Basic
docker-compose -f docker-compose.basic.yml up -d

# Terminal 2 - Start MVP
docker-compose -f docker-compose.mvp.yml up -d

# Access both:
# Basic: http://localhost:3000
# MVP: http://localhost:3001
```

## Services Per Version

### Basic Version Services
| Service | Container Name | Port | Description |
|---------|----------------|------|-------------|
| app | patchwork-basic-app | 3000 | Basic application |
| db | patchwork-basic-db | 5432 | PostgreSQL database |
| redis | patchwork-basic-redis | 6379 | Redis cache |

### MVP Version Services
| Service | Container Name | Port | Description |
|---------|----------------|------|-------------|
| app | patchwork-mvp-app | 3001 | MVP application |
| db | patchwork-mvp-db | 5433 | PostgreSQL database |
| redis | patchwork-mvp-redis | 6380 | Redis cache |

## Common Commands

### Basic Version
```bash
# Start Basic version
docker-compose -f docker-compose.basic.yml up -d

# View logs
docker-compose -f docker-compose.basic.yml logs -f

# Stop Basic version
docker-compose -f docker-compose.basic.yml down

### MVP Version
```bash
# Start MVP version
docker-compose -f docker-compose.mvp.yml up -d

# View logs
docker-compose -f docker-compose.mvp.yml logs -f

# Stop MVP version
docker-compose -f docker-compose.mvp.yml down