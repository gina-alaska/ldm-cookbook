include_recipe "build-essential"

ldm = "ldm-#{node['ldm']['version']}"

remote_file "#{Chef::Config[:file_cache_path]}/#{ldm}.tar.gz" do
  source node['ldm']['source']
  checksum node['ldm']['checksum'] if node['ldm']['checksum']
  action :create_if_missing
  owner 'ldm'
  group 'ldm'
  notifies :run, "script[build_ldm]"
end

directory node['ldm']['install_dir'] do
  user 'ldm'
  group 'ldm'
  recursive true
end

directory "#{node['ldm']['install_dir']}/etc" do
  user 'ldm'
  group 'ldm'
  recursive true
end

script 'build_ldm' do
  action :nothing
  user 'ldm'
  group 'ldm'
  interpreter "bash"
  environment node['ldm']['build_env'] if node['ldm']['build_env'].any?
  cwd "/home/ldm/"
  code <<-EOH
    gunzip -c #{Chef::Config[:file_cache_path]}/#{ldm}.tar.gz | (mkdir -p #{ldm} && cd #{ldm} && tar -xf - && mv #{ldm} src)
    cd #{ldm}/src
    ./configure --disable-root-actions --prefix=#{node['ldm']['install_dir']} --exec-prefix=#{node['ldm']['install_dir']}
    make
    make install
  EOH
  notifies :run, "script[run_ldm_root_actions]"
end

script 'run_ldm_root_actions' do
  action :nothing
  interpreter "bash"
  cwd "/home/ldm/#{ldm}/src"
  code <<-EOH
    make root-actions
  EOH
end
