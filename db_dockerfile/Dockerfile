# Build this image from an official image of mongo
FROM mongo as mongodb
# Specifies who built and maintains this image
LABEL MAINTAINER=jatkin-wasti@spartaglobal.com
# Exposes port 27017 to communicate with the app
EXPOSE 27017
# Copy across the configuration file
COPY ./mongod.conf usr/etc/
