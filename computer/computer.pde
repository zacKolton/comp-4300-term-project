import processing.net.*;

JSONObject settings;         // Basic program settings stored in .json
JSONArray computer_names;    // List of computer names - configured by the user

String computer_name;        // Name of [this] computer/frame
String ip_address;           // Ref. settings
String left_computer;        
String right_computer;       

float xpos;                  // x-axis value for ball
float ypos;                  // y-axis value for ball
float xspeed;                // Ref. settings - horizontal speed
float yspeed;                // Ref. settings - vertical speed

int radius;                  // Ref. settings - ball radius
int port;                    // Ref. settings - "server" address
int window_width;            // 
int window_height;           // 
int frame_rate;              // Ref. settings - display frame rate
int num_computers;           // 
int xdir = 1;                // Starting direction (Left or Right)
int ydir = 1;                // Starting direction (Up or Down)

color ballColor = 0x00000;   // Black
color background = 0xCED4DA; // Grey"ish"

boolean hasLeft;
boolean hasRight;

Client client;               // Client to interact with server



void setup()
{
  size(200, 200);
  applySettings();
  
  
  noStroke();
  frameRate(frame_rate);
  ellipseMode(RADIUS);
  
  xpos = window_width/2;
  ypos = window_height/2;
  client = new Client(this, ip_address, port);
  askForConfig();
  noLoop();
}

void draw() 
{
  background(background);
  drawBall(xpos, ypos);

  xpos = xpos + ( xspeed * xdir );
  ypos = ypos + ( yspeed * ydir );
  
  if(xpos < -radius && xdir < 0)
  {
    if(!left_computer.equals(""))
    {
      notifyServer(xpos, ypos, xdir, ydir, left_computer);
      noLoop();
    }
    else
    {
      xdir *= -1;
    }
  }
  
  if(xpos > width + radius && xdir > 0)
  {
    if(!right_computer.equals(""))
    {
      notifyServer(xpos, ypos, xdir, ydir, right_computer);
      noLoop();
    }
    else
    {
      xdir *= -1;
    }
  }
  
  if (ypos > window_height-radius || ypos < radius) 
  {
      ydir *= -1;
  }
  
}

void drawBall(float xpos, float ypos)
{
  ellipse(xpos, ypos, radius, radius);
  fill(ballColor);
}

void askForConfig()
{
  JSONObject output = new JSONObject();
  output.setString("request-type","getConfig");
  output.setString("name",computer_name);
  client.write(output.toString());
  print(output.toString());
}

void notifyServer(float xpos, float ypos, int xdir, int ydir, String target)
{
    JSONObject notify = new JSONObject();
    notify.setFloat("xpos",xpos);
    notify.setFloat("ypos",ypos);
    notify.setInt("ydir",ydir);
    notify.setInt("xdir",xdir);
    notify.setString("sender",computer_name);
    notify.setString("target", target);
    notify.setString("request-type","coordinates");
    client.write(notify.toString());
    print(notify.toString());
}

void clientEvent(Client c)
{
  JSONObject server_message = parseJSONObject(c.readString());
  if(server_message.getString("reciever").equals(computer_name))
  {
    if(server_message.getString("instruction") != null)
    {
      if(server_message.getString("instruction").equals("begin"))
      {
        loop();
      }
      else if(server_message.getString("instruction").equals("end"))
      {
        noLoop();
      }
      else if(server_message.getString("instruction").equals("config"))
      {
        computer_name = server_message.getString("name");
        left_computer = server_message.getString("left");
        right_computer = server_message.getString("right");
      }
      else if(server_message.getString("instruction").equals("coordinates"))
      {
        xpos = server_message.getFloat("xpos");
        ypos = server_message.getFloat("ypos");
        ydir = server_message.getInt("ydir");
        xdir = server_message.getInt("xdir");
        loop();
      }
    }
  }
  print(server_message.toString());
}

void applySettings()
{
  settings       = loadJSONObject("../settings.json");
  xspeed         = settings.getFloat("x-speed");
  yspeed         = settings.getFloat("y-speed");
  radius         = settings.getInt("ball-radius");
  port           = settings.getInt("port");
  ip_address     = settings.getString("ip");
  window_width   = width;
  window_height  = height;
  frame_rate     = settings.getInt("frame-rate");
  computer_name  = str(random(0,1000));
}
