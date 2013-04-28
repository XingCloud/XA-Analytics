module ProjectRanking
  @queue = :job_queue
  def self.perform
    projects = AnalyticService.pay_rank
    Project.transaction do
      (0..projects.length - 1).each do |index|
        project = Project.fetch(projects[index])
        project.update_attributes({:rank => index})
      end
    end
  end
end