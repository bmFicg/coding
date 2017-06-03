import  com.jogamp.opengl.GL4;
import com.jogamp.opengl.util.GLBuffers;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

int shaderProgram;
int[] vao;

IntBuffer vaobuff = GLBuffers.newDirectIntBuffer(1);

void settings() {
  size(400, 400, P3D);
  PJOGL.profile = 4;
}

void setup() {
  
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  
  shaderProgram = gl.glCreateProgram();
  
  //create fragment Shader
  int fragShader = gl.glCreateShader(GL4.GL_FRAGMENT_SHADER);
  gl.glShaderSource(fragShader, 1, 
    new String[]{"#version 420 \n"
    +"out vec4 color;"
    +"void main(void) {"
    +"color = vec4(0.2, 0.2, 0.5, 1.0);"
    +"}"}, null); //no error check
  gl.glCompileShader(fragShader);
  
  //create vertShader Shader
  int vertShader = gl.glCreateShader(GL4.GL_VERTEX_SHADER);
  gl.glShaderSource(vertShader, 1, 
    new String[]{"#version 420 \n"
    +"void main(void){"
    +"gl_Position = vec4(0.0, 0.0, 0.0, 1.0);"
    +"}"}, null); //no error check
  gl.glCompileShader(vertShader);
  
  //attach and link
  gl.glAttachShader(shaderProgram, vertShader);
  gl.glAttachShader(shaderProgram, fragShader);
  gl.glLinkProgram(shaderProgram);
  
  //the program should compiled now and we can free the shaders
  gl.glDeleteShader(vertShader);
  gl.glDeleteShader(fragShader);
  
  //create Buffers
  vao = new int[1];
  
  gl.glGenBuffers(1, vao, 0);
  
  gl.glGenVertexArrays(1, vaobuff);
  gl.glBindVertexArray(vao[0]);
  
  endPGL();
}
void draw() {
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  
  //khronos.org/opengl/wiki/GLAPI/glClearBuffer
  gl.glClearBufferfv(GL4.GL_COLOR, 0, 
                     GLBuffers.newDirectFloatBuffer(
                        new float[]{sin(frameCount*.01f)*.5f+.5f, 
                                    cos(frameCount*.01f)*.5f+.5f, 0.0f, 1.0f}));
                                  
  gl.glUseProgram(shaderProgram);
  
  gl.glPointSize(width/2f);
  gl.glDrawArrays(GL4.GL_POINTS, 0, 1);
  
  endPGL();
}

void mousePressed() {
  println("cleanup... exit");
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  gl.glUseProgram(0);
  gl.glDeleteBuffers(1, vao, 0);
  gl.glDeleteVertexArrays(1, vaobuff);
  gl.glDeleteProgram(shaderProgram);
  endPGL();
  exit();
}
