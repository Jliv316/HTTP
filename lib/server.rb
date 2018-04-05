require 'socket'
require_relative 'response_generator'
require 'pry'

class Server
    attr_reader :tcp_server, :connection
    def initialize
        @tcp_server = TCPServer.new(9292)
        @connection = nil
    end

    def start_server
        response = ResponseGenerator.new
        p "Ready for a request"
        
        loop do 
            @connection = @tcp_server.accept
            response.accept_client(@connection)
            request_lines = []
            while line = @connection.gets and !line.chomp.empty?
                request_lines << line.chomp
            end
            p "Got this request:"
            p request_lines
            response.receive_request_lines(request_lines)
            output = response.parser(request_lines)
            close_server(output) if output == []
        end 

    end

    def close_server(output)
        @tcp_server.close
    end

end

x = Server.new
x.start_server




