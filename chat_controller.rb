require 'singleton'
require 'json'

class ChatController

  include Singleton

  attr_accessor :connections

  def initialize
    @connections = [];
  end

  def sort(message)
    message = JSON.parse(message)

    case message["type"]
      when 'chat'
        addChatMessage(message)
    end
  end

  private

  def addChatMessage(message)
    puts @connections.length
    @connections.each do |connection|
      connection.send(message.to_json)
    end
  end
end
