require 'spec_helper'

describe service('ldm') do
  it 'is running and enabled' do
    expect(described_class).to be_enabled
    expect(described_class).to be_running
  end
end

describe file('/opt/ldm/var/queues/ldm.pq') do
  it 'creates the default queue' do
    expect(described_class).to be_a_file
  end
end
