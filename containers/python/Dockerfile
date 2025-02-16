FROM ghcr.io/astral-sh/uv:python3.11-alpine
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY application/pyproject.toml /code/
# https://docs.astral.sh/uv/reference/cli/#uv-sync
RUN uv sync
COPY application/ /code/
