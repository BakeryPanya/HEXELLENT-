import processing.net.*;

Server server;
int[][] area = new int[11][11];

IntList num;

int x;//x座標格納
int y;//y座標格納
int act;//act確認 10
int pl;//pl確認
int dir;//方向 
int p1x=5;
int p1y=10;
int p2x=5;
int p2y=0;
int state=0;//state
int pl1_sq=0;
int pl2_sq=0;
int myturn=1;
int turn=1;
int p1_str_ok=2;
int p2_str_ok=2;
int p1_ran_ok=1;
int p2_ran_ok=1;


int gamen;





void setup(){
  size(200,200);
  for(int m=0;m<11;m++){
    for(int n=0;n<11;n++){
      area[m][n] = 0;
    }
  }
  
  server = new Server(this,20000);
  println("server start");
}

void draw(){
  Client c = server.available();
  
  if(c != null){
    println("client_data recv");
    String map="";
    String s = c.readStringUntil('\n');
    //println("d");
    println(s);
    if(s != null){
      String[] place = splitTokens(s,",");
      x = int(place[0]);
      System.out.println("x="+x);
      y = int(place[1]);
      System.out.println("y="+y);
      act = int(place[2]);
      System.out.println("act="+act);
      dir = int(place[3]);
      System.out.println("dir="+dir);
      pl = int(place[4]);
      System.out.println("pl="+pl);
      
      
      
      
      
      if(x==100 && y==100 && act==100 && dir==100 && pl==100){
        System.out.println("true");
        area[5][0] = 2;
        area[5][10] = 1;
        state=100;//初期化state
      }else if(myturn==pl){
        if(pl==1){
          p1x = x;
          p1y = y;
        }else if(pl==2){
          p2x = x;
          p2y = y;
        }
        conv_String(x,y,act,dir,pl);
        
        if(myturn==1){
          myturn=2;
        }else{
          myturn=1;
        }
        turn+=1;
        state=1;//通常終了
        
      }else{
        state=2;//あなたのターンではありません
      }
      //書き込み処理
      
      pl1_sq=0;
      pl2_sq=0;
      
      for(int m=0;m<11;m++){
        for(int n=0;n<11;n++){
            
            if(area[m][n]==1){
              if(n==2 &&(( 0<=m && m<=1)||(9<=m && m<=10))){//y=2の2point
                pl1_sq+=2;
              }else if(n==3 &&(( 0<=m && m<=4)||(7<=m && m<=10))){
                pl1_sq+=2;
              }else if(n==4 &&( 1<=m && m<=9)){
                pl1_sq+=2;
              }else if(n==5 &&( 3<=m && m<=7)){
                pl1_sq+=2;
              }else if(n==6 && m==5){
                pl1_sq+=2;
              }else{
                pl1_sq+=1;
              }
            }
            if(area[m][n]==2){
              if(n==2 &&(( 0<=m && m<=1)||(9<=m && m<=10))){//y=2の2point
                pl2_sq+=2;
              }else if(n==3 &&(( 0<=m && m<=4)||(7<=m && m<=10))){
                pl2_sq+=2;
              }else if(n==4 &&( 1<=m && m<=9)){
                pl2_sq+=2;
              }else if(n==5 &&( 3<=m && m<=7)){
                pl2_sq+=2;
              }else if(n==6 && m==5){
                pl2_sq+=2;
              }else{
                pl2_sq+=1;
              }
            }
            
            map += area[m][n] + ",";
        
        }
      }
      
     
      
    map+="&"+str(p1x)+","+str(p1y)+","+"&"+str(p2x)+","+str(p2y)+","+"&"+str(state)+'&'+str(myturn)+'&'+str(pl1_sq)+'&'+str(pl2_sq)+'&'+str(turn)+'&'+str(p1_str_ok)+'&'+str(p1_ran_ok)+'&'+str(p2_str_ok)+'&'+str(p2_ran_ok)+'&'+'\n';
    System.out.println(map);
    System.out.println("clientにsend");
    server.write(map);
    
    if(turn>=21){
      for(int m=0;m<11;m++){
      for(int n=0;n<11;n++){
        area[m][n] = 0;
         
      }
      }
       p1x=5;
       p1y=10;
       p2x=5;
       p2y=0;
       state=0;//state
       pl1_sq=0;
       pl2_sq=0;
       myturn=1;
       turn=1;
       p1_str_ok=2;
       p2_str_ok=2;
       p1_ran_ok=1;
       p2_ran_ok=1;
     
       

      
    }
      
     
    }
    
  }//文字列読み取る

}

