# Hosting a static website with an nginx server using Docker containers
## Dockerfile
## Development environment Dockerfile
- In our Dockerfile we specify what to base the image off with the `FROM` line
- We then specify who is maintaining the container with the `LABEL`
- The app runs on port 3000 so we need to `EXPOSE` it
- We then need to `COPY` in the necessary app files and change our system location
to the new directory with `WORKDIR`
- In this new directory we have to `RUN` an installation command for npm
- And finally we start the app with `CMD`
```GO
# Build this image from an official image of nodejs
FROM node:10-alpine
# Specifies who built and maintains this image
LABEL MAINTAINER=jatkin-wasti@spartaglobal.com
# Exposes port 3000 to launch in the browser
EXPOSE 3000
# Copies file from localhost to our container to be able to run the app
COPY nodejs/ /usr/nodejs
# Changing directory to the folder we just copied in
WORKDIR usr/nodejs
# Runs commands to install npm and start the app
RUN npm install
CMD ["npm", "start", "app.js;"]
```
## Using this container
- This container is publicly available from the following link
https://hub.docker.com/repository/docker/jatkinwasti/eng74-nodejs-app
- To run this for yourself you simply need to run the following command in your terminal
 (assuming you have docker installed)
`docker run -d -p 80:3000 jatkinwasti/eng74-nodejs-app`
- This will pull and run the container and you should be able to access it on
`localhost` in your browser
- There is a fibonacci page which you can access at `localhost/fibonacci/` followed
by the position in the sequence you'd like to see i.e. `localhost/fibonacci/5` to
see the 5th number in the fibonacci sequence

## Multistage production environment Dockerfile
- Here we'll compress our app into a slimmer image before running  to save space
- In this specific example, we're already using a slim version of alpine so we
won't be saving any space however this would be extremely useful if we had used
the base version of node
- This is done so that you can have everything you need for the development
environment and then can keep only what is strictly necessary in the subsequent
stages
```GO
# Build this image from an official image of nodejs
FROM node:10-alpine as APP
# Specifies who built and maintains this image
LABEL MAINTAINER=jatkin-wasti@spartaglobal.com
# Copies file from localhost to our container to be able to run the app
COPY nodejs/ /usr/nodejs
# Changing directory to the folder we just copied in
WORKDIR usr/nodejs
# Runs commands to install npm and start the app
RUN npm install
# Multistage layer
FROM node:alpine
# This is a magic line of code that compresses it into a lighter weight image
COPY --from=app /usr/nodejs /usr/nodejs/
# Changing directory
WORKDIR /usr/nodejs
# Exposes port 3000 to launch in the browser
EXPOSE 3000
CMD ["npm", "start", "app.js;"]
```
## Getting the app to communicate with a DB
- To get the app working with the db we'll have to create two containers and
have them communicate
- We'll use docker compose to create a container for each and link them together
### App Dockerfile
```GO
# Build this image from an official image of nodejs
FROM node:10-alpine as APP
# Specifies who built and maintains this image
LABEL MAINTAINER=jatkin-wasti@spartaglobal.com
# Copies file from localhost to our container to be able to run the app
COPY nodejs/ /usr/nodejs
# Changing directory to the folder we just copied in
WORKDIR usr/nodejs
# Runs commands to install npm and start the app
RUN npm install
# Multistage layer
FROM node:alpine
# This is a magic line of code that compresses it into a lighter weight image
COPY --from=app /usr/nodejs /usr/nodejs/
# Changing directory
WORKDIR /usr/nodejs
# Exposes port 3000 to launch in the browser
EXPOSE 3000
CMD ["npm", "start", "app.js;"]
```
### Db Dockerfile
```GO
# Build this image from an official image of mongo
FROM mongo as mongodb
# Specifies who built and maintains this image
LABEL MAINTAINER=jatkin-wasti@spartaglobal.com
# Exposes port 27017 to communicate with the app
EXPOSE 27017
# Copy across the configuration file
COPY ./mongod.conf usr/etc/
```
### Compose file
- Our compose file will build containers using the Dockerfiles above
- We then bind the appropriate container and host ports and link the two containers
- Linking them allows them to communicate and share environment variables
- When creating the container for our web app we set an environment variable
of the db's private ip as this is needed to show posts
```GO
version: "3.9"
services:
  web:
    build: ./
    ports:
      - "3000:3000"
    links:
      - mongodb
    environment:
      - DB_HOST=mongodb:27017
  mongodb:
    build: ./db_dockerfile
    container_name: node-db
    ports:
      - "27017:27017"
```
### Compose commands
- We can now run `docker-compose up` to test if our implementation worked
- If there are any errors, error messages should be displayed to help you fix
this
- However, running it this way hogs the terminal while running so if we are
confident that it is working as intended we can use the `-d` flag to run in
detached mode i.e. `docker-compose up -d` will allow you to still use the terminal
after running it
