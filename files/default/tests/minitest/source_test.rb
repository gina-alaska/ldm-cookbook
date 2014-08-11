require File.expand_path('../support/helpers', __FILE__)

describe 'ldm::default' do

  include Helpers::Ldm

  it 'downloads the ldm source' do
    file(ldm_source_path).must_exist
  end
end
