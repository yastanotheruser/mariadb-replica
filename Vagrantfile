Vagrant.configure('2') do |config|
  NumNodes = 3
  hosts_file = ''

  (1..NumNodes).each do |i|
    node_name = "mariadb#{i}"
    node_addr = "172.31.255.#{i + 1}"
    hosts_file << "#{node_addr}\t#{node_name}\n"
    master_node = i % NumNodes + 1

    config.vm.define node_name do |node|
      node.vm.box = 'debian/bullseye64'
      node.vm.hostname = node_name
      node.vm.network 'private_network', ip: node_addr
      node.vm.provision 'install', type: 'shell', path: 'mariadb_install.sh',
        args: [i, master_node]
    end
  end

  hosts_script = <<EOF
cat >>/etc/hosts <<HOSTS_FILE
#{hosts_file}
HOSTS_FILE
EOF
  config.vm.provision 'shell', inline: hosts_script
  config.vm.provision 'uninstall', type: 'shell', path: 'mariadb_uninstall.sh' ,
    run: 'never'
  config.vm.provision 'dsdb', type: 'shell', path: 'setup_dsdb.sh',
    run: 'never'
end

# vim: set ft=ruby ts=2 sts=2 sw=2 et:
