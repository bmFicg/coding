//running into a bug on nvidia i see a gl_point_smooth

import com.jogamp.opengl.util.GLBuffers;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL4;

int shaderProgram;
//uniform loc 
int loctime;

int[] vao;
IntBuffer vaobuff = GLBuffers.newDirectIntBuffer(1);

void settings() {
  size(640, 360, P3D);
  PJOGL.profile = 4;
}
void setup() {
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  shaderProgram = gl.glCreateProgram();
  
  //create fragment Shader
  int fragShader = gl.glCreateShader(GL4.GL_FRAGMENT_SHADER);
  gl.glShaderSource(fragShader, 1, 
    new String[]{"#version 420 \n"
    +"out vec4 fragColor;"
    +"void main(void) {"
    +"fragColor = vec4(0.2, 0.2, 0.5, 1.0);"
    +"}"}, null);
  gl.glCompileShader(fragShader);

  //create vertShader Shader
  int vertShader = gl.glCreateShader(GL4.GL_VERTEX_SHADER);
  gl.glShaderSource(vertShader, 1, 
    new String[]{"#version 420 \n"
    +"void main(void){"
    +"gl_Position = vec4(0.0,0.5,0.0,1.0);"
    +"}"}, null);
  gl.glCompileShader(vertShader);

  //attach and link
  gl.glAttachShader(shaderProgram, vertShader);
  gl.glAttachShader(shaderProgram, fragShader);
  gl.glLinkProgram(shaderProgram);

  //program compiled free the shaders
  gl.glDeleteShader(vertShader);
  gl.glDeleteShader(fragShader);

  //create Buffers
  vao = new int[1];
  gl.glGenBuffers(1, vao, 0);
  gl.glGenVertexArrays(1, vaobuff);
  gl.glBindVertexArray(vao[0]);

  endPGL();
}
FloatBuffer clearcolor = GLBuffers.newDirectFloatBuffer(4);

void draw() {
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  gl.glClearBufferfv(GL4.GL_COLOR, 0, clearcolor.put(0, 1f).put(1, 0f).put(2, 0f).put(3, 1f));
  gl.glUseProgram(shaderProgram);
  gl.glPointSize(40f);
  gl.glDrawArrays(GL4.GL_POINTS, 0, 1);

  if (!focused) {
    println("cleanup... exit");
    gl.glUseProgram(0);
    gl.glDeleteBuffers(1, vao, 0);
    gl.glDeleteVertexArrays(1, vaobuff);
    gl.glDeleteProgram(shaderProgram);
    exit();
  }
  endPGL();
}
