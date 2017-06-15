#include <fstream>

int main() {

	int width = 640;
	int height = 360;

	std::ofstream outFile("test.ppm", std::ios::binary);

	//http://netpbm.sourceforge.net/doc/ppm.html
	outFile << "P3\n" << width << " " << height << "\n255\n";

	for (int j = height - 1; j >= 0; j--) {
		for (int i = 0; i < width; i++) {
			//RGB
			outFile << (255 * i / width) << " "<< (255 * j / height) << " "<< (255 * 0.2f) << "\n";
		}
	}
}

/* one liner
#include <fstream>
int main(){int w=640,h=360;std::ofstream o("test.ppm");o<<"P3\n"<<w<<" "<<h<<"\n255\n";for(int j=h;j-->=0;)for(int i=0;i++<w;)o<<255*i/w<<" "<<255*j/h<<" "<<255*.2f<<"\n";}
*/
