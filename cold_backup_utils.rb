require 'aws/decider'

class ColdBackupUtils
  WF_VERSION = "1.1"
  ACTIVITY_VERSION = "1.0"
  WF_TASK_LIST = "workflow_task_list"
  ACTIVITY_TASK_LIST = "activity_task_list"
  DOMAIN = "ColdBackup"

  def initialize
    swf = AWS::SimpleWorkflow.new
    @domain = swf.domains[DOMAIN]
    unless @domain.exists?
      @domain = swf.domains.create(DOMAIN, 90)
    end
  end

  def activity_worker(klass)
    AWS::Flow::ActivityWorker.new(@domain.client, @domain, ACTIVITY_TASK_LIST, klass)
  end

  def workflow_worker(klass)
    AWS::Flow::WorkflowWorker.new(@domain.client, @domain, WF_TASK_LIST, klass)
  end

  def workflow_client(klass)
    AWS::Flow::workflow_client(@domain.client, @domain) { { from_class: klass.name } }
  end
  
end
