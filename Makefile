# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

.DEFAULT_GOAL=build

network:
	@docker network inspect jupyterhub-network >/dev/null 2>&1 || docker network create jupyterhub-network

volumes:
	@docker volume inspect jupyterhub-data >/dev/null 2>&1 || docker volume create --name jupyterhub-data
	@docker volume inspect jupyterhub-db-data >/dev/null 2>&1 || docker volume create --name jupyterhub-db-data


postgres-pw-gen:
	@echo "Generating postgres password in $@"
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 32)" > ~/secrets/postgres/postgres.env

check-files:  ~/secrets/postgres/postgres.env