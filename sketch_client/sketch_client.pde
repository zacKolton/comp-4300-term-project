import processing.net.*; 

Client myClient; 
String computer_name;
color ballColor = 0x00000;
color background = 0xCED4DA;
 
void setup() { 
  size(300, 300); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "127.0.0.1", 5204);
  myClient.write("Test from Client");
} 

void draw()
{
  background(background);
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );
  
  if (xpos > width+rad || xpos < -rad) {
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }
  
  ellipse(xpos, ypos, rad, rad);
  fill(ballColor);
}
