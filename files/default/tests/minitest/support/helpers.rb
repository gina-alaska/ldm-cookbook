module Helpers
  module Ldm
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
    
    def ldm_source_path 
      "#{Chef::Config[:file_cache_path]}/#{node['ldm']['package']}"
    end
    
    def ldmd_conf
      "#{node['ldm']['install_dir']}/etc/ldmd.conf"
    end
    
    def pqact_conf
      "#{node['ldm']['install_dir']}/etc/pqact.conf"
    end
  end
end
