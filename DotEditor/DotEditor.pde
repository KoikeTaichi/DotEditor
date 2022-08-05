int massCnt=32, undoCnt;
String tmp, fname;
PrintWriter undoFile;
float[] rX=new float[massCnt], rY=new float[massCnt];
float mass, r, g, b;
String[] a={"clear", "save", "open", "undo", "fill"};
color[][] massColor=new color[massCnt][massCnt];
PImage img, img2;
float smouseX, smouseY;
boolean fill, isPaint[][]=new boolean[massCnt][massCnt];
Slider s, s2, s3;
Menu m;
SelectFile sf;
File f=new File("C:/Users/c011810621/Documents/Processing/お遊び/editor/editor6");
void setup() {
  size(1280, 548);
  stroke(0);
  strokeWeight(1);
  orientation(LANDSCAPE);
  background(255);
  frameRate(120);
  s=new Slider(width/2+height/2+(width-(width/2+height/2))/2-width/16, height/4-height/32, width/8, height/16);
  s2=new Slider(width/2+height/2+(width-(width/2+height/2))/2-width/16, height*2/4-height/32, width/8, height/16);
  s3=new Slider(width/2+height/2+(width-(width/2+height/2))/2-width/16, height*3/4-height/32, width/8, height/16);
  s.sR=255;
  s2.sR=255;
  s3.sR=255;
  s.sC=color(255, 0, 0);
  s2.sC=color(0, 255, 0);
  s3.sC=color(0, 0, 255);
  m=new Menu(a, (width/2+height/2)/75, (width/2+height/2)/75, width/2-height/2-(width/2+height/2)*2/75, height-(width/2+height/2)*2/75);
  fill(255);
  mass=(float)height/massCnt;
  orientation(LANDSCAPE);
  for (int i=0; i<rY.length; i++) {
    rY[i]=mass*i;
  }
  for (int i=0; i<rX.length; i++) {
    rX[i]=mass*i+width/2-height/2;
    for (int j=0; j<rY.length; j++) {
      rect(rX[i], rY[j], mass, mass);
      massColor[i][j]=color(255, 255, 255);
    }
  }
  sf=new SelectFile(f);
  img2=loadImage("pngBackground.png");
}
void draw() {
  if (!sf.open) {
    s.draw();
    s2.draw();
    s3.draw();
    m.draw();
  }
  sf.draw();
  if (sf.fileSelected) {
    if (isImg(sf.openFilePath)) {
      tmp="C:/Users/c011810621/Documents/Processing/お遊び/editor/editor5/data/tmp/tmp_"+undoCnt+".pdot";
      img=loadImage(sf.openFilePath);
      undoFile=createWriter(tmp);
      for (int i=0; i<massCnt; i++) {
        for (int j=0; j<massCnt; j++) {
          undoFile.print(massColor[i][j]+",");
        }
        undoFile.println();
      }
      undoFile.flush();
      undoCnt++;
      fname=sf.openFilePath;
      PImage img;
      img=loadImage(fname);
      img.resize(massCnt, massCnt);
      img.loadPixels();
      background(255);
      for (int i=0; i<massCnt; i++) {
        for (int j=0; j<massCnt; j++) {
          massColor[i][j] = img.pixels[j*massCnt+i];
          fill(massColor[i][j]);
          rect(rX[i], rY[j], mass, mass);
        }
      }
    } else {
      background(255);
      for (int i=0; i<massCnt; i++) {
        for (int j=0; j<massCnt; j++) {
          fill(massColor[i][j]);
          rect(rX[i], rY[j], mass, mass);
        }
      }
    }
    sf.fileSelected=false;
  }
}
void mousePressed() {
  smouseX=mouseX;
  smouseY=mouseY;
  if (mouseX>=width/2-height/2&&mouseX<width/2-height/2+height) {
    tmp="C:/Users/c011810621/Documents/Processing/お遊び/editor/editor5/data/tmp/tmp_"+undoCnt+".pdot";
    if (!sf.open) {
      undoFile=createWriter(tmp);
      for (int i=0; i<massCnt; i++) {
        for (int j=0; j<massCnt; j++) {
          undoFile.print(massColor[i][j]+",");
        }
        undoFile.println();
      }
      undoFile.flush();
      undoCnt++;
      if (fill) {
        int tmpX=(int)((mouseX-width/2+height/2)/mass), tmpY=(int)(mouseY/mass), rightX=0, leftX=0, upY=0, downY=0;
        color tmpColor=massColor[tmpX][tmpY];
        //右を確かめる
        for (int i=tmpX; i<massCnt; i++) {
          if (!checkFill(i, tmpY, tmpColor)) {
            rightX=i-1;
            break;
          }
          if (i==massCnt-1) {
            rightX=i;
          }
        }
        //左を確かめる
        for (int i=tmpX-1; i>=0; i--) {
          if (!checkFill(i, tmpY, tmpColor)) {
            leftX=i+1;
            break;
          }
          if (i==0) {
            leftX=i;
          }
        }
        for (int h=leftX; h<=rightX; h++) {
          //上を確かめる
          for (int i=tmpY-1; i>=0; i--) {
            if (!checkFill(h, i, tmpColor)) {
              upY=i+1;
              break;
            }
            if (i==0) {
              upY=i;
            }
          }
          //下を確かめる
          for (int i=tmpY+1; i<massCnt; i++) {
            if (!checkFill(h, i, tmpColor)) {
              downY=i-1;
              break;
            }
            if (i==0) {
              downY=i;
            }
          }
        }
        paint();
      }
      massColor[(int)((mouseX-width/2+height/2)/mass)][(int)(mouseY/mass)]=color(r, g, b);
      fill(r, g, b);
      rect(rX[(int)((mouseX-width/2+height/2)/mass)], rY[(int)(mouseY/mass)], mass, mass);
    }
  }
}

