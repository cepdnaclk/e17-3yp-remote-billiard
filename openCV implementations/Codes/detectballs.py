#to detect balls
#and generate processsed image
import cv2
import numpy as np

width,height =1000,500

def nothing(x):
    pass
#hsv limits
lower = {'red':(2,135,109),
         'green':(54,0,69),
         'blue':(85,31,0),
         'yellow':(23,59,119),
         'orange':(9,150,135),
         'purple':(151,56,29),
         'burgundy':(177,47,0)
         }

upper = {'red':(9,255,255),
         'green':(80,255,255),
         'blue':(147,231,255),
         'yellow':(50,255,255),
         'orange':(23,255,255),
         'purple':(175,255,255),
         'burgundy':(255,255,255)
         }

# define standard colors for circle around the object
colors = {'red':(0,0,255),
          'green':(0,255,0),
          'blue':(255,0,0),
          'yellow':(0,255,217),
          'orange':(0,140,255),
          'purple':(151,56,29),
          'burgundy':(13,50,0)
          }

font = cv2.FONT_HERSHEY_SIMPLEX


frame = cv2.imread("venv/images/balls3.webp")
h, w, c = frame.shape
cv2.imwrite('testimg.jpg', frame)
wht = cv2.imread("venv/images/white.jpg")
wht =cv2.resize(wht,(w,h)) #same size whie back ground
cv2.imshow("Outputw",wht)
#out =cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
#out=cv2.Canny(imgGray,40,60)
#out =frame.copy()
#cv2.imshow("Output",out)

#frame =cv2.resize(frame,(800,400))
blurred = cv2.GaussianBlur(frame,(11,11),0)
hsv = cv2.cvtColor(frame,cv2.COLOR_BGR2HSV)
    #for each color in dictionary check object in frame
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
    res1 = cv2.bitwise_and(frame, frame, mask=mask)
    #cv2.imshow("res", res1)
    #cv2.waitKey(0)


    #Calculate percentage of pixel colors
    output = cv2.countNonZero(mask)
    res = np.divide(float(output),mask.shape[0]*int(mask.shape[1] / 128))
    percent_colors = np.multiply((res),400) / 10000
    percent=(np.round(percent_colors*100,2))

    cnts = cv2.findContours(mask.copy(),cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)[-2]
    cv2.drawContours(frame, cnts, -1, (10, 0, 200), 3)
    #for stripe balls (min areas)
    c1 = min(cnts, key=cv2.contourArea)
    ((x1, y1), radius1) = cv2.minEnclosingCircle(c1)
    #center calculation
    M1 = cv2.moments(c1)
    center1 = (int(M1["m10"] / M1["m00"]), int(M1["m01"] / M1["m00"]))
    #drawing circles
    cv2.circle(frame, (int(x1), int(y1)), int(radius1), colors[key], 2)
    cv2.circle(wht, (int(x1), int(y1)), int(radius1), colors[key], 2)
    #drwaing marker and text
    cv2.drawMarker(wht, center1, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
    cv2.putText(frame, 'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
    cv2.putText(wht,  'Stripe-' + key, (int(x1 - radius1), int(y1 - radius1)), font, 0.6, colors[key], 2)
    center = None

    #For solid balls (max)
    #if len(cnts) > 0:
    c = max(cnts, key=cv2.contourArea)
    ((x,y), radius) = cv2.minEnclosingCircle(c)
    M = cv2.moments(c)
    center = (int(M["m10"] / M["m00"]),int(M["m01"] / M["m00"]))

    if radius > 0.5:
        #draw circles
        cv2.circle(frame,(int(x),int(y)),int(radius),colors[key],2)
        cv2.circle(wht, (int(x), int(y)), int(radius), colors[key], 2)
        #draw markers and text
        cv2.drawMarker(wht, center, colors[key], markerType=cv2.MARKER_CROSS, thickness=2)
        cv2.putText(frame,'solid-' +key,(int(x-radius),int(y-radius)),font,0.6,colors[key],2)
        cv2.putText(wht, 'solid-' + key, (int(x - radius), int(y - radius)), font, 0.6, colors[key], 2)

#writeng and showing outputs
cv2.imwrite('Colors.jpg', frame)
cv2.imshow("Frame",frame)
#cv2.imwrite('Colors1.jpg', out)
cv2.imshow("Output1",wht)

key = cv2.waitKey(0)
