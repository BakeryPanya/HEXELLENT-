#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

// Which pin on the Arduino is connected to the NeoPixels?
#define PIN        3 // On Trinket or Gemma, suggest changing this to 1

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS 91 // Popular NeoPixel ring size

// When setting up the NeoPixel library, we tell it how many pixels,
// and which pin to use to send signals. Note that for older NeoPixel
// strips you might need to change the third parameter -- see the
// strandtest example for more information on possible values.
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#define DELAYVAL 10 // Time (in milliseconds) to pause between pixels



#define SW_up 33
#define SW_dw 36
#define SW_leftdw 35
#define SW_leftup 34
#define SW_rightup 39
#define SW_rightdw 37
#define SW_RANDOM 30
#define SW_LINE 32
#define SW_DONUT 29
#define SW_decide 31

#define TAPELED 3

#define y_1 53
#define y_2 52
#define y_3 51
#define y_4 50

#define x_1 49
#define x_2 48
#define x_3 47
#define x_5 45
#define x_6 44
#define x_7 43
#define x_8 42
#define x_9 41
#define x_10 40
#define x_11 38

int STPta1 = 4;
int STPta2 = 5;
int STPta3 = 6;
int STPta4 = 7;
int APHASE  = 10;
int AENBL   = 11;
int BPHASE  = 12;
int BENBL   = 13;


int VR_PIN = A0;
unsigned long VR_VALUE = 0;

int MAS = 25;
int HALFMAS = 13;

int STP_x =5;
int STP_y =0;

char data[93];
int k= 0;
int j=0;

char buf_x;
char buf_y;

int x1=0;
int x2=0;

int y1=0;
int y2=0;

int xy[11][11] ={{0,0}};

bool push_1 = true;
bool bool_2 = true;


void READ_VR(void)
{
  VR_VALUE = analogRead(VR_PIN);
}

//==============ステッピングモータ用ディレイ==============
void DELAY_WAIT(void){
  for (int i = 0; i < (VR_VALUE /10 + 7) ; i++) delayMicroseconds(100);
  /* VR_VALUE=0,delay略=100のとき、forループ100回で1回転なので
   * delay略=50にすればforループ200回で1回転のはず */
}
//==============ステッピングモータ用ディレイ==============



//==============縦に半マス移動==============
void y_half(int dire){

  if(dire > 0){
      //正転
      while(dire != 0){
        for(int i=0; i < HALFMAS; i++){
          READ_VR();

          digitalWrite(STPta1,HIGH);
          DELAY_WAIT();

          digitalWrite(STPta3,HIGH);
          DELAY_WAIT();

          digitalWrite(STPta1,LOW);
          DELAY_WAIT();

          digitalWrite(STPta3,LOW);
          DELAY_WAIT();
        }
        dire--;
      }

      delay(500);
  }

  
  if(dire < 0){    
      //逆転
      while(dire != 0){
        for(int i=0; i < HALFMAS ; i++){
          READ_VR();

          digitalWrite(STPta3,LOW);
          DELAY_WAIT();

          digitalWrite(STPta1,LOW);
          DELAY_WAIT();

          digitalWrite(STPta3,HIGH);
          DELAY_WAIT();

          digitalWrite(STPta1,HIGH);
          DELAY_WAIT();
        }
        dire++;
      }

      delay(500);

  }
}
//==============縦に半マス移動==============



//==============横に1マス移動==============
void x_full(int dire){

  if(dire > 0){
    //正転
    while(dire != 0){
      for(int i=0; i<MAS; i++){
        READ_VR();
        digitalWrite(APHASE,HIGH);
        DELAY_WAIT();

        digitalWrite(BPHASE,HIGH);
        DELAY_WAIT();

        digitalWrite(APHASE,LOW);
        DELAY_WAIT();

        digitalWrite(BPHASE,LOW);
        DELAY_WAIT();
      }
      dire--;
    }
  delay(500);
  }
  
  if(dire < 0){
    //逆転
    while(dire != 0){
      for(int i=0; i<MAS; i++){
      READ_VR();

      digitalWrite(BPHASE,LOW);
      DELAY_WAIT();

      digitalWrite(APHASE,LOW);
      DELAY_WAIT();

      digitalWrite(BPHASE,HIGH);
      DELAY_WAIT();

      digitalWrite(APHASE,HIGH);
      DELAY_WAIT();

      }
      dire++;
    }
  delay(500);
  }
}
//==============横に1マス移動==============



/*
 * 200ループで1回転
 * 
 * DERAY WAIT 700msec
 */

 

