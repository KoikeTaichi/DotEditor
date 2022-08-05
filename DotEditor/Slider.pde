import select.files.*;

class Slider {
  float sX, sY, sSX=100, sSY=100, sR=100, sV=100;
  color sC=color(0, 0, 0);
  Slider(float sX, float sY, float sSX, float sSY) {
    this.sX=sX;
    this.sY=sY;
    this.sSX=sSX;
    this.sSY=sSY;
    sV=0;
  }
  void draw() {
    pushStyle();
    if (red(sC)+green(sC)+blue(sC)>=382.5) {
      fill(red(sC)-127.5, green(sC)-127.5, blue(sC)-127.5);
    } else {
      fill(red(sC)+127.5, green(sC)+127.5, blue(sC)+127.5);
    }
    rect(sX, sY, sSX, sSY);
    noStroke();
    fill(sC);
    rect(sX, sY, (sSX/sR)*sV, sSY);
    textAlign(RIGHT, BOTTOM);
    if (red(sC)+green(sC)+blue(sC)>=382.5) {
      fill(0);
    } else {
      fill(255);
    }
    textSize(sSY/2);
    text((int)sV, sX+sSX, sY+sSY);
    if (mousePressed) {
      if (mouseX>=sX&&mouseX<=sX+sSX&&mouseY>=sY&&mouseY<sY+sSY) {
        sV=(mouseX-sX)/(sSX/sR);
      } else if (pmouseX>=sX&&pmouseX<=sX+sSX&&pmouseY>=sY&&pmouseY<sY+sSY) {
        if (mouseX>=sX+sSX) {
          sV=sR;
        } else if (mouseX<=sX) {
          sV=0;
        }
      }
    } 
    popStyle();
  }
}
