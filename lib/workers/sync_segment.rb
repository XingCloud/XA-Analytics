module Workers
  module SyncSegment
    @queue = :sync_segment

    def self.perform(segment_id, project_id, action="APPEND_OR_UPDATE")
      segment = Segment.find(segment_id)
      project = (project_id.present? ? Project.find(project_id) : nil)
      AnalyticService.sync_segments(action, [segment], project)
      if action == "REMOVE"
        raise "destroy error" unless segment.destroy
      end
    end
  end
end