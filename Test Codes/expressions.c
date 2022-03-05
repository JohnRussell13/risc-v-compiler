//TEST ALU OPS

//#define y 3

int main(){
    int x;
    int y;
    int z0;
    int w;
    int q;
    int t;
    int a;
    int b;


    x = 2;
    y = 3;
    z0 = x + y;
    w = x - z0;
    q = x << y;
    t = z0 >> 1;
    a = x & t;
    b = x * z0;

    x = 5;
    x = x % y;
}
