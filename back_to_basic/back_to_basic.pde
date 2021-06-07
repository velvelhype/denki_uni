PVector eyePos;
Scene scene;

final float C_SPSILON = 1.0 /512;
final int MAX_RECURSION = 8;

void setup()
{
  size(312, 312);
  background(color(0, 0, 0));

  noSmooth();
  noLoop();

  eyePos = new PVector(0, 0, -5);
  scene = new Scene();

  Sphere sph1 = new Sphere(new PVector(-0.25, -0.5, 3), 0.5);
  sph1.material.ambientFactor.set(0.00, 0.00, 0.00);
  sph1.material.diffuseFactor.set(1, 0.20, 0.10);
  sph1.material.specularFactor.set(0.00, 0.00, 0.00);
  sph1.material.shininess = 1.0;
  sph1.material.usePerfectReflectance = true;
  sph1.material.catadioptricFactor.set(0, 1, 1);
  scene.shapes.add(sph1);

  Plane pln1 = new Plane(new PVector(0, 1, 0), new PVector(0, -1, 0));
  scene.shapes.add(pln1);


  PointLightSource pls1 = new PointLightSource();
  pls1.position.set(0, 0.9, 2.5);
  pls1.intensity.set(0.1, 0.1, 0.1);
  scene.lightSources.add(pls1);
  scene.ambientIntensity = new FColor(0.1, 0.1, 0.1);
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

      PVector eyeDir = PVector.sub(pw, eyePos);
      Ray eyeRay = new Ray(eyePos, eyeDir);

      stroke(color(100, 130, 10));
      FColor col = rayTrace(scene, eyeRay);

      if (col != null)
      {
        stroke(col.toColor());
      }
      point(x, y);
    }
  }
}

FColor rayTrace(Scene scene, Ray ray)
{
  IntersectionTestResult testResult = scene.testIntersectionWithAll(ray);
  if (testResult != null)
  {
    Shape shape = testResult.shape;
    IntersectionPoint res = testResult.intersectionPoint;

    //Material mat = shape.material;
    Material mat = shape.material;

    FColor kAmb =  mat.ambientFactor;
    FColor kDif =  mat.diffuseFactor;
    FColor kSpe =  mat.specularFactor;
    float shine = shape.material.shininess;

    FColor col = new FColor(0, 0, 0);
    for (PointLightSource light : scene.lightSources)
    {
      Lighting ltg = light.lightingAt(res.position);
      float nlDot = constrain(res.normal.dot(ltg.direction), 0, 1);
      print(nlDot+"\n");
      col.add(new FColor (255*constrain(kDif.red*nlDot, 0, 1), 255*constrain(kDif.green*nlDot, 0, 1), 255*constrain(kDif.blue*nlDot, 0, 1)));
      if (nlDot > 0)
      {
        PVector refDir = PVector.sub(PVector.mult(res.normal, 2*nlDot), ltg.direction);
        PVector invEyeDir = PVector.mult(ray.direction, -1);
        invEyeDir.normalize();
        float vrDot = constrain(refDir.dot(invEyeDir), 0, 1);
        col.add(new FColor (255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.green, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1)));
      }
    }
    return col;
  }
  return null;
}

//FColor rayTraceRecursive(Scene scene, Ray ray, int recursionLevel)
//{
//  if (recursionLevel < MAX_RECURSION )
//    return null;

//  PVector eyeDir = ray.start;
//  Ray eyeRay = new Ray(eyePos, eyeDir);
//  IntersectionTestResult testResult = scene.testIntersectionWithAll(eyeRay);

//  if ( testResult != null )
//  {
//    print("its in");
//    Shape shape = testResult.shape;
//    IntersectionPoint res = testResult.intersectionPoint;

//    FColor kAmb = testResult.shape.material.ambientFactor;
//    FColor kDif =  testResult.shape.material.diffuseFactor;
//    FColor kSpe =  testResult.shape.material.specularFactor;
//    float shine =testResult.shape.material.shininess;

//    Material mat = shape.material;

//    FColor col = new FColor(0, 0, 0);

//    for (PointLightSource light : scene.lightSources)
//    {
//      PVector sDir =  PVector.sub(light.position, testResult.intersectionPoint.position);
//      Ray shadowRay = new Ray(testResult.intersectionPoint.position, sDir);
//      shadowRay.start = PVector.add(testResult.intersectionPoint.position, PVector.mult(sDir, C_SPSILON));
//      IntersectionTestResult shadowRes = scene.testIntersectionWithAll(shadowRay, sDir.mag(), true);
//      if ( shadowRes != null)
//        continue;

//      Lighting ltg = light.lightingAt(res.position);
//      float nlDot = constrain(res.normal.dot(ltg.direction), 0, 1);
//      col.add(new FColor (255*constrain(kDif.red*nlDot, 0, 1), 255*constrain(kDif.green*nlDot, 0, 1), 255*constrain(kDif.blue*nlDot, 0, 1)));
//      if (nlDot > 0)
//      {
//        PVector refDir = PVector.sub(PVector.mult(res.normal, 2*nlDot), ltg.direction);
//        PVector invEyeDir = PVector.mult(eyeDir, -1);
//        invEyeDir.normalize();
//        float vrDot = constrain(refDir.dot(invEyeDir), 0, 1);
//        col.add(new FColor (255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.green, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1)));
//      }
//    }
//    if (mat.usePerfectReflectance == true)
//    {
//      PVector invEyeDir = eyeDir.mult(-1);
//      invEyeDir.normalize();

//      float vnDot = invEyeDir.dot(res.normal);
//      if (vnDot > 0)
//      {
//        PVector reDir = PVector.sub(PVector.mult(res.normal, 2*vnDot), invEyeDir);
//        Ray reRay = new Ray(res.position, reDir);
//        reRay.start = PVector.add(res.position, PVector.mult(reDir, C_SPSILON));
//        FColor reCol = rayTrace(scene, reRay);
//        if (reCol != null)
//          col.add(reCol);
//      }
//    }
//    return col;
//  }
//  return null;
//}


//FColor rayTrace(Scene scene, Ray ray)
//{
//  return rayTraceRecursive(scene, ray, 0);
//}
