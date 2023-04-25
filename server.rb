require 'socket'
require 'uri'
require 'net/http'
require 'json'

# Server bound to port 2000
server = TCPServer.new 2000
puts "Server is started at #{Time.now}\n"
puts ""

def get_user_from_uri(request)
    args = request.lines[0].split

    # Getting URI from request and remove first backslash
    username = args[1].delete('/')
    return username
end

# Makes user link and retrieve info from GitHub
def get_user_info(username)
    msg = ""
    if username == ""
        msg =
        "No username passed. Consider using host:port/username\n" +
        "Falling back to default account (r4whnx)\n"
        username = "r4whnx"

    # Underscore is not allowed in GH usernames so use it for k8s
    elsif username == "health_check"
        msg = "Ready\n"
        return msg
    end
    uri = URI('https://api.github.com/users/' + username)
    res = Net::HTTP.get_response(uri)
    
    if res.is_a?(Net::HTTPNotFound)
        msg = "Not found. Try another user\n"
    else
        parsed_res = JSON.parse(res.body)
        msg = msg +
        "User #{parsed_res['login']} is found.\n" +
        "User id is #{parsed_res['id']}.\n" + 
        "Profile can be found at #{parsed_res["html_url"]}\n"
    end
    return msg
end

class Response
    attr_reader :code
    def initialize(code:, data: "")
      @response =
      "HTTP/1.1 #{code}\r\n" +
      "Content-Length: #{data.size}\r\n" +
      "\r\n" +
      "#{data}\r\n"
      @code = code
    end
    def send(client)
      client.write(@response)
    end
end

def make_response(msg)
  Response.new(code: 200, data: msg)
end

loop do
    # Keyboard interruption
    trap "SIGINT" do
        puts "Exiting"
        exit
    end

    trap "SIGTERM" do
        puts "Termination signal recieved at #{Time.now}"
        sleep(3)
        exit
    end

    # Wait for a client to connect
    client = server.accept
    request = client.readpartial(2048)
    
    # Requests logging kinda
    puts request

    msg = get_user_info(get_user_from_uri(request))
    make_response(msg).send(client)
    client.close
end
