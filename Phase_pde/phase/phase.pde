int longueurRect = 700;
int hauteurRect = 100;
int nbRectangle = 5;
int nbTrait = 35; // doit etre un multiple de longueurRect
int margin = 10;

MyContener c;

void setup(){
  size(1024, 768, P2D);
  //smooth(2);
  frameRate(40);
  background(0,0,0);
  c = new MyContener(nbRectangle);
}

void draw(){
  background(0,0,0);
  c.display();
  println(frameRate);
}

/** Contient les rectangles, ajuste leurs positions **/
class MyContener{
  int nbRect;
  MyRect[] r;
  
  MyContener(int nbrect){
    nbRect=nbrect;
    r = new MyRect[nbRect];
    for(int i=0; i<nbRect; i++){
      int x1 = (width/2)-(longueurRect/2);  
      int x2 = longueurRect;
      int y1=0;
      int y2 = hauteurRect;
      if(nbRect==1){
        y1 = (height/2)-(hauteurRect/2);
      }
      else{
        y1 = (height/2)-(((nbRect*hauteurRect)/2) + (((nbRect-1)*margin)/2))+ (i*(hauteurRect+margin));
      }
      r[i]= new MyRect(x1,y1,x2,y2,nbTrait);
    }
  }

  void display(){
      for(int i=0; i<nbRect;i++){
        r[i].display();
      }
    }
}

class MyRect{
  int x1;
  int y1;
  int x2;
  int y2;
  int nbLine;
  MyTriangle[] l;
  
  MyRect(int X1, int Y1, int X2, int Y2, int nbline){
    x1 = X1;
    y1 = Y1;
    x2 = X2;
    y2 = Y2;
    nbLine =nbline;
    l = new MyTriangle[nbLine];
    int dephasage = (int)random(longueurRect/nbline);
    int sens = (int)random(2);
    for(int i=0;i<nbline;i++){
      l[i] = new MyTriangle(x1,y1,i,nbline,dephasage,sens);
    }
   }
   
  void display(){
    noFill();
    stroke(255,255,255);
    rect(x1,y1,x2,y2);
      
    for(int i=0;i<nbTrait;i++){
      l[i].deplacement();
      l[i].display();
    }
    //masque côté gauche
    fill(0);
    noStroke();
    rect(x1-hauteurRect-1,y1-1,hauteurRect+1,hauteurRect+1);
  }
}

class MyLine{ 
  
  /** Points de la line **/
  int x1Line;
  int y1Line;
  int x2Line;
  int y2Line;
  
  /** Point du rectangle **/
  int x1Rect; 
  int y1Rect;
  int x2Rect;
  int y2Rect;
  
  /** Point de l'intervale de déplacement de la line **/
  int start;
  int end;
  int sens;
  int increment;
  int dephasage;  
  int pas;        // ecart entre 2 lines
  int nbline;     // nombre de ligne totale dans le rectangle
  
  MyLine(int X1, int Y1, int increment, int nbline,int dephasage, int sens){ // le pas correspond a l'incrément de la boucle des lines
    this.dephasage = dephasage; 
    this.nbline = nbline;
    this.sens = sens;
    this.pas = (longueurRect/nbline);
    int decalage = calculdecalage(increment);
    this.start = X1+decalage+dephasage;
    this.increment = increment;
    x1Line = start;
    y1Line = Y1;
    x2Line = x1Line;
    y2Line = Y1+hauteurRect;
    x1Rect = X1;
    y1Rect = Y1;
    x2Rect = X1+longueurRect;
    y2Rect = Y1+hauteurRect;
    
    end = calculEnd();
  }
  
  void display(){
    line(x1Line, y1Line, x2Line, y2Line);
  }
  
  void deplacement(){
    /** Sens de gauche à droite **/
    if(sens == 0){
      if(dephasage != 0){
        /** Si la ligne sors du rectangle **/  
        if(x1Line >= x2Rect){
          x1Line=x1Rect;
          x2Line = x1Line;
        }
        /** Si la ligne atteint son arrivée dans le cas normal **/
        if(x1Line >= end && x1Line >= start && start < end){
          x1Line=start;
          x2Line = x1Line; 
        }
        /** Si la ligne atteint son arrivé dans le cas ou start est après l'arrivée **/
        if(x1Line >= end && x1Line <= start && start > end){
          x1Line=start;
          x2Line = x1Line; 
        }
      }
      if(dephasage == 0){
        if(x1Line>= end){
           x1Line=start;
           x2Line = x1Line; 
        }
      }  //<>//
      x1Line+=1; //<>//
      x2Line=x1Line; //<>//
    }
    /** Sens de droite à gauche**/
    if(sens == 1){
      if(dephasage != 0){
        /** Si la ligne sors du rectangle **/  
        if(x1Line <= x1Rect){
          x1Line=x2Rect;
          x2Line = x1Line;
        }
        /** Si la ligne atteint son arrivée dans le cas normal **/
        if(x1Line <= start && x1Line <= end && start < end){
          x1Line=end;
          x2Line = x1Line; 
        }
        /** Si la ligne atteint son arrivé dans le cas ou start est après l'arrivée **/
        if(x1Line <= start && x1Line >= end && start > end){
          x1Line=end;
          x2Line = x1Line; 
        }
      }
      if(dephasage == 0){
        if(x1Line<= start){
           x1Line=end;
           x2Line = x1Line; 
        }
      }
      x1Line-=1;
      x2Line=x1Line;
    }
  }
  
