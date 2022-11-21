from imutils.video import VideoStream
import datetime
import imutils
import time
import cv2
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import uuid
import json
import base64
import numpy as np
import argparse

from PIL import Image
#hsv limits
lower = {
     'red':(153,0,0),
         'green':(66,46,224),
         'blue':(75,216,0),
        'yellow':(23,59,119),
        'orange':(0,6,78),
         'purple':(112,46,175),
         'burgundy':(177,47,0)
         }

upper = {
'red':(255,255,255),
         'green':(91,177,255),
         'blue':(255,255,255),
         'yellow':(50,255,255),
    'orange':(40,255,255),
     'purple':(78,252,145),
      'burgundy':(255,255,255)
         }

# define standard colors for circle around the object
colors = {
'red':(0,0,255),
          'green':(0,255,0),
          'blue':(255,0,0),
         'yellow':(0,255,217),
         'orange':(0,140,255),
   'purple':(151,56,29),
          'burgundy':(13,50,0)
          }

def publish(img):
  client_ID = str(uuid.uuid1())
  myMQTTClient = AWSIoTMQTTClient(client_ID)
  myMQTTClient.configureEndpoint("afi69rocow2w9-ats.iot.ap-northeast-1.amazonaws.com", 8883)
  #myMQTTClient.configureCredentials("/home/pi/Desktop/rusp/certificates/root.pem", "/home/pi/Desktop/rusp/certificates/private.pem.key", "/home/pi/Desktop/rusp/certificates/certificate.pem.crt")
  myMQTTClient.configureCredentials("Root.pem", "private.pem.key", "certificate.pem.crt")
  myMQTTClient.configureOfflinePublishQueueing(-1) # Infinite offline Publish queueing
  myMQTTClient.configureDrainingFrequency(2) # Draining: 2 Hz
  myMQTTClient.configureConnectDisconnectTimeout(10) # 10 sec
  myMQTTClient.configureMQTTOperationTimeout(5) # 5 sec
  print ('Initiating Realtime Data Transfer From Raspberry Pi...\n')
  myMQTTClient.connect()
  print ('Publisher ID : '+client_ID)
  with open(img, "rb") as image:
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

