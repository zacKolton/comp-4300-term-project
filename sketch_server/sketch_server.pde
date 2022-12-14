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
  applySettings();
  
  myServer = new Server(this,5204, "192.168.1.15"); 
}

void draw() 
{
  available_client = myServer.available();
  JSONObject output = new JSONObject();
  
  if(available_client != null) 
  {
    JSONObject input = parseJSONObject(available_client.readString());
    
    if(input.getString("request-type").equals("getConfig"))
    {
      JSONArray computer_config = settings.getJSONArray("computer-configuration");
      boolean done = false;
      for(int i = 0; i < computer_config.size() && !done; i++)
      {
        if(!computer_config.getJSONObject(i).getBoolean("in-use"))
        {
          String computer_name = computer_config.getJSONObject(i).getString("name");
          String left_computer = computer_config.getJSONObject(i).getString("left");
          String right_computer = computer_config.getJSONObject(i).getString("right");
          computer_config.getJSONObject(i).setBoolean("in-use",true);
          settings.setJSONArray("computer-configuration",computer_config);
          saveJSONObject(settings,"../settings.json");
          
          output.setString("reciever", input.getString("name"));
          output.setString("instruction","config");
          output.setString("name", computer_name);
          output.setString("left",left_computer);
          output.setString("right",right_computer);
          done = true;
        }
        
      }
    }
    
    if(input.getString("request-type").equals("coordinates")
    {
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
       
       output.setString("sender",sender);
       output.setString("reciever", target);
       output.setInt("xdir",xdir);
       output.setInt("ydir",ydir);
       output.setFloat("xpos",xpos);
       output.setString("instruction","coordinates");
       output.setFloat("ypos",ypos);
    }
    myServer.write(output.toString());
    print(output.toString());
    
  }
}

void mouseClicked()
{
  startAnimation();
}

void startAnimation()
{
  JSONObject output = new JSONObject();
  
  JSONArray computer_names = settings.getJSONArray("computer-configuration");
  if(computer_names.getJSONObject(0) != null)
  {
    output.setString("sender","Server");
    output.setString("reciever", computer_names.getJSONObject(0).getString("name"));
    output.setString("instruction", "begin");
    print(output.toString());
  }
}

void applySettings()
{
  settings       = loadJSONObject("../settings.json");
  radius         = settings.getInt("ball-radius");
  port           = settings.getInt("port");
  ip_address     = settings.getString("ip");
  
  
}
