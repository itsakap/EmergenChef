require 'bcrypt'
class User
  include Mongoid::Document
  attr_accessor :password, :password_confirmation
  field :username, type: String
  field :hashed_password, type: String
  field :salt, type: String
  field :email_address, type: String
  field :verification_token, type: String, default: ->{random_token}
  field :is_verified?, type: Mongoid::Boolean, default: false

  before_save :hash_the_password

  has_many :orders

  validates_uniqueness_of :username

  has_one :profile
  accepts_nested_attributes_for :profile

  
  def passes_authentication?(password_to_check)
    BCrypt::Password.new(self.hashed_password).is_password?(password_to_check)
  end

  private
    def random_token
      @code = ""
      r = rand(1544804416)
      6.times do
        @code += "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"[r%34]
        r = r/34
      end
      @code
    end

    def hash_the_password
      unless self.hashed_password
        self.hashed_password = BCrypt::Password.create(self.password)
        self.password = self.password_confirmation = nil
      end
    end

end
