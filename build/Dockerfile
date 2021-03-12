# syntax=docker/dockerfile:1.2.0
FROM golang:1.15.7-alpine3.13 as golang
RUN addgroup -S appgroup -g 9999 && adduser -S appuser -G appgroup -u 8888
WORKDIR /home/appuser
USER 8888
RUN mkdir -p /home/appuser/tmp


FROM golang as dependencies
COPY --chown=appuser:appgroup go.mod .
COPY --chown=appuser:appgroup go.sum .
RUN --mount=type=cache,uid=8888,gid=9999,target=/home/appuser/.cache/go-build \
    go mod download


FROM golang as builder
ARG BUILD_ID_TAG=development
COPY --from=dependencies --chown=appuser:appgroup /home/appuser/go.mod .
COPY --from=dependencies --chown=appuser:appgroup /home/appuser/go.sum .
COPY --chown=appuser:appgroup cmd/ cmd/
WORKDIR /home/appuser/cmd/sample
RUN --mount=type=cache,uid=8888,gid=9999,target=/home/appuser/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build


FROM scratch as production
USER 8888
COPY --from=builder /home/appuser/cmd/sample/sample /sample
CMD ["/sample"]
