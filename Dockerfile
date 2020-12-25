FROM node:14.15.1

# Assigns alias for Vodka Tonic.

RUN echo 'alias vt="./vt.sh"' >> ~/.bashrc

# Installs dependencies.

RUN apt-get update && apt-get install -y