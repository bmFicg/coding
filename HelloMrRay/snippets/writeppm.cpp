#include <fstream>

int main() {

	int width = 640;
	int height = 360;

	std::ofstream outFile("test.ppm");

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
#include<fstream>
int main(int, char**argv){std::ofstream o((char*)(std::string(*argv).append(".ppm")).c_str());o<<"P3\n640 360\n255\n";for(int j=360;j-->=0;)for(int i=0;i++<640;)o<<255*i/640<<" "<<255*j/360<<" "<<255*.2f<<"\n";}
//g++ source.cpp -o test
*/
