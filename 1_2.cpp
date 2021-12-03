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
  for (unsigned long long i=3; i < vectorIn.size(); ++i){
    int currentBatch, prevBatch;
    currentBatch = vectorIn[i] + vectorIn[i-1] + vectorIn[i-2];
    prevBatch = vectorIn[i-1] + vectorIn[i-2] + vectorIn[i-3];
    if (currentBatch > prevBatch){++numIncrease;};
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
