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
        request = ""
        assert_equal "/hello", response.find_path(request)
    end

end
