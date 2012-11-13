#encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'nokogiri'

require 'fastthread'

def verifica_msgs_sala_tutoria(login, pass, course_id, opts={})
  opts[:proxy_server]      ||= ''
  opts[:proxy_port]        ||= 3128

  url_cederj = "http://graduacao.cederj.edu.br/ava/local/salatutoria/index.php?course_id="
  url_sala_tutoria = "http://graduacao.cederj.edu.br/dds/salatutoria/controle/controle.sala.tutoria.php?ususis=&disciplina="

  a = Mechanize.new

  if !opts[:proxy_server].empty?
    a.set_proxy opts[:proxy_server], opts[:proxy_port]
  end

  a.get(url_cederj + course_id.to_s) do |page|

    tutoria = page.form_with(:id => 'login') do |form|
      form.username  = login
      form.password  = pass
    end.click_button

    tutoria = a.get(url_sala_tutoria + course_id.to_s) do |sala_tutoria|
      sala_tutoria_doc = Nokogiri::HTML(sala_tutoria.content)
      
      if sala_tutoria_doc.to_str.include? "Não existem tópicos para esta disciplina!"
        return false
      else
        return true
      end
    end
  end
end

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