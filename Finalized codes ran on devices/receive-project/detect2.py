#to detect balls
#and generate processsed image
import cv2
import numpy as np

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



def optimize():
  font = cv2.FONT_HERSHEY_SIMPLEX
  #frame1 = cv2.imread("balls3.webp")
  frame1 = cv2.imread("received.jpg")
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

      if(percent > 3):
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

  




print("hello")
optimized =optimize()
#cv2.imwrite("optimized.jpg",optimized)
#cv2.imshow("optimized",optimized)


#key = cv2.waitKey(0)


