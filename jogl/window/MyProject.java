import java.nio.*;
import javax.swing.*;
import static com.jogamp.opengl.GL4.*;
import com.jogamp.opengl.*;
import com.jogamp.opengl.awt.GLCanvas;
import com.jogamp.common.nio.Buffers;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


public class MyProject extends JFrame implements GLEventListener {

	public MyProject() {
			
			setTitle("Test");
			setSize(640,360);
			// setLocation(800,100);
			final GLCanvas canvas = new GLCanvas();
			canvas.addGLEventListener(this);
			this.add(canvas);
			setVisible(true);
			
			addWindowListener(new WindowAdapter() {
				public void windowClosing(final WindowEvent e) {
						System.exit(0);
				}
			});
		}
	
	public static void main(String[]args){
			new	MyProject();
		}
	
	public void init(GLAutoDrawable drawable) {
			
			 GL4 gl=(GL4bc)GLContext.getCurrentGL();
			
			final int shdrProgram =gl.glCreateProgram();
			
			final int vs = gl.glCreateShader(GL_VERTEX_SHADER);
			gl.glShaderSource(vs, 1, new String[]{"#version 430 \n"
				+"void main() {"
				+"gl_Position=vec4(0.f,0.f,0.f,1.0);"
				+"}"
				}, null, 0);
				gl.glCompileShader(vs);
				gl.glAttachShader(shdrProgram , vs);
				gl.glDeleteShader(vs);
				
			final int fs=gl.glCreateShader(GL_FRAGMENT_SHADER);
			gl.glShaderSource(fs, 1, new String[]{"#version 430 \n"
				+"out vec4 color;"
				+"void main(){"
				+"color=vec4(0.f,0.f,1.f,1.0);"
				+"}"}, null, 0);
				gl.glCompileShader(fs);
				gl.glAttachShader(shdrProgram , fs);
				gl.glDeleteShader(fs);
				
				gl.glLinkProgram(shdrProgram );
				gl.glUseProgram(shdrProgram );
						
				gl.glDetachShader(shdrProgram , fs);
				gl.glDetachShader(shdrProgram , vs);
		}
		
	public void display(GLAutoDrawable drawable) {
		
		GL4	gl=(GL4bc)GLContext.getCurrentGL();
		
		gl.glClearBufferfv(GL_COLOR, 0,Buffers.newDirectFloatBuffer(new float[]{1.f,0.f,0.f,1.f}));
		
		gl.glPointSize(25f);
		gl.glDrawArrays(GL_POINTS, 0, 1);
		}
	
		public void reshape(GLAutoDrawable drawable,int x, int y, int width,int height)	{}
		public void dispose(GLAutoDrawable drawable) {}
		
}
