class Department < ActiveRecord::Base
  # the department class is more or less just a 'group'
  # that can be used to organize users.
  # this should help with user who wish to work on projects together etc.
  has_and_belongs_to_many :users
  belongs_to :admin, :class_name => "User"
  has_many :activities, :as => :actionable
  attr_accessible :dept_name, :user_id

  def add_user(usr)
    self.users << usr
  end

  # This is here so that we can fetch a users departments via ajax
  # from the fullcalendar.
  # once we have the users departments, we can fetch those 
  # departments department activities, and populate those on 
  # the users calendar
  def as_json
    {
      :id => self.id,
      :admin_id => self.user_id,
      :dept_name => self.dept_name
    }
  end
end