void conv_String(int x,int y,int act,int dir,int pl){
  switch(act){
    case 1://donut
      System.out.println("donut");
      System.out.println("x="+x+","+"y="+y+","+"dir="+dir+","+"pl="+pl+",");
      donut(x,y,dir,pl);
      break;
    case 2://straight
      System.out.println("straight");
      straight(x,y,dir,pl);
      if(pl == 1){
        p1_str_ok = p1_str_ok-1;
      }else if(pl == 2){
        p2_str_ok = p2_str_ok-1;
      }
      
      
      break;
    case 3://random
      System.out.println("random");
      random_hex(x,y,pl);
      if(pl == 1){
        p1_ran_ok = p1_ran_ok-1;
      }else if(pl == 2){
        p2_ran_ok = p2_ran_ok-1;
      }
     
      break;
    default:
      break;
  }
  
}

void draw_space(int xd,int yd ,int col){
  if(xd>=0 && yd>=0 && xd<11){
    if(xd<6){
      if(yd<xd+6){
        
        if(col==1){
          area[xd][yd] = 1;//赤色
        }else{
          area[xd][yd] = 2;//青色
        }
        
      }
    }else{
      if(yd<10-(xd-6)){
        
         if(col==1){
          area[xd][yd] = 1;//赤色
        }else{
          area[xd][yd] = 2;//青色
        }
        
      }
    }
    
  }
}


void donut(int conx,int cony,int dir,int col){//ドーナツの場所を指定する。これむずかしい
//donut
  
  switch(dir){
    case 1:
      donut_draw(conx,cony-2,col);
      break;
    case 2: 
      if(conx==4){
        donut_draw(conx+2,cony-1,col); 
      }else if(conx>=5){
        donut_draw(conx+2,cony-2,col);
      }else{
        donut_draw(conx+2,cony,col);
      }
      break;
     
    case 3:
      if(conx==4){
        donut_draw(conx+2,cony+1,col);
      }else if(conx>=5){
        donut_draw(conx+2,cony,col);
      }else{
        donut_draw(conx+2,cony+2,col);
      }
      break;
      
    case 4:
      donut_draw(conx,cony+2,col);
      break;
      
    case 5:
      if(conx==6){
        donut_draw(conx-2,cony+1,col);
      }else if(conx<=5){
        donut_draw(conx-2,cony,col);
      }else{
        donut_draw(conx-2,cony+2,col);
      }
      break;
      
    case 6:
      if(conx==6){
        donut_draw(conx-2,cony-1,col);
      }else if(conx<=5){
        donut_draw(conx-2,cony-2,col);
      }else{
        donut_draw(conx-2,cony,col);
      }
      break;
    default:
      break;
 }
}

void donut_draw(int donut_x,int donut_y,int col){//実際に塗る場合
  
  //よこどうすんだ問題
  if(donut_x < 5 ){
    
    draw_space(donut_x,donut_y-1,col);
    draw_space(donut_x,donut_y+1,col);
    draw_space(donut_x-1,donut_y-1,col);
    draw_space(donut_x-1,donut_y,col);
    draw_space(donut_x+1,donut_y,col);
    draw_space(donut_x+1,donut_y+1,col);
    
  }else if(donut_x == 5){
    
    draw_space(donut_x,donut_y-1,col);
    draw_space(donut_x,donut_y+1,col);
    draw_space(donut_x-1,donut_y-1,col);
    draw_space(donut_x-1,donut_y,col);
    draw_space(donut_x+1,donut_y-1,col);
    draw_space(donut_x+1,donut_y,col);
   
  }else if(5 < donut_x  ){
    
    draw_space(donut_x,donut_y-1,col);
    draw_space(donut_x,donut_y+1,col);
    draw_space(donut_x-1,donut_y,col);
    draw_space(donut_x-1,donut_y+1,col);
    draw_space(donut_x+1,donut_y-1,col);
    draw_space(donut_x+1,donut_y,col);
  }
  
}

