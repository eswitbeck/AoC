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
  }
  int l{0};
  for(const auto& tok : draws){
    int win{0};
    int m{0};
    for(auto it = tables.begin(); it != tables.end();){
      if (tok == *it){
       *it = 200;
        if(checkForWin(m,it)){
          std::cout << "A winner at board #" << giveBoardPosition(m)[0] << "!" << std::endl;
          win = 1;
          std::cout << "...on pull: " << l << std::endl;
          std::cout << "Sum: ";
          std::cout << sumRemainder(m,it) << std::endl;
          std::cout << "Times pull (" << tok << "): " << tok*(sumRemainder(m, it));
          break;
        }
        ++it, ++m;
      } else {
        ++it, ++m;
      }
    if(win==1){break;}
    }
    ++l;
    if(win==1){break;}
  }
  
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
  std::cout << "Bingo!!!" << std::endl << std::endl;
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
