class Profile
  include Mongoid::Document
  field :startup_name, type: String
  field :address, type: String
  field :phone_number, type: String
  field :how_frequently_your_team_pulls_all_nighters, type: String
  field :party_size, type: Integer
  field :favorite_foods, type: String
  field :credit_card_number, type: String
  field :expiration_date, type: String
  field :cvv, type: String
  belongs_to :user
end
