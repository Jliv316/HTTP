require 'socket'
require './lib/diagnostics_output'
class ResponseGenerator
    include DiagnosticsOutput

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
        when path == "/"            then diagnostics_report(request_lines)
        when path == "/hello"       then hello_world_response
        when path == "/datetime"    then date_and_time
        when path == "/shutdown"    then shutdown
        when path.include?("word")  then grab_value(path)
        when path == "/start_game"  then start_game
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

    def diagnostics_report(request_lines)

        report =   "Verb: #{verb_output(request_lines)}\n" +
                    "Path: #{path_output(request_lines)}\n" +
                    "Protocol #{protocol_output(request_lines)}\n" +
                    "Host: #{host_output(request_lines)}\n" +
                    "Port: #{port_output(request_lines)}\n" +
                    "Origin #{origin_output(request_lines)}\n" +
                    "Accept: #{accept_output(request_lines)}"

        push(report)
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

    def grab_value(path)
        value = path.split("=")[1]
        word_lookup(value)
    end

    def word_lookup(value)

        matching_words = File.open("/usr/share/dict/words") do |word|
            word.grep(/\b#{value}\b/)
        end
        return false if matching_words == []
        return true
    end


end
