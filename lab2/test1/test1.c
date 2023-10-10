#include<stdio.h>
int n = 5;
int main(){
    float A[5];
    int i = 0;
    float x = 1.1;
    for(;i<n;i++){
        A[i] = x * i + n;
    }
    while (i>0)
    {
        printf("%f\n", A[5-i]);
        i--;
    }
    return 0;
}