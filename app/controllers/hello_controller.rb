class HelloController < ApplicationController
#TODO user auth needed in the next round
  def home #one big button
    @traps = Trap.all.order('created_at DESC')
    @trap = Trap.new(trap_name: SecureRandom.hex(32))
  end

  def newtrap
    @trap = Trap.new(trap_params)
    if @trap.save
      flash[:success] = "The trap '#{@trap.trap_name}' is ok."
      redirect_to trap_list_path(@trap)
    else
      flash[:danger] = "The trap '#{@trap.trap_name}' is already there."
      redirect_to root_path
    end
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

  def rqs_list
    @trap = Trap.find(params[:id])
    @rqs = @trap.rqs.order('created_at DESC')
    @unwrapped = params[:unwrapped] ? params[:unwrapped].split(',').collect{|i| i.to_i } : []
    render '_rqs_listing', layout: false
  end

  def trap_oneline
    unless @rq = Rq.find(params[:id])
      redirect_to root_path
    end
  end

  def delete_rq
    @rq = Rq.find(params[:id])
    @trap = @rq.trap
    @rq.destroy
    @rqs = @trap.rqs.order('created_at DESC')
    respond_to do |format|
      format.html { render '_rqs_listing', layout: false, notice: 'Rq was successfully destroyed.' }
      format.json { render json: @trap.rqs }
    end
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
