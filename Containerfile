ARG SOURCE_IMAGE="${SOURCE_IMAGE:-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-40}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

# Setup Copr repo
RUN wget https://copr.fedorainfracloud.org/coprs/ryanabx/cosmic-epoch/repo/fedora-40/ryanabx-cosmic-epoch-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ryanabx-cosmic.repo

# Install cosmic desktop environment
RUN rpm-ostree install cosmic-epoch

# Install extras (currently just a power manager and a libsecret manager)
RUN rpm-ostree install \
    tuned \
    gnome-keyring

# Set up display manager
RUN rm -f /etc/systemd/system/display-manager.service && \
    ln -s /usr/lib/systemd/system/cosmic-greeter.service /etc/systemd/system/display-manager.service

RUN ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
