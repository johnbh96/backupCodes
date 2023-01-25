FROM python:3.8.15

WORKDIR /app

COPY requirements.in .
COPY requirements.txt .
RUN pip install pip-tools
RUN pip-sync

ENTRYPOINT [ "/bin/bash" ]