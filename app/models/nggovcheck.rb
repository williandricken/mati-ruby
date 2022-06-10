class Nggovcheck < ApplicationRecord
  has_many :govwebhooks, dependent: :destroy
end
