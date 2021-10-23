from imutils.video import VideoStream
import datetime
import imutils
import time
import cv2
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import uuid
import json
import base64

import argparse

#vs = VideoStream(src=0).start()
#vs = cv2.VideoCapture(0)
#time.sleep(2.0)


firstFrame = None
vs = cv2.VideoCapture("venv/images/vid.mp4")
ref, frame = vs.read()
time.sleep(2.0)
frame_width = int(vs.get(3))

frame_height = int(vs.get(4))



# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.

out = cv2.VideoWriter('venv/images/vid1.avi', cv2.VideoWriter_fourcc('M', 'J', 'P', 'G'), 10, (frame_width, frame_height))
while True:
	# grab the current frame and initialize the occupied/unoccupied
	# text
	prev_frame = frame[:]
	ref,frame = vs.read()
	#firstFrame =frame[1]
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
	cv2.putText(frame, "Ball Status: {}".format(text), (10, 20),
				cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)
	cv2.putText(frame, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),
				(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)
	# show the frame and record if the user presses a key
	img = frame.copy()
	img = cv2.resize(img, (600, 300))
	if(Moving == False):
		#print("Well done!!")
		cv2.imwrite("green.jpg", img)
	cv2.imshow("Ball Movement", img)
	#print("Ball Status: ".format(text))
	out.write(frame)
	#cv2.imshow("Thresh", thresh)
	#cv2.imshow("Frame Delta", frameDelta)
	key = cv2.waitKey(1) & 0xFF
	# if the `q` key is pressed, break from the lop
	if key == ord("q"):
		break
vs.release()
out.release()
cv2.destroyAllWindows()
#
img1= cv2.imread("green.jpg")

#
cv2.imshow("Captured", img1)
cv2.waitKey(0)
img2= cv2.imread("final.jpg")
img2 = cv2.resize(img2, (600, 300))
#
cv2.imshow("Processed", img2)
print("\nimage captured\n")
print("\nimage processed\n")
cv2.waitKey(0)
#vs.release()
#out.release()
cv2.destroyAllWindows()
client_ID = str(uuid.uuid1())
myMQTTClient = AWSIoTMQTTClient(str(uuid.uuid1()))
myMQTTClient.configureEndpoint("alses9dufe5nu-ats.iot.us-east-1.amazonaws.com", 8883)
myMQTTClient.configureCredentials("certificates/root.pem", "certificates/a8270e7aff-private.pem.key", "certificates/a8270e7aff-certificate.pem.crt")
myMQTTClient.configureOfflinePublishQueueing(-1) # Infinite offline Publish queueing
myMQTTClient.configureDrainingFrequency(2) # Draining: 2 Hz
myMQTTClient.configureConnectDisconnectTimeout(20) # 10 sec
myMQTTClient.configureMQTTOperationTimeout(5) # 5 sec
print ('Initiating Realtime Data Transfer From Raspberry Pi...\n')
myMQTTClient.connect()
print("connected to AWS core with client ID: {}".format(client_ID))

with open("green.jpg", "rb") as image:
  f = image.read()
  encoded_data = base64.b64encode(f)
  message = encoded_data.decode('utf-8')
  #byteArr = bytearray(f)
  #print b[0]
with open("final.jpg", "rb") as image1:
  f1 = image1.read()
  encoded_data1 = base64.b64encode(f1)
  message1 = encoded_data1.decode('utf-8')
data = {'Signal':True,'client_ID':client_ID,'image1':message1}
data1 = json.dumps(data)
myMQTTClient.publish(
    topic = "billiard/device1",
    QoS= 1,
    payload = data1
	)