#
# Cookbook Name:: ldm
# Recipe:: default
#
# Copyright (C) 2013 Scott Macfarlane
#
# All rights reserved - Do Not Redistribute
#

node['ldm']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'ldm::_user'
include_recipe "ldm::#{node['ldm']['install_type']}"

template "#{node['ldm']['install_dir']}/etc/ldmd.conf" do
  source "ldmd.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    accepts: node['ldm']['accepts'],
    allows: node['ldm']['allows'],
    requests: node['ldm']['requests']
  })
  not_if { ::File.exist?("#{node['ldm']['install_dir']}/etc/ldmd.conf") && node['ldm']['overwrite_ldmd_conf'] == false }
end

template "#{node['ldm']['install_dir']}/etc/scour.conf" do
  source 'scour.conf.erb'
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    scours: node['ldm']['scours']
  })
end

template "#{node['ldm']['install_dir']}/etc/pqact.conf" do
  source 'pqact.conf.erb'
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    pqacts: node['ldm']['pqacts']
  })
  not_if { ::File.exist?("#{node['ldm']['install_dir']}/etc/pqact.conf") && node['ldm']['overwrite_pqact_conf'] == false }
end

file "/etc/profile.d/ldm.sh" do
  content <<-EOL.gsub(/^\W+/, '')
    export PATH=#{node['ldm']['install_dir']}/bin:$PATH
    export LDMHOME=#{node['ldm']['install_dir']}
  EOL
  mode 0644
end

template '/etc/init.d/ldm' do
  source 'ldm.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables({
    user: node['ldm']['user'],
    ldmadmin: "#{node['ldm']['install_dir']}/bin/ldmadmin",
    pidfile: "#{node['ldm']['install_dir']}/ldmd.pid",
  })
end

if node['ldm']['auto-start'] then
  service 'ldm' do
    action [ :enable, :start ]
  end
end

# setup some cronjobs
node['ldm']['cronjobs'].each do |cj|
  cron "#{cj['name']}" do
    minute "#{cj['minute']}"
    hour "#{cj['hour']}"
    day "#{cj['day']}"
    month "#{cj['month']}"
    weekday "#{cj['weekday']}"
    user "#{cj['user']}"
    command "#{cj['command']}"
    action :create
  end
end

#Only run this on first installation
execute 'create_ldm_queue' do
  environment({"PATH" => "#{node['ldm']['install_dir']}/bin:/usr/bin:$PATH"}) if node['ldm']['install_dir']
  command "#{node['ldm']['install_dir']}/bin/ldmadmin mkqueue"
  user "ldm"
  group "ldm"
  not_if { system("#{node['ldm']['install_dir']}/bin/pqcheck") }
end

file "#{node['ldm']['install_dir']}/var/queues/ldm.pq" do
  mode 0666
  only_if { node['ldm']['global_queue'] }
end
