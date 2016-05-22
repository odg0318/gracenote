$:.unshift File.expand_path(File.dirname(__FILE__))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'lib/exception'
require 'lib/session'
require 'lib/data'
require 'app/app'
require 'yaml'

$config = YAML.load(File.read('config.yaml'))

$session_manager = SessionManager.create_instance({
  :session_expired_time_secs => $config['session_expired_time_secs']
})

$members = {
  'gracenote' => Member.new('gracenote', '1234', 'gracenote'),
  'guri' => Member.new('guri', '1234', 'guri')
}

App.run!({
  :bind => '0.0.0.0',
  :port => $config['port'] 
})
