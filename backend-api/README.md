
# Counter Back-end

### Prerequisites

  

1. Python `3.8.x`

2. Docker `4.x.x`

  #

### Activate Environment

  

1.  `python3.8 -m venv venv`

2.  `source venv/bin/activate`
  
  #

### Install Dependencies

  

1. Install `pip-tools`

2. Run: `pip-sync requirements.in`

  

For M1, run following to install `psycopg2-binary`:

  

```shell

env LDFLAGS="-I/opt/homebrew/opt/openssl/include -L/opt/homebrew/opt/openssl/lib" pip --no-cache install psycopg2

```

Or

  

```shell

env LDFLAGS="-I/opt/homebrew/opt/openssl/include -L/opt/homebrew/opt/openssl/lib" pip-sync requirements.txt

```

  #

### Setup Environment Variables

Run: `source .envrc`

### Start Back-end Services Locally

Run: `./scripts/build_api_docker.sh`
Run(frontend): `./scripts/start_local_backend.sh`
Run(backend): `./scripts/start_local_frontend.sh`

# Initial Setup

You need to set up available business types and resources

before running other steps
  Note: To get into api container `docker exec -it counterise_dev-api-1 /bin/bash`
 - Setup Environment Variables
 - [ ] Start Back-end Services
 - [ ] Start Server Console: `./manage.py shell`
##
 - [ ] Import initial setup: `from counter.models import run_initial_setup`
 - [ ] Run initial setup: `run_initial_setup()`
# Unit Tests
Run: `./manage.py test`
# BDD Test
Run: `./scripts/run_bdd_tests.sh`

# Run Locally
Start Celery Worker: `celery --app=api worker -l INFO`
Start Server: `./manage.py runserver`
