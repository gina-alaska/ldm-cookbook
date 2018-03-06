# # encoding: utf-8

# Inspec test for recipe imiq-map-app-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

## test ldm
describe service('ldm') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# test ldm queue
describe file('/opt/ldm/var/queues/ldm.pq') do
  it { should exist }

end
