class Menu {
  boolean[] item;
  boolean isBG, stop;
  String[] itemDetail;
  float mX, mY, mSX, mSY, sRC, sGC, sBC, rRC, rGC, rBC;
  int tmp;
  color strokeColor=color(0), textColor=color(0), bgColor=color(255);
  Menu(String[] iD, float mX, float mY, float mSX, float mSY) {
    itemDetail=new String[iD.length];
    item=new boolean[iD.length];
    for (int i=0; i<iD.length; i++) {
      itemDetail[i]=iD[i];
    }
    this.mX=mX;
    this.mY=mY;
    this.mSX=mSX;
    this.mSY=mSY;
    tmp=9999;
  }
  void draw() {
    pushStyle();
    fill(bgColor);
    noStroke();
    rect(mX, mY, mSX, mSY, 10);
    if (mouseX>=mX&&mouseX<=mX+mSX&&mouseY>=mY&&mouseY<mY+mSY&&!stop) {
      noStroke();
      if (red(bgColor)+green(bgColor)+blue(bgColor)>=382.5) {
        fill(red(bgColor)-63.75, green(bgColor)-63.75, blue(bgColor)-63.75);
      } else {
        fill(red(bgColor)+63.75, green(bgColor)+63.75, blue(bgColor)+63.75);
      }
      if (mousePressed) {
        if (red(bgColor)+green(bgColor)+blue(bgColor)>=382.5) {
          fill(red(bgColor)-127.5, green(bgColor)-127.5, blue(bgColor)-127.5);
        } else {
          fill(red(bgColor)+127.5, green(bgColor)+127.5, blue(bgColor)+127.5);
        }
      }
      rect(mX, (int)(((mouseY-mY)/(mSY/itemDetail.length)))*mSY/itemDetail.length+mY, mSX, mSY/itemDetail.length, 10);
      tmp=(int)(((mouseY-mY)/(mSY/itemDetail.length)));
    } else {
      tmp=9999;
    }
    noFill();
    strokeWeight((mSY+mSX)/150);
    stroke(strokeColor);
    rect(mX, mY, mSX, mSY, 10);
    fill(textColor);
    textAlign(CENTER, CENTER);
    for (int i=0; i<itemDetail.length; i++) {
      if (mSY/itemDetail.length>=mSX/(itemDetail[i].length()+2)) {
        textSize(mSX/(itemDetail[i].length()+2));
      } else {
        textSize(mSY/itemDetail.length);
      }
      text(itemDetail[i], mX+mSX/2, mY+(mSY/itemDetail.length)*i+(mSY/itemDetail.length)/2);
    }
    popStyle();
  }
  void mouseClicked() {
    if (mouseX>=mX&&mouseX<=mX+mSX&&mouseY>=mY&&mouseY<mY+mSY&&!stop) {
      item[(int)(((mouseY-mY)/(mSY/itemDetail.length)))]=true;
    }
  }
  void stop() {
    stop=true;
  }
  void start() {
    stop=false;
  }
}
