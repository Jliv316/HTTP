require 'socket'
require_relative 'response_generator'

class Server
    attr_reader :tcp_server
    def initialize
        @tcp_server = TCPServer.new(9292)
    end

    def start_server
        response = ResponseGenerator.new
        p "Ready for a request"
        # client = tcp_server.accept
        # response.accept_client(client)

        loop do
            client = tcp_server.accept
            response.accept_client(client)
            request_lines = []
        while line = client.gets and !line.chomp.empty?
            request_lines << line.chomp
        end
        p "Got this request:"
        p request_lines
        response.receive_request_lines(request_lines)
        response.reader(request_lines)
        end 
    end
end

x = Server.new
x.start_server
