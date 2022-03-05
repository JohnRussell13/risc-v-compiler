int main(){
    int x;
    int y;
    int a[5];
    int b[5][3];

    for(x=0;x<5;x++){
        a[x] = x;
    }

    for(y=0;y<5;y++){
        x = x + a[y];
    }

    for(x=0;x<5;x++){
        b[x][0] = x;
        b[x][1] = x+1;
        b[x][2] = x+2;
    }

    //return 0;
}
