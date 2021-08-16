class Webhook < ApplicationRecord
  self.primary_key = :id
  
  belongs_to :identity
end
