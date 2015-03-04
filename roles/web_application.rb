name "web_application"
run_list "recipe[wp-nfs::client]", "recipe[wp-apache2]", "recipe[apache2::mod_php5]", "recipe[php::module_mysql]"