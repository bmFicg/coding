const regl = require('regl')()
const bunny = require('bunny')
const camera = require('regl-camera')(regl,{
  center:[0,2.5,0],
  distance:30
})
const pixels = regl.texture()

const wbunny = regl({
  frag: `precision mediump float;
  void main() {gl_FragColor++;}`,
   vert: `precision mediump float;
  attribute vec3 position;
  uniform mat4 view, projection;
  uniform float time;
  //wave bunny shader @gregtatum
  //https://www.youtube.com/watch?v=2sCjWkk9R1w
  void main() {
    vec3 pos2 = position;
    pos2.y +=sin(time*10.+position.x+position.y*.2);
    gl_Position = projection * view * vec4(pos2, 1);
  }
  `,
  attributes:{
    position:bunny.positions
  },
  uniforms:{
    time:({time})=>time*8<<2
  },
  elements:bunny.cells
})
const mmap = regl({
  frag: `
  precision mediump float;
  varying vec2 vUV;
  uniform sampler2D texture;
  void main () {
    gl_FragColor=vec4(texture2D(texture,vUV.xy).rgb,.6);
  }`,

  vert: `
  precision mediump float;
  attribute vec2 position;
  varying vec2 vUV;
  void main () {
   vUV.xy = position;
        gl_Position = vec4(-1.+position, 0, 1);
  }`,
  attributes: {
    position: regl.buffer([
    [1, 1],[1, -1],[-1, -1],
    [-1, -1],[-1, 1],[1, 1]
    ])
  },
  uniforms: {
      texture: pixels
  },
blend: {
    enable: true,
    func: {
      src: 'src alpha',
      dst: 'one minus src alpha'
    }
  },
  count: 6
})
regl.frame(()=>{
camera((context) => {
    regl.clear(
      {
        depth: 1,color: [0.2, 0.2, 0.2, 1],
    })
  //the bug: create texture after the projected plane was created
  // wbunny(),mmap(),pixels({copy: true}),  
  wbunny(),pixels({copy: true}),mmap()  
  })
})
