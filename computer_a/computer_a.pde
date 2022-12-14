import processing.net.*;

String computer_name = "computer_a";

float xpos;
float ypos;    // Starting position of shape    
float xspeed = 4;  // Speed of the shape
float yspeed = 4;  // Speed of the shape

int rad = 20;        // Width of the shape
int xdir = 1;  // Left or Right
int ydir = 1;  // Top to Bottom

color ballColor = 0x00000;
color background = 0xCED4DA;

Client client;

void setup()
{
  size(1500, 600);
  noStroke();
  frameRate(40);
  ellipseMode(RADIUS);
  
  xpos = width/2;
  ypos = height/2;
  client = new Client(this, "192.168.1.15", 5204);
}

void draw() 
{
  background(background);
  if(xpos > width + rad && xdir > 0)
  {
    JSONObject notify = new JSONObject();
    notify.setFloat("xpos",xpos);
    notify.setFloat("ypos",ypos);
    notify.setInt("ydir",ydir);
    notify.setString("sender",computer_name);
    client.write(notify.toString());
    noLoop();
  }
  else
  {
    xpos = xpos + ( xspeed * xdir );
    ypos = ypos + ( yspeed * ydir );
    
    if(xpos - rad == 0)
    {
      xdir *= -1;
    }
    
    if (ypos > height-rad || ypos < rad) 
    {
      ydir *= -1;
    }
    
    ellipse(xpos, ypos, rad, rad);
    fill(ballColor);
  }
}

void clientEvent(Client c)
{
  JSONObject server_message = parseJSONObject(c.readString());
  if(server_message.getString("reciever").equals(computer_name))
  {
    xpos = server_message.getFloat("xpos");
    ypos = server_message.getFloat("ypos");
    ydir = server_message.getInt("ydir");
    xdir *= -1;
    loop();
  }
  
}
