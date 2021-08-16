class Identity < ApplicationRecord
  has_many :webhooks, dependent: :destroy
end
