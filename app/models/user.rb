class User < ActiveRecord::Base

  attr_accessible :username, :password
  attr_reader :password

  validates :password_digest, :presence => true
  validates :session_token, :presence => true
  validates :username, :presence => true

  after_initialize :ensure_session_token

  # this probably isn't the perfect place to use this, but it works.
  has_and_belongs_to_many :departments
  has_many :activities, :as => :actionable, :dependent => :destroy

  # pass in the user credentials (password and username)
  # if the username exists, and the password is valid, good to go
  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    user.has_password?(password) ? user : nil if user
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  # Using the BCrypt gem, we make a new encrypted password (aka digest) 
  # using the plaintext passed in. If the resulting hash is in the range
  # of hashes that can be made by BCrypt from the password digest
  # stored for the user, it is valid.
  def has_password?(password)
    user_password = self.password_digest
    encrpyted_password = BCrypt::Password.new(user_password)
    encrpyted_password.is_password?(password)
  end

  # use BCrypt to store password digest in db.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  # unsafely save
  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save!
  end
  
  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end