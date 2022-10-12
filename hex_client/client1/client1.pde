import controlP5.*;
import processing.net.*;
import processing.serial.*;

Serial ser;
Client client;
int[][] area = new int[11][11];
//client rotateなしとする




String[] comPort = ser.list();
int num = comPort.length;
int err_num=0;
//描画必要変数
float x;
float y;
float x1;
float y1;

color p1_col;
color p2_col;
color area_col;
color haikei;


int absx ;//ここを変えると描画場所が変わります
int absy ;

int dx =5;//cursor現在位置
int dy=10;//cursor現在位置
int push=0;//連続移動回避用
int pl_color=1;//player_color設定用

int scene=0;

float mag = 1.5;

String map;
String pl1;
String pl2;
String state;
String turn = "0";
String myturn;
String pl1_sq ="0";
String pl2_sq = "0";
Textfield t1;
String input = "";

int dir=0;

boolean once=true;
boolean push_1 = true;
boolean push_2 = true;
boolean push_3 = true;
boolean push_4 = true;
boolean not_aru = false;
boolean not_serv = false;
boolean toggle1 = true;
boolean serv_1 = true;

int mode=0;
int str_ok = 2;
int ran_ok = 1;

PImage title ;
PImage cursor;
PImage turn_img;
PImage win;
PImage draw;
PImage lose;
PImage waku;
PImage up;
PImage down;
PImage left_up;
PImage right_up;
PImage left_down;
PImage right_down;
PImage donut;
PImage straight;
PImage random;
PImage vs;
PImage arrow;
PImage b_mode;
PFont font;

ControlP5 cp5;
ControlP5 cp6;
ControlP5 cp7;

//ここまで
//

void setup(){
  fullScreen();
  font = createFont("Square.ttf",64);
  textFont(font);
  absx = width/4;
  absy = (height/4)+60;
  p1_col = #FF2E63;
  p2_col = #08D9D6;
  area_col = #FD7E00;
  haikei = #2f3136;
  background(200);
  title = loadImage("logo.png");
  cursor = loadImage("cursor.png");
  turn_img = loadImage("turn.png");
  win = loadImage("win.png");
  lose = loadImage("lose.png");
  draw = loadImage("draw.png");
  waku = loadImage("waku.png");
  up = loadImage("Up.png");
  down = loadImage("Down.png");
  left_up = loadImage("LeftUp.png");
  left_down = loadImage("LeftDown.png");
  right_up =loadImage("RightUp.png");
  right_down = loadImage("RightDown.png");
  donut = loadImage("Donut.png");
  straight = loadImage("Straight.png");
  random = loadImage("Random.png");
  vs = loadImage("vs.png");
  
  waku.resize(int(waku.width*0.9),int(waku.height*0.9));
  donut.resize(int(donut.width*0.6),int(donut.height*0.6));
  straight.resize(int(straight.width*0.5),int(straight.height*0.5));
  random.resize(int(random.width*0.5),int(random.height*0.5));
  turn_img.resize(int(turn_img.width*0.8),int(turn_img.height*0.8));
  
 
  cursor(cursor);
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  cp7 = new ControlP5(this);
  x1=absx;
  y1=absy;
  
  for(int m=0;m<11;m++){
    for(int n=0;n<11;n++){
      area[m][n] = 0;
    }
  }
  
  for(int i=1;i<=6;i++){
    x = x1;
    y = y1; 
    for(int j=0; j<i+5; j++ ){
    beginShape();
    vertex(x*mag,y*mag);
    vertex((x+20)*mag,y*mag);
    vertex((x+30)*mag,(y+10*sqrt(3))*mag);
    vertex((x+20)*mag,(y+20*sqrt(3))*mag);
    vertex(x*mag,(y+20*sqrt(3))*mag);
    vertex((x-10)*mag,(y+10*sqrt(3))*mag);
    endShape(CLOSE);
    y+=(20*sqrt(3));
    
    }
  x1 +=30;
  y1 -=10*sqrt(3);
  }


  y1+=20*sqrt(3);

  for(int i=5;i>=1;i--){
    x = x1;
    y = y1; 
    for(int j=1; j<=i+5; j++ ){
    beginShape();
    vertex(x*mag,y*mag);
    vertex((x+20)*mag,y*mag);
    vertex((x+30)*mag,(y+10*sqrt(3))*mag);
    vertex((x+20)*mag,(y+20*sqrt(3))*mag);
    vertex(x*mag,(y+20*sqrt(3))*mag);
    vertex((x-10)*mag,(y+10*sqrt(3))*mag);
    endShape(CLOSE);
    y+=20*sqrt(3);
    
    }
  x1 +=30;
  y1 +=10*sqrt(3);
  }
  
   
   
   
   
   cp5.addButton("start")
    .setPosition(width/2-150,height/2+100)
    .setColorBackground(color(255)) 
     .setColorForeground(color(100,100,100))   
    .setSize(250,100);
    
   t1 = cp6.addTextfield("serverip") 
     .setPosition(300,height/1.6)
     .setSize(200,50)
     .setFont(font)
     .setFocus(true)
     .setAutoClear(false);
    
  
  cp7.addToggle("toggle1")
     .setPosition((width/2)+500,height/2+150)
     .setSize(200,30)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     .getCaptionLabel()
     .setVisible(false);
     
   //ser = new Serial(this,"COM6", 9600);
    
  for (int i=0; i<num; i++) {
    print(comPort[i]+"     ");
    try {
      ser = new Serial(this, comPort[i], 9600);
      delay(300);
      println("O.K---");
    }
    catch(Exception e) {
      println("failed");
      err_num+=1;
      continue;
    }
  }
  
  if(err_num==num){
    not_aru = true;
    print("error!!!");
  }
   
}

