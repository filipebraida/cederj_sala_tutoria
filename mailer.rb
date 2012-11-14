#encoding: utf-8

require 'net/smtp'

def send_email(to, opts={})
	#Senders and Recipients
	opts[:from_name]    ||= 'Cederj Tutori'
	opts[:from_mail]    ||= 'me@mydomain.com'
	opts[:to_name]		||= 'My Friend'
	opts[:to_mail]     	||= 'them@theirdomain.com'

	#Servers and Authentication
	opts[:smtp_host]    ||= 'mail.mydomain.com'
	opts[:smtp_port]    ||= 25
	opts[:smtp_domain]	||= 'mydomain.com'
	opts[:smtp_user]   	||= 'user@mydomain.com'
	opts[:smtp_pwd]    	||= 'secure_password'

	#The subject and the message
	t = Time.now
	opts[:subj] = 'Sending Email with Ruby'
	opts[:msg_body] = "Check out the instructions on how to send mail using Ruby.\n"

	#The date/time should look something like: Thu, 03 Jan 2006 12:33:22 -0700
	msg_date = t.strftime("%a, %d %b %Y %H:%M:%S +0800")

	#Compose the message for the email
	msg = <<END_OF_MESSAGE
Date: #{msg_date}
From: #{opts[:from_name]} <#{opts[:from_mail]}>
To: #{opts[:to_name]} <#{opts[:to_mail]}>
Subject: #{opts[:subj]}
  
#{opts[:msg_body]}
END_OF_MESSAGE

	Net::SMTP.start(opts[:smtp_host], opts[:smtp_port], opts[:smtp_domain], opts[:smtp_user], opts[:smtp_pwd], :plain) do |smtp|
	  smtp.send_message opts[:msg], opts[:smtp_user], opts[:to_mail]
	end