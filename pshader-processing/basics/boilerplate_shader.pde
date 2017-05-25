PShader shdr;

void setup() {
  size(640, 360, P3D);
  
  /*noLights();
  noSmooth();
  noStroke();
  rectMode(RADIUS);
  noLoop();*/
  
  shdr=new PShader(this, 
    new String[]{"#version 150 \n"
    + "in vec4 position;"
    + "void main() {"
    + "gl_Position = vec4(position.xy,0.,1.);"
   + "}"  
    }, new String[]{"#version 150 \n"
      + "out vec4 fragColor;"
      + "uniform vec3 reso;"
      + "void main() {"
      + "vec2 p = gl_FragCoord.xy/reso.xy;"
      + "fragColor = vec4(vec3(p.x>=p.y),1.);"
     +"}"
      }){
      PShader run(){
      //  
      this.set("reso",new PVector(width*.1f,height*.1f,0));
      return this;
      }
    }.run();
    
   shader(shdr);
   
}

void draw(){
  background(0);
  rect(0,0,width,height);
}
