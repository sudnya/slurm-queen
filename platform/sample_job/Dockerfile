FROM python:3.9 as base

ARG PACKAGE_NAME="sample-job"

# Install Ubuntu libraries
RUN apt-get -yq update

# Install python packages
WORKDIR /app/${PACKAGE_NAME}
#COPY ./requirements.txt /app/${PACKAGE_NAME}/requirements.txt
#RUN pip install -r requirements.txt

# Copy all files to the container
COPY . /app/${PACKAGE_NAME}
WORKDIR /app/${PACKAGE_NAME}

RUN chmod a+x /app/${PACKAGE_NAME}/start.sh

ENV PACKAGE_NAME=$PACKAGE_NAME
ENTRYPOINT /app/${PACKAGE_NAME}/start.sh
