# Proposed central build only; not executed during the static review.
# The build runner is native linux/amd64. No upstream workflow or installer is used.
ARG SOURCE_DATE_EPOCH=0
FROM --platform=linux/amd64 docker.io/library/golang@sha256:ea30e25680a5470bac02b08bb0e0a735fb75bd0ab7d431b9b95ee0abef362586 AS compiler

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
# v1.24.1 removed the upstream pkg/ tree; a stale COPY pkg/ fails the build.
# Re-check every COPY source against the pinned tree whenever the pin moves.

# timetzdata embeds the timezone database already shipped in the pinned Go SDK.
# No APK, go generate, go tool, go install, release, docs or test command runs.
RUN case "${TARGETARCH}" in amd64|arm64) ;; *) exit 1 ;; esac && \
    CGO_ENABLED=0 GOARCH="${TARGETARCH}" go build \
      -mod=readonly \
      -trimpath \
      -buildvcs=false \
      -tags=timetzdata \
      -ldflags="-s -w -buildid= -X github.com/nicholas-fedor/watchtower/internal/meta.Version=v1.24.2" \
      -o /output/watchtower .

FROM scratch
LABEL org.opencontainers.image.source="https://github.com/nicholas-fedor/watchtower" \
      org.opencontainers.image.revision="c1b68f690828b7cb0270d74a51db4eefd483d3c9" \
      org.opencontainers.image.version="v1.24.2"
COPY --from=compiler /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=compiler /output/watchtower /watchtower
ENV TZ=UTC
EXPOSE 8080
HEALTHCHECK CMD ["/watchtower", "--health-check"]
ENTRYPOINT ["/watchtower"]
