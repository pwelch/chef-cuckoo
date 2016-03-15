# Cuckoo
[![Build Status](https://secure.travis-ci.org/pwelch/chef-cuckoo.svg)](http://travis-ci.org/pwelch/chef-cuckoo)

Installs and configures [Cuckoo Malware Sandbox](https://cuckoosandbox.org/)

## Overview

Currently it just installs and configures basic Cuckoo Host.

## Usage

Add the default recipe to the node run list:
```
run_list(
  "recipe[apt]",
  "recipe[cuckoo::default]"
)
```

Cuckoo Sandbox Resources will be available at these locations:
- Cuckoo Web: http://NODE_IP_ADDRESS/
- Cuckoo API: http://NODE_IP_ADDRESS/api/cuckoo/status

## Contributing

1. Fork it ( https://github.com/pwelch/chef-cuckoo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
