import  com.jogamp.opengl.GL4;
import com.jogamp.opengl.util.GLBuffers;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

int shaderProgram;
//uniform loc 
int loctime;

int[] vao;

IntBuffer vaobuff = GLBuffers.newDirectIntBuffer(1);

void settings() {
  size(400, 400, P3D);
  PJOGL.profile = 4;
}

void setup() {

  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();

  //create the program object 
  shaderProgram = gl.glCreateProgram();

  //create fragment Shader
  int fragShader = gl.glCreateShader(GL4.GL_FRAGMENT_SHADER);
  gl.glShaderSource(fragShader, 1, 
    new String[]{"#version 420 \n"
    +"out vec4 fragColor;"
    +"void main(void) {"
    +"fragColor = vec4(0.2, 0.2, 0.5, 1.0);"
    +"}"}, null); //no error check
  gl.glCompileShader(fragShader);
  
  //based on: tutorialspoint.com/webgl/webgl_drawing_points.htm
  
  //create vertShader Shader
  int vertShader = gl.glCreateShader(GL4.GL_VERTEX_SHADER);
  gl.glShaderSource(vertShader, 1, 
    new String[]{"#version 420 \n"
    +"uniform float t; \n" 
    +"void main(void){"
    +"vec3 points[3]=vec3[3](vec3(-0.5,0.5*sin(t),0.0),"
                           +"vec3(0.2*cos(t),0.5,0.0),"
                           +"vec3(-0.5*sin(t),0.25,0.0));"
    +"gl_Position = vec4(points[gl_VertexID],1.);"
    +"}"}, null); //no error check
  gl.glCompileShader(vertShader);

  //attach and link
  gl.glAttachShader(shaderProgram, vertShader);
  gl.glAttachShader(shaderProgram, fragShader);
  gl.glLinkProgram(shaderProgram);

  //uniform location
  loctime=gl.glGetUniformLocation(shaderProgram, "t");

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
  gl.glClearBufferfv(GL4.GL_COLOR, 0, GLBuffers.newDirectFloatBuffer(new float[]{sin(frameCount*.01f)*.5f+.5f,cos(frameCount*.01f)*.5f+.5f, 0.0f, 1.0f}));

  gl.glUseProgram(shaderProgram);

  gl.glPointSize(25f);

  gl.glUniform1f(loctime, millis()*.001f); 

  gl.glDrawArrays(GL4.GL_POINTS, 0, 3);

  endPGL();

  if (keyPressed == true||mousePressed == true) end();
}

void end() {
  println("cleanup... exit");
  GL4 gl = ((PJOGL)beginPGL()).gl.getGL4();
  gl.glUseProgram(0);
  gl.glDeleteBuffers(1, vao, 0);
  gl.glDeleteVertexArrays(1, vaobuff);
  gl.glDeleteProgram(shaderProgram);
  endPGL();
  exit();
}
