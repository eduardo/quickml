require 'net/smtp'

if ARGV.length < 3
  puts "usage: cat message | ruby sendmail.rb <from> <to> <subject> [cc]"
  exit 1
end

from = ARGV.shift
to = ARGV.shift
subject = ARGV.shift
cc = (ARGV.shift or "")
lines = readlines

contents = []
if lines.length == 1
  body = lines.first
  contents = [
    "To: #{to}\n", 
    "From: #{from}\n",
    "Subject: #{subject}\n",
    "Cc: #{cc}\n",
    "\n",
    body]
else
  body = lines.join('')
  contents = [
    "To: #{to}\n", 
    "From: #{from}\n",
    "Subject: #{subject}\n",
    "Cc: #{cc}\n",
    body]
end

Net::SMTP.start("localhost") {|smtp|
  smtp.send_mail(contents, from, to)
}

