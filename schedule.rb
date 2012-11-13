#encoding: utf-8

require 'fastthread'
require_relative 'cederj'

if __FILE__ == $0

login = ARGV[0]
pass = ARGV[1]
course_id = ARGV[2]

time = 5; #seconds

t = Thread.new do
  while true do
    if verifica_msgs_sala_tutoria(login, pass, course_id, :proxy_server => 'gwmul', :proxy_port => 3128)
      print 'Tem MSG'
    else
      print 'Não Tem MSG'
    end
    sleep time
  end
end

t.join # wait for thread to exit (never, in this case)
end