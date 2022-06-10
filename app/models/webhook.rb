class Webhook < ApplicationRecord
  self.primary_key = :id

  belongs_to :identity
  # belongs_to :nggovcheck
end
