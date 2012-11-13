#encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'nokogiri'

require 'net/smtp'

require 'fastthread'

def verifica_msgs_cederj(login, pass, course_id)
  url_cederj = "http://graduacao.cederj.edu.br/ava/local/salatutoria/index.php?course_id="
  url_sala_tutoria = "http://graduacao.cederj.edu.br/dds/salatutoria/controle/controle.sala.tutoria.php?ususis=&disciplina="

  a = Mechanize.new #a.set_proxy 'gwmul', 3128

  a.get(url_cederj + course_id.to_s) do |page|

    tutoria = page.form_with(:id => 'login') do |form|
      form.username  = login
      form.password  = pass
    end.click_button

    tutoria = a.get(url_sala_tutoria + course_id.to_s) do |sala_tutoria|
      sala_tutoria_doc = Nokogiri::HTML(sala_tutoria.content)
      if sala_tutoria_doc.to_str.include? "Não existem tópicos para esta disciplina!"
        print "\n\n--Não possui dúvidas na sala de tutoria!!!\n\n"
        return false
      else
        print "\n\n--Possui dúvidas na sala de tutoria!\n\n"
        return true
      end
    end
  end
end

def send_email(to, opts={})
  opts[:server]      ||= 'localhost'
  opts[:from]        ||= 'email@example.com'
  opts[:from_alias]  ||= 'Example Emailer'
  opts[:subject]     ||= "You need to see this"
  opts[:body]        ||= "Important stuff!"

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
end

if __FILE__ == $0

login = ARGV[0]
pass = ARGV[1]
course_id = ARGV[2]

time = 5; #seconds

t = Thread.new do
  while true do
    if verifica_msgs_cederj(login, pass, course_id)
      print 'Tem MSG'
    else
      print 'Não Tem MSG'
    end
    sleep time
  end
end

t.join # wait for thread to exit (never, in this case)
end