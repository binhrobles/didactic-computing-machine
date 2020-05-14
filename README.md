<img src="https://github.com/binhrobles/didactic-computing-machine/workflows/Redis%20Listener%20Dev/badge.svg"> <img src="https://github.com/binhrobles/didactic-computing-machine/workflows/Express%20Server%20Dev/badge.svg"> <img src="https://github.com/binhrobles/didactic-computing-machine/workflows/NGINX%20Dev/badge.svg"> <img src="https://github.com/binhrobles/didactic-computing-machine/workflows/React%20Client%20Dev/badge.svg">
<img src="https://github.com/binhrobles/didactic-computing-machine/workflows/Prod%20Deploy/badge.svg">

# didactic-computing-machine

Intentionally complicated React, Node, multi-container Docker project with Github Actions->EB

## Flow

- Terraform to create static EB, Redis, and Postgres infra w/ security group connectivity
- Docker build Github Actions to build and publish the client, nginx, server, and worker images to DockerHub
- EB Deploy Github Action (https://github.com/einaregilsson/beanstalk-deploy) handles uploading the EB config file to S3 and creating the EB version (thus deploying)
- EB looks at the config file, pulls the images from DockerHub, and runs/exposes the application
- NOTE: this works because Terraform creates specifically named application `didactic-computing-machine` and env `DidacticComputingMachine-env-1`
  - if we wanted to create this more dynamically, or create multiple envs, the EB deploy action would need to look up the environment's app name
  - how could we do this with branch names?

## Learnings

### Github Actions

- workflows run in parallel by default, and don't seem to have relationships
- jobs within a workflow have `needs` and `if` logic to create dependencies
- created separate test/build workflows per container for dev
  - had to condense them into a single workflow for prod
  - these containers would probably be in separate repos anyway
- Proper syntax for env/context variables: https://help.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contexts

### Docker Build-Push Action

- Remember to first check out the repo if using it in the job
- image didn't publish until it was explicitly tagged

### Terraform Setup Action

- https://github.com/hashicorp/setup-terraform
- Can be used to facilitate a workflow where pull-requests -> `terraform plan` and pushes to master -> `terraform apply -auto-approve`
- would require short pull request -> merge deltas

## For next time

- dynamically create/deploy to EB app/env with branch names
- Rollbacks?
