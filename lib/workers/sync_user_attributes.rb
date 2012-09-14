module Workers
  module SyncUserAttributes
    @queue = :sync_user_attributes

    def self.perform(project_id, action = "SAVE", user_attribute_id = nil)
      project = Project.find(project_id)
      if user_attribute_id.present?
        user_attribute = UserAttribute.find(user_attribute_id).serialize
        AnalyticService.sync_user_attribute(project, {:type => action, :params => [user_attribute].to_json})
        if action == "REMOVE"
          raise "destroy error" unless user_attribute.destroy
        end
      else
        project.merge_user_attributes(AnalyticService.sync_user_attributes(project))
      end
    end
  end
end