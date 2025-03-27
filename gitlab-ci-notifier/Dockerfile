FROM golang:1.24-alpine AS builder

ARG GOOS=linux
ARG GOARCH=amd64
ARG CGO_ENABLED=0

ENV GOOS=$GOOS \
    GOARCH=$GOARCH \
    CGO_ENABLED=$CGO_ENABLED \
    GOPROXY="https://proxy.golang.org,direct"

RUN apk add --no-cache git ca-certificates

WORKDIR /app

COPY main.go .

RUN go build -o notify main.go

FROM alpine:latest

RUN apk add --no-cache ca-certificates

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/notify .

RUN chmod +x notify && chown appuser:appgroup notify
USER appuser

ENTRYPOINT ["/app/notify"]