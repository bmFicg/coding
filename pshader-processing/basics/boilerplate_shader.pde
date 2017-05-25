PShader shdr;

void setup() {
  size(640, 340, P2D);
  
  noStroke();
  rectMode(RADIUS);
  
  shdr=new PShader(this, 
    new String[]{"#version 150 \n"
    + "in vec2 position;"
    + "void main() {"
    + "gl_Position = vec4(position.xy,0.,1.);"
   + "}"  
    }, new String[]{"#version 150 \n"
      + "out vec4 fragColor;"
      + "uniform vec3 iResolution;"
      + "void main() {"
      + "vec2 uvv = (gl_FragCoord.xy*2.-iResolution.xy)/iResolution.z;"
      + "float cir=.2/length(uvv);"
      + "fragColor = vec4(vec3(cir),1.);"
     +"}"
      }){
      PShader run(){
      // 1f fast float cast 
      this.set("iResolution",new PVector(width*1f,height*1f,Math.min(width,height)*1f));
      return this;
      }
    }.run();
    shader(shdr);
    
}

void draw() {
  background(0);
  rect(0,0,width,height);
}
