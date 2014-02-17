class Order
  include Mongoid::Document
  field :name, type: String
  field :party_size, type: Integer
  field :dietary_preferences, type: String
  field :address, type: String
  field :emergency_date, type: Date
  field :reason_for_event, type: String
  belongs_to :user

  validates_presence_of :name
end
