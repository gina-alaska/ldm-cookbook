default['ldm']['source'] = "ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-6.11.6.tar.gz"
default['ldm']['version'] = "6.11.6"
default['ldm']['checksum'] = "43dab2a5b6072cd71f66c1d9708fc03d05c3e0db213d38d1b952c90037b14e55"
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
