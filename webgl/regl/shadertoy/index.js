const regl = require('regl')()
const drawTriangle =regl({
  frag:`
  precision highp float;
  uniform vec3 resolution;
  uniform float time;
  void main(){
	  vec2 uv = (gl_FragCoord.xy/resolution.xy);
	  gl_FragColor = vec4(uv,0.5+0.5*sin(time),1.0);
	}`,
  vert:`
  attribute vec2 position;
  void main() {
		gl_Position = vec4(position.xy,0.,1.);
	}`,
 attributes: {
	 position: {
		buffer:regl.buffer({
		usage: 'static',
		data:new Int8Array([-3,1,1,-3,1,1])
		}),
		size:2,
		type:'int8',
		normalized:false,
		stride:0,
		offset:0
		}
  },
  uniforms: {
	 resolution:c=>[c.drawingBufferWidth,c.drawingBufferHeight,Math.min(c.drawingBufferWidth,c.drawingBufferHeight)],
	 time: ({tick}) => (0.01 * tick)
  },
  primitive: 'triangle fan',  
  count: 3
})
regl.frame(() => {
  regl.clear({
    color: [0, 0, 0, 1],
	depth: 1
  })
  drawTriangle()
})