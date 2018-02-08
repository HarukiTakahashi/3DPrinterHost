// *********************************************************************
//
//  GUI components for menu windows
//
//  reference:  http://www.sojamo.de/libraries/controlP5/
//
// *********************************************************************


ControlP5 cp5_Menu;

DropdownList DDL_printer_ports;
DropdownList DDL_printer_rates;
DropdownList DDL_sensor_ports;
DropdownList DDL_sensor_rates;

Textfield TF_GcodeSend;

Textlabel LAB_current_nozzle_temp;
Textlabel LAB_current_bed_temp;

ControlFont FontSmall;
ControlFont FontNormal;

Button BTN_start_printing;
Button BTN_pause_printing;

// *********************************************************************
//  GUI components
// *********************************************************************
void Menu_GUISetting() {
  FontSmall = new ControlFont (createFont("Ariel", 12));
  FontNormal = new ControlFont (createFont("Ariel", 16));

  cp5_Menu = new ControlP5(MenuWin);

  int Local_Text_Width = 50;
  int Gcodefiles_Y = 40;

  // ************************************************************************
  // textbox for choosing original .gcode file 
  // ************************************************************************
  cp5_Menu.addLabel("Gcode file").setPosition(0, Gcodefiles_Y).setFont(FontNormal).setColor(color(0));
  cp5_Menu.addTextfield("file_name_original").setCaptionLabel("").setText(GCODE_FILENAME).setPosition(0, Gcodefiles_Y+20).setWidth(199).setHeight(20).setFont(FontSmall);
  cp5_Menu.addButton("load_gcode_file").setLabel("Open").setPosition(200, Gcodefiles_Y+20).setWidth(100).setHeight(20).setFont(FontNormal).setColorCaptionLabel(color(255));

  // ************************************************************************
  // GUI for printer's serial port
  // ************************************************************************
  cp5_Menu.addLabel("3D Printer").setPosition(0, 0).setFont(FontNormal).setColor(color(0));

  // button ===========================================
  cp5_Menu.addButton("connect_printer").setLabel("Connect").setPosition(200, 20).setWidth(100).setHeight(20).setFont(FontSmall).setColorCaptionLabel(color(255));

  // dropdownlist for baudrate ========================
  DDL_printer_rates = cp5_Menu.addDropdownList("dl-baud-rates");
  DDL_printer_rates.setLabel("baud rates").setPosition(100, 20).setWidth(100).setHeight(120).setBarHeight(20).setItemHeight(20).close();

  for (int i=0; i<BAUD_RATES.length; i++) {
    DDL_printer_rates.addItem( BAUD_RATES[i] + " bps", i);
  }
  DDL_printer_rates.setId(0);

  // dropdownlist for serial port =====================
  DDL_printer_ports = cp5_Menu.addDropdownList("dl-serial-ports");
  if ( SERIAL_PORTS.length <= 0 ) { 
    DDL_printer_ports.setLabel("not found");
  } else {
    DDL_printer_ports.setLabel("serial port");
  }

  DDL_printer_ports.setPosition(0, 20).setWidth(100).setHeight(80).setBarHeight(20).setItemHeight(20).close();

  for (int i=0; i<SERIAL_PORTS.length; i++) {
    DDL_printer_ports.addItem(SERIAL_PORTS[i], i);
  }
  DDL_printer_ports.setId(0);


  // ************************************************************************
  // Controller
  // ************************************************************************

  int GUI_Cnt_posX = 10;
  int GUI_Cnt_posY = 200;

  cp5_Menu.addLabel("Controller")
    .setPosition(0, GUI_Cnt_posY-20).setFont(FontNormal).setColor(color(0));

  // X ==========================================================
  cp5_Menu.addButton("controller_x_minus").setLabel("-").setFont(FontNormal).setPosition(GUI_Cnt_posX + 0, GUI_Cnt_posY).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_x_home").setLabel("X").setFont(FontNormal).setPosition(GUI_Cnt_posX + 40, GUI_Cnt_posY).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_x_plus").setLabel("+").setFont(FontNormal).setPosition(GUI_Cnt_posX + 80, GUI_Cnt_posY).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));

  // Y ==========================================================
  cp5_Menu.addButton("controller_y_minus").setLabel("-").setFont(FontNormal).setPosition(GUI_Cnt_posX + 0, GUI_Cnt_posY + 40).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_y_home").setLabel("Y").setFont(FontNormal).setPosition(GUI_Cnt_posX + 40, GUI_Cnt_posY + 40).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_y_plus").setLabel("+").setFont(FontNormal).setPosition(GUI_Cnt_posX + 80, GUI_Cnt_posY + 40).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));

  //  ==========================================================
  cp5_Menu.addButton("controller_z_minus").setLabel("-").setFont(FontNormal).setPosition(GUI_Cnt_posX + 0, GUI_Cnt_posY + 80).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_z_home").setLabel("Z").setFont(FontNormal).setPosition(GUI_Cnt_posX + 40, GUI_Cnt_posY + 80).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_z_plus").setLabel("+").setFont(FontNormal).setPosition(GUI_Cnt_posX + 80, GUI_Cnt_posY + 80).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));

  // E ==========================================================
  cp5_Menu.addButton("controller_e_minus").setLabel("-").setFont(FontNormal).setPosition(GUI_Cnt_posX + 0, GUI_Cnt_posY + 120).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_e_home").setLabel("E").setFont(FontNormal).setPosition(GUI_Cnt_posX + 40, GUI_Cnt_posY + 120).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));
  cp5_Menu.addButton("controller_e_plus").setLabel("+").setFont(FontNormal).setPosition(GUI_Cnt_posX + 80, GUI_Cnt_posY + 120).setWidth(30).setHeight(30).setColorCaptionLabel(color(255));

  // Home ==========================================================
  cp5_Menu.addButton("controller_homepos").setLabel("Home pos").setFont(FontNormal).setPosition(GUI_Cnt_posX + 150, GUI_Cnt_posY + 0).setWidth(110).setHeight(30).setColorCaptionLabel(color(255));

  // Temperature ==========================================================
  cp5_Menu.addButton("controller_nozzletemp").setLabel("Nozzle temp").setFont(FontSmall).setPosition(GUI_Cnt_posX + 150, GUI_Cnt_posY + 40).setWidth(110).setHeight(30).setColorCaptionLabel(color(255));
  LAB_current_nozzle_temp = cp5_Menu.addLabel("nozzle").setText("XX").setPosition(GUI_Cnt_posX+150, GUI_Cnt_posY+70).setFont(FontNormal).setColor(color(0));
  cp5_Menu.addTextfield("nozzle_temp").setCaptionLabel("").setText("190").setPosition(GUI_Cnt_posX+210, GUI_Cnt_posY+70).setWidth(Local_Text_Width).setHeight(20).setFont(FontSmall);

  cp5_Menu.addButton("controller_bedtemp").setLabel("Bed temp").setFont(FontSmall).setPosition(GUI_Cnt_posX + 150, GUI_Cnt_posY + 100).setWidth(110).setHeight(30).setColorCaptionLabel(color(255));
  LAB_current_bed_temp = cp5_Menu.addLabel("bed").setText("XX").setPosition(GUI_Cnt_posX+150, GUI_Cnt_posY+130).setFont(FontNormal).setColor(color(0));
  cp5_Menu.addTextfield("bed_temp").setCaptionLabel("").setText("50").setPosition(GUI_Cnt_posX+210, GUI_Cnt_posY+130).setWidth(Local_Text_Width).setHeight(20).setFont(FontSmall);


  // Arbitary gcode ==========================================================
  cp5_Menu.addLabel("Gcode").setPosition(GUI_Cnt_posX, GUI_Cnt_posY+150).setFont(FontNormal).setColor(color(0));
  TF_GcodeSend = cp5_Menu.addTextfield("gcode_direct_input").setCaptionLabel("").setText("").setPosition(GUI_Cnt_posX, GUI_Cnt_posY+170).setWidth(180).setHeight(20).setFont(FontSmall);
  cp5_Menu.addButton("controller_gcode_send").setPosition(GUI_Cnt_posX + 200, GUI_Cnt_posY + 170).setWidth(80).setHeight(20).setLabel("Send").setFont(FontNormal).setColorCaptionLabel(color(255));

  // start printing ==========================================================
  BTN_start_printing = cp5_Menu.addButton("controller_start_printing").setPosition(20, GUI_Cnt_posY + 210).setWidth(120).setHeight(30)
    .setLabel("Start print").setFont(FontNormal).setColorCaptionLabel(color(255));

  // start printing ==========================================================
  BTN_pause_printing = cp5_Menu.addButton("controller_pause_printing").setPosition(150, GUI_Cnt_posY + 210).setWidth(120).setHeight(30)
    .setLabel("Pause print").setFont(FontNormal).setColorCaptionLabel(color(255));
}