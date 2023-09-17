#include<stdio.h>
#define two 2

int main(){
	int i, n, f;
	scanf("%d", &n);
	i = two; //define
	f = 1;
	while(i <= n){
		f = f*i;
		i += 1;
	}
	printf("result: %d\n", f );
	return 0;
}
