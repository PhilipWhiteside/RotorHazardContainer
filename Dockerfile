FROM docker.io/library/debian:bullseye-slim

#
# BASE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
	&& apt install -y \
		python3-dev \
		libffi-dev \
		python3-smbus \
		build-essential \
		python3-pip \
		git \
		scons \
		swig \
	&& rm -rf /var/lib/apt/lists/*

RUN if [ $(arch) = "arm64" ] \
		|| [ $(arch) = "armel"  ] \
		|| [ $(arch) = "armhf"  ] ; \
	then \
		echo "ARM arch detected." \
		&& apt update \
		&& apt install -y python3-rpi.gpio \
		&& rm -rf /var/lib/apt/lists* ; \
	else \
		echo "WARNING: Not ARM arch. Skipping Pi specific packages. App won't work. Continuing for preview use only." ; \
	fi

# 
# ROTORHAZARD
# ROTORHAZARD | DOWNLOAD
ADD https://github.com/RotorHazard/RotorHazard/archive/refs/tags/v3.2.2.tar.gz /v3.2.2.tar.gz
RUN tar -xf v3.2.2.tar.gz
WORKDIR /RotorHazard-3.2.2/src/server

# ROTORHAZARD | INSTALL
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN python --version
RUN pip install -r requirements.txt
RUN cp config-dist.json /config.json
RUN ln -s /config.json config.json
RUN mkdir /database-db
RUN ln -s /database-db/database.db database.db

#
# MISC
EXPOSE 5000
ENTRYPOINT ["python", "server.py"]