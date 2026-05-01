FROM registry.fedoraproject.org/fedora:43

# Minimal toolchain to bootstrap Ansible. The GNOME role is guarded with
# `not is_container` and is skipped at converge time, so no desktop packages
# are needed in the test image.
RUN dnf install -y python3 ansible openssh-server sudo \
    && dnf clean all
