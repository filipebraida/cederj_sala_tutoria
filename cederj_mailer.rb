#encoding: utf-8

require_relative 'cederj'
require_relative 'mailer'

if __FILE__ == $0
  login = ARGV[0]
  pass = ARGV[1]
  course_id = ARGV[2]
  yourDomain = ARGV[3]
  yourAccountName = ARGV[4]
  port = ARGV[5]
  yourPassword = ARGV[6]
  fromAddress = ARGV[7]
  toAddress = ARGV[8]

  puts 'Getting Msgs ...'
  duvidas = verifica_msgs_sala_tutoria(login, pass, course_id)
  puts '... ok'

  puts 'Sending E-Mail ...'
  send_email(duvidas, :yourDomain => yourDomain, :yourAccountName => yourAccountName, :port => port, :yourPassword => yourPassword, :fromAddress => fromAddress, :toAddress => toAddress)
  puts '... ok'
end
