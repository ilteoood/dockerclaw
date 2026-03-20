# dockerclaw

Docker image for [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) — Personal AI Assistant. Zero overhead. Zero compromise. 100% Rust. 100% Agnostic.

![Build only image](https://github.com/ilteoood/dockerclaw/workflows/Build%20only%20image/badge.svg?branch=main)

------------------------------------------------

This is a [multi-arch](https://medium.com/gft-engineering/docker-why-multi-arch-images-matters-927397a5be2e) image, updated automatically thanks to [GitHub Actions](https://github.com/features/actions).

Its purpose is to provide a ready-to-run [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) instance deployable anywhere with Docker.

## Configuration

The container is configured through a ZeroClaw config file mounted at `/zeroclaw-data/.zeroclaw/config.toml`.

### Custom initialization

It is possible to override the script at path `/usr/local/bin/init` to install additional software or run custom commands when the container boots.

## Execution

You can run this image using [Docker compose](https://docs.docker.com/compose/) and the [sample file](./docker-compose.yml) provided.

Or you can use the standard `docker run` command:

```sh
docker run --name dockerclaw -v /path/to/zeroclaw-data:/zeroclaw-data -p 42617:42617 ilteoood/dockerclaw
```

Once running, the ZeroClaw gateway is accessible at `http://localhost:42617`.

## Do you like my work?
<p align="center">
    <a href="https://www.patreon.com/ilteoood">
        <img align="center" alt="patreon" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dilteoood%26type%3Dpatrons&style=for-the-badge">
        </img>
    </a>
    or
    <a href="https://www.buymeacoffee.com/ilteoood">
        <img align="center" alt="buy-me-a-coffee" src="https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee">
        </img>
    </a>
</p>
