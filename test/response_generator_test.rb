require 'minitest/autorun'
require 'minitest/test'
require 'pry'
require 'faraday'
require_relative '../lib/response_generator'

class ResponseGeneratorTest < Minitest::Test

    def setup
        @response_generator = ResponseGenerator.new
    end

    def test_it_exists
        assert_instance_of ResponseGenerator, @response_generator 
    end

    def test_it_finds_path
        request = ["GET /hello HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: 47feda2f-e31c-c29d-de15-6a3b30284999", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
        assert_equal "/hello", @response_generator.find_path(request)
    end

    def test_it_finds_verb
        request = ["GET /hello HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: 47feda2f-e31c-c29d-de15-6a3b30284999", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
        assert_equal "GET", @response_generator.find_verb(request)
    end

    def test_it_can_count_hello
        request_lines = ["GET /hello HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: 47feda2f-e31c-c29d-de15-6a3b30284999", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
        @response_generator.parser(request_lines)
        assert_equal 1, @response_generator.counter
    end

    def test_faraday_can_get
        faraday = Faraday.new
        response = faraday.get 'localhost:9292/hello'
        binding.pry
        assert_eual response, response
    end

end
