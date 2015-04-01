class Department < ActiveRecord::Base
  # the department class is more or less just a 'group'
  # that can be used to organize users.
  # this should help with user who wish to work on projects together etc.
  has_and_belongs_to_many :users
  attr_accessible :dept_name

  def add_user(usr)
    self.users << usr
  end
end