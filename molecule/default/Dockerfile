FROM registry.fedoraproject.org/fedora:latest

# Install base tools
RUN dnf install -y python3 ansible openssh-server

# Install GNOME Desktop Environment using dnf5 group syntax
RUN dnf install -y @gnome-desktop

# Clean DNF cache
RUN dnf clean all