require 'json'

class WebSocketConnection
  OPCODE_TEXT = 0x01

  def initialize(socket)
    @socket = socket
  end

  def recv
    fin_and_opcode = @socket.read(1).bytes[0].to_s(2)

    fin = fin_and_opcode[0]
    opcode = "0x%02x" % fin_and_opcode[4,4].to_i(2)

    mask_and_length_indicator = @socket.read(1).bytes[0]
    length_indicator = mask_and_length_indicator - 128

    length =  if length_indicator <= 125
                length_indicator
              elsif length_indicator == 126
                @socket.read(2).unpack("n")[0]
              else
                @socket.read(8).unpack("Q>")[0]
              end

    mask = @socket.read(4).bytes
    encoded = @socket.read(length).bytes

    decoded = encoded.each_with_index.map do |byte, index|
      byte ^ mask[index % 4]
    end

    if fin === '1'
      case opcode
      when "0x01"
        return decoded.pack('c*')
      when "0x08"
        closeConnection
      end
    end

  end

  def send(message)
    bytes = [0x80 | OPCODE_TEXT]
    size = message.bytesize

    bytes +=  if size <= 125
                [size]
              elsif size < 2**16
                [126] + [size].pack("n").bytes
              else
                [127] + [size].pack("Q>").bytes
              end

    bytes += message.bytes
    data = bytes.pack("C*")
    @socket << data
  end

  def closeConnection
    @socket.close
  end

end
