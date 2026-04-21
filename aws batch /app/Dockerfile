FROM python:3.8

# Copy the Python script into the container
COPY app/square.py /app

# Set the working directory
WORKDIR /app

ENV PYTHONUNBUFFERED=1

# Run the Python script when the container starts
CMD ["python", "square.py", "3"]
