# Dockerfiles

**WARN!!** *amd64 & arm64 only*

- [beanstalkd](https://github.com/users/naiba/packages/container/package/beanstalkd) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/beanstalkd.yml/badge.svg) is a lightweight message queue commonly used in PHP.
- [PHP-FPM](https://github.com/users/naiba/packages/container/package/php-fpm) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/php8-fpm.yml/badge.svg) is a PHP-FPM docker with integrated ioncube.
- [akshare](https://github.com/users/naiba/packages/container/package/akshare) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/akshare.yml/badge.svg) AKShare docker.
- [cliproxyapiplus](https://github.com/users/naiba/packages/container/package/cliproxyapiplus) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/cliproxyapiplus.yml/badge.svg) CLIProxyAPIPlus Docker image; `latest` builds CLIProxyAPI [v8.0.40](https://github.com/router-for-me/CLIProxyAPI/commit/d946c4fba6fc9a5cfbca1f3d85184d62ad2fb683), with [source review](cliproxyapi/upstream-release-review.md); the `keeper` tag builds CPA Usage Keeper v2.0.0 from pinned audited commit `fc8cbde97fe6baa35189e51115716865ce377ec2`.
- [watchtower](https://github.com/orgs/naiba-forks/packages/container/package/watchtower) ![Build Status](https://github.com/naiba/Dockerfiles/actions/workflows/watchtower.yml/badge.svg) automatically updates Docker containers; public image `ghcr.io/naiba-forks/watchtower` for amd64 and arm64, built from pinned, audited upstream [v1.23.2](https://github.com/nicholas-fedor/watchtower/commit/cd5946be205ea0a60dd31235a11f04ac9851ebf6). See [build and review details](watchtower/README.md).
- [PHP docker all-in-one](php-docker-allinone) is a PHP development environment with Nginx, MySQL, Adminer, File Manager.
