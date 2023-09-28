# Use a base image suitable for your application's runtime environment
FROM python:3.9

RUN mkdir -p /app/certs
# Set the working directory
WORKDIR /app 

# Copy your application code into the container


# Install any dependencies

RUN apt-get update && \
    apt-get install -y openssl && \
    openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 && \
    openssl rsa -passin pass:x -in server.pass.key -out key.pem && \
    rm server.pass.key && \
    openssl req -new -key key.pem -out server.csr \
        -subj "/C=US/ST=GA/L=Atlanta/O=Data Cube Inc/OU=IT Department/CN=www.datacubeinc.com" && \
    openssl x509 -req -days 365 -in server.csr -signkey key.pem -out certificate.pem
RUN apt-get install -y libzmq3-dev python3-pip
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip
RUN pip3 freeze > requirements.txt
RUN cp *.pem /app/certs/

RUN pip3 install --upgrade pip
#RUN pip3 install -r requirements.txt
RUN cp *.pem /app/certs/
#RUN cp lib/rdsAdmin.py /usr/lib/python3.4
#RUN cp lib/rdsAdmin.py /usr/local/lib/python3.9
#RUN apt-get install -y apt-utils && apt-get install -y curl
RUN apt-get -y install curl
 
COPY Sudokusolver.py /app

# Expose the port your application listens on (if applicable)
EXPOSE 8080

# Command to run your application
CMD [ "python", "Sudokusolver.py" ]

