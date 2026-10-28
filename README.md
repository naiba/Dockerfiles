# Dockerfiles

**WARN!!** *amd64 & arm64 only*

- [beanstalkd](https://github.com/users/naiba/packages/container/package/beanstalkd) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/beanstalkd.yml/badge.svg) is a lightweight message queue commonly used in PHP.
- [PHP-FPM](https://github.com/users/naiba/packages/container/package/php-fpm) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/php8-fpm.yml/badge.svg) is a PHP-FPM docker with integrated ioncube.
- [akshare](https://github.com/users/naiba/packages/container/package/akshare) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/akshare.yml/badge.svg) AKShare docker.
- [cliproxyapiplus](https://github.com/users/naiba/packages/container/package/cliproxyapiplus) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/cliproxyapiplus.yml/badge.svg) CLIProxyAPIPlus Docker image; `latest` builds CLIProxyAPI [v8.0.46](https://github.com/router-for-me/CLIProxyAPI/commit/9717e325ba6ab2c7483ea93ccb5f2047eb2e7dd5), with [source review](cliproxyapi/upstream-release-review.md); the `keeper` tag builds CPA Usage Keeper v2.0.2 from pinned audited commit `46fe6278db0c47a5460e882fa1742f15ab49bb14`.
- [watchtower](https://github.com/orgs/naiba-forks/packages/container/package/watchtower) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/watchtower.yml/badge.svg) automatically updates Docker containers; public image `ghcr.io/naiba-forks/watchtower` for amd64 and arm64, built from pinned, audited upstream [v1.23.2](https://github.com/nicholas-fedor/watchtower/commit/cd5946be205ea0a60dd31235a11f04ac9851ebf6). See [build and review details](watchtower/README.md).
- [PHP docker all-in-one](php-docker-allinone) is a PHP development environment with Nginx, MySQL, Adminer, File Manager.
