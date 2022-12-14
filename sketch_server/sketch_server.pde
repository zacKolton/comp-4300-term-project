import processing.net.*;

JSONObject settings;
JSONObject curr_client;

Server myServer;
Client available_client;

int radius;
int port;                    // Ref. settings - "server" address
String ip_address;           // Ref. settings

void setup() {
  size(300, 300);
  applySettings()
  
  myServer = new Server(this,5204, "192.168.1.15"); 
}

void draw() 
{
  available_client = myServer.available();
  
  if(available_client != null) 
  {
    JSONObject input = parseJSONObject(available_client.readString());
    
    String sender = input.getString("sender");
    String target = input.getString("target");
    int xdir = input.getInt("xdir");
    int ydir = input.getInt("ydir");
    float xpos = input.getFloat("xpos");
    float ypos = input.getFloat("ypos");
    
     if(xdir < 0)
     {
       xpos = width + radius;
     }
     if(xdir > 0)
     {
       xpos = -radius;
     }
     
     JSONObject output = new JSONObject();
     output.setString("sender","Server");
     output.setString("reciever", target);
     output.setInt("xdir",xdir);
     output.setInt("ydir",ydir);
     output.setFloat("xpos",xpos);
     output.setFloat("ypos",ypos);
     
     myServer.write(output.toString());
  }
}

void applySettings()
{
  settings       = loadJSONObject("../settings.json");
  radius         = settings.getInt("ball-radius");
  port           = settings.getInt("port");
  ip_address     = settings.getString("ip");
  window_width   = width;
  window_height  = height;
  computer_names = settings.getJSONArray("computer-configuration");
}
