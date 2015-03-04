name "web_application"
run_list "recipe[wp-nfs::server]", "recipe[wordpress-cookbook::default]"