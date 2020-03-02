#include <iostream>
#include <stdio.h>
#include <string.h>
#include <cstring>

using namespace std;

int main() {
int t_int_0;
int t_int_1;
int t_int_2;
int i;
char a;
char ch;
a = 'a';
i = 0;
bp0:
t_int_2 = i > 5;
if( t_int_2) goto bp1;
t_int_0 = i+a;
ch = t_int_0;
t_int_1 = i+a;
cout << t_int_1;
cout << "=";
cout << ch;
cout << ';';
i = i + 1;
goto bp0;
bp1:
return 0;
}

