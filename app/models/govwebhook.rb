class Govwebhook < ApplicationRecord
  self.primary_key = :id

  belongs_to :nggovcheck
end
