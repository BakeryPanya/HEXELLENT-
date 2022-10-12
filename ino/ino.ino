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

int y[4] = {53, 52, 51, 50};

int x[11] = {49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 38};

#define NOREAD 10

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

//int x1=0;
//int x2=0;

//int y1=0;
//int y2=0;

int xy[11][11] ={{0,0}};

bool push_1 = true;
bool bool_2 = true;

int x_yomi[11] = {0};
int y_yomi[4] = {0};

int x_mae[11] = {0};
int y_mae[4] = {0};

int NOREAD_count = 5;

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

  if(dire < 0){
      //下に移動
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
        dire++;
      }

      delay(500);
  }

  
  if(dire > 0){    
      //上に移動
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
        dire--;
      }

      delay(500);

  }
}
//==============縦に半マス移動==============



//==============横に1マス移動==============
void x_full(int dire){

  if(dire < 0){
    //左に移動
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
      dire++;
    }
  delay(500);
  }
  
  if(dire > 0){
    //右に移動
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
      dire--;
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


 
    
  //step
  int move_x = 0;
  int move_y = 0;
  int data_x = 0;
  int data_y = 0;
  //ここにステッピングモータ作動動作を書きます

 
  //'を"にしました
  switch(data[91]){
    case 'A':
      data_x = 10;
      break;
    default:
      data_x = (data[91] - '0');
      break;
  }

  switch(data[92]){
    case 'A':
      data_y = 10;
      break;
    default:
      data_y = (data[92] - '0');
      break;
  }

  move_x = data_x - STP_x;
  move_y = data_y - STP_y;


  if((move_x>0 && STP_x>=5) || (move_x >(6-STP_x) && STP_x < 5)){
    if(abs(STP_x-5) <= abs(data_x-5)){
      int i = abs(STP_x-5) - abs(data_x-5);
      y_half((2*move_y)-i);
    }else{
      int i = abs(STP_x-5) - abs(data_x-5);
      y_half((2*move_y)-i);
    }
    x_full(move_x);
  }else{
    x_full(move_x);
    if(abs(STP_x-5) <= abs(data_x-5)){
      int i = abs(STP_x-5) - abs(data_x-5);
      y_half((2*(move_y))-i);
    }else{
      int i = abs(STP_x-5) - abs(data_x-5);
      y_half((2*(move_y))-i);
    }
  }


  STP_x = data_x;

  STP_y = data_y;
  
  
  //dataはdata[91]はx,data[92]はyを格納しています。
  //stepここまで

        //led
      for(j=0; j<NUMPIXELS; j++) { // For each pixel...
      // pixels.Color() takes RGB values, from 0,0,0 up to 255,255,255
      // Here we're using a moderately bright green color:
      switch(data[j]){
      case 'a'://なんもないとき
        pixels.setPixelColor(j, pixels.Color(30, 30, 30));
        break;
      case 'b'://1pのマス
        pixels.setPixelColor(j, pixels.Color(70, 0, 0));
        break;
      case 'c'://2pのマス
        pixels.setPixelColor(j, pixels.Color(0, 50, 50));//青かなあ
        break;
      default://ダメなとき
        pixels.setPixelColor(j, pixels.Color(100, 0, 100));//紫？？
        break;
    }

    delay(10); // Pause before next pass through loop

    pixels.show();   // Send the updated pixel colors to the hardware.

    
    delay(10); // Pause before next pass through loop
  }
  //led

  
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
  
  for(int i=0; i<11; i++){
    x_mae[i]=x_yomi[i];
    x_yomi[i]=digitalRead(x[i]);
  }
  
  for(int i=0; i<4; i++){
    y_mae[i]=y_yomi[i];
    y_yomi[i]=digitalRead(y[i]);
  }

  

  if(y_yomi[0] == HIGH && bool_2==true){
    if(x_yomi[0]== HIGH){
      Serial.write("s,0,4,\0");
      delay(10);
      NOREAD_count++;
    }else if(x_yomi[1]== HIGH ){
      Serial.write("s,1,5,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[2]== HIGH ){
      Serial.write("s,2,5,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[3]==HIGH ){
      Serial.write("s,3,6,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[4]== HIGH ){
      Serial.write("s,4,6,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[5]== HIGH ){
      Serial.write("s,5,7,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[6]== HIGH ){
      Serial.write("s,6,6,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[7]== HIGH ){
      Serial.write("s,7,6,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[8]== HIGH ){
      Serial.write("s,8,5,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[9]== HIGH ){
      Serial.write("s,9,5,\0");
      NOREAD_count++;
       delay(10);
    }else if(x_yomi[10]== HIGH ){
      Serial.write("s,a,4,\0");
      NOREAD_count++;
       delay(10);
    }else{
      
    }

    
  }else if(y_yomi[1]== HIGH && bool_2==true){
    if(x_yomi[0]== HIGH){
      Serial.write("s,0,5,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[1]== HIGH ){
      Serial.write("s,1,6,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[2]== HIGH ){
      Serial.write("s,2,6,\0");
       NOREAD_count++;
     delay(10);
     }else if(x_yomi[3]== HIGH ){
      Serial.write("s,3,7,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[4]== HIGH){
      Serial.write("s,4,7,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[5]== HIGH){
      Serial.write("s,5,8,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[6]== HIGH){
      Serial.write("s,6,7,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[7]== HIGH){
      Serial.write("s,7,7,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[8]== HIGH ){
      Serial.write("s,8,6,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[9]== HIGH ){
      Serial.write("s,9,6,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[10]== HIGH ){
      Serial.write("s,a,5,\0");
       NOREAD_count++;
     delay(10);
    }else{
      
    }
    
    
  }else if(y_yomi[2]== HIGH && bool_2 == true){
    if(x_yomi[2]== HIGH){
      Serial.write("s,2,7,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[3]== HIGH){
      Serial.write("s,3,8,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[4]== HIGH){
      Serial.write("s,4,8,\0");
       NOREAD_count++;
     delay(10);
     }else if(x_yomi[5]== HIGH ){
      Serial.write("s,5,9,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[6]== HIGH){
      Serial.write("s,6,8,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[7]== HIGH){
      Serial.write("s,7,8,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[8]== HIGH){
      Serial.write("s,8,7,\0");
       NOREAD_count++;
     delay(10);
    }else{
      
    }
    
    
  }else if(y_yomi[3] && bool_2 == true){
    if(x_yomi[4]== HIGH){
      Serial.write("s,4,9,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[5]== HIGH){
      Serial.write("s,5,a,\0");
       NOREAD_count++;
     delay(10);
    }else if(x_yomi[6]== HIGH){
      Serial.write("s,6,9,\0");
       NOREAD_count++;
     delay(10);
    }else{
      
    }

     
  }/*else if(y_yomi[3]== LOW &&y_yomi[2]== LOW &&y_yomi[1]== LOW &&y_yomi[0]== LOW && x_yomi[0]== LOW && x_yomi[1]== LOW && x_yomi[2]== LOW && x_yomi[4]== LOW && x_yomi[5]== LOW && x_yomi[6]== LOW && x_yomi[7]== LOW && x_yomi[8]== LOW && x_yomi[9]== LOW && x_yomi[10]== LOW && bool_2 == 0){
    bool_2 = true;
     delay(10);
  }*/

  if(NOREAD_count == NOREAD){
    bool_2 = false;
    
  }

  
  for(int i=0; i<11; i++){
    if(i<4){
      if(x_mae[i]!=x_yomi[i] || y_mae[i]!=y_yomi[i]){
        bool_2 == true;
        delay(2);
      }
    }else{
      if(x_mae[i]!=x_yomi[i]){
        bool_2 == true;
        delay(2);
      }
    }
  }
  NOREAD_count = 0;
  }
  
}
