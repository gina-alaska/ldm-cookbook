default['ldm']['source'] = "ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-6.12.4.tar.gz"
default['ldm']['version'] = "6.12.4"
default['ldm']['checksum'] = "b404db4c208e1ac02fdec1dbbfd84e3691ded520461b4266f45f1f684f565d4b"
default['ldm']['install_type'] = 'source'
default['ldm']['install_dir'] = '/opt/ldm'
default['ldm']['send_to_ucar'] = true

#Build options
# -- See http://www.unidata.ucar.edu/software/ldm/ldm-6.12.4/basics/source-install-steps.html
# --   for available autoconf and build flags
default['ldm']['build_env'] = {
  "LDMHOME" => '/opt/ldm'
}

#Package dependencies
default['ldm']['dependencies'] = [ 'perl' ]
default['ldm']['build_dependencies'] = [
  'libxml2-devel',
  'libpng-devel',
  'zlib-devel'
]

# ldmd.conf
# Requests take the form of:
# {
#   feedset: "",
#   pattern: "",
#   host: "",
#   port: "optional"
# }
default['ldm']['ldmd']['requests'] = []
# Accepts take the form of:
# {
#   feedset: "",
#   pattern: ".*",
#   hostname: "*.hostname"
# }
default['ldm']['ldmd']['accepts'] = []
# Allows take the form of:
# {
#   feedset: "",
#   hostname: "*.hostname",
#   ok: ".*(optional)",
#   not: ".*(optional)"
# }
default['ldm']['ldmd']['allows'] = []

# Includes and Execs are strings
default['ldm']['ldmd']['includes'] = []
default['ldm']['ldmd']['execs'] = []

#netcheck.conf
default['ldm']['netcheck'] = {
  upstream:   ['lightning.alden.com', 'unidata.ssec.wisc.edu'],
  downstream: ['atm.geo.nsf.gov', 'metlab1.met.fsu.edu'],
  mailname:   []
}

# pqact.conf
default['ldm']['pqact'] = []

# scour.conf
# Scour configuration takes the form of
# {
#   directory: '/path/to/somewhere',
#   days: 4
#   pattern: '*.dir.glob'
# }
default['ldm']['scour'] = []
