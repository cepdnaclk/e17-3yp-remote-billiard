mport time 
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import uuid
import base64
import json


client_ID = str(uuid.uuid1())
myMQTTClient = AWSIoTMQTTClient(client_ID)
myMQTTClient.configureEndpoint("alses9dufe5nu-ats.iot.us-east-1.amazonaws.com", 8883)
myMQTTClient.configureCredentials("/home/pi/Desktop/rusp/certificates/root.pem", "/home/pi/Desktop/rusp/certificates/private.pem.key", "/home/pi/Desktop/rusp/certificates/certificate.pem.crt")
myMQTTClient.configureOfflinePublishQueueing(-1) # Infinite offline Publish queueing
myMQTTClient.configureDrainingFrequency(2) # Draining: 2 Hz
myMQTTClient.configureConnectDisconnectTimeout(10) # 10 sec
myMQTTClient.configureMQTTOperationTimeout(5) # 5 sec
print ('Initiating Realtime Data Transfer From Raspberry Pi...\n')
myMQTTClient.connect()
print ('Publisher ID : '+client_ID)
with open("green.jpg", "rb") as image:
  f = image.read()
  encoded_data = base64.standard_b64encode(f)
  message = encoded_data.decode('utf-8')
  
data = {'Signal':True,'Publisher_ID':client_ID,'image1':message}
data1 = json.dumps(data)

myMQTTClient.publish(
    topic = "billiard/device1",
    QoS= 1,
    payload = data1
	)
