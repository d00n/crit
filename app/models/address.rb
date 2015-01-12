class Address < ActiveRecord::Base
  belongs_to :user

  #attr_accessible :line_one,
  #                :line_two,
  #                :city,
  #                :state,
  #                :postal_code,
  #                :country,
  #                :is_billing,
  #                :is_shipping,
  #                :user_id
  #
  #attr_accessor :line_one,
  #              :line_two,
  #              :city,
  #              :state,
  #              :postal_code,
  #              :country,
  #              :is_billing,
  #              :is_shipping,
  #              :user_id
end