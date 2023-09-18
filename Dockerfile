FROM --platform=${BUILDPLATFORM} bitnami/minideb AS certs
RUN install_packages ca-certificates

FROM scratch
COPY ./apps/root .
COPY --from=certs /etc/ssl /etc/ssl
ENTRYPOINT ["."]
