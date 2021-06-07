void setup()
{
  size(401, 401);
  strokeWeight(10);
  background(color(0, 0, 0));
}



void draw()
{
  int xs = 200, ys = 200;
  stroke(color(100, 100, 100));
  point(xs, ys);
  float xw = map(xs, 0, width-1, -1, 1);
  float yw = map(ys, 0, height - 1, -1, 1);
  float zw = 0;
  print(xw);
  print("\n");
  print(yw);
  print("\n");
  print(zw);
  print("\n");
}
