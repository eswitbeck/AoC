#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

std::vector<std::string> convertFile(std::string &fileName);
std::vector<char> splitColumns(std::vector<std::string> vectorIn, int n);
std::pair<char, char> tallyColumn(std::vector<char> vectorIn);

int main() {
  std::cout << "Provide data source address: ";
  std::string fileName;
  std::getline(std::cin, fileName);
  std::vector<std::string> inputAsVector = convertFile(fileName);
  std::string gammaBin, epsilonBin;
  for(int i = 0; i < (int) inputAsVector[0].length(); ++i) {
    std::pair<char, char> p = tallyColumn(splitColumns(inputAsVector, i));
    char g = p.first, e = p.second;
    gammaBin.push_back(g);
    epsilonBin.push_back(e);
  }
  int gammaInt = std::stoi(gammaBin, nullptr, 2);
  int epsilonInt = std::stoi(epsilonBin, nullptr, 2);
  std::cout << "gamma: " << gammaInt << "\n";
  std::cout << "epsilon: " << epsilonInt << "\n";
  std::cout << "multiplied : " << gammaInt * epsilonInt << std::endl;
  return 0;
}

std::vector<std::string> convertFile(std::string &fileName) {
  std::ifstream fileStream(fileName);
  std::string v;
  std::vector<std::string> out;
  while(std::getline(fileStream,v)){
    out.push_back(v);
  }
  return out;
}
std::vector<char> splitColumns(std::vector<std::string> vectorIn, int n) {
  std::vector<char> vectorOut;
  for(std::vector<std::string>::iterator it = vectorIn.begin(); it != vectorIn.end(); ++it){
    vectorOut.push_back((*it)[n]);
  }
  return vectorOut;
}
std::pair<char, char> tallyColumn(std::vector<char> vectorIn) {
  int gamma, epsilon;
  int countOnes = std::count(vectorIn.begin(), vectorIn.end(), '1');
  (countOnes > ((int) vectorIn.size() - countOnes)) ? 
    (gamma = '1', epsilon = '0') : (gamma = '0', epsilon = '1'); 
  std::pair<char, char> valuesOut = std::make_pair(gamma, epsilon);
  return valuesOut;
}
