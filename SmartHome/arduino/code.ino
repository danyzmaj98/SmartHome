#include <IRLibSendBase.h>
#include <IRLib_HashRaw.h>
#include <IRLibRecvPCI.h>
#include "codes.h"
IRsendRaw mySender;
IRrecvPCI myReceiver(2);  // Arduino UNO pin 2

char btValue = 0;
uint16_t readValue;
void setup()
{
  Serial.begin(9600);
  myReceiver.enableIRIn();
  delay(2000);
}
uint16_t codes[300];
void loop()
{
  if (Serial.available() > 0)
  {
    btValue=Serial.read();
    Serial.println(btValue);
    switch (btValue) { 
      case 'a':
        for(uint16_t i = 0; i<RAW_DATA_LENa; i++)
          {
            readValue = pgm_read_word(&a[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa,32);
        break;      

      case 'b':
        for(uint16_t i = 0; i<RAW_DATA_LENb; i++)
          {
            readValue = pgm_read_word(&b[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENb,32);
        
        break;

      case '6':
      for(uint16_t i = 0; i<RAW_DATA_LENa16; i++)
          {
            readValue = pgm_read_word(&a16[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa16,32);
        break;

      case '7':
      for(uint16_t i = 0; i<RAW_DATA_LENa17; i++)
          {
            readValue = pgm_read_word(&a17[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa17,32);
        break;

      case '8':
      for(uint16_t i = 0; i<RAW_DATA_LENa18; i++)
          {
            readValue = pgm_read_word(&a18[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa18,32);
        break;

      case '9':
      for(uint16_t i = 0; i<RAW_DATA_LENa19; i++)
          {
            readValue = pgm_read_word(&a19[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa19,32);
        break;

      case '0':
      for(uint16_t i = 0; i<RAW_DATA_LENa20; i++)
          {
            readValue = pgm_read_word(&a17[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa20,32);
        break;

      case '1':
      for(uint16_t i = 0; i<RAW_DATA_LENa21; i++)
          {
            readValue = pgm_read_word(&a21[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa21,32);
        break;

      case '2':
      for(uint16_t i = 0; i<RAW_DATA_LENa22; i++)
          {
            readValue = pgm_read_word(&a22[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa22,32);
        break;

      case '3':
      for(uint16_t i = 0; i<RAW_DATA_LENa23; i++)
          {
            readValue = pgm_read_word(&a23[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa23,32);
        break;

      case '4':
      for(uint16_t i = 0; i<RAW_DATA_LENa24; i++)
          {
            readValue = pgm_read_word(&a24[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa24,32);
        break;

      case '5':
      for(uint16_t i = 0; i<RAW_DATA_LENa25; i++)
          {
            readValue = pgm_read_word(&a25[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENa25,32);
        break;

      case 't':
      for(uint16_t i = 0; i<RAW_DATA_LENt; i++)
          {
            readValue = pgm_read_word(&t[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENt,32);
        break;

      case 'p':
      for(uint16_t i = 0; i<RAW_DATA_LENp; i++)
          {
            readValue = pgm_read_word(&p[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENp,32);
        break; 

      case 'm':
      for(uint16_t i = 0; i<RAW_DATA_LENm; i++)
          {
            readValue = pgm_read_word(&m[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENm,32);
        break; 

      case 'd':
      for(uint16_t i = 0; i<RAW_DATA_LENd; i++)
          {
            readValue = pgm_read_word(&d[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENd,32);
        break;

      case 'u':
      for(uint16_t i = 0; i<RAW_DATA_LENu; i++)
          {
            readValue = pgm_read_word(&u[i]);
            codes[i] = readValue;
          }
        mySender.send(codes,RAW_DATA_LENu,32);
        break; 

      default:
      btValue = 0;
      
       } 
        

    }
  


 
    if (myReceiver.getResults()) {
    Serial.println("\n\n-------------------------");
    Serial.println("Received IR signal:");

    Serial.print(F("\n#define RAW_DATA_LEN "));
    Serial.println(recvGlobal.recvLength, DEC);

    Serial.print(F("uint16_t rawData[RAW_DATA_LEN]={\n"));
    for (bufIndex_t i = 1; i < recvGlobal.recvLength; i++) {
      Serial.print(recvGlobal.recvBuffer[i], DEC);
      Serial.print(F(", "));
      if ((i % 8) == 0) {
        Serial.print(F("\n"));
      }
    }
    Serial.println(F("1000};"));
    Serial.println("-------------------------");

    myReceiver.enableIRIn();
  }
  }
  

  
