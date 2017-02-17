class User < ApplicationRecord

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :password, :length => { in: 8..24 },
                       :allow_nil => true
                       
  has_secure_password

  before_create :generate_token


  def generate_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(:auth_token => self[:auth_token])
  end

  def regenerate_auth_token
    self.auth_token = nil
    generate_token
    save!
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
end
