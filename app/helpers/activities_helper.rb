module ActivitiesHelper

  def make_params
    wrap_params_into_nice_hash
  end

  def search
    # sample params hash:
    search_relevant_params = {:search => params[:search],:search_by => params[:search_by], :owned_by => params[:owned_by], :current_user => current_user}
    @activities = Activity.search(search_relevant_params)
  end

  def add_non_whitelisted_properties(activity)
    activity.add_tags
    activity.user = current_user
    activity.tagged = tagged?
  end

  private

  def tagged?
    params[:activity][:tag].any?
  end

  def create_notice(activity)
    notice = Notice.populate_default_activity_notice(activity)
    notice.save
  end

  # date selectors pass in 3 parameters
  # the single date param will be constructed from these 3
  def start_date
    params_list = params[:activity]
    year = params_list["started(1i)"].to_i
    month = params_list["started(2i)"].to_i
    day = params_list["started(3i)"].to_i
    hour = params_list["started(4i)"].to_i
    minute = params_list["started(5i)"].to_i
    DateTime.new(year,month,day,hour,minute)
  end

  def finish_date
    params_list = params[:activity]
    year = params_list["finished(1i)"].to_i
    month = params_list["finished(2i)"].to_i
    day = params_list["finished(3i)"].to_i
    hour = params_list["finished(4i)"].to_i
    minute = params_list["finished(5i)"].to_i
    if year == 0 || month == 0 || day == 0
      return nil
    else
      hour ||= 0
      minute ||= 0
      dt = DateTime.new(year,month,day,hour,minute)
      return dt
    end
  end

  # make sure that the overview is a string
  ["overview", "tag", "content", "kind"].each do |el|
    define_method "sanitize_#{el}" do
      params[:activity][el.intern].to_s
    end
  end

  # create a nice params to pass in
  def wrap_params_into_nice_hash
    hash =
      {
        "notify" => params[:activity][:notify],
        "kind" => sanitize_kind,
        "overview" => sanitize_overview,
        "content" => sanitize_content,
        "tag" => sanitize_tag,
        "started" => start_date,
        "finished" => finish_date,
        "status" => params[:activity][:status]
      }
  end
end