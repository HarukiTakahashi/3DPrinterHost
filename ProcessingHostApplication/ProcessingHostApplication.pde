// *********************************************************************
//
//  Project  :  Processing host application for a Reprap 3D printer
//  Author   :  Haruki Takahashi
//  
//  
// *********************************************************************

// *********************************************************************
// import library 
// *********************************************************************
import java.io.*;  
import processing.awt.PSurfaceAWT;

import java.util.function.*;
import java.util.*;
import java.lang.*;
import processing.serial.*;
import processing.opengl.*;
import controlP5.*;

// *********************************************************************
//  setup
// *********************************************************************
void setup() {
  LOCALIZATION_POS_X.add(0);
  LOCALIZATION_POS_Y.add(0);
  LOCALIZATION_ANG.add(0);
  LOCALIZATION_POS_Z = 0;

  surface.setVisible(false); 

  // generate child windows
  MainWin = new MainWindow(this);
  MenuWin = new MenuWindow(this);
  InfoWin = new InfoWindow(this);

  // set  directory paths
  setDirAndPath();

  // load properties
  PrinterSetting.importProperty(dataPath("PrinterSetting.properties"));
  String DEFAULT_GCODE = dataPath("gcode/box_wo_waitcode.gcode");

  model = new Model(DEFAULT_GCODE);

  try {
    MainWin.drawMethods.add(MainWin.getClass().getMethod("clearWin", null));
    MainWin.drawMethodArg.add(null);
    MainWin.drawMethods.add(MainWin.getClass().getMethod("drawPlatform", null));
    MainWin.drawMethodArg.add(null);
    MainWin.drawMethods.add(MainWin.getClass().getMethod("drawModel", Model.class));
    MainWin.drawMethodArg.add(model);
  } 
  catch (Exception ex) {
    ex.printStackTrace();
  }

  queue = new GcodeQueue(16);

  printingThread = new Printing(model, queue);
  senderThread = new Sender(queue);

  senderThread.setRunning(true);
  senderThread.q.setAccess(true);
  senderThread.start();
}

void setDirAndPath() {
  MAIN_DIRECTORY = sketchPath("").replace('\\', '/'); 
  GCODE_DIRECTORY = MAIN_DIRECTORY + "workspace/GCODE/";
  GCODE_FILEPATH = GCODE_DIRECTORY + "output.gcode";
}


// *********************************************************************
// control printing process
// *********************************************************************
void StartPrinting() {
  queue.clear();
  printingThread = new Printing(model, queue);
  senderThread = new Sender(queue);

  printingThread.setRunning(true);
  printingThread.start();

  printer.write("; start\n");
  InfoWin.printInfo("Start printing");
}

void StopPrinting() {
  printingThread.setRunning(false);
  senderThread.setRunning(false);

  // refresh GUI
  NOW_PRINTING = false;
  NOW_PAUSING = false;
  BTN_start_printing
    .setLabel("Start print")
    .setColorBackground(color(0, 45, 90));
  BTN_pause_printing
    .setLabel("Pause print")
    .setColorBackground(color(0, 45, 90));

  queue.clear();

  InfoWin.printInfo("Stop printing");
}