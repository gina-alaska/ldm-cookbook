Vagrant.configure('2') do |config|

  #common = <<-SCRIPT
  #sudo echo "doing it!!"
  #sudo yum install -y lvm2
  #echo -e "yes\n100%" | sudo parted /dev/sda ---pretend-input-tty unit % resizepart 1
  #sudo xfs_growfs /
  #SCRIPT

  config.vagrant.plugins = ['vagrant-disksize']
  config.disksize.size = '100GB'
  config.vm.disk :disk, primary: true, size: "100GB"
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      ldm: {
        requests: [{
          feedset: "EXP",
          pattern: ".*",
          host: "upstream.example.edu",
          port: "12345"
        }],
        allows: [{
          feedset: "ANY",
          hostname: "^*\.example\.edu$",
          ok: "^this.*",
          not: "^not_this.*"
        }],
        accepts: [{
          feedset: "ANY",
          pattern: ".*",
          hostname: "^upstream\.example\.edu$"
        }]
      }
    }

    chef.run_list = [
        "recipe[minitest-handler::default]",
        "recipe[ldm::default]"
    ]
end
