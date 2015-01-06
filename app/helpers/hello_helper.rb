module HelloHelper
  def full_trap_name(trap)
    "http://#{request.host}:#{request.port}/#{trap.trap_name}"
  end
end
