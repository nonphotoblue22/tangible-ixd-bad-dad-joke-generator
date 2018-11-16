// MIDTERM: DadBot: Joke Generator
// Didn't get around to image manipulation

///////
////// Imports
///// 

// import a serial library giving us access to all the serial port functionality
// https://processing.org/reference/libraries/serial/index.html
import processing.serial.*;


///////
////// Vars
///// 

// arduino stuff

// make a new Serial object called myPort
Serial myPort;
String value;
int potLevel, buttonVal = 0;

// fonts

PFont staticFont;
PFont jokeFont;
int topPaddingStaticCopy = 45;

// random helper vars
int startTime;

// Layers & Images

// Layers so that stuff doesn't get redrawn I guess?
// declaring new PGraphics Objects in the program
PGraphics copyLayer;
PGraphics pointLayer;

// Initialize Dad Images
PImage dadImgLow;
PImage dadImgMed;
PImage dadImgHi;
PImage dadImgUltimate;


// Dad Jokes

// Dad Joke Level "Status"
Boolean[] dadJokeLevel= {
  false,
  false,
  false,
  false,
};

// Setting up the dadJokes!
String[][] dadJokeLow = {
  {
    "Did you hear about the guy who invented Lifesavers?",
    "They say he made a mint."
  },
  {
    "How do you make a Kleenex dance?",
    "Put a little boogie in it!"
  },
  {
    "Me: 'Hey, I was thinking…'",
    "My dad: 'I thought I smelled something burning.'"
  },
  {
    "Me: 'Dad, make me a sandwich!'",
    "Dad: 'Poof, You’re a sandwich!'"
  }
}; 

String[][] dadJokeMed = {
  {
    "How do you make holy water?",
    "You boil the hell out of it."
  },
  {
    "What is Beethoven's favorite fruit?",
    "A ba-na-na-na."
  },
  {
    "Two peanuts were walking down the street.",
    "One was a salted."
  }
};

String[][] dadJokeHi = {
  {
    "Did you hear the news?",
    "FedEx and UPS are merging. \nThey’re going to go by the name Fed-Up \nfrom now on."
  },
  {
    "What's Forrest Gump's password?",
    "1forrest1"
  },
  {
    "I used to have a job at a calendar factory",
    "but I got the sack because I took a couple \nof days off."
  }
};

String[][] dadJokeUltimate = {
  {
    "Why do chicken coops only have two doors?",
    "Because if they had four, they would \nbe chicken sedans!"
  },
  {
    "Two guys walk into a bar",
    "The third one ducks."
  },
  {
    "I had a dream that I was a muffler last night.",
    "I woke up exhausted!"
  },
  {
    "A three-legged dog walks into a bar and says to the bartender,",
    "'I'm looking for the man who shot my paw.'"
  }
};

// instructions & labels ... static text
String instructions[] = {
  "Hello!",
  "I am Dad-Bot",
  "Please press a button to tell a joke."
};

String labels[] = {
  "dad joke level",
  "low",
  "med",
  "hi",
  "ultra"
};

int randomJokeLow, randomJokeMed,randomJokeHi, randomJokeUlt;

///////
////// Setup
///// 

void setup(){
  size(1024, 600);
  background(255);

  //printArray(Serial.list());
  // grab the right name from that list and make it our port name
  String portName = Serial.list()[3];
  // set up our Serial object to belong to our sketch (this), to connect to the right port
  // and to communicate at baud 9600
  myPort = new Serial(this, portName, 9600);
  
  staticFont = createFont("Georgia", 18);
  jokeFont = createFont("Mono", 21);
    
  // construct PGraphics image for stuff later
  copyLayer = createGraphics(width, height);
  
  // Load Dad Images
  dadImgLow = loadImage("images/dadLevelLow.jpg");
  dadImgMed = loadImage("images/dadLevelMed.jpg");
  dadImgHi = loadImage("images/dadLevelHi.jpg");
  dadImgUltimate = loadImage("images/dadLevelUltimate.jpg");


  noStroke();
  // placeholder for dadbot picture\
  println("setup() complete.");
}


///////
////// Draw
///// 

