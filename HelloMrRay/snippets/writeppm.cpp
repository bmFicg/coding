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
			outFile
				<< int(255.99 * i / width) << " "
				<< int(255.99 *j / height) << " "
				<< int(255.99 * 0.2f) << "\n";
		}
	}
}
