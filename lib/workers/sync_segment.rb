module Workers
  module SyncSegment
    @queue = :sync_segment

    def self.perform(segment_id, segment, project_id, action="APPEND_OR_UPDATE")
      project = (project_id.present? ? Project.find(project_id) : nil)
      AnalyticService.sync_segments(action, {segment_id => segment.to_json}, project)
    end
  end
end