// *********************************************************************
//
//  Serial communication
//
// *********************************************************************

// connectSerial =======================================
Serial connectPrinter(String com, int baud) {
  Serial tmp=new Serial(this, com, baud);
  InfoWin.printInfo("connecting...");

  try {
    Thread.sleep(1000);
  }
  catch(Exception e) {
    InfoWin.printInfo("counld not connet to printer");
  }

  // check the connection ==========
  tmp.write(CONNECT_CODE);// home position
  InfoWin.printInfo(CONNECT_CODE);
  InfoWin.printInfo("printer is connected! [ Port : " + com + " , Baudrate : " + baud + " ]");

  temperatureThread = new Temperature(3000);
  temperatureThread.setRunning(true);
  temperatureThread.start();

  return tmp;
}

// connectSerial =======================================
Serial connectSensor(String com, int baud) {
  Serial tmp=new Serial(this, com, baud);
  InfoWin.printInfo("connecting...");
  try {
    Thread.sleep(1000);
  }
  catch(Exception e) {
    // InfoWin.printInfo("could not cennect to sensor");
  }

  InfoWin.printInfo("sensors are connected! [ Port : " + com + " , Baudrate : " + baud + " ]");
  return tmp;
}


// ingore first several messages
int discardCount = 0;
int comeonCount = 0;

// =======================================
// Called when data is available.
// Use readString() method to capture this data.
void serialEvent(Serial thisPort) {

  try {
    if (printer != null) {
      if (thisPort == printer) {
        byte[] buf = thisPort.readBytesUntil('\n');
        if (buf != null) {
          String str=new String(buf);
          str = str.trim();
          // debug

          // If 3D printer returns "ok" after recieving a data
          if (str.indexOf("ok") != -1) {
            if (str.indexOf("T:") != -1) {
              // debug
              MenuWin.setTemperature(str);
            } else {
              queue.setAccess(true);
            }
          }
        }
      }
    }
  }

  catch(RuntimeException e) {
    e.printStackTrace();
  }
}