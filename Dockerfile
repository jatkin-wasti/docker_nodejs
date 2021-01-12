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
