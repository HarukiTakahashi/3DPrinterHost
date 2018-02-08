// *********************************************************************
//
//  Menu window
//
//  Menu (controller) is generated here for debugging.
//
// *********************************************************************

MenuWindow MenuWin;

public class MenuWindow extends PApplet {

  PApplet parent;
  MenuWindow(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    // init window
    try {
      Method handleSettingsMethod = this.getClass().getSuperclass().getDeclaredMethod("handleSettings", null);
      handleSettingsMethod.setAccessible(true);
      handleSettingsMethod.invoke(this, null);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }

    PSurface surface = super.initSurface();
    surface.placeWindow(new int[]{0, 0}, new int[]{0, 0});

    this.showSurface();
    this.startSurface();
  }

  // ********************************************************************************
  //  setting -  menu window
  // ********************************************************************************
  void settings() {
    size( MENU_WINDOW_SIZE[0], MENU_WINDOW_SIZE[1]);
  }

  // ********************************************************************************
  //  setup -  menu window
  // ********************************************************************************
  void setup() {
    // window setting
    surface.setLocation(MENU_WINDOW_LOCATION[0], MENU_WINDOW_LOCATION[1]);
    surface.setTitle("Menu");

    stroke(180, 180, 180);
    Menu_GUISetting();

    frameRate(10);
  }

  // ********************************************************************************
  //  draw -  menu window
  // ********************************************************************************
  void draw() {
    background(color(200, 200, 200));
    // grid for debug
    drawGrid();
  }


  // ********************************************************************************
  //  draw grid to arrange GUI components (Debug)
  // ********************************************************************************
  void drawGrid() {
    for (int i = 0; i < width; i += 10) {
      if (i%100 == 0) {
        strokeWeight(3);
      } else {
        strokeWeight(1);
      }
      line(i, 0, i, height);
    }
    for (int j = 0; j < height; j += 10) {
      if (j%100 == 0) {
        strokeWeight(3);
      } else {
        strokeWeight(1);
      }
      line(0, j, width, j);
    }
  }

  // ************************************************************************************************************************************************
  //  GUI callback methods
  // ************************************************************************************************************************************************

  // ************************************************************************
  //  Connect Button
  void connect_printer() {
    if ( DDL_printer_ports != null && DDL_printer_rates != null) {
      if ( printer == null) {
        printer = connectPrinter(SERIAL_PORTS[(int)DDL_printer_ports.getValue()], BAUD_RATES[(int)DDL_printer_rates.getValue()]);
        temperatureThread.setRunning(true);
        Button bt = (Button)cp5_Menu.getController("connect_printer");
        bt.setColorBackground(color(255, 0, 0));
        bt.setLabel("Disconnect");
      } else {
        InfoWin.printInfo("printer is disconnected");
        temperatureThread.setRunning(false);
        printer.stop();
        printer = null;        
        Button bt = (Button)cp5_Menu.getController("connect_printer");
        bt.setColorBackground(color(0, 45, 90));
        bt.setLabel("connect");
      }
    }
  }

  // ************************************************************************
  // load stl file to Main window
  // ************************************************************************
  //  Open Button
  void load_gcode_file() {
    selectInput("select gcode file", "fileSelected", new File( dataPath("gcode") ));
  }

  void fileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      GCODE_FILENAME = selection.getAbsolutePath();

