# -*- mode: ruby -*-
# vi: set ft=ruby :



Vagrant.configure(2) do |config|
		
#		config.vm.provision "shell",
#			inline: "sudo rpm -i /vagrant/chef-12.0.3-1.x86_64.rpm"
	{"wp01" => "192.168.50.4", "wp02" => "192.168.50.5"}.each do |wpp, ip|
		config.vm.define "#{wpp}" do |wp|
#			wp.vm.synced_folder ".", "/vagrant", disabled: true
			wp.librarian_chef.cheffile_dir = "."
			wp.vm.hostname = "#{wpp}"
			wp.vm.network "private_network", ip: "#{ip}", virtualbox__intnet: "intnet"	
			wp.vm.box = "chef/centos-6.5"
			wp.vm.provider "virtualbox" do |vb|
#				vb.customize ['createhd', '--filename', "#{wpp}.vdi", '--size', 5 * 1024]
#				vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "#{wpp}.vdi"]
				vb.name = "#{wpp}"
				vb.gui = true
			end
			config.vm.provision "chef_solo" do |chef|	
				chef.cookbooks_path = "cookbooks"
				chef.roles_path = "roles"
				chef.add_role("web_application")
				chef.synced_folder_type = "rsync"
				chef.json = {
					'wp' => {
						'nfs' => "192.168.50.8"
					},
					'nginx' => {
						'default_root' => "/var/www/wordpress"
					}
				}
			 end
		end
	end
	config.vm.define "balancer" do |balancer|
		balancer.vm.network :forwarded_port, guest: 80, host: 80
#		balancer.vm.synced_folder ".", "/vagrant", disabled: true
		balancer.librarian_chef.cheffile_dir = "."
		balancer.vm.hostname = "balancer"
		balancer.vm.network "private_network", ip: "192.168.50.6", virtualbox__intnet: "intnet"
		balancer.vm.box = "chef/centos-6.5"
		balancer.vm.provider "virtualbox" do |vb|
			vb.name = "balancer"
			vb.gui = true
		end
		config.vm.provision "chef_solo" do |chef|	
			chef.roles_path = "roles"
			chef.cookbooks_path = "cookbooks"
			chef.add_role("balancer")
			chef.json = {
			'loadbalancer' => {
				'upstream_servers' => ["192.168.50.4:80", "192.168.50.5:80"]
				}
			}
		end	
	end	
	config.vm.define "db" do |db|
		db.vm.synced_folder "./chef_rpm", "/vagrant", type: "rsync"
		db.librarian_chef.cheffile_dir = "."
		config.vm.provision "shell",
			inline: "sudo rpm -i /vagrant/chef-12.0.3-1.x86_64.rpm"
		db.vm.hostname = "db"
		db.vm.network "private_network", ip: "192.168.50.7", virtualbox__intnet: "intnet"
		db.vm.box = "chef/centos-6.5"
		db.vm.provider "virtualbox" do |vb|
			vb.name = "db"
			vb.gui = true
		end
		config.vm.provision "chef_solo" do |chef|
			chef.cookbooks_path = "cookbooks"
			chef.roles_path = "roles"
			chef.add_role("database")
			chef.json = {
			"wordpress" => {
				"db" => {
					"host" => "192.168.50.7",
					"server" => "%"
					}
				}
			}
		end	
	end	
	config.vm.define "nfs" do |nfs|
		nfs.vm.synced_folder "./chef_rpm", "/vagrant", type: "rsync"
		nfs.librarian_chef.cheffile_dir = "."
		config.vm.provision "shell",
			inline: "sudo rpm -i /vagrant/chef-12.0.3-1.x86_64.rpm"
		nfs.vm.hostname = "nfs"
		nfs.vm.network "private_network", ip: "192.168.50.8", virtualbox__intnet: "intnet"
		nfs.vm.box = "chef/centos-6.5"
		nfs.vm.provider "virtualbox" do |vb|
			vb.name = "nfs"
			vb.gui = true
		end
		config.vm.provision "chef_solo" do |chef|	
			chef.cookbooks_path = "cookbooks"
			chef.roles_path = "roles"
			chef.add_role("nfs")
			chef.json = {
			"wordpress" => {
				"db" => {
					"host" => "192.168.50.8",
					"server" => "192.168.50.7"
					}
				}
			}
		end	
	end	
end