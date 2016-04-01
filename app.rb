require 'pry'

require_relative 'websocket_server'
require_relative 'chat_controller'


server = WebSocketServer.new
chat_controller = ChatController.instance

loop do
  Thread.new(server.accept) do |connection|
    puts "Connected"
    chat_controller.connections.push(connection)
     while (message = connection.recv)
      chat_controller.sort(message)
    end
  end
end
