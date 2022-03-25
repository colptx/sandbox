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

with open('PD_C3850.json') as f:
    PD_C3850 = json.load(f)

net_connect = ConnectHandler(**PD_C3850)
net_connect.enable()

output = net_connect.send_command('show int status | in 2/0/24')
print(output)

if any(hit in output for hit in {"err-disabled"}):
    config_commands = [ 'interface g2/0/24',
                        'shutdown',
                        'no shutdown' ]

    output = net_connect.send_config_set(config_commands)
    print(output)

    smtp_server = "smtp.domain.local"
    port = 25
    sender_email = "ch-sally@example.com"
    receiver_email = "email@example.com"
    subject = "port reset"
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