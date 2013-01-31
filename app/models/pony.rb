class Pony < ActiveRecord::Base
  attr_accessible :color, :kind_of, :name

  validates :name, :presence => true
end
