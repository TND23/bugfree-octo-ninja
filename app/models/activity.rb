class Activity < ActiveRecord::Base

  attr_accessible :tag, :content, :status, :overview, :started, :finished
  # each activity should belong to a user since two people shouldn't
  # be doing the exact same thing. If multiple people are doing similar
  # things on a project, this can be extended by adding a subActivity class
  # a has_many relation to a SubActivity class.
  belongs_to :user
  # note that an activity has a tag, which is just a string, and also has tags,
  # which are searchable parameters created from the tag string
  has_and_belongs_to_many :tags
  scope :are_tagged, where(:tagged => true)
  # provide ability to search for arbitrary tag
  # tags.split to array-ify the user input
  # old 1.9 syntax: lambda does not work :p
  scope :with_tag, ->(tag){ where(:tag => tag.split(" ")) }
  
  # {"utf8"=>"✓", "search"=>"", "search_by"=>"Tag", "owned_by"=>"Me", "commit"=>"OK", "action"=>"search", "controller"=>"activities"}
  def self.search(options)
   
    case options[:search_by]
    when "Tag"
      case options[:owned_by]
      when "Me"
        search_by_tags_me(options[:search], options[:current_user])
      when "All users"
        search_by_tags_all(options[:search])
      else 
        search_by_tags_my_depts(options[:search], options[:current_user])
      end
    end
  end
  # "Me", "All users", "Users in my departments"
  # necessary for full_calendar
  def as_json
    {
      :title => self.overview,
      :tag => self.tag,
      :editable => true,
      :content => self.content,
      :status => self.status,
      :start => self.started,
      :finish => self.finished,
      :user_id => self.user.id,
      :allDay => false,
      :recurring => false,
      :tagged => self.tagged,
      :url => Rails.application.routes.url_helpers.activity_path(id)  
    }
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

  def search_by_tags_all(search)
    
  end

  def search_by_tags_my_depts(search)
    
  end

  def search_over_my_depts
    
  end

  def search_over_all
    
  end

  def search_over_current_user
    
  end


end