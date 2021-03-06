class Trap < ActiveRecord::Base
  has_many :rqs, :inverse_of => :trap, :dependent => :destroy
  validates :trap_name, uniqueness: true
end
