# Contributing

## Requirements

* Docker Engine
* make
* [drone cli](https://github.com/drone/drone-cli)

## Test at local

Build Docker image for test.

```console
$ make image
```

```console
$ make ci-local
```

Don't edit .drone.yml directly.
Update .drone.jsonnet and run `make .drone.yml` .

```console
$ make .drone.yml
```
