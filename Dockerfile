FROM node:12.16.1-alpine3.9

# Working Directory
WORKDIR /app 

# Copy source code to WORKDIR
COPY . index.js /app/
COPY . public /app/

# Install packages
RUN npm install

# Expose port
EXPOSE 8000

# Run app.py at container launch
CMD ["node", "."]