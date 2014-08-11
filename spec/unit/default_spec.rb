require_relative '../spec_helper'

describe 'ldm::default' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:queue_exists?).and_return(true)
    Mixlib::ShellOut.stub(:initialize).and_return(shellout)
  end

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'adds the ldm user' do
    expect(chef_run).to create_user('ldm')
  end

  it 'creates the ldm configuration' do
    expect(chef_run).to create_template('/opt/ldm/etc/ldmd.conf').with(
      owner: 'ldm',
      group: 'ldm',
      mode: 0644,
      variables: { accepts: [], allows: [], requests:[] }
    )
  end

  it 'sets env variables' do
    expect(chef_run).to create_file('/etc/profile.d/ldm.sh').with(
      content: "export PATH=/opt/ldm/bin:$PATH",
      mode: 0644
    )
  end

  it 'creates init scripts' do
    expect(chef_run).to create_template('/etc/init.d/ldm').with(
      source: 'ldm.erb',
      mode: 0755,
      variables: { user: 'ldm', ldmadmin: '/opt/ldm/bin/ldmadmin' }
    )
  end

  it 'starts and enables ldm' do
    expect(chef_run).to enable_service('ldm')
    expect(chef_run).to start_service('ldm')
  end

  context 'queue doesnt exist' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:queue_exists?).and_return(false)
    end
    it 'creates the ldm queue' do
      expect(chef_run).to run_execute('create_ldm_queue').with(
        environment: {'PATH' => '/opt/ldm/bin:/usr/bin:$PATH'},
        command: 'ldmadmin mkqueue',
        user: 'ldm',
        group: 'ldm'
      )
    end
  end

  context 'queue exists' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:queue_exists?).and_return(true)
    end
    it 'creates the ldm queue' do
      expect(chef_run).to nothing_execute('create_ldm_queue').with(
        environment: {'PATH' => '/opt/ldm/bin:/usr/bin:$PATH'},
        command: 'ldmadmin mkqueue',
        user: 'ldm',
        group: 'ldm'
      )
    end
  end

  context 'source install' do
    before do
      chef_run.node.set['ldm']['install_type'] = 'source'
      chef_run.converge
    end

    it 'includes the source recipe' do
      expect(chef_run).to include_recipe('ldm::_source')
    end
  end

  context 'package install' do
    before do
      chef_run.node.set['ldm']['install_type'] = 'package'
      chef_run.converge
    end

    it 'includes the package recipe' do
      expect(chef_run).to install_package('ldm')
    end
  end
end
