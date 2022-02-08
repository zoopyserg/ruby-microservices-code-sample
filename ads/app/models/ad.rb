# frozen_string_literal: true

class Ad < ActiveRecord::Base
  validates :title, :description, :city, :user_id, presence: { message: "%<attribute>s can't be blank" }
end
