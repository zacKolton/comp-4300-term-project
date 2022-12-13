import processing.net.*;

String computer_name = "computer_b";

float xpos;
float ypos;    // Starting position of shape    
float xspeed = 2;  // Speed of the shape
float yspeed = 2;  // Speed of the shape

int rad = 20;        // Width of the shape
int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

color ballColor = 0x00000;
color background = 0xCED4DA;

Client client;

void setup() 
{
  size(300, 300);
  noStroke();
  frameRate(40);
  ellipseMode(RADIUS);
  
  xpos = width/2;
  ypos = height/2;
  client = new Client(this, "192.168.1.15", 5204);
}

void draw()
{
  
}