      Textfield t = (Textfield)cp5_Menu.getController("file_name_original");
      t.setText(GCODE_FILENAME);
      InfoWin.printInfo(GCODE_FILENAME.trim() + " is loaded.");
      
      
      sub_load(GCODE_FILENAME);
      printingThread.setModel(model);
      
    }
  }

  void sub_load(String str) {
    model = new Model(str);

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
  }


  // ************************************************************************
  //  start printing
  // ************************************************************************
  void controller_start_printing() {
    if (printer!=null) {
      if (!NOW_PRINTING) { 
        StartPrinting();
        NOW_PRINTING = true;
        BTN_start_printing
          .setLabel("Stop print")
          .setColorBackground(color(255, 0, 0));
      } else {
        StopPrinting();
        NOW_PRINTING = false;

        NOW_PAUSING = false;
        BTN_start_printing
          .setLabel("Start print")
          .setColorBackground(color(0, 45, 90));
        BTN_pause_printing
          .setLabel("Pause print")
          .setColorBackground(color(0, 45, 90));
      }
    }
  }

  // ************************************************************************
  //  pause printing
  // ************************************************************************
  void controller_pause_printing() {
    if (printer!=null) {

      if (!NOW_PAUSING) { 
        NOW_PAUSING = true;
        printingThread.setPause(true);
        InfoWin.printInfo("Pause!");
        InfoWin.printInfo("Wait for finishing printing this layer");

        BTN_pause_printing
          .setLabel("Resume")
          .setColorBackground(color(255, 0, 0));
      } else {
        NOW_PAUSING = false;
        printingThread.setPause(false);
        InfoWin.printInfo("Resume!");       
        BTN_pause_printing
          .setLabel("Pause print")
          .setColorBackground(color(0, 45, 90));
      }
    }
  }

  // ************************************************************************************************************************************************

  // ************************************************************************
  //  printer controller
  // ************************************************************************
  void controller_x_home() {
    if (printer!=null) {
      printer.write("G28 X0\n");
    }
  } 
  void controller_x_plus() {
    if (printer!=null) {
      printer.write("G91\nG1 X10 F3600\nG90\n");
    }
  }
  void controller_x_minus() {
    if (printer!=null) {
      printer.write("G91\nG1 X-10\nG90\n");
    }
  } 

  void controller_y_home() {
    if (printer!=null) {
      printer.write("G28 Y0\n");
    }
  } 
  void controller_y_plus() {
    if (printer!=null) {
      printer.write("G91\nG1 Y10 F3600\nG90\n");
    }
  }
  void controller_y_minus() {
    if (printer!=null) {
      printer.write("G91\nG1 Y-10\nG90\n");
    }
  } 

  void controller_z_home() {
    if (printer!=null) {
      printer.write("G28 Z0\n");
    }
  }
  void controller_z_plus() {
    if (printer!=null) {
      printer.write("G91\nG1 Z10 F3600\nG90\n");
    }
  }
  void controller_z_minus() {
    if (printer!=null) {
      printer.write("G91\nG1 Z-10\nG90\n");
    }
  } 

  void controller_e_home() {
    if (printer!=null) {
      printer.write("G28 Z0\n");
    }
  }
  void controller_e_plus() {
    if (printer!=null) {
      printer.write("M83\nG1 E10 F600\n");
    }
  }
  void controller_e_minus() {
    if (printer!=null) {
      printer.write("M83\nG1 E-10 F600\n");
    }
  } 

  void controller_homepos() {
    if (printer!=null) {
      printer.write("G28\n");
    }
  }

  void controller_gcode_send() {
    if (printer!=null) {
      String t = TF_GcodeSend.getText();
      printer.write(t + "\n");
    }
  }

  // temperature
  void controller_nozzletemp() {
    if (printer!=null) {
      Textfield t = (Textfield)cp5_Menu.getController("nozzle_temp");
      printer.write("M104 S" + t.getText() + "\n");
      InfoWin.printInfo("Nozzle temperature was set at " + t.getText() + " degrees Celsius");
    }
  }

  // temperature
  void controller_bedtemp() {
    if (printer!=null) {
      Textfield t = (Textfield)cp5_Menu.getController("bed_temp");
      printer.write("M140 S" + t.getText() + "\n");
      InfoWin.printInfo("Platform temperature was set at " + t.getText() + " degrees Celsius");
    }
  }


  // refresh textlabels according to the temperature
  void setTemperature(String str) {
    // e.g.
    // ok T:25.0 /0.0 B:25.0 /0.0 @:0 B@:0

    String regex;
    String nozzle = "";
    regex = "T:(.*?) ";
    Pattern pattern;
    Matcher matcher;

    pattern = Pattern.compile(regex);  
    matcher = pattern.matcher(str);
    if (matcher.find()) {
      nozzle = matcher.group(1).trim();
    } 

    String bed = "";
    regex = "B:(.*?) ";

    pattern = Pattern.compile(regex);  
    matcher = pattern.matcher(str);
    if (matcher.find()) {
      bed = matcher.group(1).trim();
    } 

    LAB_current_nozzle_temp.setText("" + nozzle);
    LAB_current_bed_temp.setText("" + bed);
  }
}