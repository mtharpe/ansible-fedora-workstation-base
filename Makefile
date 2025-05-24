# Variables
IMAGE_NAME := custom-fedora-ansible
DOCKERFILE := molecule/default/Dockerfile

.PHONY: all build reset test clean

# Default target
all: build reset test clean

# Build the Podman image
build:
	@echo "🔨 Building Podman image from $(DOCKERFILE)..."
	podman build -f $(DOCKERFILE) -t $(IMAGE_NAME)
	@echo "✅ Image $(IMAGE_NAME) built successfully."

# Reset Molecule
reset:
	@echo "♻️ Resetting Molecule state..."
	molecule reset || echo "⚠️ Molecule reset failed or not needed."

# Run Molecule tests
test:
	@echo "🚀 Running Molecule tests..."
	molecule test
	@echo "✅ Molecule tests completed successfully."

# Cleanup: Remove the custom Podman image
clean:
	@echo "🧹 Cleaning up Podman image $(IMAGE_NAME)..."
	@if podman images | grep -q $(IMAGE_NAME); then \
		podman rmi $(IMAGE_NAME) || echo "⚠️ Failed to remove image $(IMAGE_NAME), continuing..."; \
		echo "🗑️ Image $(IMAGE_NAME) removed."; \
	else \
		echo "ℹ️ Image $(IMAGE_NAME) not found, skipping removal."; \
	fi
	@echo "🎉 Cleanup complete."
