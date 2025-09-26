class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin basic] }

  before_validation :set_default_role, on: :create

  def admin?
    role == "admin"
  end

  def basic?
    role == "basic"
  end

  private

  def set_default_role
    self.role ||= "basic"
  end
end
