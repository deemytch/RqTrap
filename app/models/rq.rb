class Rq < ActiveRecord::Base
  belongs_to :trap, :inverse_of => :rqs
  before_save :parse_rq

  private
  def parse_rq
#    logger.debug "rq: #{self.raw_query.inspect}"
#    self.raw_query.keys.each do |k|
#      rq[k] = raw_query[k]
#    end
  end
end
