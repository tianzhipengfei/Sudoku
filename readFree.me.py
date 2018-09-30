import requests
import time

check_url = 'http://readfree.me/accounts/checkin'

fp = open('auto_signon_readfree.log','a')
ISOTIMEFORMAT='%Y-%m-%d %X'
curtime = time.strftime( ISOTIMEFORMAT, time.localtime( time.time() ) )
print ('at %s'%curtime)
fp.write('at %s\n'%curtime)

print ("准备cookie中……\n")
fp.write('准备cookie中……\n')
#
cookie_str = 'csrftoken=n2wCKJ9PQcbCGZP3YvjpDsOvAFd9Hq8fYqhEwXuEa3uUSFuGQv0P9VrN9Y6xavyt; sessionid=bxdtykmwuwk5jmy14y1ar6tmgi7fq5aa'
cookie = {}
for line in cookie_str.split(';'):
    name,value=line.strip().split('=',1)
    cookie[name]=value
print (cookie)
fp.write('%s\n'%cookie)

print ('签到中……')
fp.write('签到中……\n')
res = requests.get(check_url,cookies=cookie)
print (res)
fp.write('%s\n\n'%res)