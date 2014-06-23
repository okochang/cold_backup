require 'net/ssh'
require_relative 'cold_backup_utils'

class ColdBackupActivity
  extend AWS::Flow::Activities

  activity :get_public_ip_addr, :shutdown_mysql, :start_mysql, :create_ami do
    {
      version: ColdBackupUtils::ACTIVITY_VERSION,
      default_task_list: ColdBackupUtils::ACTIVITY_TASK_LIST,
      default_task_schedule_to_start_timeout: 30,
      default_task_start_to_close_timeout: 60
    }
  end

  def get_public_ip_addr
  end

  def shutdown_mysql(public_ip_addr, username, keyname)
    Net::SSH.start(public_ip_addr, username, keys: "~/.ssh/#{keyname}") do |ssh|
      command = "sudo service mysqld stop"
      puts ssh.exec!(command)
    end
    puts "shutdown complete"
  end

  def start_mysql(public_ip_addr, username, keyname)
    Net::SSH.start(public_ip_addr, username, keys: "~/.ssh/#{keyname}") do |ssh|
      command = "sudo service mysqld start"
      puts ssh.exec!(command)
    end
    puts "start complete"    
  end

  def create_ami
  end

end

ColdBackupUtils.new.activity_worker(ColdBackupActivity).start if $0 == __FILE__