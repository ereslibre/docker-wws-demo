FROM scratch
COPY ./apps/root .
ENTRYPOINT ["."]
