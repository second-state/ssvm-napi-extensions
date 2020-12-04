#include <iostream>
#include <string>
#include <sstream>
#include <tensorflow/c/c_api.h>

struct Version {
  int Major;
  int Minor;
  int Revision;
  Version() = default;
  Version(std::string Str) {
    std::stringstream Ss(Str);
    std::string Buffer;
    // Major
    std::getline(Ss, Buffer, '.');
    Major = std::stoi(Buffer);
    // Minor
    std::getline(Ss, Buffer, '.');
    Minor = std::stoi(Buffer);
    // Revision
    std::getline(Ss, Buffer, '.');
    Revision = std::stoi(Buffer);
  }
  bool isTooOld() {
    if (Major < 2) {
      return true;
    } else if (Major == 2 && Minor < 3) {
      return true;
    }
    return false;
  }
};
int main() {
  std::string TFVer(TF_Version());
  std::cout << "Your TensorFlow C library version: " << TFVer << "\n";
  Version V(TFVer);
  if (V.isTooOld()) {
    std::cerr << "Your TensorFlow C library is too old. Please upgrade to >=2.3.0\n";
    return 1;
  }
  return 0;
}
