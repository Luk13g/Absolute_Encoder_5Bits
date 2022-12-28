import processing.serial.*;
Serial myPort; 
String myString = null;
int incoming_position = 0;
float position_in_degree = 0;
PFont font18,font63;

void setup(){
  size(800, 600);
  font18 = loadFont("Tahoma-18.vlw");
  font63 = loadFont("Tahoma-63.vlw");
  
  
  myPort = new Serial(this, "COM3", 9600);
}

void draw(){
  background(100);
  textFont(font63, 36);
  text("RAW Position:", 30, 510);
  text(incoming_position, 270, 510);
  text("Position in Degree:", 30, 550);
  text(position_in_degree, 330, 550);
  draw_angle(400,250,200,position_in_degree); // draw circle and encoder position
  
  // Reading Serial Port when buffer not zero
while (myPort.available() > 0) {
    myString = myPort.readStringUntil(10); // Read Data from Serial until line feed (10)
    if (myString != null) {
      myString = trim(myString); // Remove Line Feed
      incoming_position = int(myString); // String to int
      position_in_degree = map(incoming_position,0, 31, 0,359.999); // translate raw position in to 360 degree position format
      println(position_in_degree);
    }
  }
  
}

void draw_angle(int x, int y,int size, float angle_dec){
  noFill();
  stroke(255,255,255,255);
  // X,Y plane Translation
  float end_x,end_y;
  float angle_rad = radians(angle_dec);
  end_x = x + cos(angle_rad)*size; 
  end_y = y + sin(angle_rad)*size;
  // mark angle guage in circle
  line(x,y,end_x,end_y);
  
  int space = 20;
  int space2 = size - space;
  ellipse(x, y, size*2+space, size*2+space);
  
  // mark small tick on cicle every 15 degree
  for(float i = 0; i < 360; i = i +11.6129){ 
    float rad1 = radians(i);
    // mark large scale on 0 90 180 270 degree
    if( i == 0 || i == 90 || i == 180 || i == 270){ 
      line(x + cos(rad1)*space2,y + sin(rad1)*space2,x + cos(rad1)*(size+space),y + sin(rad1)*(size+space));
    }else{
      line(x + cos(rad1)*space2,y + sin(rad1)*space2,x + cos(rad1)*size,y + sin(rad1)*size);
    }
  }
  
}
