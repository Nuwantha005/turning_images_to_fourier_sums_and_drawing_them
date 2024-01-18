import gab.opencv.*;
import peasy.*;

PeasyCam cam;
PImage src, dst;
OpenCV opencv;
int j = 0;
ArrayList<Contour> contours;
ArrayList<PVector> loc ;
float time = 0;
int sample_val = 393;

ArrayList<PVector> path = new ArrayList<PVector>();
FloatList x = new FloatList();
FloatList y = new FloatList();
ArrayList<Circle> fourierY;
ArrayList<Circle> fourierX;

String imgName = "\\images\\cat2.png";

void setup() {
  size(1200, 600, P3D);
  cam = new PeasyCam(this, 1000);
  background(0);
  loc = getPoints(imgName);
  println(loc.size());
  colorMode(HSB);

  for (int i = 0; i < loc.size(); i = i + 3) {
    x.append(loc.get(i).x);
    y.append(loc.get(i).y);

     //x.append(map(loc.get(i).x,0,100,0,500));
     //y.append(map(loc.get(i).y,0,100,0,500));
  }

  fourierX = bubbleSort(dft(x));
  fourierY = bubbleSort(dft(y));
  
  println("No. of Circles: ",fourierX.size());
}

void draw() {
    background(0, 0);
    
    PVector v_x = epiCycle(width/2 + 100, 200, 0, fourierX);
    PVector v_y = epiCycle(100, height/2 + 100, HALF_PI, fourierY);
    PVector vec = new PVector(v_x.x, v_y.y);

    line(v_x.x, v_x.y, vec.x, vec.y);
    line(v_y.x, v_y.y, vec.x, vec.y);

    path.add(vec);
    noFill();
    
    beginShape();
    stroke(90,255,255);
    strokeWeight(3);
    for (int i = 0; i < path.size(); i++) {
        if (i != 0) {
          if (abs((path.get(i).mag()-path.get(i-1).mag()))<20) {
            stroke(90,255,255);
            line(path.get(i).x, path.get(i).y,path.get(i-1).x, path.get(i-1).y);
          }
          
          // if (abs((path.get(i).mag()-path.get(i-1).mag()))>50) {
          //   beginShape();
          //   stroke(255,0,0);
          //   vertex(path.get(i-1).x, path.get(i-1).y);
          //   vertex(path.get(i).x, path.get(i).y);
          //   endShape();
          // } else {
          //   beginShape();
          //   stroke(90,255,255);
          //   vertex(path.get(i-1).x, path.get(i-1).y);
          //   vertex(path.get(i).x, path.get(i).y);
          //   endShape();
          // }
          // if(i<100){
             //println(abs((path.get(i).mag()-path.get(i-1).mag())));
          // }
        }
         //vertex(path.get(i).x, path.get(i).y);
        
    }
    endShape();
    strokeWeight(1);
    float dt = TWO_PI / fourierY.size();
    time += dt;

    if (time > TWO_PI) {
        time = 0;
        path = new ArrayList<PVector>();
        noLoop();
    }
    //delay(1000);
}
