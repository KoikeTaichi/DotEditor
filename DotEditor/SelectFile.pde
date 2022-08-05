class SelectFile { //<>//
  boolean[] item;
  boolean isBG, open,fileSelected;
  float mX, mY, mSX, mSY, sRC, sGC, sBC, rRC, rGC, rBC;
  File[] list;
  Menu m;
  String[] paths, iD={"back"}, undoFilePaths={};
  String currentLocation,openFilePath;
  int undoCnt;
  Camera cam; 
  int tmp, tmpCnt;
  color strokeColor=color(0), textColor=color(0), bgColor=color(255);
  SelectFile(File path) {
    m=new Menu(iD, width/32, height/2-width/32, width/16, width/16);
    list=path.listFiles();
    currentLocation=path.getAbsolutePath();
    println(currentLocation);
    paths=new String[list.length];
    for (int i=0; i<list.length; i++) {
      paths[i]=list[i].getName();
    }
    cam=new Camera();
    cam.pos.y=0;
    item=new boolean[list.length];
    mX=width/8;
    mY=0;
    mSX=width-width/8;
    mSY=height;
    tmp=9999;
  }
  void draw() {
    if (open) {
      if (mousePressed) {
        cam.pos.y-=mouseY-pmouseY;
        if (cam.pos.y<=0||list.length*(mSY/20)<=height) {
          cam.pos.y=0;
        } else if (cam.pos.y+height>=list.length*(mSY/20)) {
          cam.pos.y=list.length*(mSY/20)-height;
        }
      }
      pushMatrix();
      translate(-cam.pos.x, -cam.pos.y);
      pushStyle();
      background(bgColor);
      fill(bgColor);
      noStroke();
      rect(0, 0, width, height);
      if (mouseX>=mX&&mouseX<=mX+mSX&&mouseY>=mY&&mouseY<mY+mSY&&(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))<list.length&&(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))>=0) {
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
        rect(mX, (int)(((mouseY+cam.pos.y-mY)/(mSY/20)))*mSY/20+mY, mSX, mSY/20);
        tmp=(int)(((mouseY+cam.pos.y-mY)/(mSY/20)));
      } else {
        tmp=9999;
      }
      fill(textColor);
      textAlign(LEFT, CENTER);
      for (int i=0; i<paths.length; i++) {
        textSize(mSY/20);
        text(paths[i], mX+mSY/20, mY+(mSY/20)*i+(mSY/20)/2);
      }
      popStyle();
      popMatrix();
      m.draw();
    }
  }
  void mouseClicked() {
    if (open) {
      m.mouseClicked();
      if (mouseX>=mX&&mouseX<=mX+mSX&&mouseY>=mY&&mouseY<mY+mSY&&tmpCnt>=1&&(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))<list.length&&(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))>=0) {
        if (list[(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))].isDirectory()) {
          moveFile(list[(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))]);
        }else{
          openFilePath=list[(int)(((mouseY+cam.pos.y-mY)/(mSY/20)))].getAbsolutePath();
          close();
          fileSelected=true;

        }
      }
      if (m.item[0]) {
        if (undoCnt>=1) {
          undoMoveFile();
        }
        m.item[0]=false;
      }
      tmpCnt++;
    }
  }
  void close() {
    open=false;
  }
  void open() {
    open=true;
  }
  void moveFile(File path) {
    list=path.listFiles();
    undoFilePaths=append(undoFilePaths, "");
    undoFilePaths[undoCnt]=currentLocation;
    currentLocation=path.getAbsolutePath();
    println(currentLocation);
    paths=new String[list.length];
    for (int i=0; i<list.length; i++) {
      paths[i]=list[i].getName();
    }
    undoCnt++;
    cam.pos.x=0;
    cam.pos.y=0;
  }
  void undoMoveFile() {
    File tmpFile=new File(undoFilePaths[undoCnt-1]);
    list=tmpFile.listFiles();
    currentLocation=tmpFile.getAbsolutePath();
    println(currentLocation);
    paths=new String[list.length];
    for (int i=0; i<list.length; i++) {
      paths[i]=list[i].getName();
    }
    undoCnt--;
    cam.pos.x=0;
    cam.pos.y=0;
  }
}
