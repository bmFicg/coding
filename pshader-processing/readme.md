based on a **JOGL** ![tutorial](http://jogamp.org/git/?p=jogl-demos.git;a=blob;f=src/demos/es2/RawGL2ES2demo.java;hb=HEAD)

# RAW

***
```java
import com.jogamp.opengl.*;
import com.jogamp.opengl.GL3;
import com.jogamp.opengl.util.GLBuffers;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer;

int[] vboHandles;
int shaderProgram, vertShader, fragShader,time;
FloatBuffer clearColor = GLBuffers.newDirectFloatBuffer(4);

String vertexShaderString ="#version 150 \n" + 
  "in vec2 aposition; \n" +
  "out vec2 vcolor; \n" + 
  "void main() { \n" +
  "vcolor = aposition; \n" +
  "gl_Position = vec4(aposition.xy,0,1); \n" +
  "} ";
  
String fragmentShaderString ="#version 150 \n" + 
  "in vec2 vcolor; \n" +
  "uniform float time; \n" +
  "out vec4 fragColor; \n" +
  "void main() { \n" + 
  "fragColor = vec4(vcolor,sin(time)*.5+.5,1); \n" +
  "} ";
  
void setup() {
  size(640, 360, P3D);
  PJOGL pgl = (PJOGL) beginPGL();  
  GL3 gl = pgl.gl.getGL3();
  
  vertShader = gl.glCreateShader(GL3.GL_VERTEX_SHADER);
  fragShader = gl.glCreateShader(GL3.GL_FRAGMENT_SHADER);
  
  String[] vlines = new String[] { vertexShaderString };
  IntBuffer vbuf = GLBuffers.newDirectIntBuffer(new int[]{vlines[0].length()});
  gl.glShaderSource(vertShader, 1, vlines, vbuf);
  gl.glCompileShader(vertShader);
  String[] flines = new String[] { fragmentShaderString };
  IntBuffer fbuf = GLBuffers.newDirectIntBuffer(new int[]{flines[0].length()});
  gl.glShaderSource(fragShader, 1, flines, fbuf);
  gl.glCompileShader(fragShader);
  
  int[] compiled = new int[1];
  
  gl.glGetShaderiv(vertShader,GL3.GL_COMPILE_STATUS, compiled,0);
  if(compiled[0]!=0) println("Vertex shader compiled");
  else {
    int[] logLength = new int[1];
    gl.glGetShaderiv(vertShader,GL3.GL_INFO_LOG_LENGTH, logLength, 0);
    byte[] log = new byte[logLength[0]];
    gl.glGetShaderInfoLog(vertShader, logLength[0], (int[])null, 0, log, 0);
    System.err.println("Error compiling the vertex shader: " + new String(log));
    exit();
        }
  gl.glGetShaderiv(fragShader, GL3.GL_COMPILE_STATUS, compiled,0);
  if(compiled[0]!=0) println("Fragment shader compiled");
  else {
     int[] logLength1 = new int[1];
     gl.glGetShaderiv(fragShader,GL3.GL_INFO_LOG_LENGTH, logLength1, 0);
     byte[] log = new byte[logLength1[0]];
     gl.glGetShaderInfoLog(fragShader, logLength1[0], (int[])null, 0, log, 0);
     println("Error compiling the fragment shader: " + new String(log));
     exit();
       }
       
  shaderProgram = gl.glCreateProgram();
  gl.glAttachShader(shaderProgram, vertShader);
  gl.glAttachShader(shaderProgram, fragShader);
  gl.glLinkProgram(shaderProgram);
  
  gl.glBindAttribLocation(shaderProgram, 0, "aposition");
  time =gl.glGetUniformLocation(shaderProgram,"time");
  
  vboHandles = new int[2];
  gl.glGenBuffers(2, vboHandles, 0);
  
  endPGL();
}

void draw() {
  PJOGL  pgl = (PJOGL) beginPGL();  
  GL3 gl = pgl.gl.getGL3();
  
  gl.glClearBufferfv(GL3.GL_COLOR, 0, clearColor.put(0, 0f).put(1, 0f).put(2, 0f).put(3, 0f));
  
  gl.glUseProgram(shaderProgram);
  
  float positions[]={-1,-1,1,-1,1,1,-1,1};
  FloatBuffer vertexBuffer = GLBuffers.newDirectFloatBuffer(positions);
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, vboHandles[1]);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, vertexBuffer.capacity() * Float.BYTES, vertexBuffer, GL3.GL_STATIC_DRAW);
  vertexBuffer = null;
  
  gl.glVertexAttribPointer(0, 2, 0x1406, false, 8, 0);
  gl.glEnableVertexAttribArray(0);
  
  short indx[] = {0, 1, 3, 2};
  ShortBuffer indx_buf = GLBuffers.newDirectShortBuffer(indx);
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, vboHandles[0]);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, indx_buf.capacity() * Short.BYTES, indx_buf, GL3.GL_STATIC_DRAW);
  indx_buf = null;

  gl.glUniform1f(time,millis()*.001f); 
  
  gl.glDrawArrays(PGL.TRIANGLE_FAN, 0, 4);
  
  gl.glDisableVertexAttribArray(0); 
  gl.glDisableVertexAttribArray(1); 
  
  if (keyPressed == true||mousePressed == true) end();
  endPGL();
}

void end() {
  println("cleanup... exit");
  PJOGL pgl = (PJOGL) beginPGL();  
  GL3 gl = pgl.gl.getGL3();
  gl.glUseProgram(0);
  gl.glDeleteBuffers(2, vboHandles, 0);
  vboHandles = null;
  gl.glDetachShader(shaderProgram, vertShader);
  gl.glDeleteShader(vertShader);
  gl.glDetachShader(shaderProgram, fragShader);
  gl.glDeleteShader(fragShader);
  gl.glDeleteProgram(shaderProgram);
  exit();
}  
```
