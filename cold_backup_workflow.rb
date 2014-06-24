require_relative 'cold_backup_utils'
require_relative 'cold_backup_activity'

class ColdBackupWorkflow
  extend AWS::Flow::Workflows

  workflow :cold_backup do
    {
      version: ColdBackupUtils::WF_VERSION,
      task_list: ColdBackupUtils::WF_TASK_LIST,
      execution_start_to_close_timeout: 3600,
    }
  end

  activity_client(:client) { { from_class: "ColdBackupActivity" } }

  def cold_backup(instance_id, public_ip_addr, username, keyname)
    client.get_public_ip_addr(instance_id)
    client.shutdown_mysql(public_ip_addr, username, keyname)
    client.start_mysql(public_ip_addr, username, keyname)
  end

end

ColdBackupUtils.new.workflow_worker(ColdBackupWorkflow).start if $0 == __FILE__
