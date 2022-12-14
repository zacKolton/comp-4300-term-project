import processing.net.*;

JSONObject settings;         // Basic program settings stored in .json
JSONArray computer_names;    // List of computer names - configured by the user

String computer_name;        // Name of [this] computer/frame
String ip_address;           // Ref. settings

float xpos;                  // x-axis value for ball
float ypos;                  // y-axis value for ball
float xspeed;                // Ref. settings - horizontal speed
float yspeed;                // Ref. settings - vertical speed

int radius;                  // Ref. settings - ball radius
int port;                    // Ref. settings - "server" address
int window_width;            // Ref. settings - display width 
int window_height;           // Ref. settings - display height
int frame_rate;              // Ref. settings - display frame rate
int config_order;            // Ref. settings - relative location (for edges)
int num_computers;           // 
int xdir = 1;                // Starting direction (Left or Right)
int ydir = 1;                // Starting direction (Up or Down)

color ballColor = 0x00000;   // Black
color background = 0xCED4DA; // Grey"ish"

Client client;               // Client to interact with server

void applySettings()
{
  settings       = loadJSONObject("../settings.json");
  xspeed         = settings.getFloat("x-speed");
  yspeed         = settings.getFloat("y-speed");
  radius         = settings.getInt("ball-radius");
  port           = settings.getInt("port");
  ip_address     = settings.getString("ip");
  window_width   = settings.getInt("window-width");
  window_height  = settings.getInt("window-height");
  frame_rate     = settings.getInt("frame-rate");
  computer_names = settings.getJSONArray("computer-configuration");
  
  for(int i = 0; i < computer_names.size(); i++)
  {
    if(!computer_names.getJSONObject(i).getBoolean("in-use"))
    {
      computer_name = computer_names.getJSONObject(i).getString("name");
      config_order = i;
      computer_names.getJSONObject(i).setBoolean("in-use",true);
    }
  }
}

void setup()
{
  applySettings();
  
  size(window_width, window_height);
  noStroke();
  frameRate(frame_rate);
  ellipseMode(RADIUS);
  
  xpos = window_width/2;
  ypos = window_height/2;
  client = new Client(this, ip_address, port);
}

void draw() 
{
  background(background);
  if(xpos > window_width + radius && xdir > 0 && config_order < computer_names.size() - 1)
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
    
    if(xpos - radius == 0)
    {
      xdir *= -1;
    }
    
    if (ypos > window_height-radius || ypos < radius) 
    {
      ydir *= -1;
    }
    ellipse(xpos, ypos, radius, radius);
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
