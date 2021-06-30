public class Animator {
  public ArrayList<int[]> parameters = new ArrayList<int[]>();
  public ArrayList<float[]> animations = new ArrayList<float[]>();
  
  public void animate(int frame) {
    for (int i = 0; i < parameters.size(); i++) {
      int[] info = parameters.get(i); //<>//
      if (frame >= info[1] && frame < info[2]) {
        float[] anim = animations.get(i);
        if (info[0] == 0) {
          //Camera 
        } else if (info[0] - 1 < lightList.length) {
          //lights
        } else if (info[0] - 1 - lightList.length < shapeList.length) {
          //shapes
          Matrix matrix = new Matrix();
          Shape shape = shapeList[info[0] - 1 - lightList.length];
          if (anim[0] == 0) {
            Matrix translate = matrix.createTranslate(anim[1],anim[2],anim[3]);
            shape.applyTranslation(translate);
          }
        } else if (info[0] - 1 - lightList.length - shapeList.length < shapeList.length) {
          //materials
        }
      }
    }   
  }
}
