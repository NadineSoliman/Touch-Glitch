//intiate an image
PImage img;
String imgName = "img.jpg";

// BEGINNING SERIAL COMM
import processing.serial.*;
Serial myPort;
float input =0;

// COLOR ARRAY FOR GLITCHING – IF YOU WANNA MAKE IT LESS RANDOM
color [] colors = new color [5];
color c;

//for glitch effect
// NUMBER OF TIMES IT PLAYS AROUND WITH THE IMAGE
int counter =10;

//CONTROL BOOLEANS
boolean done = false;
boolean glitching = true;
boolean saved = false;
boolean begin = false;
boolean run = true;

// STUPID WAY TO GET AROUND OVERWRITING
// CHANGE THE FILE COUNT NAME 
String file_count = "112398472m";


void setup() {
  //SERIAL
  String portname = "/dev/tty.usbserial-DN01EZE7";
  myPort = new Serial(this, portname, 9600);
  myPort.bufferUntil('\n');

  // THIS WILL MAKE SENSE BELOW
  size(1, 1);
  smooth();
  colorMode(HSB, 360, 100, 100, 100);

  //LOADING IMAGE HERE
  img = loadImage(imgName); 
  imageMode(CENTER);

  // CHANGES THE SIZE ACCORDING TO THE IMAGE SIZE AS 
  // YOU CANNOT INPUT VARIABLES IN SIZE 
  surface.setResizable(true);
  surface.setSize(img.width, img.height);

  // DRAWS IMAGE
  image(img, img.width/2, img.height/2);
}

void draw() {
  //println(input);
  //PAUSES DRAW IF THE SKETCH IS NOT RESTARTED
  if (run) {
    // IF ARDUINO IS SENDING START MESSAGE --> BEGIN GLITCHING
    if (int(input) == 1) {
      begin = true;
      glitching = true;
      //println("should glitch");
    }
    // IF NO START MESSAGE DO NOT BEGIN
    if (int(input) == 0.0) {
      begin = false;
    }
    // JUST DRAW THE BACKGROUND IMAGE
    if (!begin) {
      noTint();
      image(img, img.width/2, img.height/2);
    }

    // THE FUN GLITCHING PART
    if (begin) {
      // RANDOMLY PICK COLORS TO GLITCH WITH
      
      for (int i =0; i<colors.length; ++i) {
        colors[i] = color(random(360), 100, random(80, 100));
        //map(i, 0, colors.length, 0, 360)
      }
      if (glitching) {
        //DRAW BASE IMAGE NO GLITCHING --> 
        //KEEPS IT STILL RECOGNIZABLE AND COHERENT
        
        image(img, img.width/2, img.height/2);
        for (int i = 0; i<counter; ++i) {
          // SHIFT IT ON THE X AXIS AND Y AXIS
          float y_shift = random(-30, 30);
          float x_shift = random(-width/2, width/2);
          //color c = color(random(360), 100, random(80, 100));
          c = colors[i];  //%colors.length
          
          //DO THE GLITCHING AND DRAW IT
          tint(c, random(10, 50));
          filter(POSTERIZE, random(2, 30));
          image(img, img.width/2+ x_shift, y_shift+ img.height/2, random(img.width), img.height);
        }
        // STOP IT FROMING LOOPING AGAIN
        done = true;
        glitching = false;
        run = false;
      }
      if (done) {
        // SAVE THE FRAME
        if (!saved) {
          saveFrame(imgName +file_count );
          // IF SAME SKETCH RUNNING DOESNT OVERWRITE
          file_count+= "1";
          saved = true;
        }
        // DRAWS LINES FOR EXXTRA GLITCHINESS 
        // ADDED THEM HERE TO MAKE THEM MOVE IN THE FUTURE
        for (int y = 0; y< height; y+=random(10)) {
          stroke(0, 20);
          line(0, y, width, y);
        }
        for (int x = 0; x< width; x+=random(500)) {
          pushStyle();
          strokeWeight(random(50));
          stroke(0, random(50));
          line(x, 0, x, height);
          popStyle();
        }
      }
    }
  }
}


void serialEvent(Serial myPort) {
  while (myPort.available() > 0) {
    String message = myPort.readString();
    input = float(message);
  }
}


//RESTARTS IT ALL --> YOU GET A FRESH START
void mousePressed() {
  done = false;
  background(0);
  saved = false;
  run = true;
  glitching = true;
}