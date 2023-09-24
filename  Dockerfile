# Use a base image suitable for your application's runtime environment
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy your application code into the container
COPY Sudokusolver.py /app

# Install any dependencies
RUN pip install

# Expose the port your application listens on (if applicable)
EXPOSE 80

# Command to run your application
CMD [ "python", "Sudokusolver.py" ]

