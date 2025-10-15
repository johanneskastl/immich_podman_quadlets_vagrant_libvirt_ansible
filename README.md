# immich_podman_quadlets_vagrant_libvirt_ansible

This Vagrant setup creates a VM and installs [Podman](podman.io) on it.
Using podman, it runs [Immich](https://immich.app/) behind the [Traefik reverse
proxy](traefik.io), both as Podman quadlets.

Default OS is openSUSE Tumbleweed. Although that can be changed in the
Vagrantfile, please beware that this will break the Ansible provisioning.

The `main` branch runs just Immich and its related containers (machine-learning,
Valkey and PostgreSQL). Immich is reachable over port 2283, the exact IP will be
printed by Ansible during provisioning.

The `traefik` branch runs this setup behind a Traefik reverse proxy, so it will
be reachable over HTTPS (with a self-signed certificate).

## Vagrant

1. You need vagrant obviously. And ansible. And git...
1. Fetch the box, per default this is `opensuse/Tumbleweed.x86_64`, using
   `vagrant box add opensuse/Tumbleweed.x86_64`.
1. Make sure the git submodules are fully working by issuing `git submodule init
   && git submodule update`
1. Run `vagrant up`
1. Open the URL that Ansible printed out at the end of the provisioning. The URL
   looks something like `http://192.168.2.13:2283` (where
   `192.168.2.13` is your VM's IP address).
1. Party!

## Cleaning up

The VM can be torn down after playing around using `vagrant destroy`.

## Using private registries or registry mirrors

This setup contains two playbooks that can configure Podman (for the vagrant
user in the VM) to use a private registry or registry mirror, so you do not run
into rate limiting with the Docker Hub etc.

For the authentication part, create a file
`ansible/group_vars/all/podman_auth_json.yml` (which will be ignored by git)
containing a valid `auth.json`:

```
podman_auth_json: |
  {
      "auths": {
          "registry.example.org": {
              "auth": "BASE64_ENCODED_STRING_GOES_HERE"
          }
      }
  }
```

`BASE64_ENCODED_STRING_GOES_HERE` is a base64-encoded string containing
`username:password` for the registry.

To configure a registry mirror, i.e. create a
`~/.config/containers/registries.conf` file, create a file
`ansible/group_vars/all/podman_registries_conf.yml` with content like the
following:

```
podman_registries_conf: |
  # # An array of host[:port] registries to try when pulling an unqualified image, in order.
  unqualified-search-registries = ["registry.opensuse.org", "registry.suse.com", "docker.io"]

  [[registry]]
  prefix = "docker.io"
  location = "docker.io"

  [[registry.mirror]]
  prefix = "docker.io"
  location = "registry.example.org"

  [[registry]]
  prefix = "ghcr.io"
  location = "ghcr.io"

  [[registry.mirror]]
  prefix = "ghcr.io"
  location = "registry.example.org"

  [[registry]]
  prefix = "quay.io"
  location = "quay.io"

  [[registry.mirror]]
  prefix = "quay.io"
  location = "registry.example.org"

  [[registry]]
  prefix = "cgr.dev"
  location = "cgr.dev"

  [[registry.mirror]]
  prefix = "cgr.dev"
  location = "registry.example.org"
```

## License

BSD-3-Clause

## Author Information

I am Johannes Kastl, reachable via git@johannes-kastl.de