  /** Calcul le point de départ du point en fonction de l'incrément **/
  int calculdecalage(int Pas){
    if(Pas==0){return 0;}
    else{
      return((longueurRect/nbline)*Pas);
    }
  }
  /** Calcul le point d'arrivée de la ligne **/
  int calculEnd(){
    // Si l'arrivée est dans le rectangle
    if((start+pas) <= x2Rect){
      return (start+pas);
    }
    // si l'arrivée est en dehors du rectangle
    if ((start+pas) > x2Rect){
      return(x1Rect + dephasage);
    }
    else return 0;
  }
}

class MyTriangle{ 
  
  /** Points de la line **/
  int x1Triangle;
  int y1Triangle;
  int x2Triangle;
  int y2Triangle;
  int x3Triangle;
  int y3Triangle;
  
  /** Point du rectangle **/
  int x1Rect; 
  int y1Rect;
  int x2Rect;
  int y2Rect;
  
  /** Point de l'intervale de déplacement de la line **/
  int start;
  int end;
  int sens;
  int increment;
  int dephasage;  
  int pas;        // ecart entre 2 lines
  int nbline;     // nombre de ligne totale dans le rectangle
  
  MyTriangle(int X1, int Y1, int increment, int nbline,int dephasage, int sens){ // le pas correspond a l'incrément de la boucle des lines
    this.dephasage = dephasage; 
    this.nbline = nbline;
    this.sens = sens;
    this.pas = (longueurRect/nbline);
    int decalage = calculdecalage(increment);
    this.start = X1+decalage+dephasage;
    this.increment = increment;
    x1Triangle = start;
    y1Triangle = Y1;
    x2Triangle = x1Triangle;
    y2Triangle = Y1+hauteurRect;
    x3Triangle = x1Triangle - hauteurRect;
    y3Triangle = y1Triangle + (hauteurRect/2);
    x1Rect = X1;
    y1Rect = Y1;
    x2Rect = X1+longueurRect;
    y2Rect = Y1+hauteurRect;
    
    end = calculEnd();
  }
  
  void display(){
    triangle(x1Triangle, y1Triangle, x2Triangle, y2Triangle,x3Triangle, y3Triangle);
  }
  
  void deplacement(){
    /** Sens de gauche à droite **/
    if(sens == 0){
      if(dephasage != 0){
        /** Si la ligne sors du rectangle **/  
        if(x1Triangle >= x2Rect){
          x1Triangle=x1Rect;
          x2Triangle = x1Triangle;
          x3Triangle = x1Triangle - hauteurRect;
          
        }
        /** Si la ligne atteint son arrivée dans le cas normal **/
        if(x1Triangle >= end && x1Triangle >= start && start < end){
          x1Triangle=start;
          x2Triangle = x1Triangle; 
          x3Triangle = x1Triangle - hauteurRect;
        }
        /** Si la ligne atteint son arrivé dans le cas ou start est après l'arrivée **/
        if(x1Triangle >= end && x1Triangle <= start && start > end){
          x1Triangle=start;
          x2Triangle = x1Triangle;
          x3Triangle = x1Triangle - hauteurRect;
        }
      }
      if(dephasage == 0){
        if(x1Triangle>= end){
           x1Triangle=start;
           x2Triangle = x1Triangle;
           x3Triangle = x1Triangle - hauteurRect;
        }
      } 
      x1Triangle+=1;
      x2Triangle=x1Triangle;
      x3Triangle +=1;
    }
    /** Sens de droite à gauche**/
    if(sens == 1){
      if(dephasage != 0){
        /** Si la ligne sors du rectangle **/  
        if(x1Triangle <= x1Rect){
          x1Triangle=x2Rect;
          x2Triangle = x1Triangle;
          x3Triangle = x1Triangle - hauteurRect;
        }
        /** Si la ligne atteint son arrivée dans le cas normal **/
        if(x1Triangle <= start && x1Triangle <= end && start < end){
          x1Triangle=end;
          x2Triangle = x1Triangle;
          x3Triangle = x1Triangle - hauteurRect;
        }
        /** Si la ligne atteint son arrivé dans le cas ou start est après l'arrivée **/
        if(x1Triangle <= start && x1Triangle >= end && start > end){
          x1Triangle=end;
          x2Triangle = x1Triangle; 
          x3Triangle = x1Triangle - hauteurRect;
        }
      }
      if(dephasage == 0){
        if(x1Triangle<= start){
           x1Triangle=end;
           x2Triangle = x1Triangle;
           x3Triangle = x1Triangle - hauteurRect;
        }
      }
      x1Triangle-=1;
      x2Triangle=x1Triangle;
      x3Triangle -=1;
    }
  }
  
  /** Calcul le point de départ du point en fonction de l'incrément **/
  int calculdecalage(int Pas){
    if(Pas==0){return 0;}
    else{
      return((longueurRect/nbline)*Pas);
    }
  }
  /** Calcul le point d'arrivée de la ligne **/
  int calculEnd(){
    // Si l'arrivée est dans le rectangle
    if((start+pas) <= x2Rect){
      return (start+pas);
    }
    // si l'arrivée est en dehors du rectangle
    if ((start+pas) > x2Rect){
      return(x1Rect + dephasage);
    }
    else return 0;
  }
}
