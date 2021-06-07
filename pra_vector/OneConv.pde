void setup()
{
  size(512, 512);
 
  int x = 382;
  int y = 255;

  PVector pw = new PVector();
  pw.x = map(382, 1, 512,-1,1);
   pw.y = map(255, 1, 512,-1,1);
   pw.z = 0;
  println("(" + x + ", " + y + ") -> " + pw);
}
