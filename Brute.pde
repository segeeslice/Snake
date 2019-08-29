class Brute {
  BruteQueue queue;
  BruteQueue visited;
  
  Brute () {
    queue = new BruteQueue();
    visited = new BruteQueue();
  }
    
  Boolean processInput () {
   snake.setDirection('D');
   
   return snake.moveAuto();
  }
}
