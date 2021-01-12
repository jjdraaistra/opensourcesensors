
import java.awt.Font;
import ketai.sensors.*;
KetaiSensor sensor;
PVector magneticField, accelerometer;
float light, proximity;
KetaiAudioInput mic;
short[] data;
float rotationX, rotationY, rotationZ;
float roll, pitch, yaw;

ArrayList<PVector> points = new ArrayList<PVector>();  //(1)
PFont Akzidenz;
boolean ecrire = false;
void setup()
{
  Akzidenz = createFont("Akzidenz-grotesk-bold.ttf", width/10);
  sensor = new KetaiSensor(this);
  sensor.start();
  sensor.list();
  accelerometer = new PVector();
  magneticField = new PVector();
  orientation(LANDSCAPE);
  mic = new KetaiAudioInput(this);
  size(displayWidth, displayHeight, P3D);
  fill(255, 0, 0);
  textSize(48);

  noStroke();
  int sections = 3600;  //(2)

  for (int i=0; i<=sections; i++)  //(3)
  {
    pushMatrix();  //(4)
    rotateZ(radians(map(i, 0, sections, 0, 360)));  //(5)
    pushMatrix();  //(6)
    translate(width/2, 0, 0);  //(7)
    pushMatrix();  //(8)
    rotateY(radians(map(i, 0, sections, 0, 180)));  //(9)
    points.add(
      new PVector(modelX(0, 0, 100), modelY(0, 0, 100), modelZ(0, 0, 100))  //(10)
    );
    points.add(
      new PVector(modelX(0, 0, -100), modelY(0, 0, -100), modelZ(0, 0, -100))  //(11)
    );
    popMatrix();
    popMatrix();
    popMatrix();
  }
}

void draw() {
  
    if (proximity == 0 ) {
    background(255,0,0);
    }
    else {
      background(0);
      fill(255, 255, 255);
 
    textAlign(CENTER);
    textFont(Akzidenz);
       textSize(120);
    text("LIGHT", width/2, height/2);
    }
if (light > 100 ) {
       background(#EFEFEF);
     fill(255, 255, 255);
 
    textAlign(CENTER);
    textFont(Akzidenz);
       textSize(120);
    text("LIGHT", width/2, height/2);

  } 
  else {
   
    fill(255, 255, 255);
    textAlign(CENTER);

     textFont(Akzidenz);
         textSize(120);
    text("THERE IS NO LIGHT", width/2, height/2); 
   
  }

  String micCheck;
  if (mic.isActive()) {
    micCheck = "READING MIC";
  } else {
    micCheck = "NOT READING MIC";
  }

  rectMode(LEFT);
  textAlign(LEFT);
  textSize(40);
  text("Accelerometer :" + "\n" 
    + "x: " + nfp(accelerometer.x, 1, 2) + "\n" 
    + "y: " + nfp(accelerometer.y, 1, 2) + "\n" 
    + "z: " + nfp(accelerometer.z, 1, 2) + "\n"
    + "MagneticField :" + "\n" 
    + "x: " + nfp(magneticField.x, 1, 2) + "\n"
    + "y: " + nfp(magneticField.y, 1, 2) + "\n" 
    + "z: " + nfp(magneticField.z, 1, 2) + "\n"
    + "Light Sensor : " + light + "\n" 
    + "Proximity Sensor : " + proximity + "\n"
    + micCheck, 20, 0, width, height);


  if (data != null)
  {  
    for (int i = 0; i < data.length; i++) {
      int afstand = int(i * 1.7);

      if (i != data.length-1)
        line(afstand, map(data[i], -30000, 32767, height, 0), afstand+1, map(data[i+1], -30000, 32767, height, 0));
        strokeWeight(4);
    }
  }

  rectMode(CENTER);
  stroke(255);
  strokeWeight(4);
  noFill();
  rect(width/2, height/2, map(accelerometer.x, -5, +5, width/4, width-(width/4)), map(accelerometer.y, -5, +5, height/4, height-(height/4)) );

ambientLight(0, 0, 128);  //(12)
  pointLight(255, 255, 255, 0, 0, 0);  //(13)

  pitch += rotationX;  //(14)
  roll += rotationY;  //(15)
  yaw += rotationZ;  //(16)

  translate(width/2, height/2, 0);
  rotateX(pitch);
  rotateY(-roll);
  rotateZ(yaw);

noFill();
box(600);

  if (frameCount % 100 == 0)
    println(frameRate);
}

void onGyroscopeEvent(float x, float y, float z)  //(19)
{
  rotationX = radians(x);  
  rotationY = radians(y);
  rotationZ = radians(z); 
}



void onAccelerometerEvent(float x, float y, float z, long time, int accuracy)
{
  accelerometer.set(x, y, z);
}

void onMagneticFieldEvent(float x, float y, float z, long time, int accuracy)
{
  magneticField.set(x, y, z);
}

void onLightEvent(float v)
{
  light = v;
}

void onProximityEvent(float v)
{
  proximity = v;
}

void onAudioEvent(short[] _data)
{
  data= _data;
}

void mousePressed()
{
  mic.start();
  sensor.start();
}
