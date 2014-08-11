#
# Cookbook Name:: ldm
# Recipe:: default
#
# Copyright (C) 2013 Scott Macfarlane
#
# All rights reserved - Do Not Redistribute
#

user 'ldm'

node['ldm']['dependencies'].each do |pkg|
  package pkg do
    action :install
  end
end

case node['ldm']['install_type']
when 'source'
  include_recipe "ldm::_source"
when 'package'
  package 'ldm'
end

file "/etc/profile.d/ldm.sh" do
  content "export PATH=#{node['ldm']['install_dir']}/bin:$PATH"
  mode 0644
end

template "#{node['ldm']['install_dir']}/etc/ldmd.conf" do
  source "ldmd.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    accepts: node['ldm']['ldmd']['accepts'],
    allows: node['ldm']['ldmd']['allows'],
    requests: node['ldm']['ldmd']['requests'],
    includes: node['ldm']['ldmd']['includes'],
    execs: node['ldm']['ldmd']['execs']
  })
end

template "#{node['ldm']['install_dir']}/etc/scour.conf" do
  source "scour.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    directories: node['ldm']['scour']
  })
end

template "#{node['ldm']['install_dir']}/etc/pqact.conf" do
  source "pqact.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    entries: node['ldm']['pqact']
  })
end

template "#{node['ldm']['install_dir']}/etc/netcheck.conf" do
  source "netcheck.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    upstreams: node['ldm']['netcheck']['upstream'],
    downstreams: node['ldm']['netcheck']['downstream'],
    mailnames: node['ldm']['netcheck']['mailname']
  })
end

#Only run this on first installation
execute "create_ldm_queue" do
  environment({"PATH" => "#{node['ldm']['install_dir']}/bin:/usr/bin:$PATH"}) if node['ldm']['install_dir']
  command "ldmadmin mkqueue"
  user "ldm"
  group "ldm"
  not_if { queue_exists? }
end

template "/etc/init.d/ldm" do
  source "ldm.erb"
  owner 'root'
  group 'root'
  mode 0755
  variables({
    user: 'ldm',
    ldmadmin: "#{node['ldm']['install_dir']}/bin/ldmadmin"
  })
end

service "ldm" do
  action [ :enable, :start ]
end