void mouseDragged() {
  if (mouseX>width/2-height/2&&mouseX<width/2-height/2+height&&mouseY>0&&mouseY<height&&pmouseX>width/2-height/2&&pmouseX<width/2-height/2+height&&pmouseY>0&&pmouseY<height&&!sf.open) {
    fill(r, g, b);
    rect(rX[(int)((mouseX-width/2+height/2)/mass)], rY[(int)(mouseY/mass)], mass, mass);
    massColor[(int)((mouseX-width/2+height/2)/mass)][(int)(mouseY/mass)]=color(r, g, b);
    connectLine();
  }
}
void connectLine() {
  int tmp=(int)((mouseX-width/2+height/2)/mass)-(int)((pmouseX-width/2+height/2)/mass);
  int tmp2=(int)(mouseY/mass)-(int)(pmouseY/mass); 
  if (tmp>=1&&tmp2>=1) {
    if (tmp>=tmp2) {
      tmp/=tmp2;
      tmp2=1;
    } else {
      tmp2/=tmp;
      tmp=1;
    }
    int tmp3=(int)((pmouseX-width/2+height/2)/mass), tmp4=(int)(pmouseY/mass);
    while (!(rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]||rY[tmp4]==rY[(int)(mouseY/mass)])) {
      for (int i=1; i<=tmp; i++) {
        tmp3++;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
      for (int i=1; i<=tmp2; i++) {
        tmp4++;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
    }
    if (rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]) {
      for (int i=tmp4; i<(int)(mouseY/mass); i++) {
        rect(rX[tmp3], rY[i], mass, mass);
        massColor[tmp3][i]=color(r, g, b);
      }
    } else {
      for (int i=tmp3; i<(int)((mouseX-width/2+height/2)/mass); i++) {
        rect(rX[i], rY[tmp4], mass, mass);
        massColor[i][tmp4]=color(r, g, b);
      }
    }
  } else if (tmp<=-1&&tmp2>=1) {
    if (abs(tmp)>=tmp2) {
      tmp/=tmp2;
      tmp2=1;
    } else if (abs(tmp)<tmp2) {
      tmp2/=abs(tmp);
      tmp=-1;
    }
    int tmp3=(int)((pmouseX-width/2+height/2)/mass), tmp4=(int)(pmouseY/mass);
    while (!(rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]||rY[tmp4]==rY[(int)(mouseY/mass)])) {
      for (int i=-1; i>=tmp; i--) {
        tmp3--;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
      for (int i=1; i<=tmp2; i++) {
        tmp4++;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
    }
    if (rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]) {
      for (int i=tmp4; i<(int)(mouseY/mass); i++) {
        rect(rX[tmp3], rY[i], mass, mass);
        massColor[tmp3][i]=color(r, g, b);
      }
    } else {
      for (int i=tmp3; i>(int)((mouseX-width/2+height/2)/mass); i--) {
        rect(rX[i], rY[tmp4], mass, mass);
        massColor[i][tmp4]=color(r, g, b);
      }
    }
  } else if (tmp<=-1&&tmp2<=-1) {
    if (tmp<=tmp2) {
      tmp/=tmp2;
      tmp*=-1;
      tmp2=-1;
    } else {
      tmp2/=tmp;
      tmp2*=-1;
      tmp=-1;
    }
    int tmp3=(int)((pmouseX-width/2+height/2)/mass), tmp4=(int)(pmouseY/mass);
    while (!(rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]||rY[tmp4]==rY[(int)(mouseY/mass)])) {
      for (int i=-1; i>=tmp; i--) {
        tmp3--;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
      for (int i=-1; i>=tmp2; i--) {
        tmp4--;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
    }
    if (rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]) {
      for (int i=tmp4; i>(int)(mouseY/mass); i--) {
        rect(rX[tmp3], rY[i], mass, mass);
        massColor[tmp3][i]=color(r, g, b);
      }
    } else {
      for (int i=tmp3; i>(int)((mouseX-width/2+height/2)/mass); i--) {
        rect(rX[i], rY[tmp4], mass, mass);
        massColor[i][tmp4]=color(r, g, b);
      }
    }
  } else if (tmp>=1&&tmp2<=-1) {
    if (tmp>=abs(tmp2)) {
      tmp/=abs(tmp2);
      tmp2=-1;
    } else if (tmp<abs(tmp2)) {
      tmp2/=tmp;
      tmp=1;
    }
    int tmp3=(int)((pmouseX-width/2+height/2)/mass), tmp4=(int)(pmouseY/mass);
    while (!(rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]||rY[tmp4]==rY[(int)(mouseY/mass)])) {
      for (int i=1; i<=tmp; i++) {
        tmp3++;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
      for (int i=-1; i>=tmp2; i--) {
        tmp4--;
        rect(rX[tmp3], rY[tmp4], mass, mass);
        massColor[tmp3][tmp4]=color(r, g, b);
      }
    }
    if (rX[tmp3]==rX[(int)((mouseX-width/2+height/2)/mass)]) {
      for (int i=tmp4; i>(int)(mouseY/mass); i--) {
        rect(rX[tmp3], rY[i], mass, mass);
        massColor[tmp3][i]=color(r, g, b);
      }
    } else {
      for (int i=tmp3; i<(int)((mouseX-width/2+height/2)/mass); i++) {
        rect(rX[i], rY[tmp4], mass, mass);
        massColor[i][tmp4]=color(r, g, b);
      }
    }
  } else if (tmp>=1&&tmp2==0) {
    for (int i=(int)((pmouseX-width/2+height/2)/mass); i<(int)((mouseX-width/2+height/2)/mass); i++) {
      rect(rX[i], rY[(int)(pmouseY/mass)], mass, mass);
      massColor[i][(int)(pmouseY/mass)]=color(r, g, b);
    }
  } else if (tmp<=-1&&tmp2==0) {
    for (int i=(int)((pmouseX-width/2+height/2)/mass); i>(int)((mouseX-width/2+height/2)/mass); i--) {
      rect(rX[i], rY[(int)(pmouseY/mass)], mass, mass);
      massColor[i][(int)(pmouseY/mass)]=color(r, g, b);
    }
  } else if (tmp==0&&tmp2>=1) {
    for (int i=(int)(pmouseY/mass); i<(int)(mouseY/mass); i++) {
      rect(rX[(int)((pmouseX-width/2+height/2)/mass)], rY[i], mass, mass);
      massColor[(int)((pmouseX-width/2+height/2)/mass)][i]=color(r, g, b);
    }
  } else if (tmp==0&&tmp2<=-1) {
    for (int i=(int)(pmouseY/mass); i>(int)(mouseY/mass); i--) {
      rect(rX[(int)((pmouseX-width/2+height/2)/mass)], rY[i], mass, mass);
      massColor[(int)((pmouseX-width/2+height/2)/mass)][i]=color(r, g, b);
    }
  }
}
void mouseClicked() {
  if (!sf.open) {
    m.mouseClicked();
    if (m.item[0]) {
      fill(255);
      for (int i=0; i<rX.length; i++) {
        for (int j=0; j<rY.length; j++) {
          rect(rX[i], rY[j], mass, mass);
          massColor[i][j]=color(255, 255, 255);
        }
      }
      m.item[0]=false;
    }
    if (m.item[1]) {
      PImage img = createImage(massCnt, massCnt, ARGB);//画面を画像にコピー
      img.loadPixels();
      for (int i=0; i<massCnt; i++) {
        for (int j=0; j<massCnt; j++) {
          img.pixels[j*massCnt+i] = massColor[i][j];
        }
      }
      img.updatePixels();
      img.save("C:/Users/c011810621/Documents/Processing/お遊び/editor/editor5/data/pict_" + 
        year() + month() + day() + hour() + minute() + second() + ".png");
      m.item[1]=false;
    }
    if (m.item[2]) {
      sf.open();
      m.item[2]=false;
    }
    if (m.item[3]) {
      if (undoCnt>=1) {
        fname="C:/Users/c011810621/Documents/Processing/お遊び/editor/editor5/data/tmp/tmp_"+(undoCnt-1)+".pdot";
        String undoData[]=loadStrings(fname);
        for (int i=0; i<rX.length; i++) {
          String massData[]=split(undoData[i], ",");
          for (int j=0; j<rY.length; j++) {
            massColor[i][j]=parseInt(massData[j]);
            fill(parseInt(massData[j]));
            rect(rX[i], rY[j], mass, mass);
          }
        }
        undoCnt--;
      }
      m.item[3]=false;
    }
    if (m.item[4]) {
      if (!fill) {
        fill=true;
      } else {
        fill=false;
      }
      m.item[4]=false;
    }
  } else {
    sf.mouseClicked();
  }
}
void mouseReleased() {
  r=s.sV;
  g=s2.sV;
  b=s3.sV;
}
void keyPressed() {
  if (keyCode==24) {
    s.sV=255;
  } else if (keyCode==25) {
    s.sV=0;
  }
  r=s.sV;
  g=s2.sV;
  b=s3.sV;
}
boolean isImg(String path) {
  if (path.indexOf(".png")!=-1||sf.openFilePath.indexOf(".jpg")!=-1||sf.openFilePath.indexOf("bmp")!=-1) {
    return true;
  } else {
    return false;
  }
}
boolean checkFill(int x, int y, color fCl) {
  //println("x:"+x+"\n"+"y:"+y);
  if (massColor[x][y]==fCl&&isPaint[x][y]==false) {
    isPaint[x][y]=true;
    return true;
  } else {
    return false;
  }
}
void paint() {
  boolean isPainted=false;
  fill(r, g, b);
  for (int i=0; i<isPaint.length; i++) {
    if (!isPainted) {
      for (int j=0; j<isPaint[i].length; j++) {
        if (isPaint[i][j]==true) {
          if (massColor[i][j]==color(r, g, b)) {
            isPainted=true;
          }
          rect(rX[i], rY[j], mass, mass);
          massColor[i][j]=color(r, g, b);
          isPaint[i][j]=false;
        }
      }
    }
  }
  for (int i=0; i<massCnt; i++) {
    for (int j=0; j<massCnt; j++) {
      isPaint[i][j]=false;
    }
  }
  fill=false;
}
