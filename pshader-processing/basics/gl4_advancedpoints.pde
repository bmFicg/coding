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

  GL4 gl4 = ((PJOGL)beginPGL()).gl.getGL4();

  //create the program object 
  shaderProgram = gl4.glCreateProgram();

  //create fragment Shader
  int fragShader = gl4.glCreateShader(GL4.GL_FRAGMENT_SHADER);
  gl4.glShaderSource(fragShader, 1, 
    new String[]{"#version 420 \n"
    +"out vec4 fragColor;"
    +"void main(void) {"
    +"fragColor = vec4(0.2, 0.2, 0.5, 1.0);"
    +"}"}, null); //no error check
  gl4.glCompileShader(fragShader);
  
  //based on: tutorialspoint.com/webgl/webgl_drawing_points.htm
  
  //create vertShader Shader
  int vertShader = gl4.glCreateShader(GL4.GL_VERTEX_SHADER);
  gl4.glShaderSource(vertShader, 1, 
    new String[]{"#version 420 \n"
    +"uniform float t; \n" 
    +"void main(void){"
    +"vec3 points[3]=vec3[3](vec3(-0.5,0.5*sin(t),0.0),"
                           +"vec3(0.2*cos(t),0.5,0.0),"
                           +"vec3(-0.5*sin(t),0.25,0.0));"
    +"gl_Position = vec4(points[gl_VertexID],1.);"
    +"}"}, null); //no error check
  gl4.glCompileShader(vertShader);

  //attach and link
  gl4.glAttachShader(shaderProgram, vertShader);
  gl4.glAttachShader(shaderProgram, fragShader);
  gl4.glLinkProgram(shaderProgram);

  //uniform location
  loctime=gl4.glGetUniformLocation(shaderProgram, "t");

  //program compiled and we can free the shaders
  gl4.glDeleteShader(vertShader);
  gl4.glDeleteShader(fragShader);

  //create Buffers
  vao = new int[1];

  gl4.glGenBuffers(1, vao, 0);

  gl4.glGenVertexArrays(1, vaobuff);
  gl4.glBindVertexArray(vao[0]);

  endPGL();
}
void draw() {
  GL4 gl4 = ((PJOGL)beginPGL()).gl.getGL4();

  //khronos.org/opengl/wiki/GLAPI/glClearBuffer
  gl4.glClearBufferfv(GL4.GL_COLOR, 0, GLBuffers.newDirectFloatBuffer(new float[]{sin(frameCount*.01f)*.5f+.5f,cos(frameCount*.01f)*.5f+.5f, 0.0f, 1.0f}));

  gl4.glUseProgram(shaderProgram);

  gl4.glPointSize(25f);

  gl4.glUniform1f(loctime, millis()*.001f); 

  gl4.glDrawArrays(GL4.GL_POINTS, 0, 3);
 
  //click on an area outside will exit the scetch 
  if(!focused){
    println("cleanup... exit");
    gl4.glUseProgram(0);
    gl4.glDeleteBuffers(1, vao, 0);
    gl4.glDeleteVertexArrays(1, vaobuff);
    gl4.glDeleteProgram(shaderProgram);
    exit();
  }
  endPGL();
}
