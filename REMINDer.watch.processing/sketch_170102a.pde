// Digital clock
DigitalClock digitalClock;
PFont font;
int cx, cy;
float clockDiameter;

// Timer time unit: minute
float setTimerTime = (15) * 60.0 * 60.0;
float currentTimerTime = 0.0;

//Buttons
PImage pauseButton;
PImage pauseButtonHover;
PImage playButton;
PImage playButtonHover;
PImage extendButton;
PImage extendButtonHover;
PImage okayButton;
PImage okayButtonHover;

//Images
PImage watchBase;
PImage upperQuote;
PImage lowerQuote;
PImage userImage;

Boolean overPause = false;
Boolean overExtend = false;
Boolean overOkay = false;
Boolean timerRunning = true;

// 0 = standard mode, 1 = timer mode, 2 = receive message
// keyboard control S = 0, T = 1, M = 2
int mode = 0;


void setup() {
  size(640, 640);
  stroke(255);

  font = createFont("futura/Futura-Light.otf", 80);
  //Load all images
  pauseButton = loadImage("CircledPause.png");
  pauseButtonHover = loadImage("CircledPauseHover.png");
  playButton = loadImage("CircledPlay.png");
  playButtonHover = loadImage("CircledPlayHover.png");
  extendButton = loadImage("Extend.png");
  extendButtonHover = loadImage("ExtendHover.png");
  okayButton = loadImage("Ok.png");
  okayButtonHover = loadImage("OkHover.png");
  upperQuote = loadImage("QuoteUpper.png");
  lowerQuote = loadImage("QuoteLower.png");
  userImage = loadImage("sampleUser.png");
  //Load watch base
  watchBase = loadImage("watchbase.png");
  image(watchBase, cx, cy, width, height); 
  
  int radius = min(width, height) / 3;
  clockDiameter = radius * 1.6;

  cx = width / 2;
  cy = height / 2 + 3;
  // Digital clock
  digitalClock = new DigitalClock(100, width/2, height/2);
  currentTimerTime = setTimerTime;
}

void draw() {
  // Draw the clock background
  fill(52);
  switch(mode) {
    case 0:
      drawDigitalClock();
      break;
    case 1:
      drawTimerOnly(60, width/2, height/2);
      break;
    case 2:
      receiveMessage(30);
      break;
  }
  if(timerRunning){
    currentTimerTime --;
  }
}

void drawDigitalClock() {
  stroke(52);
  ellipse(cx, cy, clockDiameter + 2, clockDiameter + 2);
  strokeWeight(10);
  if (currentTimerTime * (2 * PI / setTimerTime) < PI / 2.0) {
    stroke(234, 102, 53);
  } else {
    stroke(53, 218, 234);
  }
  // Draw the timer ellipse
  arc(cx, cy, clockDiameter, clockDiameter, -PI / 2.0, -PI / 2.0 + currentTimerTime * ( 2 * PI / setTimerTime));
  // Draw the digital clock
  digitalClock.getTime();
  digitalClock.display();
}

void drawTimerOnly(int _fontSize, float _x, float _y) {
  fill(52); 
  stroke(52);
  ellipse(cx, cy, clockDiameter + 2, clockDiameter + 2);
  if (currentTimerTime * ( 2 * PI / setTimerTime) < PI / 2.0) {
    fill(234, 102, 53, 127);
  } else {
    fill(53, 218, 234, 127);
  }
  arc(cx, cy, clockDiameter + 2, clockDiameter + 2, -PI / 2.0, -PI / 2.0 + currentTimerTime * ( 2 * PI / setTimerTime));
  
  textAlign(CENTER);
  fill(255, 255, 255);
  textFont(font, _fontSize);
  if(currentTimerTime > 0) {
    int timerHour = int(currentTimerTime/(3600*60));
    int timerMin = int(currentTimerTime/3600 - timerHour * 60);
    int timerSec = int(currentTimerTime/60 - timerMin * 60);
    text(formatTimeText(timerHour) + ":" + formatTimeText(timerMin) + ":" + formatTimeText(timerSec), _x, _y);
    textFont(font, _fontSize / 2.2);
    fill(195, 195, 54);
    text("Final Research Report", _x, _y - _fontSize * 1.2);
    
    //Set buttons
    if(timerRunning) {
      image(pauseButton, cx - width / 18, cy + height / 18, width/9, height/9);
    } else {
      image(playButton, cx - width / 18, cy + height / 18, width/9, height/9);
    }
    
    //Set button hover
    if (overPauseButton(cx, cy + height / 9, width/9)) {
      if(timerRunning) {
        image(pauseButtonHover, cx - width / 18, cy + height / 18, width/9, height/9); 
      } else {
        image(playButtonHover, cx - width / 18, cy + height / 18, width/9, height/9); 
      }
    }
  } else {
    text("00:00:00", _x, _y);
    textFont(font, _fontSize / 1.5);
    fill(255, 255, 255);
    text("TIME'S UP", _x, _y - _fontSize * 1.2);
    image(extendButton, cx - width / 6, cy + height / 18, width/9, height/9);
    image(okayButton, cx + width / 18, cy + height / 18, width/9, height/9);
    if (overExtendButton(cx - width / 9, cy + height / 9, width/9)) {
      image(extendButtonHover, cx - width / 6, cy + height / 18, width/9, height/9);
    }
    if (overOkayButton(cx + width / 9, cy + height / 9, width/9)) {
      image(okayButtonHover, cx + width / 18, cy + height / 18, width/9, height/9);
    }
  }
}