void straight(int str_x,int str_y,int dir,int col){
  switch(dir){
    case 1:
      for(int i=1;i<=6;i++){
        draw_space(str_x,str_y-i,col);
      }
      break;
      
    case 2:
      for(int i=1;i<=6;i++){
        if(str_x+i <= 5){
          draw_space(str_x+i,str_y,col);
        }else{
          int k=1;
          for(int j=i;j<=6;j++){
          draw_space(str_x+j,str_y-k,col);
          k+=1;
          }
         
          break;
        }
        
      }
      break;
    
    case 3:
      for(int i=1;i<=6;i++){
        if(str_x+i <= 5){
          draw_space(str_x+i,str_y+i,col);
        }else{
          int k=i-1;
          for(int j=i;j<=6;j++){
            draw_space(str_x+j,str_y+k,col);
          }
          break;
        }
      }
      break;
      
    case 4:
      for(int i=1;i<=6;i++){
        draw_space(str_x,str_y+i,col);
      }
      break;
    
    case 5:
      for(int i=1;i<=6;i++){
        if(str_x-i >= 5){
          draw_space(str_x-i,str_y+i,col);
        }else{
          int k=i-1;
          for(int j=i;j<=6;j++){
            draw_space(str_x-j,str_y+k,col);
          }
          break;
        }
      }
      break;
      
   case 6:
     for(int i=1;i<=6;i++){
        if(str_x-i >= 5){
          draw_space(str_x-i,str_y,col);
        }else{
          int k=1;
          for(int j=i;j<=6;j++){
          draw_space(str_x-j,str_y-k,col);
          k+=1;
          }
          break;
        }
        
      }
      break;
   
      
    default:
      break;
  
  }
}

