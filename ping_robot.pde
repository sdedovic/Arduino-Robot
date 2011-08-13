/* please ignore any spelling errors. 
Thanks. also, feel free to use this 
for whatever you want. 
(as long as i get to see thoes creations)
*/

#include <AFMotor.h>
AF_DCMotor motor(2, MOTOR12_1KHZ);
AF_DCMotor turn(1, MOTOR12_1KHZ); //Motor Shield Stuff


int pingPin = A5; // 

int turnDelay = 2000; //how long a turn is. A larger number means a larger turn. and vice versa.

void setup(){ //runs the motor for a really short time and then waits 3 sec. 
              //This just gives me time to put the motor down before it starts up.
  motor.setSpeed(175);  
  turn.setSpeed(255);   
  motor.run(FORWARD);
  delay(25);
  motor.run(RELEASE);
  delay(3000);
}

void loop(){
  int distance = 7; //distance, in inches, that triggers the turn sequence 
  
  
  int x = 0;
  x = ping(); //get distance

  
  if(x > distance){ 
    motor.run(FORWARD); 
  }
  
  else if(x < distance){
    
    motor.run(BACKWARD); //instantly stop
    delay(250);
    left();
    motor.run(RELEASE);  //THIS RELEASE AND DELAY IS ESSENTIAL.
    delay(100);
    
   /*  So about that comment above. I found out that after turning the robot in any direction, 
       the use of both the turning motor/servo and the movement motor used up all the power for the device. 
       So everytime the robot turns, I make sure to wait a little after cutting off power to both motors.
       This ensures that the ping))) sensor recieves all the power from the batteries. 
       Then it reruns the loop and checks the distance, and either moves foward or turns. 
   */
   
  }  
}


unsigned long ping(){ //arduino ping example: http://www.arduino.cc/en/Tutorial/Ping
  long duration, inches, cm;
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);
  return inches; 
}

void left(){ //turns the robot to the left
    turn.run(BACKWARD);
    delay(turnDelay - 100);
    turn.run(FORWARD);
    delay(100);
    motor.run(FORWARD);
    delay(turnDelay);
    turn.run(RELEASE);
}

void right(){ //turns the robot to the right
  turn.run(FORWARD);
    delay(turnDelay - 100);
    turn.run(BACKWARD);
    delay(100);    
    motor.run(FORWARD);
    delay(turnDelay);   
    turn.run(RELEASE);
}

long microsecondsToInches(long microseconds) //more ping stuff
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds) //even more ping stuff
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

