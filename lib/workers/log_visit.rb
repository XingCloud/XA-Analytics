module Workers
  module LogVisit
    @queue = :log_visit
    def self.perform(project_id, user_name)
      user = User.find_by_name(user_name)
      if user.present?
        project_user = user.project_users.find_by_project_id(project_id)
        if project_user.present?
          project_user.update_attributes({:visit => project_user.visit + 1})
        end
      end
    end
  end
end