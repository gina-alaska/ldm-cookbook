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

user node['ldm']['user']

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
end

template "#{node['ldm']['install_dir']}/etc/scour.conf" do
  source "scour.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    scours: node['ldm']['scours'] 
  })
end

template "#{node['ldm']['install_dir']}/etc/pqact.conf" do
  source "pqact.conf.erb"
  owner 'ldm'
  group 'ldm'
  mode 0644
  variables({
    pqacts: node['ldm']['pqacts'] 
  })
end

file "/etc/profile.d/ldm.sh" do
  content "export PATH=#{node['ldm']['install_dir']}/bin:$PATH"
  mode 0644
end

template "/etc/init.d/ldm" do
  source "ldm.erb"
  owner 'root'
  group 'root'
  mode 0755
  variables({
    user: node['ldm']['user'],
    ldmadmin: "#{node['ldm']['install_dir']}/bin/ldmadmin",
    pidfile: "#{node['ldm']['install_dir']}/ldmd.pid",
  })
end

service "ldm" do
  action [ :enable, :start ]
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
execute "create_ldm_queue" do
  environment({"PATH" => "#{node['ldm']['install_dir']}/bin:/usr/bin:$PATH"}) if node['ldm']['install_dir']
  command "#{node['ldm']['install_dir']}/bin/ldmadmin mkqueue -f > /tmp/ldm_test"
  user "ldm"
  group "ldm"
  not_if { system("#{node['ldm']['install_dir']}/bin/pqcheck") }
end

