# Use an official Python runtime as the base image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]

