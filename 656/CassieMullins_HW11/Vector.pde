public class Vector {
  public float x, y, z;
  public float r, g, b;
  
  public Vector(float newX, float newY, float newZ) {
    x = newX;
    r = newX;
    y = newY;
    g = newY;
    z = newZ;
    b = newZ;
 }
 
  public Vector(color c) {
    x = red(c);
    y = green(c);
    z = blue(c);
    r = x;
    g = y;
    b = z;
 }
 
 
 public Vector(float newX, float newY) {
    x = newX;
    r = newX;
    y = newY;
    g = newY;
    z = 0;
    b = 0;
 }
 
 public Vector ElemMult(Vector v) {
   return new Vector(x * v.x, y *v.y, z *v.z);
 }
 
 public Vector Mult(float s) {
   return new Vector(x * s, y * s, z * s);
 }
 
  public Vector Mult(Vector v) {
   return new Vector(x * v.x, y * v.y, z * v.z);
 }
 
 public Vector Sub(Vector v) {
   return new Vector(x - v.x, y - v.y, z - v.z);
 }
 
 public Vector Add(Vector v) {
   return new Vector(x + v.x, y + v.y, z + v.z);
 }  
 
 public float Mag() {
   return (float) Math.sqrt(x*x + y*y + z*z);
 }
 
 public Vector Div(float s) {
   return new Vector(x/s, y/s, z/s); 
 }
 
 public float Dot(Vector v) {
   return x*v.x + y*v.y + z*v.z; 
 }
 
 public Vector Cross(Vector v) {
   return new Vector(y*v.z -z*v.y, z*v.x - x*v.z, x*v.y - y*v.x);
 }
 
 public void Normalize() {
   float magnitude = Mag();
   if (magnitude != 0) {
     x = x/magnitude;
     y = y/magnitude;
     z = z/magnitude;
     r = x;
     g = y;
     b = z;
   }
 }
 
 public float Dist(Vector v) {
   return (float) Math.sqrt(Math.pow(x - v.x, 2) + Math.pow(y - v.y, 2) + Math.pow(z - v.z, 2));
 }
 
 public color Color() {
    return color(r,g,b);
  }
  
  public String toString() {
    return x + " " + y + " " + z;
  }
}
