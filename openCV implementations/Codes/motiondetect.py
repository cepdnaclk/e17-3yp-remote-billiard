from imutils.video import VideoStream
import datetime
import imutils
import time
import cv2
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

	cv2.putText(frame, "Ball Status: {}".format(text), (10, 20),
				cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)
	cv2.putText(frame, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),
				(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)
	# show the frame and record if the user presses a key
	cv2.imshow("Ball Movement", frame)
	out.write(frame)
	cv2.imshow("Thresh", thresh)
	cv2.imshow("Frame Delta", frameDelta)
	key = cv2.waitKey(1) & 0xFF
	# if the `q` key is pressed, break from the lop
	if key == ord("q"):
		break

vs.release()
out.release()
cv2.destroyAllWindows()