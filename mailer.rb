#encoding: utf-8

require 'net/smtp'

def send_email(duvidas, opts={})
	opts[:yourDomain] 	     ||= ''
	opts[:yourAccountName]       ||= ''
	opts[:port]	  	     ||= ''
	opts[:yourPassword]	     ||= ''
	opts[:fromAddress]	     ||= ''
	opts[:toAddress]	     ||= ''

  if duvidas.empty?
    @msg = "Subject: AutoTutoria - Sem Dúvidas!\nYeah!"
  else
    @msg = "Subject: AutoTutoria - Dúvidas!\nSe Ferrou!"
  end

  smtp = Net::SMTP.new opts[:yourDomain], opts[:port]
	smtp.enable_starttls

  smtp.start(opts[:yourDomain], opts[:yourAccountName], opts[:yourPassword], :login) do
	  smtp.send_message(@msg, opts[:fromAddress], opts[:toAddress])
	end
end
