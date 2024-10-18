class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable #, :confirmable

  before_create :generate_authentication_token

  def generate_authentication_token
    self.token = SecureRandom.hex(10)
  end
  
  ROLES = %w[guest author]

  def author?
    role == 'author'
  end

  def guest?
    role == 'guest'
  end
end
