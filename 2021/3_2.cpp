#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

std::vector<std::string> convertFile(std::string &fileName);
std::vector<std::string> filterRange(std::vector<std::string> input, int c);

int main() {
  std::cout << "Provide data source address: ";
  std::string fileName;
  std::getline(std::cin, fileName);
  std::vector<std::string> inputAsVector = convertFile(fileName);
  int oxygenRating = std::stoi((filterRange(inputAsVector, 0))[0], nullptr, 2);
  int C02Rating = std::stoi((filterRange(inputAsVector, 1))[0], nullptr, 2);
  std::cout << "Oxygen reading is: " << oxygenRating << "\n";
  std::cout << "C02 reading is: " << C02Rating << "\n";
  std::cout << "Multiplied reading is: " << oxygenRating * C02Rating << std::endl;
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
std::vector<std::string> filterRange(std::vector<std::string> input, int c) {
  std::vector<std::string> vectorIn = input;
  int n = 0;
  while(n < (int) vectorIn[0].length()){
    if (vectorIn.size() == 1) break;
    std::vector<char> column;
    for(std::vector<std::string>::iterator it = vectorIn.begin();
        it != vectorIn.end(); ++it){column.push_back((*it)[n]);
    }
    int countOnes = std::count(column.begin(), column.end(), '1');
    char majorityChar, minorityChar;
    (countOnes >= ((int) column.size() - countOnes)) ? 
        (majorityChar = '1', minorityChar = '0') :
        (majorityChar = '0', minorityChar = '1');
    char check;
    (c == 0) ? check = majorityChar : check = minorityChar;
    for(std::vector<std::string>::iterator it = vectorIn.begin(); it != vectorIn.end();
        ){
      if((*it)[n] != check){vectorIn.erase(it);
      } else {++it;}
    }
    ++n;
  }
  return vectorIn;
}
