int main(){
    int x;
    int y;

    for(x = 0; x < 5; x++){
        for(y = 0; y < 2; y++){
            y = y;
        }

        for(y = 0; y < 3; y++){
            y = y;
        }
    }

    for(x = 0; x < 3; x++){
        for(y = 0; y < 4; y++){
            y = y;
        }
    }

    x = 0;

    while(x < 5){
        y = 3;
        while(y > 0){
            y--;
        }
        x++;
    }

    //return 0;
}
