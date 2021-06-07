void setup()
{
  size(512, 512);
  background(color(0, 0, 0));

  noSmooth();
  //noLoop();
}

void draw()
{
  float cl_r = 0;
  float cl_g = 0;
  float cl_b = 0;
  //float cl_y = 0;
  for (int y  = 0; y < height; ++y)
  {
    for (int x = 0; x <width; ++x)
    {
      cl_r = map((512 - x), 0, 512, 0, 255);
      cl_g = map(y, 0, 512, 0, 255);
      cl_b = map(x*y, 0, sq(512), 0, 255);
      stroke(color(cl_r, cl_g, cl_b));
      point(x, y);
    }
  }
}
