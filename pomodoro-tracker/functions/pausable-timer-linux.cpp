#include <Rcpp.h>
using namespace Rcpp;

#include <iomanip>
#include <iostream>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <string>
#include <chrono>
#include <cmath>

int kbhit(void)
{
  struct termios oldt, newt;
  int ch;
  int oldf;
  
  tcgetattr(STDIN_FILENO, &oldt);
  newt = oldt;
  newt.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, TCSANOW, &newt);
  oldf = fcntl(STDIN_FILENO, F_GETFL, 0);
  fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);
  
  ch = getchar();
  
  tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
  fcntl(STDIN_FILENO, F_SETFL, oldf);
  
  if(ch != EOF)
  {
    ungetc(ch, stdin);
    return 1;
  }
  
  return 0;
}

void print_progress_bar(double progress,double finish, int progress_bar_length){
  
  double unit = finish / progress_bar_length;
  int progress_count = std::round(progress / unit);
  std::cout << "|";
  for(int i=0;i < progress_count;i++){
    std::cout << "=";
  }
  for(int i=0;i < (progress_bar_length-progress_count);i++){
    std::cout << " ";
  }
  std::cout << "|";
  std::cout << " " << std::round(progress / finish * 100) << "%";
}

// [[Rcpp::export]]
int command_line_timer(int length,int window_width = 80)
{
  auto start = std::chrono::system_clock::now();
  auto last_pause = std::chrono::system_clock::now();
  auto current = std::chrono::system_clock::now();
  std::chrono::duration<double> time_elapsed = current-start;
  std::chrono::duration<double> prior_time_elapsed = current-last_pause;
  std::chrono::duration<double> epoch_length = current-start;
  int progress_bar_length = window_width - 4;
  
  std::chrono::duration<double> timer_length(length);
  bool STOP = false;
  bool CANCELLED = false;
  int c;
  std::string response;
  puts("Press any key to pause:\n");
  while(!STOP){
    current = std::chrono::system_clock::now();
    std::chrono::duration<double> epoch_length = current-last_pause;
    time_elapsed = prior_time_elapsed + epoch_length;
    if(time_elapsed > timer_length){
      STOP = true;
    }
    //puts("Press a key!\n");
    std::cout << "\r";
    print_progress_bar(time_elapsed.count(),timer_length.count(),progress_bar_length);
    if(kbhit()){
      std::cout << "\nTimer paused. Enter C to cancel or R to resume: ";
      c = getchar(); //while (c != EOF && c != '\n');
      //std::cout << "\nPoint 1";
      std::cin >> response;
     // std::cout << "\nPoint 2" << response << "&" << response;
      if(response == "C"){
        //std::cout << "\nPoint 3";
        STOP = true;
        CANCELLED = true;
      }else{
        //std::cout << "\nPoint 4";
        do c = getchar(); while (c != EOF && c != '\n');
        //std::cout << "\nPoint 5";
        prior_time_elapsed = time_elapsed;
        last_pause = std::chrono::system_clock::now();
        puts("Press any key to pause:\n");
      }
    }
  }
  
  if(CANCELLED){
    std::cout << "\nTimer stopped prematurely." << std::endl;
    do c = getchar(); while (c != EOF && c != '\n');
  }else{
    std::cout << "\nTimer completed." << std::endl;
  }
  return 0;
}