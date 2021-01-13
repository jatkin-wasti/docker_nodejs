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
