// *********************************************************************
//
//  Model Class
//    * Layer Class
//        Gcode Class
//
//    An instance of this class has a layer in 3D model (gcode).
//    i.e., a ArrayList field keeps gcodes that form a layer.
//   
// *********************************************************************

class Layer {
  ArrayList<Gcode> gcode;
  float LastEvalue = 0;

  public Layer() {
    this.gcode = new ArrayList<Gcode>();
    this.LastEvalue = 0;
  }

  public Gcode getGcode(int gc) {
    if (gc < 0 || gcode.size() <= gc) {
      println("ERROR: gcode number is out of range in this layer ( Gcode Count: " + gcode.size() + ")");
      return null;
    }

    return gcode.get(gc);
  }


  public float setLastEvalue() {
    if (gcode.size() == 0) {
      return -1;
    }

    for (int i = gcode.size()-1; i > 0; i--) {
      if (gcode.get(i).e.exist()) {
        this.LastEvalue = gcode.get(i).e.v;
        return gcode.get(i).e.v;
      }
    }
    return -1;
  }

  // divide a gcode into micromovement (set by the argment)
  void divide(float MaxLen, float previousE) {

    for (int i = 0; i < gcode.size()-1; i++) {
      Gcode g = gcode.get(i);

      // the Gcode is not G1
      if (g.cmd.indexOf("G1") == -1) {
        continue;
      }

      // the Gcode doesn't have E param
      if (!g.e.exist() || !g.x.exist() || !g.y.exist()) {
        continue;
      }

      // before and after Gcode are not G1 (since the E pram can not be calculated) 
      if (i > 0) {
        Gcode pg = null;
        float prevE = 10000;
        for (int j = i-1; j >= 0; j--) {
          if (gcode.get(j).cmd.indexOf("G1")!=-1 || gcode.get(j).cmd.indexOf("G0")!=-1) {
            if (pg == null && gcode.get(j).x.exist() && gcode.get(j).y.exist()) {
              pg = gcode.get(j);
            }
            if (prevE == 10000 && gcode.get(j).e.exist()) {
              prevE = gcode.get(j).e.v;
            }
          }
        }
        
        if(prevE == 10000){
          prevE = previousE;
        }
        if (pg == null || prevE > g.e.v) {
          continue;
        }
        

        // main =========
        PVector CurPos = new PVector(g.x.get(), g.y.get());
        PVector PrevPos = new PVector(pg.x.get(), pg.y.get());


        float distPrevtoCur = dist(CurPos.x, CurPos.y, PrevPos.x, PrevPos.y);
        if (distPrevtoCur > MaxLen) {            
          int divCount = int(distPrevtoCur / MaxLen);

          PVector PrevtoCur = PVector.sub(CurPos, PrevPos);
          
          float PrevtoCurE = g.e.v - prevE;

          for (int j = 1; j < divCount; j++) {


            PVector AddPos = new PVector(PrevPos.x + (PrevtoCur.x/divCount)*j, PrevPos.y + (PrevtoCur.y/divCount)*j);


            Gcode addGcode = new Gcode("G1", AddPos.x, AddPos.y, 1800); // cmd, X, Y, F
            //addGcode.f.flag = false;
            addGcode.e.flag = true;
            addGcode.e.v = prevE + PrevtoCurE / divCount * j;
            addGcode.comment = "; new gcode";


            gcode.add(i + j -1, addGcode);
          }

          i += divCount-1;
        }
      }
    }
  }
}