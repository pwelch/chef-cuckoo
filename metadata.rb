name             'cuckoo'
maintainer       'Paul Welch'
maintainer_email 'git@pwelch.net'
license          'MIT'
description      'Installs/Configures Cuckoo Malware Sandbox'
long_description 'Installs/Configures Cuckoo Malware Sandbox'
version          '0.2.0'

source_url 'https://github.com/pwelch/chef-cuckoo' if respond_to?(:source_url)
issues_url 'https://github.com/pwelch/chef-cuckoo/issues' if respond_to?(:issues_url)

depends 'apt'
depends 'poise-python'
depends 'supervisor'

%w{ ubuntu debian }.each do |os|
  supports os
end
