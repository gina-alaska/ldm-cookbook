account = data_bag_item('users', 'ldm')

group 'ldm' do
  gid account['gid'] || account['uid']
end

user_account 'ldm' do
  gid 'ldm'
  home node['ldm']['install-dir']
  comment 'Sandy LDM'
  ssh_keys account['ssh_keys']
  ssh_keygen false
end