void draw(){
  background(255);
  if(not_aru == false){
  if ( ser.available() > 0) {  
     println("来てますよ");// 画面クリア
     String data = ser.readString(); // 文字列を受信
     
     String[] data_sp = splitTokens(data,",");
     println("なんか来てる");// 文字サイズ
     println(data);           // 画面に文字表示
     if(data_sp.length == 2 || data_sp.length == 3){//data落ちは不可
     switch(data_sp[0]){
       case "b":
         switch(data_sp[1]){
          case "1":
            dir = 1;
            break;
          case "5":
            dir = 2;
            break;
          case "6":
            dir = 3;
            break;
          case "2":
            dir = 4;
            break;
          case "3":
            dir = 5;
            break;
          case "4":
            dir = 6;
            break;
          case "7":
            mode = 3;
            break;
          case "8":
            mode = 2;
            break;
          case "9":
            mode = 1;
            break;
          case "0":
            if((ran_ok > 0 || mode!=3)&&(str_ok > 0 || mode!=2)){
              if(area[dx][dy] == pl_color){
            String a=str(dx)+","+str(dy)+","+str(mode)+","+str(dir)+","+str(pl_color)+","+"\n";
            println(a);
            client.write(a);
            
            println("serverにsend");
            serv_1 =false;
            if(mode==3){
              ran_ok -=1;
            }else if(mode == 2){
              str_ok -=1;
            }
            //println("c");
            }
            break;
            
          
          
            }
            default:
            break;
        }//bのやることおわり
       break;
        
      case "s":
        if(data_sp.length == 3){
          switch(data_sp[1]){
            case "a":
              dx = 10;
              break;
            default:
              dx = int(data_sp[1]);
              break;
              
          }
          
          switch(data_sp[2]){
            case "a":
              dy = 10;
              break;
            default:
              dy = int(data_sp[2]);
          }
        
        }
        break;
        
      default:
        break;
      }
     }
     data = "";
     }
  }
  
  
  
     
     
  if(scene == 0){
    background(haikei);
    push();
    fill(0);
    textSize(50);
    //text("Hexellent!!!-betaEdition-",200,200);
    image(title ,(width/2)-800,100);
    fill(255);
    textSize(150);
    text("PUSH HERE",width/2-240,height/2+250);
    fill(p1_col);
    text("PL1",width/2+300,height/2+200);
    fill(p2_col);
    text("PL2",width/2+750,height/2+200);
    pop();
   
    
    
    
    
  }else if(scene == 1){
     push();
     background(haikei);
     //枠などの表示
       image(waku,(width/10)+180,(height/15));
       image(vs,(width/2)-300,(height/20)-100);
       
     //
    
    if(once == true){
      //
         if(toggle1) {
        pl_color = 1;
        dx=5;
        dy=10;
      } else {
        pl_color = 2;
        dx=5;
        dy=0;
      }
      //
     
    cp5.getController("start").remove();
    cp6.getController("serverip").remove();
    cp7.getController("toggle1").remove();
    once=false;
    }
    x1 = absx;
    y1 = absy;
    for(int i=1;i<=6;i++){
      x = x1;
      y = y1; 
      for(int j=0; j<i+5; j++ ){
        beginShape();
        //特殊エリア色付け
        if(j==2 &&(( 1<=i && i<=2)||(9<=i && i<=10))){//y=2の2point
                 stroke(0);
                fill(area_col);
              }else if(j==3 &&(( 1<=i && i<=4)||(7<=i && i<=10))){
                 stroke(0);
                fill(area_col);
              }else if(j==4 &&( 2<=i && i<=9)){
                 stroke(0);
                fill(area_col);
              }else if(j==5 &&( 4<=i && i<=7)){
                 stroke(0);
                fill(area_col);
              }else if(j==6 && i==6){
                stroke(0);
                fill(area_col);
              }else{
                stroke(0);
                fill(255);
              }
        //ここまで ごり押しのため無駄なコードがある
        vertex(x*mag,y*mag);
        vertex((x+20)*mag,y*mag);
        vertex((x+30)*mag,(y+10*sqrt(3))*mag);
        vertex((x+20)*mag,(y+20*sqrt(3))*mag);
        vertex(x*mag,(y+20*sqrt(3))*mag);
        vertex((x-10)*mag,(y+10*sqrt(3))*mag);
        endShape(CLOSE);
        y+=(20*sqrt(3));
      
      }
      x1 +=30;
      y1 -=10*sqrt(3);
    }
  
  
    y1+=20*sqrt(3);
  
    for(int i=5;i>=1;i--){
      x = x1;
      y = y1; 
      for(int j=1; j<=i+5; j++ ){
        beginShape();
        //特殊エリア色付け
        if(j==3 &&( i==2 || i==1)){//y=2の2point
                 stroke(0);
                fill(area_col);
              }else if(j==4 &&(i==4||i==3||i==2||i==1)){
                stroke(0);
                fill(area_col);
              }else if(j==5 &&(i==5||i==4||i==3||i==2)){
                stroke(0);
                fill(area_col);
          
              }else if(j==6 &&(i==5||i==4 )){
                stroke(0);
                fill(area_col);
              }else if(j==6 && i==5){
                stroke(0);
                fill(area_col);
              }else{
                stroke(0);
                fill(255);
              }
        //ここまで
        vertex(x*mag,y*mag);
        vertex((x+20)*mag,y*mag);
        vertex((x+30)*mag,(y+10*sqrt(3))*mag);
        vertex((x+20)*mag,(y+20*sqrt(3))*mag);
        vertex(x*mag,(y+20*sqrt(3))*mag);
        vertex((x-10)*mag,(y+10*sqrt(3))*mag);
        endShape(CLOSE);
        y+=20*sqrt(3);
      }
      x1 +=30;
      y1 +=10*sqrt(3);
    }
    ////
    for(int m=0;m<11;m++){
        for(int n=0;n<11;n++){
          if(area[m][n] >= 1){
            draw_space(m,n,area[m][n]);
          }
        }
      }
     pop();
     cursor_now();
     
     server_send();
     
     push();//textarea
     fill(area_col,30);
     //rect(530,600,500,300);
     fill(255);
     
     textSize(300);
     text(pl2_sq,500,(height/6)+50);
     text(pl1_sq,width-(650),(height/6)+50);
     //text("turn:"+turn,width/2.5,height-100);
     //text("status:"+state,100,1000);
     text("Mode",width-500,(height/2)-100);
     textSize(200);
     text("Direction",50,(height/2)-100);
     image(turn_img,0,height-300);
     textSize(250);
     text(turn,440,(height-170));
     textSize(75);
     switch(mode){
       case 1:
         image(donut,width-560,height/2);
         break;
       case 2:
         image(straight,width-545,height/2);
         break;
       case 3:
         image(random,width-545,height/2);
         break;
       default:
         break;
     }
     
     switch(dir){
       case 1:
         image(up,(width/15)+70,(height/1.75)-100);
         break;
       case 2:
         image(right_up,(width/15)+70,(height/1.75)-100);
         break;
       case 3:
         image(right_down,(width/15)+70,(height/1.75)-100);
         break;
       case 4:
         image(down,(width/15)+70,(height/1.75)-100);
         break;
       case 5:
         image(left_down,(width/15)+70,(height/1.75)-100);
         break;
       case 6:
         image(left_up,(width/15)+70,(height/1.75)-100);
         break;
       default:
         break;
     }
     
     pop();
     
     if(int(turn)>=21)scene=3;
     
  }else if(scene == 3){
    push();
    fill(255);
    textSize(300);
    background(haikei);
    image(vs,(width/2)-300,(height/20)-100);
    text(pl2_sq,540,(height/6)+50);
    text(pl1_sq,width-(650),(height/6)+50);
    //text("gameset",100,200);
    //text(pl1_sq+"vs"+pl2_sq,300,600);
    if(int(pl1_sq)>int(pl2_sq)){
      if(pl_color == 1){
        image(win,(width/2)-500,(height/2)-450);
      }else{
        image(lose,(width/2)-680,(height/2)-250);
      }
    
      }else if(int(pl1_sq)<int(pl2_sq)){
        if(pl_color == 2){
          image(win,(width/2)-500,(height/2)-450);
        }else{
          image(lose,(width/2)-680,(height/2)-250);
        }
      }else{
        image(draw,(width/2)-350,(height/2)-200);
      }
    pop();
  }
  
}

