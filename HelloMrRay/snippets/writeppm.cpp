#include <fstream>

int main() {

	int width = 640;
	int height = 360;

	std::ofstream outFile("test.ppm");

	//http://netpbm.sourceforge.net/doc/ppm.html
	outFile << "P3\n" << width << " " << height << "\n255\n";

	for (float j = height-1.f;j-- >= 0;) {
		for (float i = 0; i++ < width;)
			o << int(255.99 * i / width) << " " << int(255.99 * j / height) << " " << int(255.99 *0.2) << "\n";
	}
	o.flush();
}

/* one liner
#include<fstream>
int main(int, char**argv){std::ofstream o((char*)(std::string(*argv).append(".ppm")).c_str());o<<"P3\n640 360\n255\n";for(int j=360;j-->=0;)for(int i=0;i++<640;)o<<255*i/640<<" "<<255*j/360<<" "<<255*.2f<<"\n";}
//g++ source.cpp -o test
*/
