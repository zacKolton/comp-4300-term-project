import processing.net.*; 

Client testClient; 
String computer_name = "client_test";
 
void setup() { 
  size(300, 300); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  testClient = new Client(this, "127.0.0.2", 5204);
  
  
} 
