# README

## Commands

Run with default config

```sh
podman run \
	-p 5000:5000\
	localhost/rh
```

Output default config

```sh
podman run \
	--rm \
	--entrypoint /bin/cat \
	localhost/rh \
	/config.json
```

Run with config

```sh
podman run \
	--rm\
	-v ./config.json:/config.json \
	-v rotorhazard-db:/database-db \
	-p 5000:5000 \
	localhost/rh
```