class Notice < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :activity

  def self.populate_default_activity_notice(activity)
    notice = Notice.new
    notice.activity = activity
    notice.set_all(activity)
    return notice
  end

  def set_all(activity)
    set_activity_notice_content(activity)
    set_activity_notice_kind(activity.status)
    set_activity_title(activity.overview)
  end
  
  private 

  def set_activity_notice_content(activity)
    self.content = <<-NCONTENT
      Status: #{activity.status}\n
      Started: #{activity.started}\n
      Kind: #{activity.kind}\n
    NCONTENT
  end

  def set_activity_notice_kind(status)
    if status == "New"
      self.kind = "Default"
    elsif status == "In Progress"
      self.kind = "IP"
    elsif status == "Completed"
      self.kind = "Comp"
    end
  end

  def set_activity_title(title)
    self.title = title
  end

end