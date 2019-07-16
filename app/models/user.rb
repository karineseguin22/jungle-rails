class User < ActiveRecord::Base
    has_secure_password
    has_many :reviews 
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
end
