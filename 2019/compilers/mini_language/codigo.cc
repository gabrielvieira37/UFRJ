#include <iostream>

using namespace std;

int main() {
int t_0;
int t_1;
int t_2;
int t_3;
int t_4;
int t_5;
int t_6;
int t_7;
int t_8;
int t_9;
int a, b, i, j;
cin >> a;
cin >> b;
i = 3;
bp3:
t_9 = i > a;
if( t_9) goto bp4;
  t_0 = i*2;
  t_1 = b*b;
j = t_0;
bp1:
t_7 = j > t_1;
if( t_7) goto bp2;
  t_2 = i*i;
  t_3 = t_2+1;
  t_4 = t_3%j;
  t_5 = t_4*j;
  t_6 = t_5==0;
t_6 = !t_6;
if (t_6) goto bp0;
cout << "[";
cout << i;
cout << ",";
cout << j;
cout << "] ";
bp0:
j = j + 1;
goto bp1;
bp2:
  t_8 = i*i;
cout << "(";
cout << t_8;
cout << ")";
cout << endl;
i = i + 1;
goto bp3;
bp4:
return 0;
}

