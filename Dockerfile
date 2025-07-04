FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3 AS wget

ARG TARGETARCH

ARG KUBECTL="1.33.1"
ARG HELM="3.18.2"
ARG FLUX="2.6.1"
ARG CILIUM="0.18.4"
ARG K9S="0.50.6"

RUN cd $(mktemp -d) && \
    wget -qO kubectl https://dl.k8s.io/release/v${KUBECTL}/bin/linux/${TARGETARCH}/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/
RUN cd $(mktemp -d) && \
    wget -qO helm.tar.gz https://get.helm.sh/helm-v${HELM}-linux-${TARGETARCH}.tar.gz && \
    tar -xf helm.tar.gz && \
    install -o root -g root -m 0755 linux-${TARGETARCH}/helm /usr/local/bin/
RUN cd $(mktemp -d) && \
    wget -qO flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v${FLUX}/flux_${FLUX}_linux_${TARGETARCH}.tar.gz && \
    tar -xf flux.tar.gz && \
    install -o root -g root -m 0755 flux /usr/local/bin/
RUN cd $(mktemp -d) && \
    wget -qO cilium.tar.gz https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-${TARGETARCH}.tar.gz && \
    tar -xf cilium.tar.gz && \
    install -o root -g root -m 0755 cilium /usr/local/bin/
RUN cd $(mktemp -d) && \
    wget -qO k9s.tar.gz https://github.com/derailed/k9s/releases/download/v${K9S}/k9s_Linux_${TARGETARCH}.tar.gz && \
    tar -xf k9s.tar.gz && \
    install -o root -g root -m 0755 k9s /usr/local/bin/

FROM docker.io/library/alpine:3

COPY --from=wget /usr/local/bin /usr/local/bin/
COPY --from=wget --chown=65534:65534 --chmod=700 /var/empty /home/nobody/

USER 65534:65534
ENV HOME="/home/nobody"

CMD ["/bin/sh"]
