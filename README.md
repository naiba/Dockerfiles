# Dockerfiles

**WARN!!** *amd64 & arm64 only*

- [beanstalkd](https://github.com/users/naiba/packages/container/package/beanstalkd) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/beanstalkd.yml/badge.svg) is a lightweight message queue commonly used in PHP.
- [PHP-FPM](https://github.com/users/naiba/packages/container/package/php-fpm) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/php8-fpm.yml/badge.svg) is a PHP-FPM docker with integrated ioncube.
- [akshare](https://github.com/users/naiba/packages/container/package/akshare) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/akshare.yml/badge.svg) AKShare docker.
- [cliproxyapiplus](https://github.com/users/naiba/packages/container/package/cliproxyapiplus) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/cliproxyapi.yml/badge.svg) CLIProxyAPI and CPA Usage Keeper images; `latest` builds CLIProxyAPI [v8.1.1](https://github.com/router-for-me/CLIProxyAPI/commit/6eb8554f0ede597b2aa3e508ffb3f111d3c2b9e6), with [source review](cliproxyapi/upstream-release-review.md); the `keeper` tag builds CPA Usage Keeper v2.1.1 from pinned audited commit `5c97bee91678e3cd9e75201a8025bfcaadf77681`.
- [watchtower](https://github.com/orgs/naiba-forks/packages/container/package/watchtower) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/watchtower.yml/badge.svg) automatically updates Docker containers; public image `ghcr.io/naiba-forks/watchtower` for amd64 and arm64, built from pinned, audited upstream [v1.24.1](https://github.com/nicholas-fedor/watchtower/commit/f45081047d683daceb9d3196dc8569bb6b534879). See [build and review details](watchtower/README.md).
- [PHP docker all-in-one](php-docker-allinone) is a PHP development environment with Nginx, MySQL, Adminer, File Manager.
