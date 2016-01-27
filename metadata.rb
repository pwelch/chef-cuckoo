name             'cuckoo'
maintainer       'Paul Welch'
maintainer_email 'paul@pwelch.net'
license          'MIT'
description      'Installs/Configures Cuckoo'
long_description 'Installs/Configures Cuckoo'
version          '0.1.0'

depends 'poise-python'
depends 'supervisor'

%w{ ubuntu debian }.each do |os|
  supports os
end