void receiveMessage(int _fontSize) {
  stroke(52);
  ellipse(cx, cy, clockDiameter + 2, clockDiameter + 2);
  strokeWeight(10);
  if (currentTimerTime * ( 2 * PI / setTimerTime) < PI / 2.0) {
    stroke(234, 102, 53);
  } else {
    stroke(53, 218, 234);
  }
  // Draw the timer ellipse
  arc(cx, cy, clockDiameter, clockDiameter, -PI / 2.0, -PI / 2.0 + currentTimerTime * ( 2 * PI / setTimerTime));
  
  image(userImage, cx - width / 10, cy - height / 5 - 16, width / 5, height / 5); 
  image(upperQuote, cx - width / 18 - width / 5.5, cy - height / 16 + 16, width/18, height/18);
  image(lowerQuote, cx - width / 18 + width / 4.7, cy + height / 16 + 16, width/18, height/18);
  textAlign(CENTER);
  textFont(font, _fontSize / 1.5);
  fill(255, 255, 255);
  text("Hey Gale! Don't forget to \n hand in your report at 9AM \n on Monday!", cx, cy + 16);
}

void mousePressed() {
  if (overPause) {
    if(timerRunning) {
      timerRunning = false;
    } else {
      timerRunning = true;
    }
  }
  if (overExtend && currentTimerTime <= 0) {
     currentTimerTime = setTimerTime;
  }
  if(mouseX > 525 && mouseX < 545 && mouseY > 190 && mouseY < 210) {
    mode = 1;
  } else if (mouseX > 570 && mouseX < 590 && mouseY > 315 && mouseY < 335) {
    mode = 0;
  } else if (mouseX > 525 && mouseX < 545 && mouseY > 445 && mouseY < 465) {
    mode = 2;
  }
}

String formatTimeText(int timeText){
  String formattedText = "";
  if(timeText <10){
    formattedText = "0" + str(timeText);
  } else {
    formattedText = str(timeText);
  }
  return formattedText;
}

boolean overPauseButton(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    overPause = true;
  } else {
    overPause = false;
  }
  return overPause;
}

boolean overExtendButton(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    overExtend = true;
  } else {
    overExtend = false;
  }
  return overExtend;
}

boolean overOkayButton(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2) {
    overOkay = true;
  } else {
    overOkay = false;
  }
  return overOkay;
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    mode = 0;
  } else if (key == 't' || key == 'T') {
    mode = 1;
  } else if (key == 'm' || key == 'M') {
    mode = 2;
  }
}

class DigitalClock extends Clock {
  int fontSize;
  float x, y;

  DigitalClock(int _fontSize, float _x, float _y) {
    fontSize = _fontSize;
    x = _x;
    y = _y;
  }

  void getTime() {
    super.getTime();
  }

  void display() {
    textAlign(CENTER);
    fill(255, 255, 255);
    textFont(font, fontSize);
    text(h + ":" + nf(m, 2), x, y);
    textFont(font, fontSize / 2);
    text(timeFrame, x, y + fontSize / 2 + 10);
  }
}

class Clock {
  int h, m, s;
  String timeFrame;
  Clock() {
  }

  void getTime() {
    h = hour();
    if (h > 12) {
      timeFrame = "PM";
      h = h - 12;
    } else {
      timeFrame = "AM";
    }
    m = minute();
    s = second();
  }
}