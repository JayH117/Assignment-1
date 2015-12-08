//library for audio player
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//declaring data
ArrayList<Float> spideyData;

//Audio player data
Minim minim;
AudioPlayer player;
AudioMetaData meta;

PImage img;

int firstYear = 1966;

//controlp5 library
import controlP5.*;
ControlP5 cp5;

float highest;
float border;

void setup()
{
  size(650,650);
  background(0);
  loadData();
  cp5 = new ControlP5(this);
  
  //declarations for cp5 buttons
  cp5.addButton("drawTrendGraph").setValue(1).setPosition(100,20).setSize(80,20).setLabel("Line Graph");
  cp5.addButton("drawScatter").setValue(2).setPosition(200, 20).setSize(80,20).setLabel("Scatter Graph");
  cp5.addButton("drawCircles").setValue(3).setPosition(300, 20).setSize(80,20).setLabel("Circle Graph");
  cp5.addButton("muteMusic").setValue(4).setPosition(400, 20).setSize(80,20).setLabel("Mute Music");
  cp5.addButton("menu").setValue(5).setPosition(500, 20).setSize(80,20).setLabel("Menu");

  //playing audio
  minim = new Minim(this);
  player = minim.loadFile("spidey.mp3", 2048);
  player.loop();
  
  //loading image for menu
  img = loadImage("Spi3.jpg");
  image(img, 0, 0);
  image(img, 0, 0, width, height);
  
  border = 0.1 * width;
  
  //finding highest data value
  highest = spideyData.get(0);
  for (int i = 1 ; i < spideyData.size() ; i ++)
    {
      if (spideyData.get(i) > highest)
      highest = spideyData.get(i);
    }
}

void draw()
{
}

//muting music
void muteMusic()
{
  player.mute();
}

//loading the data
void loadData() {
  
  spideyData = new ArrayList<Float>();
  String[] lines = loadStrings("Spidey.csv"); 
  for(String s:lines)
  {
    float f = Float.parseFloat(s);
    spideyData.add(f);
  }
}

//drawing the axis for scatter graph and line graph
void drawAxis()
{
  stroke(200, 200, 200);
  fill(200, 200, 200);
  int horizontalIntervals = 10;
  int verticalIntervals = 10;
  
  float vertDataRange = highest;

  
  line(border, height - border, width - border, height - border);

  float horizontalWindowRange = (width - (border * 2.0f));
  float horizontalDataGap = spideyData.size() / horizontalIntervals;
  float horizontalWindowGap = horizontalWindowRange / horizontalIntervals;
  float tickSize = border * 0.1f;

  for (int i = 0 ; i <=  horizontalIntervals; i ++)
  {
    
    float x = border + (i * horizontalWindowGap);
    line(x, height - (border - tickSize), x, (height - border));
    float textY = height - (border * 0.5f);

    textAlign(CENTER, CENTER);
    text((int)(firstYear + i*horizontalDataGap) , x, textY);//4.2
  }

  
  line(border, border , border, height - border);

  float verticalDataGap = vertDataRange / verticalIntervals;
  float verticalWindowRange = height - (border * 2.0f);
  float verticalWindowGap = verticalWindowRange / verticalIntervals;
  for (int i = 0 ; i <= verticalIntervals ; i ++)
  {
    float y = (height - border) - (i * verticalWindowGap);
    line(border - tickSize, y, border, y);
    float hAxisLabel = verticalDataGap * i;

    textAlign(RIGHT, CENTER);
    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }
}

//drawing the trend(line) graph
void drawTrendGraph() 
{
  //reseting the background
  background(0);
  drawAxis();
  float maxValue = highest;
  
  stroke(255);
  
  //mapping the data onto the graph
  for (int i = 1 ; i < spideyData.size() ; i ++)
  {
    float x1 = map(i-1, 0, spideyData.size(), border, width - border);
    float x2 = map(i, 0, spideyData.size(), border, width - border);
    float y1 = map(spideyData.get(i-1), 0, maxValue, height - border, border);
    float y2 = map(spideyData.get(i), 0, maxValue, height - border, border);
    line(x1, y1, x2, y2);
  }
}

void drawScatter () 
{
  background(0);
  drawAxis();
  float maxValue = highest;
  stroke(255);
  
  //mapping the data onto the graph
  for (int i = 1 ; i < spideyData.size() ; i ++)
  {
    float x1 = map(i-1, 0, spideyData.size(), border, width - border);
    float x2 = map(i, 0, spideyData.size(), border, width - border);
    float y1 = map(spideyData.get(i-1), 0, maxValue, height - border, border);
    float y2 = map(spideyData.get(i), 0, maxValue, height - border, border);
    ellipse(x1, y1, 5, 5);
  }
}

void drawCircles()
{
  background(0);
  float maxValue = highest;
  stroke(0);
  fill(255,0,0);
  
  //declaring variables needed to rotate the circles as they are drawn
  float theta;
  float radius = 250;
  float cx = width/2;
  float cy = height/2; //centre points
  float x = 0;
  float y = 0;
  text("Spider-man over the years", cx+50, cy); 
  float lastX, lastY;
  
  //drawing circles
  for(int i = 1 ; i < spideyData.size() ; i ++)
  {
    theta = ((TWO_PI)/spideyData.size()* i );
    x = cx + sin(theta) * radius;
    y = cy - cos(theta) * radius;
    fill(0);
    ellipse(x,y, 20, 20);
    lastX = x; 
    lastY = y;
    fill(random(200,255), 0, random(0));
    stroke(random(200,255), 0, random(200, 255));
    ellipse(lastX, lastY, spideyData.get(i) * .0005, spideyData.get(i) * .0005);
    if(i == 1)
    {
      text("First year, 1966", width-20, 50);
    }
    if(i == spideyData.size()-1)
    {
      text("Last Year, 2006", 200, 50);
    }
  }
  
}

//re-drawing the image for the menu
void menu()
{
  image(img, 0, 0);
  image(img, 0, 0, width, height);
}

 
  
