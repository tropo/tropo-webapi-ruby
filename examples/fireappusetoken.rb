# http://ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html 
require 'open-uri'

# Go fetch the contents of a URL & store them as a String
base_url = "http://192.168.26.21:8080/gateway/sessions?action=create&token="
token = "735241734c656d79616a43754162664e4b4f6d7a61747258525271436d53764b6c777a78655176695370746b"

time = Time.new

puts time.to_s
puts time.ctime
puts time.localtime
puts time.strftime("%Y-%m-%d %H:%M:%S")

nnow = time.strftime("%Y-%m-%d %H:%M:%S")
parammm = "&yuxiangjun= I am frank&noww= Now is " + nnow

=begin
open(base_url + token + parammm) {|f|
  f.each_line {|line| p line}
  p f.base_uri         # <URI::HTTP:0x40e6ef2 URL:http://www.ruby-lang.org/en/>
  p f.content_type     # "text/html"
  p f.charset          # "iso-8859-1"
  p f.content_encoding # []
  p f.last_modified    # Thu Dec 05 02:45:02 UTC 2002
}

=end
response = open(base_url + token + parammm).read

# "Pretty prints" the result to look like a web page instead of one long string of HTML
#URI.parse(response).class

# Print the contents of the website to the console
puts "\n\n#{response.inspect}\n\n"