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
