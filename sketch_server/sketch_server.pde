import processing.net.*;

Server myServer;
JSONObject settings;
JSONObject curr_client;
Client available_client;


void setup() {
  settings = loadJSONObject("../settings.json");
  
  size(200, 200);
  // Starts a myServer on port 5204
  myServer = new Server(this,5204, "192.168.1.15"); 
}

void draw() 
{
  available_client = myServer.available();
  
  if(available_client != null) 
  {
    JSONObject input = parseJSONObject(available_client.readString());
    print(input.toString());
    
    
  }
}


/*
    JSONObject input = parseJSONObject(available_client.readString());
    String computer_name = input.getString("computer-name");
    String leaving_name = input.getJSONObject("event").getString("leaving");
    String entering_name= input.getJSONObject("event").getString("entering");
    float x_pos = input.getJSONObject("event").getFloat("x-pos");
    float y_pos = input.getJSONObject("event").getFloat("y-pos");
    int x_dir = input.getJSONObject("event").getInt("x-dir");
    int y_dir = input.getJSONObject("event").getInt("y-dir");
    
    
    JSONObject computer_config = settings.getJSONObject(computer_name);
    JSONObject output;
    
    if(computer_config != null && leaving_name.equals(computer_name))
    {
      output = new JSONObject();
      output.setString("computer-name", entering_name);

      output.setString("x","");
      output.setString("y","");
    } 
    */
