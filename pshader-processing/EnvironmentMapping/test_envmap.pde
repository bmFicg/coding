//test scetch i made for testing
//
//vertex pre multiplication done by processing 
//forum.processing.org/two/discussion/11186/edit-stroke-position-and-stroke-color-of-a-pshape-using-shader
 
PShader bgShader, bunnyShader;
 
PMatrix3D rotY=new PMatrix3D();
PMatrix3D model = new PMatrix3D();
PMatrix3D modelview = new PMatrix3D(); 
 
float x =0;
 
void setup(){
  size(856,480,P3D);
 
 modelview=((PGraphicsOpenGL)g).modelview;
 
 //Shader for Environment Mapping
  bgShader=new PShader(this, 
    new String[]{"#version 150  \n"
    + "in vec4 position; "
    + "uniform mat4 Ry,view;"
    + "out vec4 refDir;"
    + "void main() {"
    + "gl_Position = vec4(position.xy,.0, 1.);"
 
    //for reasons for taste i apply the rotation matrix first
    + "refDir =Ry*view*vec4(position.xy,1.,0);"
   + "}"
    }, new String[] {"#version 150  \n"
      + "in vec4 refDir;"
      + "uniform sampler2D envmap;"
      + "out vec4 fragColor;"
      + "const float PI ="+(double)PI+";"
      + "void main () {"
       //reindelsoftware.com/Documents/Mapping/Mapping.html
      + "fragColor = texture(envmap,"
      +                "vec2(.5+atan(refDir.z,refDir.x)/(2.0*PI),"
      +                        "acos(refDir.y/length(refDir))/PI));"
     + "}"
    }){
      PShader run(){
 
        //mode: linear
        ((PGraphicsOpenGL)g).textureSampling(2);
 
        //somewhere else i run this minimal clear background
        rectMode(RADIUS);
        fill(x);
        rect(x,x,width,height);
        //draw grid
        stroke(254);
        while(x<width){
        x+=20.01f;
        line(x,0,x,height);
        line(0,x,width,x);
        } //x=0;
 
        this.set("envmap",get() );
 
       //for debug leave it here
       //this.set("modelview",((PGraphicsOpenGL)g).modelview);
 
        return this;
        }
    }.run();
  //Shader for the Processing Shape
  bunnyShader=new PShader(this, 
      new String[]{ "#version 150  \n"
      +  "in vec3 position,normal;"
      + "uniform mat4 modelviewInv,view,projection;"
      + "uniform float time;"
      + "out vec3 refDir;"
      + "void main () {"
      + "vec4 camPos = view*vec4(position, 1);"
      + "vec3 eye = normalize(position.xyz-modelviewInv[3].xyz/modelviewInv[3].w);"
      + "refDir = reflect(eye, normal);"
     + "camPos.z*=clamp(sin(time)*.5+.5,0,1.);"
      + "gl_Position = projection*camPos;"
     + "}"
    },new String[]{"#version 150  \n"
        +  "in vec3 refDir;"
        + "uniform sampler2D envmap;"
        + "out vec4 fragColor;"
        + "const float PI ="+(double)PI+";"
        + "void main () {"
       /* + "fragColor = texture(envmap,"
        +                "vec2(.5+atan(refDir.z,refDir.x)/(2.0*PI),"
        +                        "acos(refDir.y/length(refDir))/PI));"*/
         //mvps.org/directx/articles/spheremap.htm
        + "fragColor = texture(envmap,vec2( .5+asin(refDir.x/PI) ,.5+ asin(refDir.y/PI) ));"
       +"}"
      }){
        PShader run(){
          this.set("modelviewInv",((PGraphicsOpenGL)g).modelviewInv);
 
          //for debug leave it here
          //this.set("modelview",   ((PGraphicsOpenGL)g).modelview);
 
          this.set("projection",  ((PGraphicsOpenGL)g).projection);
          return this;  
        }
    }.run();
 
   //with both options off/on you can see their some weird things happens
 
   //for debug leave it here
   //hint(DISABLE_OPTIMIZED_STROKE);
 
   //for debug leave it here
   //wireframe Mode
   noStroke();
}
float t=0;
void draw(){
 
  t=frameCount*.04f;
  beginCamera();
  camera();
  //rotate Camera
  rotateX(cos(t));rotateZ(sin(t*.01f)/TWO_PI);
 endCamera();
  //load the Identity matrix first PMatrix3D() returns the Identity matrix
  //is far as i understand it. 
  bgShader.set("Ry", rotY);
  //reset the stack 
  rotY.reset(); 
  rotY.apply(cos(t), 0,sin(t), 0, 0, 1, 0, 0, -sin(t), 0, cos(t), 0, 0, 0, 0, 1);
 
  //set time
  bunnyShader.set("time",t);
 
  //no depth testing
  hint(DISABLE_DEPTH_MASK); 
  shader(bgShader); 
 
  //for debug leave it here
  background(0); 
 
  //RADIUS works best (maybe)
  rectMode(RADIUS);
  rect(0, 0, width, height);
  bunnyShader.set("envmap",get());
 
 // hint(ENABLE_DEPTH_MASK);
  shader(bunnyShader);
 
  translate(width/2, height/2,-10);
  sphere(120); 
 
 
  //after we apply the transformation to the sphere we update the matrix
  //and going back to the begining of the draw loop ->camera
 
   //load the modelview from stack first then update it
  bgShader.set("view",model);
  bunnyShader.set("view",model); 
 
  //reset the stack 
  model.reset();
  model.apply(modelview.m00, modelview.m10, modelview.m20, modelview.m30,
                                    modelview.m01, modelview.m11, modelview.m21, modelview.m31,
                                    modelview.m02, modelview.m12, modelview.m22, modelview.m32,
                                    modelview.m03, modelview.m13, modelview.m23, modelview.m33);
 
 
  //for debug leave it here
  //if(keyPressed||mousePressed)exit();
}
