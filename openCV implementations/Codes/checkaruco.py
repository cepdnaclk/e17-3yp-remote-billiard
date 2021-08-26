#to check existance of aruco tags on a captured image

import argparse
import imutils
import cv2
import sys

ap = argparse.ArgumentParser()
ap.add_argument("-i", "--venv/images/4.jpg", required=True,
	help="path to input image containing ArUCo tag")
ap.add_argument("-t", "--type", type=str,
	default="DICT_ARUCO_ORIGINAL",
	help="type of ArUCo tag to detect")
args = vars(ap.parse_args())

image = cv2.imread(args["venv/images/4.jpg"])
image = imutils.resize(image, width=600)
# verify that the supplied ArUCo tag exists and is supported by
# OpenCV
if ARUCO_DICT.get(args["type"], None) is None:
	print("[INFO] ArUCo tag of '{}' is not supported".format(
		args["type"]))
	sys.exit(0)
# load the ArUCo dictionary, grab the ArUCo parameters, and detect
# the markers
print("[INFO] detecting '{}' tags...".format(args["type"]))
arucoDict = cv2.aruco.Dictionary_get(ARUCO_DICT[args["type"]])
arucoParams = cv2.aruco.DetectorParameters_create()
(corners, ids, rejected) = cv2.aruco.detectMarkers(image, arucoDict,
	parameters=arucoParams)