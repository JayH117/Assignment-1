import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


ArrayList<ArrayList<Float>> spideyData;

int firstYear = 1966;

Minim minim;
AudioPlayer player;
AudioMetaData meta;

PImage img;
void setup()
{
  minim = new Minim(this);
  player = minim.loadFile("spidey.mp3", 2048);
  player.loop();
  
  img = loadImage("Spi3.jpg");
  size(600,600);
  background(0);

  float border = 0.1 * width;
  loadspideyData();
}

void draw()
{
  image(img, 0, 0);
  image(img, 0, 0, width, height);
}

void loadspideyData() 
{
  spideyData = new ArrayList<ArrayList<Float>>();
  String[] lines = loadStrings("Spidey.csv");
  for (String s : lines) {
    
    ArrayList<Float> v = new ArrayList<Float>();
    String[] values = s.split(",");
    for (int i = 1; i<values.length ; i++) 
    {
      float f = Float.parseFloat(values[i]);
      v.add(f);
    }
    spideyData.add(v);
  }

  println(spideyData);
}
