require 'faye'

Faye::WebSocket.load_adapter('thin')
app = Faye::RackAdapter.new(mount: '/fafa', timeout: 31, ping: 30)
run app
