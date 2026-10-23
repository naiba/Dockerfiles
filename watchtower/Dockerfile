# Proposed central build only; not executed during the static review.
# The build runner is native linux/amd64. No upstream workflow or installer is used.
ARG SOURCE_DATE_EPOCH=0
FROM --platform=linux/amd64 docker.io/library/golang@sha256:8aa2821993207ae840ce09e4223217efcd14e01f71525db734faf4232bd59999 AS compiler

ARG TARGETARCH
ENV GOTOOLCHAIN=local \
    GOENV=off \
    GOWORK=off \
    GOFLAGS="" \
    GOOS=linux \
    GOAMD64=v1 \
    GOPROXY=https://proxy.golang.org \
    GOSUMDB=sum.golang.org \
    GOPRIVATE="" \
    GONOPROXY="" \
    GONOSUMDB="" \
    GOVCS="*:off"

WORKDIR /source
# Context must match the independently verified Git blobs at the fixed SHA.
COPY go.mod go.sum main.go ./
COPY cmd/ ./cmd/
COPY internal/ ./internal/
COPY pkg/ ./pkg/

# timetzdata embeds the timezone database already shipped in the pinned Go SDK.
# No APK, go generate, go tool, go install, release, docs or test command runs.
RUN case "${TARGETARCH}" in amd64|arm64) ;; *) exit 1 ;; esac && \
    CGO_ENABLED=0 GOARCH="${TARGETARCH}" go build \
      -mod=readonly \
      -trimpath \
      -buildvcs=false \
      -tags=timetzdata \
      -ldflags="-s -w -buildid= -X github.com/nicholas-fedor/watchtower/internal/meta.Version=v1.23.2" \
      -o /output/watchtower .

FROM scratch
LABEL org.opencontainers.image.source="https://github.com/nicholas-fedor/watchtower" \
      org.opencontainers.image.revision="cd5946be205ea0a60dd31235a11f04ac9851ebf6" \
      org.opencontainers.image.version="v1.23.2"
COPY --from=compiler /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=compiler /output/watchtower /watchtower
ENV TZ=UTC
EXPOSE 8080
HEALTHCHECK CMD ["/watchtower", "--health-check"]
ENTRYPOINT ["/watchtower"]
