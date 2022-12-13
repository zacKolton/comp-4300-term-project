import processing.net.*;

String computer_name = "computer_a";
String reciever_name = "computer_b";


float xpos;
float ypos;    // Starting position of shape    
float xspeed = 2;  // Speed of the shape
float yspeed = 2;  // Speed of the shape

int rad = 20;        // Width of the shape
int xdir = 1;  // Left or Right
int ydir = 1;  // Top to Bottom

color ballColor = 0x00000;
color background = 0xCED4DA;

boolean sendUpdateX = false;
boolean sendUpdateY = false;
boolean draw = true;

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
  background(background);
  JSONObject server_message = null;
  String recipient = "";
  
  if(client.available() > 0)
  {
    server_message = parseJSONObject(client.readString());
    recipient = server_message.getString("reciever_name");
  }
  
  if(recipient.equals(computer_name) && server_message != null)
  {
    xpos = server_message.getFloat("xpos");
    ypos = server_message.getFloat("ypos");
    xdir = server_message.getInt("xdir");
    ydir = server_message.getInt("ydir");
    draw = true;
  }
  else
  {
    xpos = xpos + ( xspeed * xdir );
    ypos = ypos + ( yspeed * ydir );
    
    if(xpos < -rad)
    {
      xdir *= -1;
    }
    
    if (xpos > width+rad) {
      sendUpdateX = true;
    }
    if (ypos > height-rad || ypos < rad) {
      ydir *= -1;
    }
  }
  
  if(sendUpdateX)
  {
    JSONObject notify = new JSONObject();
    notify.setString("sender_name",computer_name);
    notify.setString("reciever_name", reciever_name);
    notify.setFloat("xpos",xpos);
    notify.setFloat("ypos",ypos);
    notify.setInt("xdir",xdir);
    notify.setInt("ydir",ydir);
   
    String message = notify.toString();
    client.write(message);
    
  }
    ellipse(xpos, ypos, rad, rad);
    fill(ballColor);
  sendUpdateX = false;
  
}
