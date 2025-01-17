FROM debian:bullseye-slim

ENV PATH="$PATH:/opt/bento4/bin" 
ENV BENTO4_VERSION="1-6-0-640"

WORKDIR /app

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y curl zip unzip 

COPY ./manzana/requirements.txt /app/requirements.txt
RUN apt-get install -y python3 python3-pip
RUN pip install -Ur requirements.txt

RUN apt-get install -y ccextractor gpac

RUN curl -lO https://www.bok.net/Bento4/binaries/Bento4-SDK-${BENTO4_VERSION}.x86_64-unknown-linux.zip \
    && unzip Bento4-SDK-${BENTO4_VERSION}.x86_64-unknown-linux.zip -d /opt \
    && ln -s Bento4-SDK-${BENTO4_VERSION}.x86_64-unknown-linux /opt/bento4

RUN apt-get -y purge unzip \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf Bento4-SDK-${BENTO4_VERSION}.x86_64-unknown-linux.zip


COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["start-container"]
