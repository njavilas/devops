FROM golang:1.23 AS builder

WORKDIR /app

COPY main.go .
COPY go.mod .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o backend

FROM alpine:latest

COPY --from=builder /app/backend /app/backend

EXPOSE 8080

CMD ["/app/backend"]
