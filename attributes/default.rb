default['ldm']['source'] = "ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-6.12.9.tar.gz"
default['ldm']['checksum'] = "eccb66a5e86a6d43cabde28e048e70053374c53b85cebd37233920ae5d8c28d5"
default['ldm']['install_type'] = 'source'
default['ldm']['install_dir'] = '/opt/ldm'
default['ldm']['user'] = 'ldm'

#Build options
# -- See http://www.unidata.ucar.edu/software/ldm/ldm-6.11.6/basics/source-install-steps.html
# --   for available autoconf and build flags
default['ldm']['build_env'] = {
  "LDMHOME" => default['ldm']['install_dir']
}

#Package dependencies
default['ldm']['packages'] = [
  'perl',
  'libxml2',
  'libxml2-devel',
  'libpng',
  'libpng-devel',
  'zlib',
  'zlib-devel'
]


#LDM Configuration - ldmd.conf
default['ldm']['requests'] = Array.new
default['ldm']['accepts'] = Array.new
default['ldm']['allows'] = Array.new
#LDM Configuration - scour.conf
default['ldm']['scours'] = Array.new
#LDM Configuration - pqact.conf
default['ldm']['pqacts'] = Array.new

#cronjob Configuration
default['ldm']['cronjobs'] = Array.new
