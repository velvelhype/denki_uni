int screenWidth = 600;
int screenHeight=480;

void setup()
{
  size(600, 480);
}

void draw()
{
  background(0, 0, 0);
  stroke(255);
  line(screenWidth/2-5, screenHeight/2, screenWidth/2+5, screenHeight/2);
  line(screenWidth/2, screenHeight/2-5, screenWidth/2, screenHeight/2+5);
}
