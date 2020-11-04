default['ldm']['source'] = 'ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-6.13.6.tar.gz'
default['ldm']['checksum'] = 'f271bc2c6a02c28f74d1c8c179157d52c6ac39fc3a2b55d74c5030923fe2d54b'

default['ldm']['install_type'] = 'source'
default['ldm']['install_dir'] = '/opt/ldm'
default['ldm']['user'] = 'ldm'
default['ldm']['global_queue'] = false

# Build options
# -- See http://www.unidata.ucar.edu/software/ldm/ldm-6.11.6/basics/source-install-steps.html
# --   for available autoconf and build flags
default['ldm']['build_env'] = {
  'LDMHOME' => default['ldm']['install_dir']
}

# Package dependencies
default['ldm']['packages'] = [
  'perl',
  'libxml2',
  'libxml2-devel',
  'libpng',
  'libpng-devel',
  'zlib',
  'zlib-devel'
]

# LDM Configuration - ldmd.conf
default['ldm']['requests'] = Array.new
default['ldm']['accepts'] = Array.new
default['ldm']['allows'] = Array.new
# LDM Configuration - scour.conf
default['ldm']['scours'] = Array.new
# LDM Configuration - pqact.conf
default['ldm']['pqacts'] = Array.new

# cronjob Configuration
default['ldm']['cronjobs'] = Array.new

# start and enable ldm if true. Defaults to true to maintain compatibility
default['ldm']['auto-start'] = true

# Set to false to ignore the files once installed
default['ldm']['overwrite_ldmd_conf'] = true
default['ldm']['overwrite_pqact_conf'] = true
