# partekflow

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-partekflow.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-partekflow)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with partekflow](#setup)
    * [What partekflow affects](#what-partekflow-affects)
    * [Beginning with partekflow](#beginning-with-partekflow)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

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

### To disable the stable repsitory files but still have them present in /etc/yum.repos.d/

```puppet
class { 'partekflow':
  yumrepo_ensure_stable  => true,
  yumrepo_enabled_stable => false,
}
```

### To use a local repository mirror instead of the Partek repositories

```puppet
class { 'partekflow':
  yumrepo_baseurl_server       => 'http://yum.example.com',
  yumrepo_baseurl_stablepath   => '/path/to/stable',
  yumrepo_baseurl_unstablepath => '/path/to/unstable',
}
```

### To remove the unstable /etc/yum.repos.d/ files

```puppet
class { 'partekflow':
  yumrepo_ensure_unstable => false,
}
```


## Reference


This module is setup for the use of Puppet Strings to generate class and parameter documentation. The [Puppet Strings doumentation](https://github.com/puppetlabs/puppet-strings/) provides more details on what Puppet Strings provides and other ways of generating documentaiton output.

As a quick start, if you are using the gem version of puppet:

```bash
gem install puppet-strings
puppet strings generate manifests/*.pp
```

The puppet strings command should be run from the root of the module directory. The resulting documentation will by default be placed in a docs/ directory within the module.

If you are setup with the development environment as described in the [CONTRIBUTING document](CONTRIBUTING.md) :

```bash
bundle exec rake strings:generate manifests/*.pp
```

from within the module directory will generate the documentation as well.

## Limitations

This module is written to work with Puppet 4.7 or higher. Hiera 5 data is embedded within the module as well for Puppet 4.9 or higher. The module depends on Puppet 4 data types provided by [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib) as well as the [treydock-gpg_key](https://forge.puppet.com/treydock/gpg_key) module.

Originally written for CentOS 6/7 systems, it could work on other osfamily RedHat distributions. While Partek Flow supports installation on Debian based distributions, this module does not at this time.

This module was written to reflect initial installation and configuration [documentation provided by Partek](https://documentation.partek.com/display/FLOWDOC/). This is not an all inclusive module as there are configuration tasks that need to be done via the web UI to configure portions of the application. If you find some configuration option would be helpful for maintaining the software on your own servers, please submit an issue or pull request. The latest released version of Partek flow when this was written was: 6.0.17.0919.278-1 and serves as a start point for reference. It is possible that this module will work with prior partekflow versions; however, that condition has not been tested.

While the module maintainer supports the puppet code contained in the module, support for the application or performance of the Partek Flow software should be directed toward Partek. The module maintainer does not have a relationship with Partek.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-partekflow/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).
