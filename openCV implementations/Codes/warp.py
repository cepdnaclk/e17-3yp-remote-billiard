import cv2
import numpy as np

width=600
height=300


def empty(a):
   pass

def getContours(img): #get contors return the biggest
    biggest = np.array([])
    max_area = 0
    contours, hierarchy = cv2.findContours(img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    for i in contours:
        area = cv2.contourArea(i)
        if area > 1000:
            peri = cv2.arcLength(i, True)
            cv2.drawContours(imgcontour, i, -1, (10, 0, 200), 7)
            approx = cv2.approxPolyDP(i, 0.02 * peri, True)
            if area > max_area and len(approx) == 4:  # chech if it a rectangle
                biggest = approx  # biggect rechtangle
                max_area = area

    return biggest
#to warp image
def getWarp(img,biggest):
   biggest=reorder(biggest)
   pts1 = np.float32(biggest)
   pts2 = np.float32([[0, 0], [width, 0], [0, height], [width, height]])
   matrix = cv2.getPerspectiveTransform(pts1, pts2)
   imgOutput = cv2.warpPerspective(img, matrix, (width, height))

   return imgOutput
#reorder the coordinates
def reorder (myPoints):
    myPoints = myPoints.reshape((4,2))
    myPointsNew = np.zeros((4,1,2),np.int32)
    add =myPoints.sum(1)

    myPointsNew[0]=myPoints[np.argmin(add)]
    myPointsNew[3]=myPoints[np.argmax(add)]
    diff = np.diff(myPoints,axis=1)
    myPointsNew[1] = myPoints[np.argmin(diff)]
    myPointsNew[2] = myPoints[np.argmax(diff)]

    return myPointsNew

img= cv2.imread("venv/images/8.png")
img =cv2.resize(img,(width,height))
cv2.imshow("Original", img)
cv2.waitKey()
imgcontour = img.copy()
#imgblur =cv2.GaussianBlur(img,(7,7),1)
imgGray =cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)


#image preproccesing
imgcanny=cv2.Canny(imgGray,40,60)
cv2.imshow("canny", imgcanny)
cv2.imwrite('Canny.jpg', imgcanny)
cv2.waitKey()
kernel=np.ones((5,5))
imgDil =cv2.dilate(imgcanny,kernel,iterations=1)
imgThre =cv2.erode(imgDil,kernel,iterations=1)
#cv2.imshow("dial", imgDil)
#cv2.imshow("thre", imgThre)
cv2.waitKey()

#get the edges and warp
imgcontour = img.copy()
imgBiggestcon =img.copy()
biggest = getContours(imgThre)
cv2.drawContours(imgBiggestcon, biggest, -1, (10, 0, 200), 10)
imgWarped = getWarp(img,biggest)
#showoutputs
imgsmall = imgWarped.copy()
print(biggest)
cv2.imshow("con", imgcontour)
cv2.imwrite('Contour.jpg', imgcontour)
cv2.imshow("conbiggest", imgBiggestcon)
cv2.imwrite('Bigcontour.jpg', imgBiggestcon)

cv2.waitKey()
cv2.imshow("Warped", imgWarped)
cv2.imwrite('Warped.jpg', imgWarped)
cv2.waitKey()



#reprocss output image for remove boarder
imgGray1 =cv2.cvtColor(imgsmall,cv2.COLOR_BGR2GRAY)
imgcanny1=cv2.Canny(imgGray1,40,60)
cv2.imwrite('canny1.jpg', imgcanny1)
cv2.imshow("canny2", imgcanny1)
cv2.waitKey()
kernel=np.ones((5,5))
imgDil1 =cv2.dilate(imgcanny1,kernel,iterations=1)
imgThre1 =cv2.erode(imgDil1,kernel,iterations=1)
cv2.imshow("dial", imgDil1)
cv2.imshow("thre", imgThre1)
cv2.waitKey()

#Again conner detection and warp
#imgcontour1 = imgsmall.copy()
imgBiggestcon1 =imgsmall.copy()
biggest1 = getContours(imgThre1)
cv2.drawContours(imgBiggestcon1, biggest1, -1, (10, 0, 200), 12)
imgWarped1 = getWarp(imgsmall,biggest1)

#img = imgWarped.copy()
print(biggest1) #corner cordinetes

#display outputs
cv2.imshow("conbiggest", imgBiggestcon1)
cv2.imwrite('biggest1.jpg', imgBiggestcon1)

cv2.waitKey()
cv2.imshow("Warped1", imgWarped1)
cv2.imwrite('Warped1.jpg', imgWarped1)
cv2.waitKey()


