class Tag < ActiveRecord::Base
  attr_accessible :tag
  # prohibition of all special characters should make this safe by itself.
  validates :tag, 
  :format => { 
    :with => /\A(?!select\s*|insert\s*|create\s*|drop\s*|delete\s*)[A-Z0-9_\s]*\z/i,
    :message => "The tag was not of the form neccessary. Tags cannot contain special characters except underscore _ ."
  }
 
  # rails takes care of this pluralization correctly as of having written this
  has_and_belongs_to_many :activities

end

