// ************************************************************************
//
//  config and global fields
//
// ************************************************************************


// ************************************************************************
//  external programs
// ************************************************************************

// working path ====================================================
String MAIN_DIRECTORY = "";

// =================================================================
String GCODE_DIRECTORY;
String GCODE_FILEPATH;


// ************************************************************************
//  inserted item transformation
//  0: position_x  1: position_y  2: position_z  3: rotation_z
// ************************************************************************
ArrayList LOCALIZATION_POS_X = new ArrayList();
ArrayList LOCALIZATION_POS_Y = new ArrayList();
ArrayList LOCALIZATION_ANG = new ArrayList();
float LOCALIZATION_POS_Z = 0;

// ************************************************************************
//  default 3D models
// ************************************************************************
String GCODE_FILENAME = "";
String INSERTED_MODEL_FILENAME = "";

// ************************************************************************
//  model
// ************************************************************************
Model model;

// ************************************************************************
//  serial
// ************************************************************************

Serial printer=null;

String[] SERIAL_PORTS = Serial.list();
final int[] BAUD_RATES = { 250000, 9600, 115200 };


// ************************************************************************
//  threads
// ************************************************************************
Printing printingThread;
Sender senderThread;
Temperature temperatureThread;

// ************************************************************************
//  main queue
// ************************************************************************
GcodeQueue queue;


// ************************************************************************
//  default start code
// ************************************************************************
String CONNECT_CODE = "G1 Z5\n"+ "M105\n";

// ************************************************************************
//  whether printer is printing or not
// ************************************************************************
boolean NOW_PRINTING = false;
boolean NOW_PAUSING = false;


// ************************************************************************
//  size and location of windows
// ************************************************************************
final int MAIN_WINDOW_SIZE[] = new int[]{500, 250};
final int MAIN_WINDOW_LOCATION[] = new int[]{350, 50};

final int INFO_WINDOW_SIZE[] = new int[]{MAIN_WINDOW_SIZE[0], 180};
final int INFO_WINDOW_LOCATION[] = new int[]{MAIN_WINDOW_LOCATION[0], MAIN_WINDOW_LOCATION[1]+MAIN_WINDOW_SIZE[1]+35};

final int MENU_WINDOW_SIZE[] = new int[]{300, MAIN_WINDOW_SIZE[1]+INFO_WINDOW_SIZE[1] + 35};
final int MENU_WINDOW_LOCATION[] = new int[]{MAIN_WINDOW_LOCATION[0]-MENU_WINDOW_SIZE[0]-10, MAIN_WINDOW_LOCATION[1]};

final int CAMERA_WINDOW_SIZE[] = new int[]{384, MENU_WINDOW_SIZE[1]};
final int CAMERA_WINDOW_LOCATION[] = new int[]{MAIN_WINDOW_LOCATION[0]+MAIN_WINDOW_SIZE[0], MAIN_WINDOW_LOCATION[1]};