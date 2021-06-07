PVector eyePos;
ArrayList <Shape> shapes;
ArrayList <LightSource> lightSources;

LightSource lightSource;
FColor ambientInt;
FColor ambInt;

FColor kAmb;
FColor kDif;
FColor kSpe;
float shine;

void setup()
{
  size(312, 312);
  background(color(0, 0, 0));

  eyePos = new PVector(0, 0, -5);
  shapes = new ArrayList<Shape>();

  Sphere sph1 = new Sphere(new PVector(2, 0, 20), 1);
  shapes.add(sph1);
  sph1.material.ambientFactor.set(0.01, 0.01, 0.01);
  sph1.material.diffuseFactor.set(0.19, 0.00, 0.70);
  sph1.material.specularFactor.set(0.30, 0.30, 0.30);
  sph1.material.shininess = 3.0;
  Sphere sph2 = new Sphere(new PVector(1, 0, 15), 1);
  shapes.add(sph2);
  sph2.material.ambientFactor.set(0.01, 0.01, 0.01);
  sph2.material.diffuseFactor.set(0.00, 0.69, 0.00);
  sph2.material.specularFactor.set(0.30, 0.30, 0.30);
  sph2.material.shininess = 8.0;
  Sphere sph3 = new Sphere(new PVector(3, 0, 5), 1);
  shapes.add(sph3);
  sph3.material.ambientFactor.set(0.01, 0.01, 0.01);
  sph3.material.diffuseFactor.set(0.70, 0.69, 0.00);
  sph3.material.specularFactor.set(0.30, 0.30, 0.30);
  sph3.material.shininess = 8.0;
  Sphere sph4 = new Sphere(new PVector(3, 5, 25), 1);
  shapes.add(sph4);
  sph4.material.ambientFactor.set(0.01, 0.41, 0.01);
  sph4.material.diffuseFactor.set(0.70, 0.49, 0.00);
  sph4.material.specularFactor.set(0.30, 0.50, 0.30);
  sph4.material.shininess = 8.0;
  Sphere sph5 = new Sphere(new PVector(-1, 4, 6), 1);
  shapes.add(sph5);
  sph5.material.ambientFactor.set(0.01, 0.01, 0.01);
  sph5.material.diffuseFactor.set(0.20, 1.69, 1.00);
  sph5.material.specularFactor.set(0.00, 0.30, 0.30);
  sph5.material.shininess = 8.0;

  Plane pln = new Plane(new PVector(0, 1, 0), new PVector(0, -1, 0));
  shapes.add(pln);

  lightSources = new ArrayList<LightSource>();
  PointLightSource pls4 = new PointLightSource(new PVector(1000, 5, -5), new FColor(1, 1, 1));
  lightSources.add(pls4);
  PointLightSource pls5 = new PointLightSource(new PVector(-1110, 5, -5), new FColor(1, 1, 1));
  lightSources.add(pls5);
  PointLightSource pls6 = new PointLightSource(new PVector(-1110, 511, -2225), new FColor(1, 1111, 1));
  lightSources.add(pls6);

  ambInt = new FColor(0.1, 0.1, 0.1);
}

void draw()
{ 
  PVector pw = new PVector();
  pw.z = 0;

  for (int y = 0; y <height; ++ y)
  {
    pw.y = map(y, 0, height - 1, 1, -1);
    for (int x = 0; x <width; ++x)
    {
      pw.x = map(x, 0, width - 1, 1, -1);

      stroke(color(100, 130, 10));

      PVector eyeDir = PVector.sub(pw, eyePos);
      Ray eyeRay = new Ray(eyePos, eyeDir);
      IntersectionPoint nearestIntP = null;
      Shape nearestShape = null;
      for (int i = 0; i < shapes.size(); ++i)
      {

        IntersectionPoint res = shapes.get(i).testIntersection(eyeRay);
        if (res != null)
        {
          if (nearestIntP == null || nearestIntP.distance  > res.distance)
          {
            nearestIntP = res;
            nearestShape = shapes.get(i);
          }
        }
      }
      IntersectionPoint  res = nearestIntP;
      if (nearestShape != null)
      {
        kAmb =  nearestShape.material.ambientFactor;
        kDif =  nearestShape.material.diffuseFactor;
        kSpe =  nearestShape.material.specularFactor;
        shine = nearestShape.material.shininess;
      }
      if (res != null)
      {
        FColor col = new FColor(0, 0, 0);
        for (int l = 0; l < lightSources.size(); ++l)
        {
          Lighting ltg = lightSources.get(l).lightingAt(res.position);
          float nlDot = constrain(res.normal.dot(ltg.direction), 0, 1);
          col.add(new FColor (255*constrain(kDif.red*nlDot, 0, 1), 255*constrain(kDif.green*nlDot, 0, 1), 255*constrain(kDif.blue*nlDot, 0, 1)));
          if (nlDot > 0)
          {
            PVector refDir = PVector.sub(PVector.mult(res.normal, 2*nlDot), ltg.direction);
            PVector invEyeDir = PVector.mult(eyeDir, -1);
            invEyeDir.normalize();
            float vrDot = constrain(refDir.dot(invEyeDir), 0, 1);
            col.add(new FColor (255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.green, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1)));
          }
        }
        stroke(col.red, col.green, col.blue);
      }
      point(x, y);
    }
  }
}


