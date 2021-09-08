# syntax=docker/dockerfile:1


##
## Build stage
##
FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /gin-server

##
## Deploy Stage
##
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /gin-server /gin-server

EXPOSE 8090

USER nonroot:nonroot

ENTRYPOINT ["/gin-server"] 
