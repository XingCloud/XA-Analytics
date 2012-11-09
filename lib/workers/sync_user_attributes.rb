module Workers
  module SyncUserAttributes
    @queue = :sync_user_attributes

    def self.perform(project_id, action = "SAVE", user_attribute = nil)
      project = Project.find(project_id)
      if user_attribute.present?
        AnalyticService.sync_user_attribute(project, {:type => action, :params => [user_attribute].to_json})
      else
        project.merge_user_attributes(AnalyticService.sync_user_attributes(project))
      end
    end
  end
end