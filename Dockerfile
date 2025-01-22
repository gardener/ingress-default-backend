# SPDX-FileCopyrightText: 2024 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.23.5 AS builder

WORKDIR /go/src/github.com/gardener/ingress-default-backend

# Copy go mod and sum files
COPY go.mod go.sum ./
# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

COPY . .

ARG EFFECTIVE_VERSION
RUN make install EFFECTIVE_VERSION=$EFFECTIVE_VERSION

############# ingress-default-backend
FROM  gcr.io/distroless/static:latest AS ingress-default-backend
WORKDIR /

COPY public /public
COPY routes /routes
COPY --from=builder /go/bin/ingress-default-backend /ingress-default-backend
USER 65534:65534
EXPOSE 8080
ENTRYPOINT ["/ingress-default-backend"]
