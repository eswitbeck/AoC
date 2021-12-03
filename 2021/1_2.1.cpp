#include <string>
#include <iostream>
#include <sstream>
#include <iterator>
#include <fstream>
#include <list>
using namespace std;

list<int> fileToList (string &fileName){
  ifstream fileStream (fileName);
  list<int> listOut;
  string temp;
  while(getline(fileStream, temp)){
    listOut.push_back(stoi(temp,nullptr));
  }
  return listOut;
}
int countIncreases (list<int> &listIn){
  int numIncrease = 0;
  for (list<int>::iterator it = next(listIn.begin(),3);it != listIn.end(); ++it){
    if ( *it > *prev(it,3) ){++numIncrease;};
  }
  return numIncrease;
}

int main(){
  string fileName;
  list<int> file;
  cout << "Input filename: ";
  getline(cin, fileName);
  file = fileToList(fileName);
  cout << countIncreases(file);
  return 0;
}
