#encoding: utf-8

require 'rubygems'
require 'mechanize'
require 'nokogiri'

def verifica_msgs_sala_tutoria(login, pass, course_id, opts={})
  opts[:proxy_server]      ||= ''
  opts[:proxy_port]        ||= 3128

  url_cederj = "http://graduacao.cederj.edu.br/ava/local/salatutoria/index.php?course_id="
  url_sala_tutoria = "http://graduacao.cederj.edu.br/dds/salatutoria/controle/controle.sala.tutoria.php?ususis=&disciplina="
  str_tutoria_sem_msg = "Não existem tópicos para esta disciplina!"

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
      
      if sala_tutoria_doc.to_str.include? str_tutoria_sem_msg
        return {}
      else
        rows = sala_tutoria_doc.xpath('//table/tbody/tr')

        duvidas = rows.collect do |row|
          duvida = {}
          [
            [:codigo, 'td[1]/text()'],
            [:assunto, 'td[2]/a/text()'],
            [:data, 'td[4]/text()'],
          ].each do |name, xpath|
            duvida[name] = row.at_xpath(xpath).to_s.strip
          end
          duvida
        end
        return duvidas
      end
    end
  end
end

