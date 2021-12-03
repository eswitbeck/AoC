#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
using namespace std;

vector<int> fileToVector (string fileName){
  string temp;
  ifstream fileStream (fileName);
  int tempInt;
  vector<int> vectorOut;
  while(getline(fileStream,temp)){
    stringstream(temp) >> tempInt;
    vectorOut.push_back(tempInt);
  }
  return vectorOut;
}
int countIncreases (vector<int> vectorIn){
  int numIncrease = 0;
  for (unsigned long long i=1; i < vectorIn.size(); ++i){
    if (vectorIn[i] > vectorIn[i-1]){++numIncrease;};
  }
  return numIncrease;
}

int main(){
  string fileName;
  vector<int> file;
  cout << "Input filename: ";
  getline(cin, fileName);
  file = fileToVector(fileName);
  cout << countIncreases(file);
  return 0;
}
