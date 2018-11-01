# Puppetboard Docker Images

[Puppetboard](https://github.com/voxpupuli/puppetboard) is a web interface to
[PuppetDB](https://puppet.com/docs/puppetdb/). This project contains components
required to build Docker container images for Puppetboard.

This project exists because Puppet's own
[Puppet-in-Docker](https://github.com/puppetlabs/puppet-in-docker) repository,
which previously included a Puppetboard image, has been
[deprecated](https://github.com/puppetlabs/puppet-in-docker/commit/f8299438b7253dc37605463f0804b80f41a84d57).
None of the other images that I can find from other parties seemed right for
me, generally because they are not kept up to date. The images provided by this
project are rebuilt weekly.

## Maintainer

This project and the resulting Docker images are maintained by
[Chris Boot](https://github.com/bootc). Co-maintainers are welcome.

The canonical source for this project is on my personal GitLab CE instance at
<https://git.boo.tc/bootc/puppetboard-docker> but it is mirrored automatically
to GitHub at <https://github.com/bootc/puppetboard-docker>.

## License

Puppetboard is distributed under the Apache-2.0 license. This project is also
licensed under the Apache-2.0 license.

Note that Docker images produced using files in this repository will likely
contain software covered by other licenses.
