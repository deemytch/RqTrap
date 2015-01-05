class Trap < ActiveRecord::Base
  has_many :rqs, :inverse_of => :trap
end