public void start(int Value) {
  try {
      client = new Client(this,input,20000);
      String s="100,100,100,100,100,\n";
      client.write(s);
      println("O.K");
      
      
    }
    catch(Exception e) {
      not_serv = true;
      println("failed");
      
    }
  scene=1;
  Value=2;
}

void mouseClicked(){
  //String s="5,5,1,1,1\n";
  //client.write(s);
  //println("c");
}




void clientEvent(Client c){
  String s = c.readStringUntil('\n');
  
  if(s != null){
    System.out.println("serverからrecv");
    String[] ss = splitTokens(s,"&");
    map = ss[0];
    pl1 = ss[1];
    pl2 = ss[2];
    state = ss[3];
    myturn = ss[4];
    pl1_sq = ss[5];
    pl2_sq = ss[6];
    turn = ss[7];
    
    
    
    
    println("現在状況"+ss[0]);
    
    String[] kaku = splitTokens(map,",");
    String[] aite = splitTokens(ss[2],",");
    String aru_map="";
    int cnt=0;
    int cnt_1=0;
    
    for(int m=0;m<11;m++){
      for(int n=0;n<11;n++){
        //print(kaku[cnt]);
        area[m][n] = int(kaku[cnt]);
        if(m<6 && n<=m+5){
          if(int(kaku[cnt]) == 0)aru_map+='a';
          if(int(kaku[cnt]) == 1)aru_map+='b';
          if(int(kaku[cnt]) == 2)aru_map+='c';
          cnt_1+=1;
        }else if(m>5 && m<=(9-(n-6))){
           if(int(kaku[cnt]) == 0)aru_map+='a';
          if(int(kaku[cnt]) == 1)aru_map+='b';
          if(int(kaku[cnt]) == 2)aru_map+='c';
          cnt_1+=1;
        }
        cnt+=1;
      }
      
    }
    println(cnt);
    println(cnt_1);
    println(aru_map);
    
    println(aite[0]);
     println(aite[1]);
     println("---");
     
    
    if(int(aite[0])==10)aite[0]="A";
    if(int(aite[1])==10)aite[1]="A";
    
     println(aite[0]);
     println(aite[1]);
     println("---");
    aru_map+=aite[0]+aite[1];
    aru_map+="\0";
    if(not_aru ==false){
      println("send");
      ser.write(aru_map);
    }
    
    println(aru_map);
    
    //盤面データ格納
    
    for(int m=0;m<11;m++){
      for(int n=0;n<11;n++){
        if(area[m][n] >= 1){
          draw_space(m,n,area[m][n]);
        }
      }
    }
    
    serv_1=true;
  }
  
}


