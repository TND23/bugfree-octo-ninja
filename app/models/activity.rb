class Activity < ActiveRecord::Base

  attr_accessible :tag, :content, :status, :overview, :started, :finished, :start, :finish, :notify, :kind, :repeats, :repeats_freq

  # we want an activity to be able to belong to a user or department
  belongs_to :actionable, :polymorphic => true
  # each activity should belong to a user since two people shouldn't
  # be doing the exact same thing. If multiple people are doing similar
  # things, it can belong to a department
  belongs_to :user
  # note that an activity has a tag, which is just a string, and also has tags,
  # which are searchable parameters created from the tag string
  has_and_belongs_to_many :tags
  belongs_to :department
  has_many :notices, :dependent => :destroy
  scope :are_tagged, where(:tagged => true)

  # some html displayed attributes will exist, so we don't want any script nastiness
  validates :content, :format => {
    :without =>  /\A.*<script>.*\z/,
    :message => "contained something suspicious."
  }

  default_scope {order('started DESC')}

  paginates_per 25

  def self.search(options)
   
    case options[:search_by]
    when "Tag"
      case options[:owned_by]
      when "Me"
        search_by_tags_me(options[:search], options[:current_user])
      else
        search_by_tags_all(options[:search])
      end
    when "Status"
      case options[:owned_by]
      when "Me"
        search_by_status_me(options[:search], options[:current_user])
      else
        search_by_status_all(options[:search])
      end
    end
  end

  # allows these to be downloaded as csvs i guess.
  def self.to_csv(str,options={})
    # list the columns which we will be retrieving data for
    column_names = ["tag", "content", "status", "overview", "started", "finished"]
    CSV.generate(options) do |csv|
      #binding.pry
      csv << column_names
      str.each do |activity|
        csv << activity.attributes.values_at(*column_names)
      end
    end
  end
  # hash to put it important details in json form, which will be used in the ajax methods in full_calendar
  def as_json
    # if it belongs to a department, user_id = 0
    user_id = self.user ? self.user.id : 0  
    {
      :id => self.id,
      :notify => self.notify,
      :kind => self.kind,
      :current_state => self.status,
      :title => self.overview,
      :tag => self.tag,
      :long_description => self.content,
      :editable => true,
      :start => self.started,
      :finish => self.finished,
      :end => self.finished,
      :department_id => self.department_id,
      :user_id => user_id,
      :allDay => false,
      :url => Rails.application.routes.url_helpers.activity_path(id) 
    }
  end

  def as_dept_json
    json_object = self.as_json
    json_object[:url] = Rails.application.routes.url_helpers.department_department_activity_path(self[:department_id], self[:id])
    json_object
  end

  # split the tags and then set the 'tagged' boolean (to speed up search)
  def add_tags
    tags = split_tags
    if tags.empty?
      return nil
    else
      # try and add relations to tags
      add_tag_associations(tags)
    end
  end

  def destroy_notices_if_completed(current_status)
    if self.notices.any? && current_status == "Completed"
      self.notices.delete_all
    end
  end

  private

  # if the tag already exists, add it to the association
  # otherwise, try and create the tag, and add it to the association if successful
  # HAVE NOT YET HANDLED TAGS THAT ARE NOT SAVED
  def add_tag_associations(tags)
    tags.each do |tag|
      t = Tag.find_by_tag(tag)
      if t
        self.tags << t
      else
        t = Tag.new(:tag => tag)
        self.tags << t if t.save
      end
    end        
  end

  # if we split the tag string and wind up with an empty array, there are no tags
  def set_tagged_bool
    self.tag.split(" ").empty? ? self.tagged = false : self.tagged = true
  end

  # determine if tags exist: if so, we will split them up and add relations
  def split_tags
    set_tagged_bool
    self.tagged ? self.tag.split(" ") : []
  end

  def self.search_by_tags_me(search, user)
    search = search.split(" ")
    return [] if search == []
    # find all Tag objects that have their tag attribute equal to part of the search
    # and then find all activities which have those tags and belong to the current_user
    Tag.where(:tag => search).collect{|candidate| candidate.activities.where(:user_id => user.id)}.flatten
  end

  # pretty much the same as above
  def self.search_by_tags_all(search)
    search = search.split(" ")
    return [] if search == []
    Tag.where(:tag => search).collect{|candidate| candidate.activities}.flatten
  end

  def self.search_by_status_me(search, user)
    return [] if search == []
    Activity.where(:status => search.capitalize, :user_id => user.id)
  end

  def self.search_by_status_all(search)
    return [] if search == []
    Activity.where(:status => search.capitalize)
  end

end