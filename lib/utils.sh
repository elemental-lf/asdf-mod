#!/usr/bin/env bash

set -euo pipefail

declare -r GH_USER_REPO="variantdev/mod"
declare -r GH_REPO_URL="https://github.com/${GH_USER_REPO}"
declare -r GH_RELEASES_URL="https://api.github.com/repos/${GH_USER_REPO}/releases"
declare -r GH_RELEASES_DOWNLOAD_URL="https://github.com/${GH_USER_REPO}/releases/download"
declare -r TOOL_NAME="mod"

fail()
{
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions()
{
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' \
    | LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags()
{
  git ls-remote --tags --refs "$GH_REPO_URL" \
    | grep -o 'refs/tags/.*' | cut -d/ -f3- \
    | sed 's/^v//'
}

list_github_releases()
{
  curl "${curl_opts[@]}" "$GH_RELEASES_URL" \
    | grep -oE "tag_name\": *\".{1,15}\"," \
    | sed 's/tag_name\": *\"v//;s/\",//'
}

list_all_versions()
{
  # list_github_tags | sort_versions
  list_github_releases | sort_versions
}

list_latest_stable()
{
  # shellcheck disable=SC2155
  local latest_version=$(curl "${curl_opts[@]}" "${GH_RELEASES_URL}/latest" \
    | grep -oE "tag_name\": *\".{1,15}\"," \
    | sed 's/tag_name\": *\"v//;s/\",//')

  if [ -z "${latest_version}" ]; then
    latest_version="$(list_all_versions | tail -n1)"
  fi

  echo "${latest_version}"
}

get_arch()
{
  local -r arch="$(uname -m)"

  case "${arch}" in
    x86_64)
      echo amd64
      ;;
    arm64 | aarch64)
      echo arm64
      ;;
    *)
      echo "$arch"
      ;;
  esac
}

get_platform()
{
  uname | LC_ALL=C tr '[:upper:]' '[:lower:]'
}

download_release()
{
  local -r version="$1"
  local -r filename="$2"

  local -r url="${GH_RELEASES_DOWNLOAD_URL}/v${version}/${TOOL_NAME}_${version}_$(get_platform)_$(get_arch).tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  # shellchheck disable=SC2155
  local -r http_code=$(curl "${curl_opts[@]}" -o "$filename" -C - --write-out '%{http_code}' "$url" 2> /dev/null)
  case "$http_code" in
    2* | 416)
      # Fall through
      ;;
    *)
      fail "Unable to download $url (HTTP code $http_code)."
      ;;
  esac
}

#https://github.com/variantdev/mod/releases/download/v0.25.1/mod_0.25.1_darwin_amd64.tar.gz

install_version()
{
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp "$ASDF_DOWNLOAD_PATH"/mod "$install_path"
    chmod a+x "$install_path/mod"

    echo "* $TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
