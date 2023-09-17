#include<stdio.h>

const int zero = 0;
int vtwo = 2;
float a[5] = {0, 1, 2, 3, 4};

int isSmaller(int x, int y){
	return y>x;
}

int fib(int n){
	if(n == zero)
		return 0;
	else if(n == 1)
		return 1;
	else
		return fib(n-1) + fib(n-2);
}

int main(){
	if(isSmaller(fib(5), 10))
		for(int i=0; i<5; i++){
			printf("a[%d] isSmaller? %d\n", i, isSmaller(a[i], vtwo));
			a[i] = a[i]*3;
			a[i] = a[i]/2;
		}
	
	return 0;
}
