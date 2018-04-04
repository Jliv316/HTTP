module DiagnosticsOutput
    
    def verb_output(request_lines)
        request_lines[0].split[0]
    end

    def path_output(request_lines)
        request_lines[0].split[1]
    end

    def protocol_output(request_lines)
        request_lines[0].split[2]
    end

    def host_output(request_lines)
        request_lines[1].split[1]
    end

    def port_output(request_lines)
        request_lines[1].split[1].split(":")[1]
    end

    def origin_output(request_lines)
        request_lines[1].split[1]
    end

    def accept_output(request_lines)
        request_lines[-6].split[1]
    end

end