require "socket"
 
webserver = TCPServer.new('192.168.26.1', 2000)
while (session = webserver.accept)
  session.write(Time.now)
  session.print("Hello World!")
  session.close
end