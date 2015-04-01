module ActivitiesHelper

  def make_params
    wrap_params_into_nice_hash
  end

  def search
    # sample params hash:
    # {"utf8"=>"✓", "search"=>"", "search_by"=>"Tag", "owned_by"=>"Me", "commit"=>"OK", "action"=>"search", "controller"=>"activities"}
    search_relevant_params = {:search => params[:search],:search_by => params[:search_by], :owned_by => params[:owned_by], :current_user => current_user}
    @activities = Activity.search(search_relevant_params)
  end

  private

  def tagged?
    if params[:activity][:tag].empty?
      return false
    else 
      return true
    end
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
  def sanitize_overview
    params[:activity][:overview].to_s
  end

  def sanitize_tag
    params[:activity][:tag].to_s
  end

  def sanitize_content
    params[:activity][:content].to_s
  end

  # create a nice params to pass in
  def wrap_params_into_nice_hash
    hash =
      {
        "overview" => sanitize_overview,
        "content" => sanitize_content,
        "tag" => sanitize_tag,
        "started" => start_date,
        "finished" => finish_date,
        "status" => params[:activity][:status]
      }
  end

end
