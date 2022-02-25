//TEST ALU OPS

//#define y 3

// int sub(int a, int b){
//     int x;
//     x = a - b;
// 	return x;
// }

// int add(int a, int b){
//     int x;
//     x = sub(a,b);
// 	return x;
// }

int fact(int x){
    int a;
    a = 1;
    if(x > 1){
        a = fact(x-1);
    }
    a = a * x;
    return a;
}

int main(){
    int x;
    int y;
    // int z0;
    // int w;
    // int q;
    // int t;
    // y = 7;


    // x = 0x1;
    // y = (2 + 3) << (1 - 4);
    // z0 = x + y;
    // w = x - z0;
    // q = x << y;
    // t = z0 >> 1;

    // x = 5;
    // y = 7;
    // if(x<y){
    //     x=6;
    // }

    // x = 0;
    // while(x < 2){
    //     x++;
    // }

    // x = 5;

    // x = 0;
    // for(y = 0; y < 5; y++){
    //     x++;
    // }
    
    // y++;

    // x = 13;
    // y = 3;
    // x = x%y;

    x = fact(4);
    //return 0;
}
