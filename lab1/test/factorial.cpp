#include<iostream>

using namespace std;


#define my_max 999999

inline int isLarger(int x, int y){
	return (x>y)?x : y;
}

int isSmaller(int x, int y){
	return (x<y)?x : y;
}

int main(){
	int i, n, f;
	cin>>n;
	i = 2;
	f = 1;
	while (i <=n ){
		f = f * i;
		i = i + 1;
	}
	cout << f << endl;

	cout << "isLarger?" << isLarger(100, my_max);
	cout << "isSmaller?" << isSmaller(100, my_max);

	return 0;

}