void random_hex(int random_x,int random_y,int col){
  int x = random_x;
  int y = random_y;
  int cnt = 0;
  int i = 0;
  num = new IntList();
  for(int j=1; j<=18; j++){
    num.append(j);  
  }
  
  num.shuffle();
  
  while(cnt!=6){
    
    int a = num.get(i);
    
    if(random_x < 4){
      switch(a){
        case 1:
          x = random_x;
          y = random_y - 2;
          break;
        case 2:
          x = random_x - 1;
          y = random_y - 2;
          break;
        case 3:
          x = random_x - 2;
          y = random_y - 2;
          break;
        case 4:
          x = random_x + 1;
          y = random_y - 1;
          break;
        case 5:
          x = random_x;
          y = random_y - 1;
          break;
        case 6:
          x = random_x - 1;
          y = random_y - 1;
          break;
        case 7:
          x = random_x - 2;
          y = random_y - 1;
          break;
        case 8:
          x = random_x + 2;
          y = random_y;
          break;
        case 9:
          x = random_x + 1;
          y = random_y;
          break;
        case 10:
          x = random_x - 1;
          y = random_y;
          break;
        case 11:
          x = random_x - 2;
          y = random_y;
          break;
        case 12:
          x = random_x + 2;
          y = random_y + 1;
          break;
        case 13:
          x = random_x + 1;
          y = random_y + 1;
          break;
        case 14:
          x = random_x;
          y = random_y + 1;
          break;
        case 15:
          x = random_x - 1;
          y = random_y + 1;
          break;
        case 16:
          x = random_x + 2;
          y = random_y + 2;
          break;
        case 17:
          x = random_x + 1;
          y = random_y + 2;
          break;
        case 18:
          x = random_x;
          y = random_y + 2;
          break;
        default:
          break;
      }
    }else if(random_x == 4){
      switch(a){
        case 1://
          x = random_x;
          y = random_y - 2;
          break;
        case 2://
          x = random_x - 1;
          y = random_y - 2;
          break;
        case 3://
          x = random_x - 2;
          y = random_y - 2;
          break;
        case 4://
          x = random_x + 1;
          y = random_y - 1;
          break;
        case 5://
          x = random_x;
          y = random_y - 1;
          break;
        case 6://
          x = random_x - 1;
          y = random_y - 1;
          break;
        case 7://
          x = random_x - 2;
          y = random_y - 1; 
          break;
        case 8://
          x = random_x + 2;
          y = random_y - 1;
          break;
        case 9://
          x = random_x + 1;
          y = random_y;
          break;
        case 10://
          x = random_x - 1;
          y = random_y;
          break;
        case 11://
          x = random_x - 2;
          y = random_y;
          break;
        case 12://
          x = random_x + 2;
          y = random_y;
          break;
        case 13://
          x = random_x + 1;
          y = random_y + 1;
          break;
        case 14://
          x = random_x;
          y = random_y + 1;
          break;
        case 15://
          x = random_x - 1;
          y = random_y + 1;
          break;
        case 16://
          x = random_x + 2;
          y = random_y + 1;
          break;
        case 17://
          x = random_x + 1;
          y = random_y + 2;
          break;
        case 18://
          x = random_x;
          y = random_y + 2;
          break;
        default:
          break;
      }
    }else if(random_x == 5){
      switch(a){
        case 1://
          x = random_x;
          y = random_y - 2;
          break;
        case 2://
          x = random_x - 1;
          y = random_y - 2;
          break;
        case 3://
          x = random_x - 2;
          y = random_y - 2;
          break;
        case 4://
          x = random_x + 1;
          y = random_y - 2;
          break;
        case 5://
          x = random_x;
          y = random_y - 1;
          break;
        case 6://
          x = random_x - 1;
          y = random_y - 1;
          break;
        case 7://
          x = random_x - 2;
          y = random_y - 1;
          break;
        case 8://
          x = random_x + 2;
          y = random_y - 2;
          break;
        case 9://
          x = random_x + 1;
          y = random_y - 1;
          break;
        case 10://
          x = random_x - 1;
          y = random_y;
          break;
        case 11://
          x = random_x - 2;
          y = random_y;
          break;
        case 12://
          x = random_x + 2;
          y = random_y - 1;
          break;
        case 13://
          x = random_x + 1;
          y = random_y;
          break;
        case 14://
          x = random_x;
          y = random_y + 1;
          break;
        case 15://
          x = random_x - 1;
          y = random_y + 1;
          break;
        case 16://
          x = random_x + 2;
          y = random_y;
          break;
        case 17://
          x = random_x + 1;
          y = random_y + 1;
          break;
        case 18://
          x = random_x;
          y = random_y + 2;
          break;
        default:
          break;
      }
    }else if(random_x == 6){
      switch(a){
        case 1://
          x = random_x;
          y = random_y - 2;
          break;
        case 2://
          x = random_x - 1;
          y = random_y - 1;
          break;
        case 3://
          x = random_x - 2;
          y = random_y - 1;
          break;
        case 4://
          x = random_x + 1;
          y = random_y - 2;
          break;
        case 5://
          x = random_x;
          y = random_y - 1;
          break;
        case 6://
          x = random_x - 1;
          y = random_y;
          break;
        case 7://
          x = random_x - 2;
          y = random_y;
          break;
        case 8://
          x = random_x + 2;
          y = random_y - 2;
          break;
        case 9://
          x = random_x + 1;
          y = random_y - 1;
          break;
        case 10://
          x = random_x - 1;
          y = random_y + 1;
          break;
        case 11://
          x = random_x - 2;
          y = random_y + 1;
          break;
        case 12://
          x = random_x + 2;
          y = random_y - 1;
          break;
        case 13://
          x = random_x + 1;
          y = random_y;
          break;
        case 14://
          x = random_x;
          y = random_y + 1;
          break;
        case 15://
          x = random_x - 1;
          y = random_y + 2;
          break;
        case 16://
          x = random_x + 2;
          y = random_y;
          break;
        case 17://
          x = random_x + 1;
          y = random_y + 1;
          break;
        case 18://
          x = random_x;
          y = random_y + 2;
          break;
        default:
          break;
      }
    }else if(random_x > 6){
      switch(a){
        case 1://
          x = random_x;
          y = random_y - 2;
          break;
        case 2://
          x = random_x - 1;
          y = random_y - 1;
          break;
        case 3://
          x = random_x - 2;
          y = random_y;
          break;
        case 4://
          x = random_x + 1;
          y = random_y - 2;
          break;
        case 5://
          x = random_x;
          y = random_y - 1;
          break;
        case 6://
          x = random_x - 1;
          y = random_y;
          break;
        case 7://
          x = random_x - 2;
          y = random_y + 1;
          break;
        case 8://
          x = random_x + 2;
          y = random_y - 2;
          break;
        case 9://
          x = random_x + 1;
          y = random_y - 1;
          break;
        case 10://
          x = random_x - 1;
          y = random_y + 1;
          break;
        case 11://
          x = random_x - 2;
          y = random_y + 2;
          break;
        case 12://
          x = random_x + 2;
          y = random_y - 1;
          break;
        case 13://
          x = random_x + 1;
          y = random_y;
          break;
        case 14://
          x = random_x;
          y = random_y + 1;
          break;
        case 15://
          x = random_x - 1;
          y = random_y + 2;
          break;
        case 16://
          x = random_x + 2;
          y = random_y;
          break;
        case 17://
          x = random_x + 1;
          y = random_y + 1;
          break;
        case 18://
          x = random_x;
          y = random_y + 2;
          break;
        default:
          break;
      }
      
    }//ここで振り分け終わり
    
    if(x>=0 && y>=0 && x<11){
      if(x<6){
        if(y<x+6){
          draw_space(x,y,col);
          cnt += 1;
        }
      }else{
        if(y<10-(x-6)){
          draw_space(x,y,col);
          cnt += 1;
        }
      }
    }
    
    i+=1;
  }
  
  
}
