#include <iostream>
#include <numeric>
#include <list>
#include <iterator>
#include <fstream>
#include <string>
using namespace std;

list<string> fileToString(string &fileName){
  string temp;
  list<string> listOut;
  ifstream fileStream (fileName);
  while(getline(fileStream, temp)){
    listOut.push_back(temp);
  }
  return listOut;
}
list<int> twoDOutput(list<string> &listIn){
  int depth = 0; int horiz = 0; int aim = 0;
  for(list<string>::iterator it = listIn.begin(); it != listIn.end(); ++it){
    string temp = *it;
    int intHarvest = stoi(temp.substr(temp.length()-1,temp.length()),nullptr);
    string stringHarvest = temp.substr(0,temp.length()-2);
    if(stringHarvest == "forward"){
      horiz += intHarvest;
      depth += (intHarvest * aim);
      }
    else if(stringHarvest == "up"){
      aim -= intHarvest;}
    else if(stringHarvest == "down"){
      aim += intHarvest;
    }
  }
  list<int> listOut = {horiz, depth};
  return listOut;
}

int main(){
string fileName;
list<string> listToTwoD;
list<int> finalEntries;
cout << "Provide file name:\n";
getline(cin, fileName);
listToTwoD = fileToString(fileName);
finalEntries = twoDOutput(listToTwoD);
cout << "\n" << accumulate(finalEntries.begin(),finalEntries.end(),1,multiplies<int>());
return 0;
}
