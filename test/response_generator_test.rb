require 'minitest/autorun'
require 'minitest/test'
require 'pry'
require_relative '../lib/response_generator'

class ResponseGeneratorTest < Minitest::Test

    def setup
        @response_generator = ResponseGenerator.new
    end

    def test_it_exists
        assert_instance_of ResponseGenerator, @response_generator 
    end

    def test_it_finds_path
        @response_generator.find_path(request_lines)
        request = ["GET /hello HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: 47feda2f-e31c-c29d-de15-6a3b30284999", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
        assert_equal "/hello", @response_generator.find_path(request)
    end

    def test_it_finds_verb
        @response_generator.find_verb(request_lines)
        request = ["GET /hello HTTP/1.1", "Host: localhost:9292", "Connection: keep-alive", "Cache-Control: no-cache", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36", "Postman-Token: 47feda2f-e31c-c29d-de15-6a3b30284999", "Accept: */*", "Accept-Encoding: gzip, deflate, br", "Accept-Language: en-US,en;q=0.9"]
        assert_eqaul "GET", @response_generator.find_verb(request)
    end

end
