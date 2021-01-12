# Nodejs app with Docker
## Dockerfile
- In our Dockerfile we specify what to base the image off with the `FROM` line
- We then specify who is maintaining the container with the `LABEL`
- The app runs on port 3000 so we need to `EXPOSE` it
- We then need to `COPY` in the necessary app files and change our system location
to the new directory with `WORKDIR`
- In this new directory we have to `RUN` an installation command for npm
- And finally we start the app with `CMD`
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
