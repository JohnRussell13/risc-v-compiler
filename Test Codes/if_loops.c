//JUMP TEST

int main(){
    int x;
    int y;
    int z;

    x = 2;

    if(x > 0){
        z = 2;
    }
    else{
        z = 0;
    }

    if(x == 1){
        z = z + 1;
    }
    else{
        z = z - 1;
    }

    while(x > 0){
        z = z + 5;
        x = x - 1;
    }
    x++;


    x = 0;
    for(y = 0; y < 5; y++){
        x++;
    }
    
    y++;

    //return 0;
}