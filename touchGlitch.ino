//the variables
float val = 0;        // the value read by sesnor
int msg;             // the value sent to processing
float threshold = 13;


void setup() {
  pinMode(A0, INPUT);
  Serial.begin(9600);
}

void loop() {
  val = analogRead(A0);
  // if value is less that the threshold send the green light to processing
  if (val < threshold) {
    msg = 1;
  }
  else{msg = 0;}
  Serial.println(msg);

}
