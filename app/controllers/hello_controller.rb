class HelloController < ApplicationController
  include ActionController::Live
  # after_action :send_rqs_list, only: [:trap, :delete_rq]

#TODO user auth needed in the next round
  def home #one big button
    @traps = Trap.all.order('created_at DESC')
    @trap = Trap.new(trap_name: SecureRandom.hex(32))
  end

  def newtrap
    @trap = Trap.create(trap_params)
    redirect_to trap_list_path(@trap)
  end

  def trap #got incoming request and wrote it to db
    unless @trap = Trap.find_by(trap_name: params[:trap_name])
      render nothing: true, status: 503
    else
      @rq = Rq.create(
        trap: @trap,
        raw_query: request.inspect,
        ip: request.remote_ip,
        user_agent: request.env["HTTP_USER_AGENT"],
        method: request.method,
        rq: {
          url: request.original_url,
          headers: request.env.select{|k,v| k =~ /^HTTP|^CONTENT|^SERVER|^REMOTE|^REQUEST/ },
          body: request.body.read.to_s.force_encoding("utf-8"),
          scheme: request.env['rack.url_scheme']
        }
      )

      client = Faye::Client.new('http://localhost:9292/fafa')
      EM.run{ client.publish("/#{@trap.id}", :cmd => :insert, html: render_to_string('_request_line', layout: false)) }

      render text: "Ok. Got it."
    end
  end

  def trap_full #show all requests for one trap ordered by time
    unless @trap = Trap.find(params[:id])
      redirect_to root_path
    end
    @rqs = @trap.rqs.order('created_at DESC')
    @unwrapped = params[:unwrapped] ? params[:unwrapped].split(',').collect{|i| i.to_i } : []
    respond_to do |fmt|
      fmt.html { }
      fmt.json { render json: @rqs }
    end
  end

  def trap_oneline
    unless @rq = Rq.find(params[:id])
      redirect_to root_path
    end
    render '_request_line', layout: false
  end

  def delete_rq
    @rq = Rq.find(params[:id])
    @trap = @rq.trap
    if @rq.destroy
      client = Faye::Client.new('http://localhost:9292/fafa')
      EM.run{ client.publish("/#{@trap.id}", :cmd => :delete, rqid: params[:id]) }
    end
    render nothing: true
  end

  def delete_trap
    @trap = Trap.find(params[:id])
    @trap.destroy
    redirect_to root_url
  end

  private
  def trap_params
    params.require(:trap).permit(:trap_name, :comment)
  end
end
