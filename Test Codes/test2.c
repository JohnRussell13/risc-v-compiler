//JUMP TEST

int main(){
    int x;
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
    //return 0;
}