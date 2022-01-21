//========================================
/* Copyright (C) 2020 - Matteo Vinci */
//========================================

PImage input;
int w, h;
PImage output;
float threshold;
float tune = 0;
boolean pressed = false;
int[] grads = {0,64,192,255};  //setting gradations (the same number as palette elements)
color[] palette = {#142850, #27496D, #0C7B93, #00A8CC};  //setting palette (darker to brighter)

void setup() {
  size(1,1);
  input = loadImage("forest.jpg");  //load the image
  w = input.width; h = input.height;
  output = createImage(w, h, RGB);
  //Resize canvas
  surface.setResizable(true);
  surface.setSize(w, h);
  //Load pixels array
  input.loadPixels();
  output.loadPixels();
  
}

void draw() {
  float mapMouseX = map(mouseX, 0, width, 0, 255);
  //Setting tune ON/OFF
  if(pressed){
    float mapMouseY = map(mouseY, 0, height, 0, 255);
    tune = mapMouseY;
  }
  else {tune = 0;}
  
  applyColors(mapMouseX, tune);
  image(output,0,0);
  
}

void applyColors(float tIn, float tuned){
  for(int y = 0; y < input.height; y++){
    for(int x = 0; x < input.width; x++){
      int pos = x + (y * input.width);
      
      color col = color(input.pixels[pos]);  //taking current pixel
      /*
      //Isolating color components
      int redIn = (col >> 16) & 0xFF;
      int greenIn = (col >> 8) & 0xFF;
      int blueIn = col & 0xFF;
      float lum = redIn * 0.2126 + greenIn * 0.7152 + blueIn * 0.0722;
      */
      float bright = brightness(col);
      
      for(int i = 0; i < grads.length; i++){
        float thresholdFactor = abs(bright - grads[i]);
        threshold = tIn;  //keep threshold variable up to date with mouse movements
        if(thresholdFactor < threshold){
          threshold = thresholdFactor;
          int memo = i;  //store the case
          
          //Apply changes
          switch(memo){
            case 0 :
              output.pixels[pos] = palette[0] + int(tuned);
              break;
            case 1 :
              output.pixels[pos] = palette[1] + int(tuned);
              break;
            case 2 :
              output.pixels[pos] = palette[2] + int(tuned);
              break;
            case 3 :
              output.pixels[pos] = palette[3] + int(tuned);
              break;
          }
        }
      }
    }
  }
  output.updatePixels();
}

void mouseClicked(){
  pressed = !pressed;
}

void keyPressed(){
  if(key == 's' || key == 'S'){
    output.save("colored.tif");
  }
}
