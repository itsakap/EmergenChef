class Order
  include Mongoid::Document
  field :party_size, type: Integer
  field :dietary_preferences, type: String
  field :address, type: String
  field :emergency_date, type: Time
  field :reason_for_event, type: String
  belongs_to :user
end