def optimize():
  font = cv2.FONT_HERSHEY_SIMPLEX
  #frame1 = cv2.imread("balls3.webp")
  frame1 = cv2.imread('recieved.jpg')
  h, w, c = frame1.shape
  cv2.imwrite('testimg.jpg', frame1)
  wht = cv2.imread("white.jpg")
  wht =cv2.resize(wht,(w,h)) #same size whie back ground
  #cv2.imshow("Outputw",wht)
  #out =cv2.cvtColor(frame1,cv2.COLOR_BGR2GRAY)
  #out=cv2.Canny(imgGray,40,60)
  #out =frame1.copy()
  #cv2.imshow("Output",out)

  #frame1 =cv2.resize(frame1,(800,400))
  blurred = cv2.GaussianBlur(frame1,(11,11),0)
  hsv = cv2.cvtColor(frame1,cv2.COLOR_BGR2HSV)
      #for each color in dictionary check object in frame1
  for key, value in upper.items():
      kernel = np.ones((9,9),np.uint8)
      mask = cv2.inRange(hsv,lower[key],upper[key])
      #cv2.imshow("mask", mask)
      cv2.waitKey(0)
      mask = cv2.morphologyEx(mask,cv2.MORPH_OPEN,kernel)
      #cv2.imshow("mask1", mask)
      #cv2.waitKey(0)
      mask = cv2.morphologyEx(mask,cv2.MORPH_CLOSE,kernel)
      #cv2.imshow("mask2", mask)
      #cv2.waitKey(0)
      res1 = cv2.bitwise_and(frame1, frame1, mask=mask)
      #cv2.imshow("res", res1)
      #cv2.waitKey(0)


      #Calculate percentage of pixel colors
      output = cv2.countNonZero(mask)
      res = np.divide(float(output),mask.shape[0]*int(mask.shape[1] / 128))
      percent_colors = np.multiply((res),400) / 10000
      percent=(np.round(percent_colors*100,2))

      print(key,percent)



      cnts = cv2.findContours(mask.copy(),cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)[-2]

      #print(type(cnts))

      if(len(cnts)==0):
        continue
      
      cv2.drawContours(frame1, cnts, -1, (10, 0, 200), 3)
      #for stripe balls (min areas)
      #print(cnts)
      #print(cv2.contourArea(cnts))
      c1 = min(cnts, key=cv2.contourArea)
      #print("Area",c1)

      if(percent > 3.3):
        ((x1, y1), radius1) = cv2.minEnclosingCircle(c1)
        #center calculation
        M1 = cv2.moments(c1)
        center1 = (int(M1["m10"] / M1["m00"]), int(M1["m01"] / M1["m00"]))
        #drawing circles
        cv2.circle(frame1, (int(x1), int(y1)), int(radius1), colors[key], 2)
        cv2.circle(wht, (int(x1), int(y1)), int(radius1), colors[key], 2)
        #drwaing marker and text
        cv2.drawMarker(wht, center1, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
        cv2.putText(frame1, 'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
        cv2.putText(wht,  'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
        center = None

        #For solid balls (max)
        #if len(cnts) > 0:
        c = max(cnts, key=cv2.contourArea)
        ((x,y), radius) = cv2.minEnclosingCircle(c)
        M = cv2.moments(c)
        center = (int(M["m10"] / M["m00"]),int(M["m01"] / M["m00"]))

       
        #draw circles
        cv2.circle(frame1,(int(x),int(y)),int(radius),colors[key],2)
        cv2.circle(wht, (int(x), int(y)), int(radius), colors[key], 2)
        #draw markers and text
        cv2.drawMarker(wht, center, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
        cv2.putText(frame1,'solid-' +key,(int(x-radius),int(y-radius)),font,0.6,colors[key],2)
        cv2.putText(wht, 'solid-' + key, (int(x - radius), int(y - radius)), font, 0.6, colors[key], 2)
      elif(percent<1.5):
        ((x1, y1), radius1) = cv2.minEnclosingCircle(c1)
        #center calculation
        M1 = cv2.moments(c1)
        center1 = (int(M1["m10"] / M1["m00"]), int(M1["m01"] / M1["m00"]))
        #drawing circles
        cv2.circle(frame1, (int(x1), int(y1)), int(radius1), colors[key], 2)
        cv2.circle(wht, (int(x1), int(y1)), int(radius1), colors[key], 2)
        #drwaing marker and text
        cv2.drawMarker(wht, center1, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
        cv2.putText(frame1, 'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
        cv2.putText(wht,  'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
        center = None
      else:
        c = max(cnts, key=cv2.contourArea)
        ((x,y), radius) = cv2.minEnclosingCircle(c)
        M = cv2.moments(c)
        center = (int(M["m10"] / M["m00"]),int(M["m01"] / M["m00"]))

       
        #draw circles
        cv2.circle(frame1,(int(x),int(y)),int(radius),colors[key],2)
        cv2.circle(wht, (int(x), int(y)), int(radius), colors[key], 2)
        #draw markers and text
        cv2.drawMarker(wht, center, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
        cv2.putText(frame1,'solid-' +key,(int(x-radius),int(y-radius)),font,0.6,colors[key],2)
        cv2.putText(wht, 'solid-' + key, (int(x - radius), int(y - radius)), font, 0.6, colors[key], 2)


  #writeng and showing outputs
  cv2.imwrite('Colors.jpg', frame1)
  #cv2.imshow("Frame",frame1)
  #cv2.imwrite('Colors1.jpg', out)
  #cv2.imshow("Output1",wht)
  return wht


def resignal (self,dontcare,data):
  print("\nRecieving data from AWS IoT core\n")
  print("\nTopic: "+ data.topic)
	#print("Data: ", (data.payload))
	#print(type(data.payload))
  data1 = json.loads(data.payload)
	#print(data1)
	#f = open('receive.jpg','w')
	#f.write(data.payload)
	#f.close()
  print("\nSenders ID: "+data1["Publisher_ID"])
  bytes = data1["image1"].encode('utf-8')
  with open('recieved.jpg', 'wb') as file_to_save:
    decoded_image_data = base64.standard_b64decode(bytes)
    file_to_save.write(decoded_image_data)
    print("Image received")
    wt =optimize()
    cv2.imshow("optimized",wt)
    cv2.imwrite("optimized.jpg",wt)
    publish("optimized.jpg")
		# open method used to open different extension image file
		#im = Image.open(r"recieved.jpg")
		# This method will show image in any image viewer
		#im.show()


	



	

myMQTTClient = AWSIoTMQTTClient(str(uuid.uuid1()))
myMQTTClient.configureEndpoint("afi69rocow2w9-ats.iot.ap-northeast-1.amazonaws.com", 8883)
myMQTTClient.configureCredentials("root.pem", "private.pem.key", "certificate.pem.crt")
myMQTTClient.configureOfflinePublishQueueing(-1) # Infinite offline Publish queueing
myMQTTClient.configureDrainingFrequency(2) # Draining: 2 Hz
myMQTTClient.configureConnectDisconnectTimeout(10) # 10 sec
myMQTTClient.configureMQTTOperationTimeout(5) # 5 sec
print ('Initiating Realtime Data Transfer From Raspberry Pi...')
myMQTTClient.connect()

myMQTTClient.subscribe("billiard/device11",1,resignal)

while True:
    time.sleep(5)