void draw(){  
  
  // arduino values
  // if serial data on our port is available
  if ( myPort.available() > 0) {
    // read a chunk of it until we get to the EOL character (see the Arduino sketch)
    // and store it in the 'value' container
    value = myPort.readStringUntil('\n');         
  }
  // here is some cleanup:
  // let's make sure the value is not null
  // it can happen if there is a communication error - we can disregard those errors
  if( value != null ){
    // trim some possible white space junk
    // just in case
    value = value.trim();
    // make an array of integers; split the String we received from the serial port ('value')
    // into chunks at the "TAB" symbols; convert the resulting chunks into integers
    int mysensors[] = int(split(value, '\t'));
    
    //make sure we have all 3 values
    if(mysensors.length == 2){
      //assign those values to the corrresponding variables
      potLevel = mysensors[0];
      buttonVal = mysensors[1];
    }
  }
    
  textFont(staticFont); 

  // placeholder image area
  fill(255);

  // meter code
  
  // meter bg
  //fill(200,200,200);
  rect(100, 400, 320, 45);
  
  // place holder for meter bar movement 
  fill(30,30,30);
  float mappedPotLevel = map(potLevel, 0, 1024, 0, 320);
  rect(100, 390, mappedPotLevel, 15);
  
  
  // begin rotation change photo code
  
  // basically taking the mapped potLevel and exchanging  
  // photo based on the 4 divisions of 320 while
  // also setting a boolean value up in dadJokeLevel to  
  // run the correct set of jokes when the button is pressed
  // 


  if (mappedPotLevel < 90) {
    //println("set to DadJokeLow & change photo");
    setDadValue(0);
    text("Dad Level: Normal Dad", 100, 430);
    image(dadImgLow, 100, 80, 320, 320);

  } else if (mappedPotLevel < 180) {
    //println("set to DadJokeMed & change photo");
    setDadValue(1);
    text("Dad Level: Sports Dad", 100, 430);
    image(dadImgMed, 100, 80, 320, 320);
  } else if (mappedPotLevel < 270) {
    //println("set to DadJokeHi & change photo");
    setDadValue(2);
    text("Dad Level: Gramps", 100, 430);
    image(dadImgHi, 100, 80, 320, 320);
  } else {
    //println("set to DadJokeUltimate & change photo");
    setDadValue(3);
    text("Dad Level: ULTIMATE", 100, 430);
    image(dadImgUltimate, 100, 80, 320, 320);
  }

  //printArray(dadJokeLevel);
  //println(buttonVal);
    //// draw instruction copy
    copyLayer.beginDraw();
      // run all the stuff for first layer of pGraphics object called copyLayer
      copyLayer.background(255); // create bg
      copyLayer.fill(33); // set Fill
      //copyLayer.textFont(titleFont); // set font to title copy
      copyLayer.textFont(jokeFont); 
      // button pressed code
      if(buttonVal == 1) {
        // NOT DRY... NOT DONE
        randomJokeLow = int(random(0, dadJokeLow.length));
        randomJokeMed = int(random(0, dadJokeMed.length));
        randomJokeHi = int(random(0, dadJokeHi.length));
        randomJokeUlt = int(random(0, dadJokeUltimate.length));
        String joke;
        // check what's the current dad joke level in dadJokeLevel[]
        for(int i = 0; i < dadJokeLevel.length; i++) {
          // if low
          if (dadJokeLevel[0]) {
            // could be abstracted to a function that outputs a string...
            // test 2d arrays
            joke = dadJokeLow[randomJokeLow][0];
            copyLayer.text(joke, 480, 278);
            joke = dadJokeLow[randomJokeLow][1];
            copyLayer.text(joke, 480, 320);
          } 
          // if medium
          else if (dadJokeLevel[1]) {
            // test 2d arrays
            joke = dadJokeMed[randomJokeMed][0];
            copyLayer.text(joke, 480, 278);
            joke = dadJokeMed[randomJokeMed][1];
            copyLayer.text(joke, 480, 320);
          }
          // if medium
          else if (dadJokeLevel[2]) {
            // test 2d arrays
            joke = dadJokeHi[randomJokeHi][0];
            copyLayer.text(joke, 480, 278);
            joke = dadJokeHi[randomJokeHi][1];
            copyLayer.text(joke, 480, 320);
          } 
          // im max
          else if (dadJokeLevel[3]) {
          // test 2d arrays
            joke = dadJokeUltimate[randomJokeUlt][0];
            copyLayer.text(joke, 480, 278);
            joke = dadJokeUltimate[randomJokeUlt][1];
            copyLayer.text(joke, 480, 320);
          }
        }
    copyLayer.endDraw();
    image(copyLayer, 0, 0); // show image

  }
  
  //println("this is the end of draw");

}


///////
////// Helper Functions
/////

// clear the boolean array values before setting the true ones
void setDadValue(int val) {
  for (int i = 0; i < dadJokeLevel.length; i++) {
    dadJokeLevel[i] = false;
  }
  dadJokeLevel[val] = true;
}