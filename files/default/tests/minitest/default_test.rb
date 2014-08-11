require File.expand_path('../support/helpers', __FILE__)

describe 'ldm::default' do

  include Helpers::Ldm

  # Example spec tests can be found at http://git.io/Fahwsw
  it 'installs package dependencies' do
    node['ldm']['packages'].each do |pkg|
      package(pkg).must_be_installed
    end
  end

  it 'creates the ldm user' do
    user(node['ldm']['user']).must_exist
  end
  
  it 'creates a valid queue' do
    assert_sh("#{node['ldm']['install_dir']}/bin/pqcheck")
  end
  
  it 'configures ldmd.conf' do
    file(ldmd_conf).must_have(:mode, 0644).with(:owner, 'ldm')
    file(ldmd_conf).must_include('REQUEST EXP .* upstream.example.edu:12345')
    file(ldmd_conf).must_include('ALLOW ANY ^*.example.edu$ ^this.* ^not_this.*')
    file(ldmd_conf).must_include('ACCEPT ANY .* ^upstream.example.edu$')
  end

  it 'configures pqact.conf' do
    true
  end
    
end
