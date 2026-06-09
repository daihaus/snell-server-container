#!/bin/bash

set -euo pipefail

VERSION=${1:-}
CHANNEL=${2:-stable}
PLATFORM=${PLATFORM:-linux/amd64,linux/arm64}
IMAGE_NAME=${IMAGE_NAME:-ghcr.io/daihaus/snell-server-container}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

show_usage() {
  echo "Usage: $0 VERSION [CHANNEL]"
  echo ""
  echo "Parameters:"
  echo "  VERSION  required version, for example: 5.0.1 or 5.1.0-beta"
  echo "  CHANNEL  optional release channel: stable or beta; default: stable"
  echo ""
  echo "Environment overrides:"
  echo "  IMAGE_NAME  default: ghcr.io/daihaus/snell-server-container"
  echo "  PLATFORM    default: linux/amd64,linux/arm64"
  echo ""
  echo "Examples:"
  echo "  $0 5.0.1"
  echo "  $0 5.0.1 stable"
  echo "  $0 5.1.0-beta beta"
}

if [ -z "$VERSION" ]; then
  print_error "version is required"
  show_usage
  exit 1
fi

if [[ ! "$VERSION" =~ ^[0-9][0-9A-Za-z.-]*$ ]]; then
  print_error "version must be a valid Docker tag starting with a number, for example: 5.0.1 or 5.1.0-beta"
  show_usage
  exit 1
fi

if [ "$CHANNEL" != "stable" ] && [ "$CHANNEL" != "beta" ]; then
  print_error "channel must be 'stable' or 'beta'"
  show_usage
  exit 1
fi

extract_major_version() {
  local version=$1
  if [[ "$version" =~ ^([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    print_error "failed to extract major version from '$version'"
    exit 1
  fi
}

MAJOR_VERSION=$(extract_major_version "$VERSION")
TAGS=("$VERSION")

if [ "$CHANNEL" = "stable" ]; then
  TAGS+=("$MAJOR_VERSION" "latest")
fi

TAG_ARGS=()
for tag in "${TAGS[@]}"; do
  TAG_ARGS+=(--tag "${IMAGE_NAME}:${tag}")
done

print_info "Building Docker image..."
print_info "Version: $VERSION"
print_info "Channel: $CHANNEL"
print_info "Image: $IMAGE_NAME"
print_info "Platform: $PLATFORM"

docker buildx build \
  --push \
  --platform "${PLATFORM}" \
  --build-arg "VERSION=${VERSION}" \
  "${TAG_ARGS[@]}" \
  .

print_success "Build and push completed"
print_info "Pushed tags:"
for tag in "${TAGS[@]}"; do
  echo "  - ${IMAGE_NAME}:${tag}"
done
