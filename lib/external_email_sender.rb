class ExternalEmailSender
  def self.process
    emails = User.where(created_at: 1.day.ago.at_beginning_of_day..1.day.ago.at_end_of_day).pluck(:email)
    subject = 'How about these goods?'
    body = 'T-shirt, shoes, watches'
    emails.each do |email|
      send_email(subject, body, email)
    end
  end

  def self.send_email(subject, body, email)
    Rails.logger.info "sending to #{email}"
  end
end
