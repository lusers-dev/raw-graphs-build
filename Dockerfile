FROM node:alpine as builder

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache git \
    && npm install bower -g 

RUN git clone https://github.com/densitydesign/raw.git \
    && cd raw \
    && bower install 


FROM alpine:latest as stager
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache python3 
COPY --from=builder /raw /raw


FROM alpine:latest
COPY --from=stager / /
WORKDIR /raw
ENTRYPOINT [ "python3", "-m", "http.server", "5000"]


#docker build -t raw_graphs .
#docker container run --name raw_graphs --detach --publish 5000:5000 raw_graphs:latest
