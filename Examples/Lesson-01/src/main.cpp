/**
 * @file main.cpp
 * @author Ergün CÜCÜK (github.com/ecucuk)
 * @brief This is the main file for the first lesson of the C++ Notes series. It
 * serves as an introduction to C++ programming and covers basic concepts such
 * as input/output, variables, and data types.
 * @version 0.1
 * @date 2026-03-29
 *
 * @copyright Copyright (c) 2026
 *
 */

#include <chrono>
#include <iostream>
#include <thread>

int main() {
  int value = 0;
  value += 1;
  value += 2;
  value += 3;

  std::cout << "Lesson 1 running, value = " << value << '\n';

  std::this_thread::sleep_for(std::chrono::seconds(10));
  return 0;
}