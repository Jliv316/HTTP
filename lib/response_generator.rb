require 'socket'
class ResponseGenerator
attr_reader :request_lines, :counter, :client, :total_count
    def initialize
        @request_lines = []
        @counter = 0
        @total_count = 0
        @client = nil
    end

    def accept_client(client)
        @client = client
    end

    def receive_request_lines(request_lines)
        @request_lines = request_lines
    end

    def formatted_response(request_lines)
        "<pre>" + request_lines + "</pre>"
    end

    def output(response)
        "<html><head></head><body>#{response}</body></html>"
    end

    def headers(output)
        ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"
        ].join("\r\n")
    
    end

    def find_path(request_lines)
        path = request_lines[0].split[1]
    end

    def reader(request_lines)
        path = find_path(request_lines)

        case
        # when path == "/"            then diagnostics_report
        when path == "/hello"       then hello_world_response
        when path == "/datetime"    then date_and_time
        when path == "/shutdown"    then shutdown
        else
            text = request_lines.join("\n")
            push(text)
        end
    end

    def push(text)
        formatted_response = formatted_response(text)
        output = output(formatted_response)
        headers = headers(output)
        @client.puts headers
        @client.puts output
    end

    def hello_world_response
        @counter += 1
        @total_count += 1
        text = "Hello World! (#{@counter})"
        push(text)
    end

    def shutdown
        total_requests = "Total Requests: #{@total_count}"
        push(total_requests)
        return []
        # puts "\nResponse complete, exiting."
    end

    def date_and_time
        @total_count += 1
        time = Time.now.strftime("%l:%M%p on %A, %B%e, %Y")
        push(time)
    end


end
