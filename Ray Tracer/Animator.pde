public class Animator {
  public ArrayList<int[]> parameters = new ArrayList<int[]>();
  public ArrayList<float[]> animations = new ArrayList<float[]>();
  //0 - Translate, 1 - Scale, 2 - RotateX, 3 - RotateY, 4 - RotateZ, 5 - RotateVupX, 6 - RotateVupY, 7 - RotateVupZ, 8 - Lens Size, 9 - Spotlight Size, 10 - light color, 11 - dark color, 12 - specular color, 13 - Ks, 14 - P, 15 - Krefl, 16 - Krefr, 17 - N
  
  public void animate(int frame) {
    for (int i = 0; i < parameters.size(); i++) { //<>// //<>//
      int[] info = parameters.get(i);
      if (frame >= info[1] && frame < info[2]) {
        float[] anim = animations.get(i);
        if (info[0] == 0) {
          //Camera 
          Matrix matrix = new Matrix();
          if (anim[0] == 0) {
            Matrix translate = matrix.createTranslate(anim[1],anim[2],anim[3]);
            Pe = translate.applyMatrixTransform(Pe);
          } else if (anim[0] == 2) {
            Matrix rotate = matrix.createRotateX(anim[1]);
            Vview = rotate.applyMatrixTransform(Vview);
          } else if (anim[0] == 3) {
            Matrix rotate = matrix.createRotateY(anim[1]);
            Vview = rotate.applyMatrixTransform(Vview);
          } else if (anim[0] == 4) {
            Matrix rotate = matrix.createRotateZ(anim[1]);
            Vview = rotate.applyMatrixTransform(Vview);
          } else if (anim[0] == 5) {
            Matrix rotate = matrix.createRotateX(anim[1]);
            Vup = rotate.applyMatrixTransform(Vup);
          } else if (anim[0] == 6) {
            Matrix rotate = matrix.createRotateY(anim[1]);
            Vup = rotate.applyMatrixTransform(Vup);
          } else if (anim[0] == 7) {
            Matrix rotate = matrix.createRotateZ(anim[1]);
            Vup = rotate.applyMatrixTransform(Vup);
          } else if (anim[0] == 8) {
            lensSize += anim[1];
          }  
          n0 = Vview.Cross(Vup);
          n0.Normalize();  
          
          n2 = Vview;
          n2.Normalize();
          
          n1 = n0.Cross(n2);
          
          Vector Pc = Pe.Add(n2.Mult(d));
          P00 = Pc.Sub((n0.Mult(s0).Add(n1.Mult(s1))).Div(2));
        } else if (info[0] - 1 < lightList.length) {
          //lights
          Matrix matrix = new Matrix();
          Light light = lightList[info[0] - 1];
          if (anim[0] == 0) {
            Matrix translate = matrix.createTranslate(anim[1],anim[2],anim[3]);
            light.applyTranslation(translate);
          } else if (anim[0] == 2) {
            Matrix rotate = matrix.createRotateX(anim[1]);
            light.applyRotation(rotate);
          } else if (anim[0] == 3) {
            Matrix rotate = matrix.createRotateY(anim[1]);
            light.applyRotation(rotate);
          } else if (anim[0] == 4) {
            Matrix rotate = matrix.createRotateZ(anim[1]);
            light.applyRotation(rotate);
          } else if (anim[0] == 9) {
            light.E += anim[1];
          } else if (anim[0] == 10) {
            float newR = light.Cl.r + anim[1];
            float newG = light.Cl.g + anim[2];
            float newB = light.Cl.b + anim[3];
            newR = newR > 0 ? newR < 1 ? newR : 1 : 0;
            newG = newG > 0 ? newG < 1 ? newG : 1 : 0;
            newB = newB > 0 ? newB < 1 ? newB : 1 : 0;
            light.Cl = new Vector(newR, newG, newB);
          }
        } else if (info[0] - 1 - lightList.length < shapeList.length) {
          //shapes
          Matrix matrix = new Matrix();
          Shape shape = shapeList[info[0] - 1 - lightList.length];
          if (anim[0] == 0) {
            Matrix translate = matrix.createTranslate(anim[1],anim[2],anim[3]);
            shape.applyTranslation(translate);
          } else if (anim[0] == 1) {
            Matrix scale = matrix.createScale(anim[1],anim[2],anim[3]);
            shape.applyScale(scale);
          } else if (anim[0] == 2) {
            Matrix rotate = matrix.createRotateX(anim[1]);
            shape.applyRotate(rotate);
          } else if (anim[0] == 3) {
            Matrix rotate = matrix.createRotateY(anim[1]);
            shape.applyRotate(rotate);
          } else if (anim[0] == 4) {
            Matrix rotate = matrix.createRotateZ(anim[1]);
            shape.applyRotate(rotate);
          }
        } else if (info[0] - 1 - lightList.length - shapeList.length < matList.length) {
          //materials //<>// //<>//
          Material mat = matList[info[0] - 1 - lightList.length - shapeList.length];
          if (anim[0] == 10) {
            mat.animateColor(new Vector(anim[1], anim[2], anim[3]), 1);
          } else if (anim[0] == 11) {
            mat.animateColor(new Vector(anim[1], anim[2], anim[3]), 0);
          } else if (anim[0] == 12) {
            mat.animateColor(new Vector(anim[1], anim[2], anim[3]), 2);
          } else if (anim[0] == 13) {
            mat.Ks += anim[1];
            mat.Ks = mat.Ks < 0 ? mat.Ks = 0 : mat.Ks > 1 ? mat.Ks = 1 : mat.Ks;
          } else if (anim[0] == 14) {
            mat.P += anim[1];
          } else if (anim[0] == 15) {
            mat.Krefl += anim[1];
            mat.Krefl = mat.Krefl < 0 ? mat.Krefl = 0 : mat.Krefl > 1 ? mat.Krefl = 1 : mat.Krefl;
          } else if (anim[0] == 16) {
            mat.Krefr += anim[1];
            mat.Krefr = mat.Krefr < 0 ? mat.Krefr = 0 : mat.Krefr > 1 ? mat.Krefr = 1 : mat.Krefr;
          } else if (anim[0] == 17) {
             mat.animateColor(new Vector(anim[1], anim[2], anim[3]), 3);
          }
        }
      }
    }   
  }
}
