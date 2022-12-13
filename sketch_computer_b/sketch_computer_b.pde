import processing.net.*; 

int rad = 20;        // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

color ballColor = 0x00000;
color background = 0xCED4DA;

Client client; 


// Testing for now
String computer_name = "client_v2";
String entering_name = "test_client_v2";
boolean sendUpdateX = false;
boolean sendUpdateY = false;

// Communication

int new_message;

void setup()
{
  size(300, 300);
  noStroke();
  frameRate(40);
  ellipseMode(RADIUS);
  
  
  xpos = width/2;
  ypos = height/2;
  client = new Client(this, "127.0.0.1", 5204);
}

void draw() 
{
  background(background);
  if(client.available() > 0)
  {
    
  }
  
  
}
  