void draw_space(int xd,int yd ,int col){
  
  push();
  if(xd>=0 && yd>=0 && xd<11){
    if(xd<6){
      if(yd<xd+6){
        float cx=absx+xd*30;
        float cy=absy-(xd*10*sqrt(3))+yd*20*sqrt(3);
        beginShape();
        if(col==1){
          fill(p1_col);
        }else if(col==2){
          fill(p2_col);
        }
        vertex(cx*mag,cy*mag);
        vertex((cx+20)*mag,cy*mag);
        vertex((cx+30)*mag,(cy+10*sqrt(3))*mag);
        vertex((cx+20)*mag,(cy+20*sqrt(3))*mag);
        vertex(cx*mag,(cy+20*sqrt(3))*mag);
        vertex((cx-10)*mag,(cy+10*sqrt(3))*mag);
        endShape(CLOSE);
      }
    }else{
      if(yd<10-(xd-6)){
         float cx=absx+xd*30;
         float cy=absy+(xd*10*sqrt(3))+yd*20*sqrt(3)-100*sqrt(3);
         beginShape();
         if(col==1){
          fill(p1_col);
        }else{
          fill(p2_col);
        }
         vertex(cx*mag,cy*mag);
         vertex((cx+20)*mag,cy*mag);
         vertex((cx+30)*mag,(cy+10*sqrt(3))*mag);
         vertex((cx+20)*mag,(cy+20*sqrt(3))*mag);
         vertex(cx*mag,(cy+20*sqrt(3))*mag);
         vertex((cx-10)*mag,(cy+10*sqrt(3))*mag);
         endShape(CLOSE);
      }
    }
    
  }
  pop();
}


