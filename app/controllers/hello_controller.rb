class HelloController < ApplicationController
#TODO user auth needed in the next round
  def home #one big button
    @traps = Trap.all.order('created_at DESC')
  end

  def newtrap
    @trap = Trap.create(trap_name: params[:trap_name])
    redirect_to trap_list_path(@trap)
  end

  def trap #got incoming request and wrote it to db
    unless @trap = Trap.find_by(trap_name: params[:trap_name])
      render nothing: true, status: 503
    end
    @rq = Rq.create(
      trap: @trap,
      raw_query: request.inspect,
      ip: request.remote_ip,
      user_agent: request.env["HTTP_USER_AGENT"],
      method: request.method,
      rq: {
        url: request.original_url,
        he: request.env.select{|k,v| k =~ /^HTTP|^CONTENT|^SERVER|^REMOTE|^REQUEST/ },
        bo: request.body.to_s.force_encoding("utf-8"),
        cookie: request.env['rack.request.cookie_string'],
        scheme: request.env['rack.url_scheme']
      }
    )
#    request.env.keys.each{|k| logger.debug "#{k}: #{request.env[k]}" }
    render text: "Ok. Got it."
  end

  def trap_full #show all requests for one trap ordered by time
    unless @trap = Trap.find(params[:id])
      redirect_to root_path
    end
    @rqs = @trap.rqs.order('created_at DESC')
  end

  def trap_oneline
    unless @rq = Rq.find(params[:id])
      redirect_to root_path
    end
  end

end
