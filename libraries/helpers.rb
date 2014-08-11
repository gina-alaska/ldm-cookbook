include Chef::Mixin::ShellOut

def ldm_file
  require 'uri'
  require 'pathname'

  Pathname.new(URI.parse(node['ldm']['source']).path).basename.to_s
end

def ldm_cache_file
  ::File.join(Chef::Config[:file_cache_path], ldm_file)
end

def ldm_src_dir
  ::File.join(::File.dirname(ldm_cache_file),::File.basename(ldm_cache_file, ".tar.gz"))
end

def queue_exists?
  env = {"PATH" => "#{node['ldm']['install_dir']}/bin:$PATH"}

  cmd = shell_out!("pqcheck", {env: env, returns: [0,1]})
  cmd.status == 0
end
