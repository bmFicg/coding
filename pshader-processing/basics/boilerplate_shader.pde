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
      + "uniform vec3 sResolution;"
      + "void main() {"
      + "vec2 p = gl_FragCoord.xy/sResolution.xy;"
      + "fragColor = vec4(vec3(p.x>=p.y),1.);"
     +"}"
      }){
      PShader run(){
      // xy. *.1f fake float cast 
      this.set("sResolution",new PVector(width*.1f,height*.1f,/*aspect ratio*/(width/height)*.1f));
      return this;
      }
    }.run();
    
   shader(shdr);
   
}

void draw(){
  background(0);
  rect(0,0,width,height);
}
