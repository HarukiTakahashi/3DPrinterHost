// *********************************************************************
//
//  Thread
//
//  Two threads run in parallel with main thread.
//  * "Printing Thread" transfers a gcode (from .gcode file) to a queue to print a object.
//  * "Sender Thread" continues to send a gcode in a queue to a printer.
//
// *********************************************************************

public class Printing extends Thread {
  private boolean running;
  private boolean pause;
  private GcodeQueue q;
  private Model m;

  private boolean moveaway;

  // constructor
  public Printing(Model m, GcodeQueue gq) {
    this.q = gq;
    this.m = m;
    this.running = false;
    this.pause = false;

    this.moveaway = false;
  }

  public void run() {

    InfoWin.printInfo("This model has [ " + m.layer.size()+ " layers ]");

    // transfer a gcode in m (Model) to queue
    // send start code

    for (int i = 0; i < m.startCode.size(); i++) {
      if (running) {
        try {
          Thread.sleep(10);
          Gcode g = m.getStartCode(i);
          q.add(g);
          //println("[Add to queue in startCode] " + g);
        }
        catch (InterruptedException e) {
        }
      }
    }

    // *************************************************
    // send main layers
    // *************************************************

    for (int i = 0; i < m.layer.size(); i++) {      

      // i is equals to layer number

      // while pausing ******************************************
      while (pause) {
        try {
          Thread.sleep(10);
          if (!moveaway) {

            // move away *********************************************************************
            q.add(new Gcode("G0 X200 Y200 F3600"));

            // retraction
            q.add(new Gcode("M83"));
            q.add(new Gcode("G1 E-2"));
            q.add(new Gcode("M82"));

            moveaway = true;
          }
        }
        catch (InterruptedException e) {
        }
      }

      moveaway = false;

      for (int j = 0; j < m.layer.get(i).gcode.size(); j++) {
        if (running) {
          try {
            Thread.sleep(10);
            Gcode g = m.getGcode(i, j);

            if (pause && g.f.exist()) {
              g.f.v *= 3;
            }

            q.add(g);

            if (pause) {
              // debug
              InfoWin.printInfo("[ DEBUG ] current layer status : " +  j + " / " + (m.layer.get(i).gcode.size()-1));
            }
          }
          catch (InterruptedException e) {
          }
        }
      }
    }

    // *************************************************

    // send end code
    for (int i = 0; i < m.endCode.size(); i++) {
      if (running) {
        try {
          Thread.sleep(10);
          Gcode g = m.getEndCode(i);
          if (g.comment.indexOf(";") != 0) {
            q.add(g);
          }
          //println("[Add to queue in startCode] " + g);
        }
        catch (InterruptedException e) {
        }
      }
    }

    // finish printing
    InfoWin.printInfo("Finish printing!");
    StopPrinting();
  }

  public void setRunning(boolean b) {
    running = b;
  }

  public boolean getRunning() {
    return running;
  }

  public void setPause(boolean b) {
    this.pause = b;
  }

  public void setModel(Model m) {
    this.m = m;
    InfoWin.printInfo("Printing target was changed!");
  }
}


// ********************************************************************************
//  continue to send gcode to printer
// ********************************************************************************
class Sender extends Thread {
  private boolean running;
  private GcodeQueue q;
  private Gcode lastGcode;

  // constructor
  public Sender(GcodeQueue q) {
    this.q = q;
    this.running = false;
    this.lastGcode = null;
  }

  public void run() {
    while (running) {
      while (!q.access) {
        try {
          Thread.sleep(10);
        }
        catch (InterruptedException e) {
        }
      }


      Gcode g = q.poll();             


    // コメントの処理
      if (g.toString().indexOf(";") != 0) {
        if (g.cmd.indexOf("G") != -1 || g.cmd.indexOf("M") != -1) {
          // when finished to send a data
          // if sent gcode is comment ( ; ), acceses does not be changed

          q.setAccess(false);
          printer.write(g.toString());
          println(" * send to printer : " + g.toString().trim());
        }
      }
    }
  }

  public void setRunning(boolean b) {
    this.running = b;
  }
}



// ********************************************************************************
//  Temperature 
// ********************************************************************************
class Temperature extends Thread {
  int span;
  boolean running;

  // constructor
  public Temperature(int span) {
    this.span = span;
    this.running = false;
  }

  public void run() {
    while (running) {
      try {
        Thread.sleep(span);
      }
      catch (InterruptedException e) {
      }
      if (printer != null)
        printer.write("M105\n");
    }
  }

  public void setRunning(boolean b) {
    this.running = b;
  }
}