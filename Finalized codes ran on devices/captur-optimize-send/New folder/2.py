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

#vs = VideoStream(src=0).start()
#vs = cv2.VideoCapture(0)
#time.sleep(2.0)

#hsv limits


lower = {
     'red':(149,110,158),
         'green':(0,0,0),
         'blue':(0,62,0),
        'yellow':(23,59,119),
        'orange':(167,0,161),
         'purple':(255,56,29),
         'burgundy':(177,47,0)
         }

upper = {
'red':(167,255,244),
         'green':(153,58,200),
         'blue':(149,150,235),
         'yellow':(50,255,255),
    'orange':(174,132,242),
     'purple':(175,255,255),
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












firstFrame = None
vs = cv2.VideoCapture(0)
#vs.set(3,600)
#vs.set(4,480)
print(vs.isOpened())
#vs.set(3,60)
ref, frame = vs.read()
time.sleep(2.0)
frame_width = int(vs.get(3))
frame_height = int(vs.get(4))
print(frame_width,frame_height)
count = 0;



# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.

#ut = cv2.VideoWriter('venv/images/vid1.avi', cv2.VideoWriter_fourcc('M', 'J', 'P', 'G'), 10, (frame_width, frame_height))
while True:
	# grab the current frame and initialize the occupied/unoccupied
	# text
	prev_frame = frame[:]
	ref,frame = vs.read()
	#firstFrame =frame[1]
	count = count + 1;
	print(count)
	text = "NotMoving"
	Moving = False
	# if the frame could not be grabbed, then we have reached the end
	# of the video
	if frame is None:
		break
	# resize the frame, convert it to grayscale, and blur it
	#frame = imutils.resize(frame, width=500)
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	gray = cv2.GaussianBlur(gray, (21, 21), 0)

	gray0 = cv2.cvtColor(prev_frame, cv2.COLOR_BGR2GRAY)
	gray0 = cv2.GaussianBlur(gray0, (21, 21), 0)
	# if the first frame is None, initialize it
	#if firstFrame is None:
		#firstFrame = gray
		#continue


# compute the absolute difference between the current frame and
	# first frame
	frameDelta = cv2.absdiff(gray0, gray)
	thresh = cv2.threshold(frameDelta, 25, 255, cv2.THRESH_BINARY)[1]
	# dilate the thresholded image to fill in holes, then find contours
	# on thresholded image
	thresh = cv2.dilate(thresh, None, iterations=2)
	cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
		cv2.CHAIN_APPROX_SIMPLE)
	cnts = imutils.grab_contours(cnts)
	# loop over the contours
	for c in cnts:
		# if the contour is too small, ignore it
		if cv2.contourArea(c) <5000:
			continue
		# compute the bounding box for the contour, draw it on the frame,
		# and update the text
		(x, y, w, h) = cv2.boundingRect(c)
		cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
		text = "Moving"
		Moving = True
		count =0
		#for _ in range(1):
			#if Moving == False:
				#GPIO.output(18, GPIO.LOW)
				#print("Well done!!")
				#cv2.imwrite("green.jpg", frame)
				#break
			#time.sleep(0.1)
		#else:
			#continue
	print("Ball Status: {}".format(text))
	img1 = frame.copy()
	cv2.putText(img1, "Ball Status: {}".format(text), (10, 20),
				cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)
	cv2.putText(img1, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),
				(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)
	# show the frame and record if the user presses a key
	img = frame.copy()
	img = cv2.resize(img, (600, 300))
	img1 = cv2.resize(img1, (600, 300))
	if (count == 50):
		Moving = False
	else:
		Moving = True
	if(Moving == False ):
		#print("Well done!!")
		cv2.imwrite("green.jpg", img)
		cv2.imshow("Captured",img)
		#publish("green.jpg")
		publish("good.jpg")

		

	

	cv2.imshow("Ball Movement", img1)
	#print("Ball Status: ".format(text))
	#out.write(frame)
	#cv2.imshow("Thresh", thresh)
	#cv2.imshow("Frame Delta", frameDelta)
	key = cv2.waitKey(1) & 0xFF
	# if the `q` key is pressed, break from the lop
	if key == ord("q"):
		break
vs.release()
#out.release()
cv2.destroyAllWindows()
