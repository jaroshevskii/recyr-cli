#include <iostream>
#include <windows.h>
#include <conio.h>
#include <ctime>
#include <fstream>

using namespace std;
struct Step{
	const int b = 8,c = 8;
};

void setcur(int x,int y){
	COORD coord;
	coord.X = x;
	coord.Y = y;
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);
}

int main() {
	srand(time(0));
	Step T;
	string Chose;
	char a[T.b][T.c];
	int x = 2,y = 1,PreviousX = 2, PreviousY = 1, w = 0, q = 0,p1,p2,O,PreviousW = 6, PreviousQ = 6;
	int tab; //Нажатие.
	int pluscheck = 0; //Проверка плюса.
	bool Point = false, Key = false, GotKey = false; //Вывод плюсов
	
	cout<<"Please type START or EXIT: "<<endl;
	cin>>Chose;
		if(Chose == "START" or Chose == "start"){ //Начало 
			cout<<"Good luck!"<<endl;
			Sleep(1000);//Остановка. Чтобы быстро не убиралось.
			setcur(0,0); //Очистка.
			ifstream input;
			string text;
			input.open("Rules.txt");
			
			while(!input.eof()){//Вывожу файл.
				getline(input,text);
				cout<<text<<endl;
			}
			
		}
		else{
			cout<<"Bye!"<<endl;
			return 0;
		}
		while(true){//Просто для всего. Тоесть цикл игры.
			for(int i = 0; i<8; i++){
				for(int j = 0; j<8; j++){//Заполнение таблицы и массива ВАЖНОО!!!
					if(a[i][j] == '+'){
						a[i][j] = '+';
					}
					else{
						a[i][j] = ' ';
					}
					//Грань
					a[6][3] ='#';
					a[5][3] ='#';
					a[4][3] ='#';
					a[4][1] ='#';
					if(Key == false){
						a[6][1] ='0';
					}	
					else{
						a[6][1] =' ';	
					}
					if(GotKey == false){
						a[1][6] = '=';
					}
					else{
						a[1][6] =' ';
					}
					
					if(GotKey == false){
						a[4][2] ='&';
					}
					else{
						a[4][2] = ' ';
					}
					//End 
					if (j == 0 || j == 7) {
		                a[i][j] = '#';
		            }
		            if (i == 0 || i == 7) {
		                a[i][j] = '#';
		            }
				}
			}
			while(true){//Нажатые клавишь, тоесть передвижение
				if(kbhit() == false){
					cout<<endl<<"Type W,A,S,D to move! "<<endl;
					break;
				}
				else{
					tab = getch();
				    if(tab == 119){//119
				    x--;
				    Beep(1000,100);
					setcur(0,0);
					break;  	
					}
					if(tab == 100){
				    y++;
				    Beep(1000,100);
				    setcur(0,0);
					break;  	
					}
					if(tab == 115){
				    x++;
				    Beep(1000,100);
				    setcur(0,0);
					break;  	
					}
					if(tab == 97){
				    y--;
					Beep(1000,100);
				    setcur(0,0);
					break;  	
					}
				}
			}
			
			if(a[x][y] == '#' or a[x][y] == '&'){
				x=PreviousX;
				y=PreviousY;	
			}
			if(a[x][y] == '='){
				GotKey = true;
			}
			if(a[x][y] == '0'){
				Key = true;
			}
			if(a[x][y] == '+'){
				pluscheck--;
			}
			O = 1+rand()%4;//Противник.
			
			if(O == 1 ){
				w--;
				setcur(0,0);
				
			}
			if(O == 2 ){
				q++;
				setcur(0,0);
				
			}
			if(O == 3 ){
				w++;
				setcur(0,0);
				
			}
			if(O == 4){
				q--;
				setcur(0,0);
				
			}
			if(a[w][q] == '+'){
				pluscheck--;	
			}
			if(a[w][q] == '#' or a[w][q] == '&' or a[w][q] == '=' or w<0 or q<0){
				w=PreviousW;
				q=PreviousQ;
			}
			
			if(pluscheck != 0 and Key != true ){//Нужно придумать чтобы двери откривались когда нету +
						a[3][6]='|';
						a[4][6]='|';
					}
					else{
						if(pluscheck <= 0 and Key == true){
							a[3][6]=']';
							a[4][6]=']';
							if(x == 3 and y == 6 or x == 4 and y == 6){//Проверка на выход
								
								cout<<"\t\t\t ||| Congrats! |||"<<endl;
								Beep(200,100); Beep(100,100); Beep(300,100);
								
								return 0;
							}
							
						}
						else{
								a[3][6]='|'; 
								a[4][6]='|';
							}
				}	
			if(w == x and q == y){
				Beep(600,500);
				cout<<endl<<"GAME OVER!"<<endl;
				return 0;
				}
			a[w][q] = 254;//Противник
			a[x][y] = 64; //Ти
			
			PreviousX = x;//Для исправление ошибки. Чтобы не проходил сквозь стены.
			PreviousY = y;//Для исправление ошибки. Чтобы не проходил сквозь стены.
			PreviousW = w;
			PreviousQ = q;
			
			
			cout<<"["<<x<<"]["<<y<<"]\n";
			cout<<"["<<w<<"]["<<q<<"]["<<O<<"]"<<"\n";
			for(int i = 0; i<8; i++){
			for(int j = 0; j<8; j++){
				
				if(a[i][j] == (char)254){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),12);
				}
				if(a[i][j] == '@'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),14);
				}
				if(a[i][j] == '#'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),527);
				}
				if(a[i][j] == '|'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),12);
				}
				if(a[i][j] == ']'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),10);
				}
				if(a[i][j] == '='){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),10);
				}
				if(a[i][j] == '&'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),10);
				}
				if(a[i][j] == '+'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),9);
				}
				if(a[i][j] == '0'){
					SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),10);
				}
				if(Point == false){
						p1 = 1+rand()%6;
						p2 = 1+rand()%6;
						if(a[p1][p2] == ' ' and a[p1][p2] != '#' and a[p1][p2] != '|'){
							pluscheck+=1;
							a[p1][p2] = '+';
						}
					}
				cout<<a[i][j]<<" ";
			}
			Point = true; //Конец плюсам. Тоесть нам нужно чтобы один раз заполнилась таблица плюсами. Изначально переменная False когда выходим - true. и больше не менется.
			cout<<endl;
		}
		Sleep(90);
	}
    return 0;
}