void setup() 
{
  Serial.begin(9600);
  pinMode(STPta1,OUTPUT);
  pinMode(STPta2,OUTPUT);
  pinMode(STPta3,OUTPUT);
  pinMode(STPta4,OUTPUT);
  digitalWrite(STPta2,HIGH);
  digitalWrite(STPta4,HIGH);
  pinMode(APHASE,OUTPUT);
  pinMode(AENBL,OUTPUT);
  pinMode(BPHASE,OUTPUT);
  pinMode(BENBL,OUTPUT);
  digitalWrite(AENBL,HIGH);
  digitalWrite(BENBL,HIGH);
  for(int i=29; i<53; i++){
    pinMode(i,INPUT);
  }
  // These lines are specifically to support the Adafruit Trinket 5V 16 MHz.
  // Any other board, you can remove this part (but no harm leaving it):
#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
  clock_prescale_set(clock_div_1);
#endif
  // END of Trinket-specific code.

  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  pixels.clear();

  
}



void loop(){
//    if(digitalRead(37) == HIGH){
//       pixels.setPixelColor(0, pixels.Color(0, 0, 50));
//       pixels.show();
//    }
//
//    
//
//    pixels.setPixelColor(1, pixels.Color(0, 0, 50));
//    pixels.show();
   


    
   //serial痛心
   if (Serial.available()>0) {
    char ata = Serial.read();  // 1文字ずつ受信
    data[k] = ata;
    
    
     // 文字数が93以上 or 終端文字が来たら
    if (k > 93 || data[k] == '\0') {
      
      for(j=0; j<NUMPIXELS; j++) { // For each pixel...
      // pixels.Color() takes RGB values, from 0,0,0 up to 255,255,255
      // Here we're using a moderately bright green color:
      switch(data[j]){
      case 'a'://なんもないとき
        pixels.setPixelColor(j, pixels.Color(30, 30, 30));
        break;
      case 'b'://1pのマス
        pixels.setPixelColor(j, pixels.Color(50, 0, 0));
        break;
      case 'c'://2pのマス
        pixels.setPixelColor(j, pixels.Color(0, 0, 50));//青かなあ
        break;
      default://ダメなとき
        pixels.setPixelColor(j, pixels.Color(0, 50, 50));//紫？？
        break;
    }

    delay(10); // Pause before next pass through loop

    pixels.show();   // Send the updated pixel colors to the hardware.

    
    delay(10); // Pause before next pass through loop
    
  }
  
//  int cnt = 0;
//  for(int a=0;a<11;a++){
//    if(a<6){
//      for(int b=0;b<a+6;b++){
//        xy[a][b] = data[cnt];
//        cnt+=1;
//      }
//    }else{
//      for(int b=0;b<15-a;b++){
//        xy[a][b] = data[cnt];
//        cnt+=1;
//      }
//    }
//  }
    
  
  int move_x;
  int move_y;
  //ここにステッピングモータ作動動作を書きます
  if(data[91] != 'A'){
    move_x = STP_x - (data[91] - '0');
  }else{
    move_x = STP_x - 10;
  }

  if(data[92] != 'A'){
    move_y = STP_y - (data[92] - '0');
  }else{
    move_y = STP_y - 10;
  }


  //ここから実際に動かすとこ
  if(move_x == 0){
    
    y_half(2*move_y);
    
    
  }else if(move_x < 0){
    if(abs(move_x)%2 == 0){
        //xが偶数のとき
        x_full(move_x);
        delay(500);
        y_half(move_y);
      }else{
        //xが奇数のとき
        x_full(move_x);
        delay(500);
        if(move_y < 0){
          y_half(1);
          y_half(2*(move_y-1));
        }else{
          y_half(-1);
          y_half(2*(move_y-1));
        }
        
      }
      
    }else{//move_x>0パターン

      if(move_x%2 == 0){
        //xが偶数のとき
        x_full(move_x);
        delay(500);
        y_half(2*move_y);
        
      }else{
        //xが奇数のとき
        x_full(move_x);
        delay(500);
        if(move_y < 0){
          y_half(-1);
          y_half(2*abs(move_y-1));
        }else{
          y_half(1);
          y_half(2*abs(move_y-1));
        }
        
      }
      
    }
  //ここまで実際に動かすとこ

  if(data[91] != 'A'){
    STP_x = data[91];
  }else{
    STP_x = 10;
  }

  if(data[92] != 'A'){
    STP_y = data[92];
  }else{
    STP_y = 10;
  }
  
  
  //dataはdata[91]はx,data[92]はyを格納しています。

  //バッファの要素番号をリセットします
     k=0;
  //ここまで
     
  }else{//if閉じ【】
    k++; 
  }

  }else{
 
  
  if(digitalRead(SW_up) == HIGH && push_1 == true){
    Serial.write("b,1,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_dw) == HIGH && push_1 == true){
    Serial.write("b,2,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_leftdw) ==HIGH && push_1 == true){
    Serial.write("b,3,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_leftup)==HIGH && push_1 == true){
    Serial.write("b,4,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_rightup)==HIGH && push_1 == true){
    Serial.write("b,5,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_rightdw) ==HIGH && push_1 == true){
    Serial.write("b,6,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_RANDOM)==HIGH && push_1 == true){
    Serial.write("b,7,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_LINE)==HIGH && push_1 == true){
    Serial.write("b,8,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_DONUT) ==HIGH && push_1 == true){
    Serial.write("b,9,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_decide)==HIGH && push_1 == true){
    Serial.write("b,0,\0");
    push_1 = false;
    delay(10);
    
  }else if(digitalRead(SW_up) == LOW && digitalRead(SW_dw) == LOW && digitalRead(SW_leftdw) ==LOW && digitalRead(SW_leftup)==LOW && digitalRead(SW_rightup)==LOW && digitalRead(SW_rightdw) ==LOW && digitalRead(SW_RANDOM)==LOW && digitalRead(SW_DONUT) ==LOW && digitalRead(SW_decide)==LOW && push_1 == false){
    push_1 = true;
     delay(10);
  }
  //

  //ネオジムセンサコマンド

  if(digitalRead(y_1) == HIGH && bool_2==true){
    if(digitalRead(x_1)== HIGH && bool_2==true){
      Serial.write("s,0,4,\0");
      delay(10);
      bool_2 = false;
    }else if(digitalRead(x_2)== HIGH ){
      Serial.write("s,1,5,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_3)== HIGH ){
      Serial.write("s,2,5,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_5)== HIGH ){
      Serial.write("s,4,6,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_6)== HIGH ){
      Serial.write("s,5,7,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_7)== HIGH ){
      Serial.write("s,6,6,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_8)== HIGH ){
      Serial.write("s,7,6,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_9)== HIGH ){
      Serial.write("s,8,5,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_10)== HIGH ){
      Serial.write("s,9,5,\0");
      bool_2 = false;
       delay(10);
    }else if(digitalRead(x_11)== HIGH ){
      Serial.write("s,10,4,\0");
      bool_2 = false;
       delay(10);
    }
  }else if(digitalRead(y_2)== HIGH && bool_2==true){
    if(digitalRead(x_1)== HIGH && bool_2==true){
      Serial.write("s,0,5,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_2)== HIGH ){
      Serial.write("s,1,6,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_3)== HIGH ){
      Serial.write("s,2,6,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_5)== HIGH){
      Serial.write("s,4,7,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_6)== HIGH){
      Serial.write("s,5,8,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_7)== HIGH){
      Serial.write("s,6,7,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_8)== HIGH){
      Serial.write("s,7,7,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_9)== HIGH ){
      Serial.write("s,8,6,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_10)== HIGH ){
      Serial.write("s,9,6,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_11)== HIGH ){
      Serial.write("s,10,5,\0");
       bool_2 = false;
     delay(10);
    }
    
    
  }else if(digitalRead(y_3)== HIGH && bool_2 == true){
    if(digitalRead(x_1)== HIGH){
      Serial.write("s,2,7,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_2)== HIGH){
      Serial.write("s,3,8,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_3)== HIGH){
      Serial.write("s,4,8,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_5)== HIGH){
      Serial.write("s,6,8,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_6)== HIGH){
      Serial.write("s,7,8,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_7)== HIGH){
      Serial.write("s,8,7,\0");
       bool_2 = false;
     delay(10);
    }
    bool_2 = false;
     delay(10);
    
  }else if(digitalRead(y_4) && bool_2 == true){
    if(digitalRead(x_1)== HIGH){
      Serial.write("s,4,9,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_2)== HIGH){
      Serial.write("s,5,10,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(x_3)== HIGH){
      Serial.write("s,6,9,\0");
       bool_2 = false;
     delay(10);
    }

     
  }else if(digitalRead(x_1)== LOW && digitalRead(x_2)== LOW && digitalRead(x_3)== LOW && digitalRead(x_5)== LOW && digitalRead(x_6)== LOW && digitalRead(x_7)== LOW && digitalRead(x_8)== LOW && digitalRead(x_9)== LOW && digitalRead(x_10)== LOW && digitalRead(x_11)== LOW && bool_2 == true){
    if(digitalRead(y_1)== HIGH){
      Serial.write("s,3,6,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(y_2)== HIGH){
      Serial.write("s,3,7,\0");
       bool_2 = false;
     delay(10);
    }else if(digitalRead(y_3)== HIGH){
      Serial.write("s,3,8,\0");
       bool_2 = false;
     delay(10);
    }
    
  }else if(digitalRead(y_4)== LOW &&digitalRead(y_3)== LOW &&digitalRead(y_1)== LOW &&digitalRead(y_2)== LOW && digitalRead(x_1)== LOW && digitalRead(x_2)== LOW && digitalRead(x_3)== LOW && digitalRead(x_5)== LOW && digitalRead(x_6)== LOW && digitalRead(x_7)== LOW && digitalRead(x_8)== LOW && digitalRead(x_9)== LOW && digitalRead(x_10)== LOW && digitalRead(x_11)== LOW && bool_2 == false){
    bool_2 = true;
     delay(10);
  }
  }
}

  
