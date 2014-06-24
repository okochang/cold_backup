require_relative 'cold_backup_utils'
require_relative 'cold_backup_activity'
require_relative 'cold_backup_workflow'

ColdBackupUtils.new.workflow_client(ColdBackupWorkflow).start_execution("#{ARGV[0]}", "#{ARGV[1]}", "#{ARGV[2]}", "#{ARGV[3]}")
