PVector eyePos = new PVector(0, 0, -5);
PVector spherePos = new PVector(0, 0, 5);
float sphereR = 1.0;
PVector lightPos = new PVector(-5, 5, -5);

void setup()
{
  size(500, 500);

  noSmooth();
  noLoop();
}

void draw()
{
  float EL = 0.01 * 10000;
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

      float t = -1;
      if (D == 0)
      {
        t = -B / (2*A);
      } else if (D > 0)
      {
        float t1 = (-B - sqrt(D))/(2*A);
        float t2 = (-B + sqrt(D))/(2*A);

        t = t1 > 0 && t2 > 0 ? min(t1, t2) : max(t1, t2);
      }

      stroke(color(255, 255, 255));
      if (t > 0)
      {
        PVector intPos = PVector.add(eyePos, PVector.mult(eyeDir, t));
        print(intPos + "\n");
        PVector lightDir = PVector.sub(lightPos, intPos); 
        //print(lightDir + "\n");
        lightDir.normalize();
        PVector sphereN = PVector.sub(intPos, spherePos);
        sphereN.normalize();
        float nlDot = constrain(sphereN.dot(lightDir), 0, 1);
 
        
        float radianceAmb = EL;
        //float radianceDif = ;
        float radianceSpe = 0.0f;
        //if(nlDot > 0)
        //{
        //  PVector refDir = ;
        //  PVector invEyeDir = ;
        //  invEyeDir.normalize;
          
        //  float vrDot = constrain(refDir.dot(invEyedDir),0,1);
        //  radianceSpe = ;
        //}
        
        //float radiance = constrain(,0,1);
        int gray = (int)(0.69 * 255 * nlDot);
        stroke(color(gray, gray, gray));
      } 
      point(x, y);
    }
  }
}
