

void setup()
{
  size(512, 512);
  background(color(0, 0, 0));

  noSmooth();
  noLoop();
}

void draw()
{
  PVector eyePos = new PVector(0, 0, -5);
  PVector spherePos = new PVector(0, 0, 5);
  float sphereR = 1.0;
  PVector pw = new PVector();
  pw.z = 0;

  for (int y = 0; y < height; ++y)
  {
    pw.y = map(y, 0, height - 1, 1, -1);
    for (int x = 0; x < width; ++x)
    {
      pw.x = map(x, 0, width - 1, -1, 1);
      PVector eyeDir = PVector.sub(pw, eyePos);
      PVector tmp = PVector.sub(eyePos, spherePos);

      float A = eyeDir.magSq();
      float B = 2*eyeDir.dot(tmp);
      float C = tmp.magSq() - pow(sphereR, 2);
      float D = pow(B, 2) - 4*A*C;

      if (D > 0)
      {
        stroke(color(255, 0, 0));
      }
      else
        stroke(color(255, 255, 255));

      point(x, y);
    }
  }
}
