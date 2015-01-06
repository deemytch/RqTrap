class Rq < ActiveRecord::Base
  belongs_to :trap, :inverse_of => :rqs
end
