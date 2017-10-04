master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-partekflow.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-partekflow)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with partekflow](#setup)
    * [What partekflow affects](#what-partekflow-affects)
    * [Beginning with partekflow](#beginning-with-partekflow)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

The partekflow module installs, configures, and manages Partek Flow software package and service. Partek Flow is "designed specifically for the analysis needs of next generation sequencing applications including RNA, small RNA, and DNA sequencing" that includes a web interface for creation and utilization of custom pipelines. [http://www.partek.com/partekflow](http://www.partek.com/partekflow)

## Setup

### What partekflow affects

* User and Group: flow
* Group: flowuser
* RPM GPG Key: /etc/pki/rpm-gpg/partek-public.key
* Yumrepos for accessing partek flow RPM repositories. The stable repositories are enabled while the unstable ones are not.
* Package: partekflow
* File: /etc/partekflow.conf
* Catalina temp directory location
* Service: partekflowd

### Beginning with partekflow

`include partekflow` should be all that is needed to install, configure and start the partekflowd service. One can also pass parameters in to change the configuration:

```puppet
class { 'partekflow':
    config_catalina_tmpdir => '/home/flow/partek_flow/temp',
}
```

## Usage

All parameters are passed to the main class via either puppet code or hiera. The other classes should not be called directly. Some usage examples are presented below.

### Install and startup partekflowd service

```puppet
include partekflow
```

### Change the location of the CATALINA_TMPDIR setting in /etc/partekflow.conf

```puppet
class { 'partekflow':
    config_catalina_tmpdir => '/home/flow/partek_flow/temp',
}
```

or via hiera:

```yaml
---
partekflow::config_catalina_tmpdir: '/home/flow/partek_flow/temp'
```

### To use a different template for the partekflow.conf file

```puppet
class { 'partekflow':
    config_template => 'module_name/path/to/template.erb',
}
```

## Reference

This module is using Puppet Strings to generate documentation. In order to generate the documentation set, run:

```bash
bundle exec rake strings:generate manifests/*.pp
```

from within the module directory. The resulting documentation should be placed in a docs/ directory within the module. See the [Puppet Strings doumentation](https://github.com/puppetlabs/puppet-strings/) for more details on what Puppet Strings provides and other ways of generating documentaiton output.

Note: this assumes that you have cloned the project repository and are setup for development. If you aren't in the position for doing so, viewing the main class on GitHub for the particular version will also provide similar information.

## Limitations

This module utlizes hiera 5 module data and as such works best on Puppet 4.9+ or Puppet 5.x. Originally written for CentOS 6/7 systems, it could work on other osfamily RedHat distributions. While Partek Flow supports installation on Debian based distributions, this module does not at this time.

The partekflow module depends on puppet 4 data types provided by [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib) as well as the [treydock-gpg_key](https://forge.puppet.com/treydock/gpg_key) module.

This module was written to reflect initial installation and configuration [documentation provided by Partek](https://documentation.partek.com/display/FLOWDOC/). This is not an all inclusive module as there are configuration tasks that need to be done via the web UI to configure portions as well. If you find some configuration option would be helpful for maintaining the software on your own servers, please submit an issue or pull request. The latest released version of Partek flow when this was written was: 6.0.17.0919.278-1 and serves as a start point for reference. It is possible that this module will work with prior versions; however, that condition is not tested.

While the module maintainer supports the puppet code contained in the module, support for the application or performance of the Partek Flow software should be directed toward Partek. The module maintainer does not have a relationship with Partek.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [list of contributors.](https://github.com/millerjl1701/millerjl1701-partekflow/graphs/contributors)