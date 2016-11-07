document.addEventListener("DOMContentLoaded", run, false);

function run() {
    if (BABYLON.Engine.isSupported()) {
        
    var canvas = document.getElementById("renderCanvas");
    var engine = new BABYLON.Engine(canvas, true);

    // Resize
    window.addEventListener("resize", function () { engine.resize(); });
    
    // Scene, light and camera
    var scene = new BABYLON.Scene(engine);
    var light = new BABYLON.HemisphericLight("light", new BABYLON.Vector3(0, 1, 0), scene);
    // This creates and positions a free camera (non-mesh)
  
    var camera = new BABYLON.ArcRotateCamera("Camera", 0, Math.PI / 2, 12, BABYLON.Vector3.Zero(), scene);

        camera.attachControl(canvas, false);
        camera.lowerRadiusLimit = 1;
        camera.minZ = 1.0;

 BABYLON.Effect.ShadersStore["customVertexShader"]=`precision highp float;

// Attributes
attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

// Uniforms
uniform mat4 worldViewProjection;

// Varying
varying vec4 vPosition;
varying vec3 vNormal;
varying vec2 vUV;

uniform sampler2D displacementMap;
uniform float time;

void main(void) {
   


   vec4 p = vec4( position, 1. );

	vPosition = p; 
	vNormal = normal;
    vUV = uv;
    
	vec4 dv = texture2D( displacementMap, vUV );
	
	vec4 newVertexPos = vec4(vNormal * dv*(0.1+(sin(time)-mod(sin(time),.8))), .1) + vPosition;

    gl_Position = worldViewProjection * newVertexPos;
	
}
`

 BABYLON.Effect.ShadersStore["customFragmentShader"]=`precision highp float;

// Varying
varying vec4 vPosition;
varying vec3 vNormal;
varying vec2 vUV;

// Uniforms
uniform mat4 world;

// Refs
uniform vec3 cameraPosition;
uniform sampler2D textureSampler;

void main(void) {
    vec3 vLightPosition = vec3(0,20,10);
    
    // World values
    vec3 vPositionW = vec3(world * vec4(vPosition.xyz, 1.0));
    vec3 vNormalW = normalize(vec3(world * vec4(vNormal, 0.0)));
    vec3 viewDirectionW = normalize(cameraPosition - vPositionW);
    
    // Light
    vec3 lightVectorW = normalize(vLightPosition - vPositionW);
    vec3 color = texture2D(textureSampler, vUV).rgb;
    
    // diffuse
    float ndl = max(0., dot(vNormalW, lightVectorW));
    
    // Specular
    vec3 angleW = normalize(viewDirectionW + lightVectorW);
    float specComp = max(0., dot(vNormalW, angleW));
    specComp = pow(specComp, max(1., 64.)) * 2.;
    
	gl_FragColor = vec4(.1,.2,.5,1.);
    gl_FragColor += vec4(color * ndl + vec3(specComp), 1.);
}
`

 // Compile
                var shaderMaterial = new BABYLON.ShaderMaterial("shader", scene, {
                    vertex: "custom",
                    fragment: "custom",
                },
                    {
                        attributes: ["position", "normal", "uv"],
                        uniforms: ["world", "worldView", "worldViewProjection", "view", "projection"]
                    });
                shaderMaterial.setFloat("time", 0);
                shaderMaterial.setVector3("cameraPosition", BABYLON.Vector3.Zero());
                shaderMaterial.backFaceCulling = false;
				
				 var mainTexture = new BABYLON.Texture("asserts/textures/noisetex.jpg", scene);

                shaderMaterial.setTexture("textureSampler", mainTexture);
				
    // The first parameter can be used to specify which mesh to import. Here we import all meshes
	BABYLON.SceneLoader.ImportMesh("", "asserts/scenes/", "suzanne.babylon", scene, function (newMeshes) {
		// Set the target of the camera to the first imported mesh
		camera.target = newMeshes[0];

        
                for (var index = 0; index < newMeshes.length; index++) {
                    var mesh = newMeshes[index];
                    mesh.material = shaderMaterial;
                }

		
	});
        var count =0;
       scene.onAfterCameraRenderObservable.add(function (){

             shaderMaterial.setFloat("time", count+=.01);
             
        })
       // Once the scene is loaded, just register a render loop to render it
                engine.runRenderLoop(function() {

                    scene.render();
                });
           
        }
    }
