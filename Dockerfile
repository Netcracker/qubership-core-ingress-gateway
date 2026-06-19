FROM coredns/coredns:1.14.4@sha256:3e98f280fd601b37411c5fb7075fd9f337833c480f1644970b727ae0af067782
FROM envoyproxy/envoy:v1.38.2@sha256:af7c3dfdbe10de65cb2db5839ce1adf8904ee41c9d372076d62acab43af6ec41
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