void cursor_now(){
  
  
  if(keyPressed == true && push==0){
    switch(key){
      case 'w':
        dy-=1;
        break;
      case 'a':
        if(dx<6)dy-=1;
        dx-=1;
        break;
      case 'z':
        if(dx>=6)dy+=1;
        dx-=1;
        break;
      case 'd':
        if(dx<5)dy+=1;
        dx+=1;
        break;
      case 'x':
        dy+=1;
        break;
      case 'e':
        if(dx>=5)dy-=1;
        dx+=1;
        break;
      default:
        break;
        
        
      }
    push=1;
    }
    
    if(keyPressed == false){
      push=0;
    }
  
  //エラー回避
  if(dx<0)dx=0;
  if(dx>10)dx=10;
  if(dy<0)dy = 0;
  if(dx<6){
    if(dy>dx+5){
      dy=dx+4;
    }
  }else{
    if(dy>10-(dx-5)){
      dy=10-(dx-4);
    }
  }
  
  cursor_draw(dx,dy);
  
  
}
void cursor_draw(int xd ,int yd){
  push();
  if(xd>=0 && yd>=0 && xd<11){
    if(xd<6){
      if(yd<xd+6){
        float cx=absx+xd*30;
        float cy=absy-(xd*10*sqrt(3))+yd*20*sqrt(3);
        beginShape();
        fill(255,255,255,100);
        stroke(255,0,0);
        strokeWeight(10);
        vertex(cx*mag,cy*mag);
        vertex((cx+20)*mag,cy*mag);
        vertex((cx+30)*mag,(cy+10*sqrt(3))*mag);
        vertex((cx+20)*mag,(cy+20*sqrt(3))*mag);
        vertex(cx*mag,(cy+20*sqrt(3))*mag);
        vertex((cx-10)*mag,(cy+10*sqrt(3))*mag);
        endShape(CLOSE);
      }
    }else{
      if(yd<10-(xd-6)){
         float cx=absx+xd*30;
         float cy=absy+(xd*10*sqrt(3))+yd*20*sqrt(3)-100*sqrt(3);
         beginShape();
         fill(255,255,255,100);
         stroke(255,0,0);
         strokeWeight(10);
         vertex(cx*mag,cy*mag);
         vertex((cx+20)*mag,cy*mag);
         vertex((cx+30)*mag,(cy+10*sqrt(3))*mag);
         vertex((cx+20)*mag,(cy+20*sqrt(3))*mag);
         vertex(cx*mag,(cy+20*sqrt(3))*mag);
         vertex((cx-10)*mag,(cy+10*sqrt(3))*mag);
         endShape(CLOSE);
      }
    }
    
  }
  pop();
  
}

void server_send(){
   if(area[dx][dy]==pl_color){//自分のカラーであるかどうか
     push();
     fill(0);
     text(str(dx)+","+str(dy),100,300);
     
     
     if(keyPressed==true && push_1==true){//mode決め
       switch(key){
         case '1'://mode circle
           mode=1;
           break;
           
         case '2'://mode staraight
           mode=2;
           break;
           
         case '3'://mode random
           mode=3;
           break;
           
       }
       push_1 = false;
     }
     
     if(keyPressed == false){
       push_1 = true;
     }
     pop();
     
     if(keyPressed==true && push_2==true){//dir決めを行う
       switch(key){
         case '4' :
           dir=1;
           break;
         case '5':
           dir=2;
           break;
         case '6':
           dir=3;
           break;
         case '7':
           dir=4;
           break;
         case '8':
           dir=5;
           break;
         case '9':
           dir=6;
           break;
         default:
           break;
       }
       push_2=false;
     }
     
     if(keyPressed == false){
       push_2 = true;
     }
     
     if(keyPressed == true && push_3 == true){
       if(key=='0'){
          if((ran_ok > 0 || mode!=3)&&(str_ok > 0 || mode!=2)){
          String a=str(dx)+","+str(dy)+","+str(mode)+","+str(dir)+","+str(pl_color)+","+"\n";
          println(a);
          client.write(a);
          println("serverにsend");
          
          if(mode==3){
            ran_ok -=1;
          }else if(mode == 2){
            str_ok -=1;
          }
          //println("c");
          }
          
       }
       
       push_3=false;
     }
     
     if(keyPressed == false){
       push_3 = true;
     }
   }
   
   
   
}
