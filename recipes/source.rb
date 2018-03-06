
package 'gcc'

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

remote_file ldm_cache_file do
  source node['ldm']['source']
  checksum node['ldm']['checksum'] if node['ldm']['checksum']
  action :create_if_missing
  owner 'ldm'
  group 'ldm'
  notifies :run, "bash[extract_ldm]", :immediately
end

bash 'extract_ldm' do
  action :nothing
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  tar xzf #{ldm_cache_file}
  chown -R ldm.ldm #{ldm_src_dir}
  EOH
  not_if { ::File.exists? ldm_src_dir }
  notifies :run, "bash[build_ldm]", :immediately
end

bash 'build_ldm' do
  action :nothing
  user 'ldm'
  group 'ldm'
  cwd ldm_src_dir
  environment node['ldm']['build_env'] if node['ldm']['build_env'].any?
  code <<-EOH
    ./configure --disable-root-actions --disable-static --prefix=#{node['ldm']['install_dir']}
    make install
  EOH
  notifies :run, "bash[run_ldm_root_actions]", :immediately
end


bash 'run_ldm_root_actions' do
  action :nothing
  cwd ldm_src_dir
  code <<-EOH
    make root-actions
  EOH
end
