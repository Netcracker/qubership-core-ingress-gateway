FROM coredns/coredns:1.14.3@sha256:b21d26b915e10acb5bc78715c1e8b6047ab2675389b2bcc18b3a6499d90e74c0
FROM envoyproxy/envoy:v1.37.1@sha256:29496a88fba9c4c9cdef4afe8fec70f536c5ba111b1c2bddbc5436b091ceca33
COPY --chown=10001:0 --from=0 /coredns /usr/bin/coredns
ADD --chown=10001:0 CoreDNSFile /CoreDNSFile

RUN \
  apt-get update \
  && apt-get -y install gettext-base busybox openssl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


COPY --chown=10001:0 envoy.yml            /envoy/envoy.yaml
COPY --chown=10001:0 deployments/run.sh   /envoy/run.sh

RUN mkdir -p /envoy/config && \
    chown 10001:0 /envoy/config && \
    chmod -R ug+rwx /envoy

# Set non-root group and user appuser for image run and all the following CMD command
USER 10001:10001

EXPOSE 8080 9901

VOLUME /envoy/config

CMD ["/envoy/run.sh"]
