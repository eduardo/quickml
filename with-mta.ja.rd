=begin

= quickml������: ¾��MTA�ȶ�¸��������ˡ

�ǽ�������: 2002-04-28 (������: 2002-04-28)


== quickml�����Ф�����

1. quickml�����Ф�ư���� Unix�ۥ��Ȥ˥桼�� quickml �ȥ��롼
�� quickml ��������롣

2. quickmlrc ������򼡤Τ褦�����ꤹ�롣

  Config = {
    :user => 'quickml', 
    :group => 'quickml',
    :port => 10025,
    :bind_address => "127.0.0.1",

== DNS������

ư���������ɥᥤ�� (��: foobar.com) �� MX �� quickml ������
��ư���Ƥ���ۥ��Ȥ˸����롣

== MTA ������

=== qmail �ξ��

1. /var/qmail/control/rcpthosts ��

  foobar.com 

���ɲä��롣

2. /var/qmail/control/smtproutes ��

  foobar.com:localhost:10025 

���ɲä��롣

=== Postfix �ξ��

1. /etc/postfix/transport ��

  foobar.com smtp:[localhost:10025]

���ɲä��롣

2. /etc/postfix/main.cf ��

  transport_maps = hash:/etc/transport

���ɲä������Υ��ޥ�ɤ�¹Ԥ��롣

  # postmap transport 
  # postfix reload

== �ռ�

����ʸ���
((<��ƣ���|URL:http://cl.aist-nara.ac.jp/~taku-ku/>))
���餤������������򸵤ˤ��Ƥ��ޤ���

--

- ((<Satoru Takabayashi|URL:http://namazu.org/~satoru/>)) -

=end