//PVector eyePos;
//Shape shape;

//LightSource lightSource;
//FColor ambientIntensity;

//FColor kAmb;
//FColor kDif;
//FColor kSpe;
//float shininess;

//void setup()
//{
//  size(512, 512);
//  background(color(0, 0, 0));

//  noSmooth();
//  noLoop();
//}

//void draw()
//{
//  eyePos = new PVector(0, 0, -5);

//  Sphere sph = new Sphere();
//  sph.center.set(0, 0, 5);
//  sph.radius = 1;
//  shape = sph;

//  PointLightSource pls = new PointLightSource();
//  pls.position.set(0, 0, 5);
//  pls.intensity.set(1.00, 1.00, 1.00);
//  lightSource = pls;

//  ambientIntensity = new FColor(0.10, 0.10, 0.10);

//  kAmb = new FColor(0.01, 0.01, 0.01);
//  //kAmb = new FColor(1000, 1001, 1001);
//  kDif = new FColor(0.69, 0.00, 0.00);
//  kSpe = new FColor(0.30, 0.30, 0.30);
//  shininess = 8;

//  PVector pw = new PVector();
//  pw.z = 0;
//  //Sphere sph = new Sphere(new PVector(0,0,5), 1);

//  for (int y = 0; y < height; ++y)
//  {
//    pw.y = map(y, 0, height - 1, 1, -1);
//    for (int x = 0; x <width; ++x)
//    {
//      pw.x = map(x, 0, width -1, 1, -1);

//      PVector eyeDir = PVector.sub(pw, eyePos);
//      Ray eyeRay = new Ray(eyePos, eyeDir);

//      stroke(color(100, 10, 237));

//      IntersectionPoint res = sph.testIntersection(eyeRay);
//      if (res != null)
//      {
//        FColor col = new FColor(0, 0, 0);
//        //ambientIntensity.mult(kAmb);
//        //col.add(ambientIntensity);

//        Lighting ltg  = pls.lightingAt(res.position);
//        ltg.direction = PVector.sub(pls.position, res.position); 
//        ltg.direction.normalize();
//        res.normal = PVector.sub(res.position, sph.center);
//        res.normal.normalize();
//        float nlDot = constrain((res.normal).dot(ltg.direction), 0, 1);
//        print(res.normal);

//        if (nlDot != 0)
//          print("got \n");

//        //kDif.red *= nlDot;
//        //kDif.blue *= nlDot;
//        //kDif.green *= nlDot;
//        kDif.red *= 1000;
//        kDif.blue *= 1000;
//        kDif.green *= 1000;
//        col.add(kDif);

//        //if(nlDot > 0)
//        //{
//        //  PVector refDir = PVector.sub(PVector.mult(res.normal, 2*nlDot), ltg.direction);
//        //  PVector invEyeDir = PVector.mult(eyeDir, -1);
//        //  invEyeDir.normalize();

//        //  float vrDot = constrain(refDir.dot(invEyeDir),0,1);
//        //  FColor imp = new FColor(100000,100000,100000);
//        //  col.add(imp);
//        //}
//        stroke(color(col.red, col.green, col.blue));
//      }
//      point(x, y);
//    }
//  }
//}
