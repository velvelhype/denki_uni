PVector eyePos;
Scene scene;

final float C_SPSILON = 1.0 /512;
final int MAX_RECURSION = 8;

void setup()
{
  size(312, 312);
  background(color(0, 0, 0));

  eyePos = new PVector(0, 0, -5);
  scene = new Scene();

  Sphere sph1 = new Sphere(new PVector(-0.25, -0.5, 3), 0.5);
  sph1.material.ambientFactor.set(1.00, 0.00, 0.00);
  sph1.material.diffuseFactor.set(1.00, 1.00, 0.00);
  sph1.material.specularFactor.set(0.1, 0.01, 0.00);
  sph1.material.shininess = 11.0;
  //sph1.material.usePerfectReflectance = true;
  //sph1.material.catadioptricFactor.set(0, 1, 1);
  scene.shapes.add(sph1);
  
    Sphere sph2 = new Sphere(new PVector(-0.15, -0.3, 3), 1);
  sph2.material.ambientFactor.set(1.00, 0.00, 0.00);
  sph2.material.diffuseFactor.set(1.00, 1.00, 0.00);
  sph2.material.specularFactor.set(0.1, 0.01, 0.00);
  sph2.material.shininess = 11.0;
  //sph1.material.usePerfectReflectance = true;
  //sph1.material.catadioptricFactor.set(0, 1, 1);
  scene.shapes.add(sph2);

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
  print(scene.shapes);
  for (int y = 0; y <height; ++ y)
  {
    pw.y = map(y, 0, height - 1, 1, -1);
    for (int x = 0; x <width; ++x)
    {
      pw.x = map(x, 0, width - 1, 1, -1);

      stroke(color(100, 0, 10));

      PVector eyeDir = PVector.sub(pw, eyePos);
      Ray eyeRay = new Ray(eyePos, eyeDir);
      FColor col = rayTrace(scene, eyeRay);

      if (col != null)
        stroke(col.toColor());
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

    Material mat = shape.material;

    //FColor kAmb =  mat.ambientFactor;
    FColor kDif =  mat.diffuseFactor;
    FColor kSpe =  mat.specularFactor;
    float shine = mat.shininess;

    FColor col = new FColor(0, 0, 0);
    for (PointLightSource light : scene.lightSources)
    {
      PVector sDir =  PVector.sub(light.position, testResult.intersectionPoint.position);
      Ray shadowRay = new Ray(testResult.intersectionPoint.position, sDir);
      shadowRay.start = PVector.add(testResult.intersectionPoint.position, PVector.mult(sDir, C_SPSILON));
      IntersectionTestResult shadowRes = scene.testIntersectionWithAll(shadowRay, sDir.mag(), true);
      if ( shadowRes != null)
        continue;

      Lighting ltg = light.lightingAt(res.position);

      float nlDot = constrain(res.normal.dot(ltg.direction), 0, 1);
      //print(kDif);
      col.add(new FColor (255*constrain(kDif.red*nlDot, 0, 1), 255*constrain(kDif.green*nlDot, 0, 1), 255*constrain(kDif.blue*nlDot, 0, 1)));
      if (nlDot > 0)
      {
        PVector refDir = PVector.sub(PVector.mult(res.normal, 2*nlDot), ltg.direction);
        PVector invEyeDir = PVector.mult(ray.direction, -1);
        invEyeDir.normalize();
        float vrDot = constrain(refDir.dot(invEyeDir), 0, 1);
        col.add(new FColor (255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.green, 0, 1), 255*constrain(pow(vrDot, shine)*kSpe.red, 0, 1)));
        //print(col + "\n");
      }
    }
    return col;
  }
  return null;
}
