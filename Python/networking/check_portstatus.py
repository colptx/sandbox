import smtplib
import ssl
import json

from netmiko import ConnectHandler

"""
{
    "device_type": "cisco_ios",
    "host": "10.30.255.5",
    "username": "Administrator",
    "password": "password",
    "port": 22,
    "secret": "secret"
}
"""

with open('ch_c3650.json') as f:
    ch_c3650 = json.load(f)

net_connect = ConnectHandler(**ch_c3650)
net_connect.enable()

output = net_connect.send_command('show int status | in 3/0/37')
print(output)

if any(not hit in output for hit in {"disabled"}):
    
    smtp_server = "smtp.domain.local"
    port = 25
    sender_email = "ch-sally@example.com"
    receiver_email = "email@example.com"
    subject = "port status"
    body = "Don't have a good day; Have a great day.\n\n" + output
    message = 'Subject: {}\n\n{}'.format(subject, body)

    try:
        server = smtplib.SMTP(smtp_server, port)
        server.sendmail(sender_email, receiver_email, message)
    except Exception as e:
        print(e)
    finally:
        server.quit()
        print("Email sent Successfully.")