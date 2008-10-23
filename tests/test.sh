#! /bin/sh
#
# DON'T TRY IT!
#

HOST=`hostname`

function start {
    cat /dev/null > /var/spool/mail/$USER
    sudo rm -rf mldata
    rm -f quickml-log
    mkdir mldata
    sudo ruby -I ../lib ../quickml quickmlrc.test 
}

function finish {
    sleep 3
    sudo kill `cat quickml.pid`
}

function send_normal_mail {
    echo test | ruby sendmail.rb $1 test@$HOST 'test'
    sleep 1
}

function send_japanese_mail {
    cat > tmp.message <<EOF
Content-Type: text/plain; charset=ISO-2022-JP

日本語ですよ
EOF
    nkf -j tmp.message | ruby sendmail.rb $1 test@$HOST '=?iso-2022-jp?B?GyRCJEYkOSRIGyhC?='
    sleep 1
    rm -f tmp.message
}

function send_multipart_mail {
    cat > tmp.message <<EOF
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Oct_16_19:21:12_2002_747)--"

----Next_Part(Wed_Oct_16_19:21:12_2002_747)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

test
----Next_Part(Wed_Oct_16_19:21:12_2002_747)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="foobar.txt"

foobar

----Next_Part(Wed_Oct_16_19:21:12_2002_747)----
EOF
    cat tmp.message | ruby sendmail.rb $1 test@$HOST 'multipart'
    sleep 1
    rm -f tmp.message
}

function send_japanese_multipart_mail {
    cat > tmp.message <<EOF
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Oct_16_19:21:12_2002_747)--"

----Next_Part(Wed_Oct_16_19:21:12_2002_747)--
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit

てすと
----Next_Part(Wed_Oct_16_19:21:12_2002_747)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="foobar.txt"

foobar

----Next_Part(Wed_Oct_16_19:21:12_2002_747)----
EOF
    nkf -j tmp.message | ruby sendmail.rb $1 test@$HOST '=?iso-2022-jp?B?GyRCJF4kayRBJFEhPCRIGyhC?='
    sleep 1
    rm -f tmp.message
}

function add_member {
    echo add | ruby sendmail.rb $USER test@$HOST 'add' $1
    sleep 1
}
    
function join_ml {
    echo join | ruby sendmail.rb $1 test@$HOST 'join' $USER
    sleep 1
}
    
function remove_member {
    by=$1
    member=$2
    echo '' | ruby sendmail.rb $by test@$HOST 'remove' $member
    sleep 1
}

function unsubscribe {
    echo '' | ruby sendmail.rb $1 test@$HOST 'unsubscribe'
    sleep 1
}
    
function send_large_mail {
    ruby -e '500000.times {puts("o" * 10)}' |\
	ruby sendmail.rb $USER test@$HOST 'large'
    sleep 1
}

function send_japanese_large_mail {
    (echo "Content-Type: text/plain; charset=ISO-2022-JP"
	ruby -e '500000.times {puts("o" * 10)}' ) |\
	ruby sendmail.rb $USER test@$HOST '=?iso-2022-jp?B?GyRCJEckKyQkGyhC?='
    sleep 1
}

function send_longline_mail {
    ruby -e 'printf "%s\n", "o" * 2000' |\
	ruby sendmail.rb $USER test@$HOST 'longline'
    sleep 1
}

start
  send_normal_mail root@localhost               # create new ML by root@localhost
  send_normal_mail satoru@localhost             # must be rejected
  send_japanese_multipart_mail satoru@localhost # must be rejected 
  send_multipart_mail satoru@localhost # must be rejected 
  unsubscribe root@localhost                    # close ML

  send_normal_mail satoru@localhost   # create new ML
  send_normal_mail SATORU@LOCALHOST   # case-insensitive OK?
  send_multipart_mail satoru@localhost 
  send_japanese_mail satoru@localhost # Japanese
  send_normal_mail root@localhost     # must be rejected
  add_member postmaster
  add_member root@localhost           # exceeds :max_members
  remove_member SATORU@LOCALHOST postmaster
  join_ml root@localhost
  remove_member root@localhost Satoru@Localhost
  send_normal_mail satoru@localhost   # return
  remove_member satoru@localhost root@localhost
  add_member nonexistent
  send_normal_mail satoru@localhost
  send_normal_mail Satoru@Localhost
  send_normal_mail SATORU@LOCALHOST    # exceeds :auto_unsubscribe_count
  unsubscribe satoru@localhost         # close ML

  send_normal_mail satoru@localhost    # 
  unsubscribe satoru@localhost         # close ML (English report mail)

  send_normal_mail satoru@localhost   # re-create new ML by satoru@localhost
  send_large_mail
  send_longline_mail
  send_japanese_multipart_mail satoru@localhost 
  send_japanese_large_mail
  sleep 180		              # automatic ML deletion

finish
