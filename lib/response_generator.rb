require 'socket'
require './lib/diagnostics_output'
# require './lib/game'

class ResponseGenerator
    include DiagnosticsOutput

    attr_reader :request_lines, :counter, :client, :total_count, :random_number,
                :guesses
    
    def initialize
        @request_lines = []
        @counter = 0
        @total_count = 0
        @client = nil
        @random_number = nil
        @guesses = []
        # @game = Game.new
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

     def push(text)
        formatted_response = formatted_response(text)
        output = output(formatted_response)
        headers = headers(output)
        @client.puts headers
        @client.puts output
    end

    def push_post(text)

    end

    def find_path(request_lines)
        path = request_lines[0].split[1]
    end

    def find_verb(request_lines)
        verb = request_lines[0].split[0]
    end

    


    def parser(request_lines)
        path = find_path(request_lines)
        verb = find_verb(request_lines)
        if verb == "GET"
            case
            when path == "/"            then diagnostics_report(request_lines)
            when path == "/hello"       then hello_world_response
            when path == "/datetime"    then date_and_time
            when path == "/shutdown"    then shutdown
            when path.include?("word")  then grab_value(path)
            when path.include?("game")  then game_response
            else
                text = request_lines.join("\n")
                push(text)
            end
        elsif verb == "POST"
            case
            when path == "/start_game"  then start_game
            when path.include?("game")  then grab_value(path)
            else
                text = request_lines.join("\n")
                push(text)
            end
        end
    end

    #we want to start a game
    #

    def start_game
        text = "Good luck!"
        push(text)
        @random_number = rand(0..100)
    end

   
    #guess is sent from method below called "grab_value"
    def store_and_redirect(guess)
        @guesses << guess
        game_response(guess)
        #redirect
    end

    def game_response(guess)
        guess_feedback = guess_checker(guess)
        number_of_guesses = @guesses.length
        text = "Number of guesses: #{number_of_guesses}\n" +
                "Previous guess: #{guess}\n" +
                guess_feedback
        push(text)
    end

    def guess_checker(guess)
        #if the guess is higher than @random_number
        if guess.to_i == @random_number
            return "Horah! You've done it! Congratulations you guessed the correct number!"
        elsif guess.to_i > @random_number 
            return "Your guess was too high, try again."
        elsif guess.to_i < @random_number
            return "Your guess was too low, try again."
        end
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
        word_lookup(value) if path.include?("word")
        store_and_redirect(value) if path.include?("guess")
    end

    def word_lookup(value)

        matching_words = File.open("/usr/share/dict/words") do |word|
            word.grep(/\b#{value}\b/)
        end
        return = false if matching_word == []
        return = true
        word_output(value)
    end

    def word_ouput(value)
        if word_lookup == false
            text = "#{value.upcase} is not a known word"
        elsif word_lookup == true
            text = "#{value.upcase} is a known word"
        end
        push(text)
    end



end
