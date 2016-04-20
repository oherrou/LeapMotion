// WIP
// No documentation yet


import de.voidplus.leapmotion.*;

LeapMotion leap;
PImage img_Background;
PImage img_Background2;
PImage img_Car;
boolean bDay = false;
int i = 150;
int iTimeToWait = 20;
int iLast = 0;

float fSpeed = 0;
int iPWM = 0;
float fMaxFWSpeed = 60;
float fMaxBWSpeed = 30;
String szDirection = "Stop";
String szDefault = "None";

void setup() 
{
  size(1000, 600);
  img_Background = loadImage("background.png");
  img_Background2 = loadImage("background2.png");
  img_Car = loadImage("car.png");
  
  leap = new LeapMotion(this);
}

void draw()
{
  background(5,45,89);
  drawBoard();
  updateTime(); 
  updateBoard();
  
  
 
  if (leap.getHands().size() == 0) {
      szDirection = "STOP";
      iPWM = 0;
      fSpeed = 0;
  }
 for (Hand hand : leap.getHands ()) 
 {
    // ----- BASICS -----
    int     hand_id          = hand.getId();
    PVector hand_position    = hand.getPosition();
    PVector hand_stabilized  = hand.getStabilizedPosition();
    PVector hand_direction   = hand.getDirection();
    PVector hand_dynamics    = hand.getDynamics();
    float   hand_roll        = hand.getRoll();
    float   hand_pitch       = hand.getPitch();
    float   hand_yaw         = hand.getYaw();
    boolean hand_is_left     = hand.isLeft();
    boolean hand_is_right    = hand.isRight();
    float   hand_grab        = hand.getGrabStrength();
    float   hand_pinch       = hand.getPinchStrength();
    float   hand_time        = hand.getTimeVisible();
    PVector sphere_position  = hand.getSpherePosition();
    float   sphere_radius    = hand.getSphereRadius();
    println(hand_pitch);
    if(hand_pitch > 10 && hand_pitch <= 100)
    {
      iPWM = int(map(hand_pitch, 10, 100, 0, 100));
      szDirection = "FORWARD";
    }
    else if(hand_pitch < -10 && hand_pitch >= -100)
    {
      szDirection = "BACKWARD";
      iPWM = int(map(hand_pitch, -10, -100, 0, 100));
    }
    else
    {
      szDirection = "STOP";
      iPWM = 0;
    }
    fSpeed = fMaxBWSpeed * iPWM/100;
  }
}


void drawBoard()
{
  //Background
  if(bDay) 
  {
    image(img_Background, i, 0,img_Background.width,4*img_Background.height/5);
    image(img_Background,-width+i,0,img_Background.width,4*img_Background.height/5);
  }
  else
  {
    image(img_Background2, i, 0,img_Background2.width,4*img_Background2.height/5);
    image(img_Background2,-width+i,0,img_Background2.width,4*img_Background2.height/5);
  }  
  image(img_Car,width/2-img_Car.width/4,height/2+25,img_Car.width/2,img_Car.height/2);
  
  //Board
  noFill();
  strokeWeight(5);
  stroke(235,138,28);
  rect(0, 440, width, 160,7);
  textSize(15);
  fill(255);
  text("Speed     :  "+fSpeed/10,15,460);
  text("PWM       :  "+iPWM,15,490);
  text("Direction :  "+szDirection,15,520);
  text("Default   :  "+szDefault,15,550);
  
  //PWM
  textSize(15);
  fill(242,118,27);
  text("0",65+width/2,580);
  text("100%",285+width/2,580);
  textSize(20);
  text("PWM",160+width/2,465);
  pushMatrix();
  strokeWeight(2);
  fill(116,155,196);
  stroke(97,35,48);
  translate(180+width/2,580); 
  arc(0,0,200,200,PI,TWO_PI);
  strokeWeight(1);
  fill(174,177,181);
  line(0,0,-100*cos(radians(30)),-100*sin(radians(30)));
  line(0,0,-100*cos(radians(60)),-100*sin(radians(60)));
  line(0,0,-100*cos(radians(90)),-100*sin(radians(90)));
  line(0,0,-100*cos(radians(120)),-100*sin(radians(120)));
  line(0,0,-100*cos(radians(150)),-100*sin(radians(150)));
  popMatrix();
  
  //Speed
  textSize(15);
  fill(242,118,27);
  text("0",(width/2)-295,580);
  text("6 km/h",(width/2)-72,580);
  textSize(20);
  text("SPEED",(width/2)-210,465);
  pushMatrix();
  strokeWeight(2);
  fill(116,155,196);
  stroke(97,35,48);
  translate((width/2)-180,580); 
  arc(0,0,200,200,PI,TWO_PI);
  strokeWeight(1);
  fill(174,177,181);
  line(0,0,-100*cos(radians(30)),-100*sin(radians(30)));
  line(0,0,-100*cos(radians(60)),-100*sin(radians(60)));
  line(0,0,-100*cos(radians(90)),-100*sin(radians(90)));
  line(0,0,-100*cos(radians(120)),-100*sin(radians(120)));
  line(0,0,-100*cos(radians(150)),-100*sin(radians(150)));
  popMatrix();
}

void updateBoard()
{
  int iAngle = (100-iPWM) * 180 / 100;
  //PWM
  pushMatrix();
  strokeWeight(2);
  stroke(180,20,32); 
  translate(180+width/2,579); 
  line(0,0,80*cos(radians(iAngle)),-80*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
  
  iAngle = int((60-fSpeed)*180/60);
  //Speed
  pushMatrix();
  strokeWeight(2);
  stroke(180,20,32); 
  translate((width/2)-180,579); 
  line(0,0,80*cos(radians(iAngle)),-80*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}

void updateTime()
{
   if( (millis() - iLast) > iTimeToWait)
  {
    if(szDirection.equals("FORWARD"))
    {
      i=i-int(fSpeed/5);
    }
    else if(szDirection.equals("BACKWARD"))
    {
      i=i+int(fSpeed/5);
    }
    if(i>width) i = 0;
    else if(i<0) i = width;
    iLast = millis();
  }
}





void keyPressed()
{

  if(key == 'p')
  {
    bDay = !bDay;
    println(bDay);
  } 
  if(key == 'z')
  {
    if(iPWM<100) iPWM++;
    if(szDirection.equals("FORWARD")) fSpeed = fMaxFWSpeed * iPWM/100;
    else fSpeed = fMaxBWSpeed * iPWM/100;
  }
  if(key =='s')
  {
    if(iPWM>0) iPWM--;
    if(szDirection.equals("FORWARD")) fSpeed = fMaxFWSpeed * iPWM/100;
    else fSpeed = fMaxBWSpeed * iPWM/100;
  }
  if(key == ' ')
  {
    if(szDirection.equals("FORWARD")) szDirection = "BACKWARD";
    else szDirection = "FORWARD";
  }
}