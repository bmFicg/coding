//readPixels in with jogl support 

 
import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;

import com.jogamp.opengl.util.GLBuffers;
import java.nio.FloatBuffer;

void setup() {
  size(640, 360, P3D);
  noStroke();
}<

void draw() {
  background(204);
  
  //lights();
  pushMatrix();
  translate(width/2, height/2);
  rotateY(0.52);
  fill(25, 55, 254);
  box(130);
  popMatrix();

  PJOGL pgl = (PJOGL) beginPGL();  
  GL2ES2 gl = pgl.gl.getGL2ES2();
  FloatBuffer  cbuff = GLBuffers.newDirectFloatBuffer(new float[3]);
  gl.glReadPixels(mouseX, mouseY, 1, 1, GL.GL_RGB, GL.GL_FLOAT, cbuff);
  endPGL();

  println(
      "r:"+(cbuff.get(0)*255)
    +" g:"+(cbuff.get(1)*255)
    +" b:"+(cbuff.get(2)*255));
}
