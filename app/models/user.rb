require 'bcrypt'
class User
  include Mongoid::Document
  attr_accessor :password, :password_confirmation
  field :username, type: String
  field :hashed_password, type: String
  field :salt, type: String
  field :email_address, type: String
  field :is_verified, type: Mongoid::Boolean
  field :verification_token, type: String
  
  before_save :hash_the_password
  before_save :default_values
  has_many :orders

  def passes_authentication?(password_to_check)
    BCrypt::Password.new(self.hashed_password).is_password?(password_to_check)
  end


  private
    def default_values
      #set up default value for verification token
      @code = ""
      r = rand(1544804416)
      6.times do
        @code += "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"[r%34]
        r = r/34
      end
      self.verification_token = @code
      #verified is false by default
      self.is_verified = false
    end

    def hash_the_password
      self.hashed_password = BCrypt::Password.create(self.password)
      self.password = self.password_confirmation = nil
    end

end
