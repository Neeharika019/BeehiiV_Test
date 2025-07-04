class Subscriber < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :status, inclusion: { in: %w[active inactive], message: "%{value} is not a valid status" }
  
  before_validation :normalize_email
  before_validation :set_default_status
  
  private
  
  def normalize_email
    self.email = email.strip.downcase if email.present?
  end
  
  def set_default_status
    self.status = 'active' if status.blank?
  end
end 