#include <iostream>
#include <cmath>
#include <fstream>
#include <vector>
#include <sstream>

std::vector<int> giveBoardPosition(int& n);
bool checkForWin(int n, std::vector<int>::iterator it);
int sumRemainder(int n, std::vector<int>::iterator it);

int main(int argc, char** argv){
  std::string fileName = argv[1];
  std::ifstream fileStream(fileName);
  std::string line, cellUnsplit, cell;
  std::vector<std::string> numbersUnsplit;
  while(std::getline(fileStream, line)){
    std::stringstream ss1(line);
    while(std::getline(ss1, cellUnsplit, ' ')){
      std::stringstream ss2(cellUnsplit);
      while(std::getline(ss2, cell, '\n')){
        numbersUnsplit.push_back(cell);
      }
    }
  }
  std::vector<int> draws;
  std::vector<int> tables;
  int g=0;
  for(auto i = numbersUnsplit.begin(); i != numbersUnsplit.end(); ++i){
    if(i==numbersUnsplit.begin()){
      std::stringstream ss3(*i);
      std::string t;
      while(std::getline(ss3,t,',')){
        draws.push_back(std::stoi(t));
      }
    } else {
        tables.push_back(std::stoi(*i));
    }
    ++g;
  }
  int l{0};
  std::vector<int> orderedWins;
  for(const auto& tok : draws){
    int m{0};
    for(auto it = tables.begin(); it != tables.end();){
      if (tok == *it){
       *it = 200;
        if(checkForWin(m,it)){
          int currentSum{sumRemainder(m,it)*tok};
          orderedWins.push_back(currentSum);
          int currentPoint = giveBoardPosition(m)[1]*5 + giveBoardPosition(m)[2];
          for(int i{0};i<25;++i){
            *prev(it,currentPoint-i) = 201;
          }
        }
        ++it, ++m;
      } else {
        ++it, ++m;
      }
    }
    ++l;
  }
  std::cout << "Final sum is: " << orderedWins.back() << std::endl;
    return 0;
}

std::vector<int> giveBoardPosition(int& n){
  int boardNumber = (int) std::floor(n/25);
  int rowNumber = ((int) std::floor(n/5))%5;
  int columnNumber = n%5;
  std::vector<int> out{boardNumber, rowNumber, columnNumber};
  return out;
}
bool checkForWin(int n, std::vector<int>::iterator it){
  int horizontalWin{0}, verticalWin{0};

  for(int i=(giveBoardPosition(n)[2]); i>0; --i){
    if(*it != *(prev(it, i))){
      horizontalWin = 1;
    }
  }
  for(int i=(giveBoardPosition(n)[2]); i<4; ++i){
    if(*it != *(next(it,(4-i)))){
      horizontalWin = 1;
    }
  }
  for(int i=(giveBoardPosition(n)[1]); i>0; --i){
    if(*it != *(prev(it, (i*5)))){
      verticalWin = 1;
          }
  }
  for(int i=(giveBoardPosition(n)[1]); i<4; ++i){
    if(*it != *(next(it,(20-(i*5))))){
     verticalWin = 1; 
    }
  }
  if((horizontalWin == 1) and (verticalWin == 1)){ return false;}
  return true;
}
int sumRemainder(int n, std::vector<int>::iterator it){
  int sum{0};
  int currentPoint = giveBoardPosition(n)[1]*5 + giveBoardPosition(n)[2];
  for(int i{0};i<25;++i){
    int summer = *prev(it,currentPoint-i);
    if(summer!=200){
      sum += summer;
    }
  }
  return sum;
}
