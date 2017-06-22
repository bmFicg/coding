const regl = require('regl')()
const draw =regl({
  frag: `
  precision mediump float;
  uniform sampler2D tex;
  varying vec2 uv;
  void main () {
    gl_FragColor = texture2D(tex, uv);
  }`,
  vert: `
  precision mediump float;
  attribute vec2 position;
  varying vec2 uv;
  void main () {
	  uv = position * vec2(0.5, -0.5) + 0.5;
	  gl_Position = vec4(position*0.5, 0.0, 1.0);
  }`,
  attributes: {
	    position: [
		-1,+1, 
		-1,-1, 
		+1,+1, 
		+1,-1],
  },
  uniforms: { tex: regl.prop('texture') },
  primitive: 'triangle strip',
  count: 4
})

require('resl')({
  manifest: {
    texture: {
      type: 'image',
      src: 'data/pic.png',
	
	parser: (data) => regl.texture({
		format: 'rgb',
        data: data,
        mag: 'nearest',
        min: 'nearest',
		wrap:['repeat','repeat']
      })
    }
  },
  
	onDone: ({texture}) => {
		regl.frame(() => {
			regl.clear({color: [0.5, 0.5, 0.5, 1.0],})
			draw({texture})
		})
	}
})
