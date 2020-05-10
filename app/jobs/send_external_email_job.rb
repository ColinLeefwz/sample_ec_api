class SendExternalEmailJob < ApplicationJob
  def self.perform
    ExternalEmailSender.process
  end
end
