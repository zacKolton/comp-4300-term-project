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
String computer_name = "client";
String entering_name = "test_client";
boolean sendUpdateX = false;
boolean sendUpdateY = false;

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
  
  // Update the position of the shape
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );
  
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  
  if (xpos > width+rad || xpos < -rad) {
    sendUpdateX = true;
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    sendUpdateY = true;
    ydirection *= -1;
  }
  
  if(!sendUpdateY && sendUpdateX)
  {
    JSONObject notify = new JSONObject();
    JSONObject event = new JSONObject();
    event.setString("leaving-name",computer_name);
    event.setString("entering-name",entering_name);
    event.setFloat("x-pos", xpos);
    event.setFloat("y-pos",ypos);
    event.setInt("x-dir", xdirection);
    event.setInt("y-dir", ydirection);
    notify.setString("computer-name",computer_name);
    notify.setJSONObject("event", event);
    
    String message = notify.toString();
    client.write(message);
  }
  
  sendUpdateX = false;
  sendUpdateY = false;
  // Draw the shape
  ellipse(xpos, ypos, rad, rad);
  fill(ballColor);
}
  
