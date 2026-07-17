FROM coredns/coredns:1.14.6@sha256:900f9c109f7a33545d3c811516e8376df9019147b750f5ce3e254468769176ea
FROM envoyproxy/envoy:v1.38.3@sha256:5f7c43e1147412fdb3af578c651c67478a3df818eae89d2261e707e06c209cdb
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

# Set non-root user appuser for image run and all the following CMD command
USER 10001

EXPOSE 8080 9901

VOLUME /envoy/config

CMD ["/envoy/run.sh"]
