=begin
index:Ej

= quickml server: an easy-to-use mailing list system

Last Modified: 2004-10-20 (Since: 2002-02-12)

--

quickml server is an easy-to-use mailing list system.

== What's New

  * 2004-06-09: quickml 0.7 released!
    * Some bugs were fixed.
  * 2002-02-12: quickml 0.1 released!

== Characteristics

  * You can create mailing lists just by sending usual a mail
    (not a complicated ``command mail'').
  * You can create mailing lists of any names you like very easily.
  * You can create mailing lists with any subdomains you like.
  * quickml server runs as a stand-alone SMTP server.
  * quickml server delegates mail delivery to another mail server.
  * quickml server is simply written in Ruby.

== How to Use Mailing List Service

See ((<ml-usage.en.rd|URL:ml-usage.en.html>)).

== Supported Platforms

quickml server should work on most Unix platforms. quickml
server is tested on Red Hat Linux 7.2, NetBSD 1.5.1, and
Debian sarge.

== Requirements

  * ((<Ruby|URL:http://www.ruby-lang.org/>)) 1.6.7 or later.
  * Ruby 1.8.x is recommended.

== Installation

For standard installation, the following commands will do.

  % ./configure && make
  # make install # with root privilege

You can give parameters to configure if necessary.

  --with-user=USER        quickml runs as USER [root]
  --with-group=GROUP      quickml runs as GROUP [root]
  --with-pidfile=FILE     PID is stored in FILE  [/var/run/quickml.pid]
  --with-logfile=FILE     Log is recorded in FILE [/var/log/quickml.log]
  --with-rubydir=DIR      Ruby library files go to DIR [guessed]

== Configurations

The configuration file locates at /usr/local/etc/quickmlrc
by default.  Although there are many parameters, all that
you have to change are the only three following parameters.

=== :smtp_host

Set the mail server for mail delivery.

=== :domain

Set the domain name of mailing lists. i.e.. a part of a mail
address after `@' mark.

=== :postmaster

Set the From: address for sending error mails.

== How to Use quickml Server

=== Start

  # quickml-ctl start

=== Stop
  # quickml-ctl stop

=== Restart
  # quickml-ctl restart

== Automatic Error Mail Handling

Automatic error mail handling works if you are using
((<qmail|URL:http://www.qmail.org/>)) or
((<Postfix|URL:http://www.postfix.org/>)) supporting XVERP
extension as a mail server for delivery. quickml server
automatically removes a mail address when error mail returns
five times from the mail server for delivery. You can change
the threshold :auto_unsubscribe_count by editing quickmlrc
file.

If you are using qmail, set :use_qmail_verp = true in the
quickmlrc file. If you are using Postfix, no additional
configuration is needed.

== Subdomain Handling

You can create mailing lists with any subudomains you like
by employing DNS's wildcard MX feature.  To enable the
subdomain handling, all mails to any subdomains should be
delivered to quickml server. DNS's wildcard MX RR (Resource
Record) allows such a delivery.

The following illustrates a sample configuration for
BIND. In this example, quickml server runs at ml.pitecan.com
(192.168.0.1).

  $ORIGIN pitecan.com.
  @    IN MX 10 ml           ; 1
  *    IN MX 10 ml           ; 2
  ml   IN A     192.168.0.1  ; 3
       IN MX 10 ml           ; 4
  

=== Notes

  (1) All mails to @pitecan.com are delivered to ml.pitecan.com.
  (2) All mails to any subdomains at pitecan.com are delivered to ml.ptiecan.com.
  (3) IP address of ml.pitecan.com
  (4) MX RR

== Mailing List Data Files

Mailing list data files locate at /usr/local/var/lib/quickml
by default.  The following are basic files.

  * foo: Member list
  * foo,count: Serial Number
  * foo,keyword: Keyword for a sub mailing list

=== Special Files

You can create special mailing lists by creating the
following empty files.

  * foo,permanent: Permanent mailing list
  * foo,forward: Anyone-can-post mailing list
  * foo,unlimited: Mailing list with unlimited number of members.
  * foo,config: Configurations such as Number of members and Max size of mail.

== quickml-analog

quickml-analog is a tool to analyze quickml's log and
generate charts. gnuplot, ImageMagick, and ghostscript are
required. 

  % quickml-analog -i -o output-dir quickml.log

== Download

quickml server is a free software with ABSOLUTELY NO
WARRANTY under the terms of the GNU General Public License
version 2.

  * ((<URL:http://quickml.com/quickml/quickml-0.7.tar.gz>))
  * ((<URL:http://sourceforge.net/cvs/?group_id=111025>))

== QuickML History

Idea of QuickML emerged from a discussion by ((<Satoru
Takabayashi|URL:http://namazu.org/~satoru//>)) and
((<Toshiyuki Masui|URL:http://pitecan.com/>)).
quickml server has been implemented in Ruby by Takabayashi
based on the prototype in Perl by Masui.  subdomain support
was helped by 
((<Sohgo Takeuchi|URL:http://www.csl.sony.co.jp/person/sohgo/>)).

--

- ((<Satoru Takabayashi|URL:http://namazu.org/~satoru/>)) -

=end
