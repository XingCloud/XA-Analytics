module Workers
  module LogAction
    @queue = :log_action
    def self.perform(project_id, resource_type, resource_name, action, user, perform_at)
      ActionLog.create!({:project_id => project_id,
                        :resource_type => resource_type,
                        :resource_name => resource_name,
                        :action => action,
                        :user => user,
                        :perform_at => perform_at})
    end
  end
end