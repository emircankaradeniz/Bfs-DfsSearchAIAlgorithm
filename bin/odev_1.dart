
import 'dart:math';

import 'package:test/expect.dart';

void main(){
  List<List<State>> grid = List<List<State>>.generate(10, (i) => List<State>.generate(10, (index) => State(Coordinate(i, index), 1), growable: false), growable: false);
  grid[2][0].color = 0;
  grid[1][1].color = 0; grid[2][1].color = 0; grid[4][1].color = 0; grid[8][1].color = 0;
  grid[5][2].color = 0; grid[7][2].color = 0;
  grid[6][3].color = 0;
  grid[2][4].color = 0;
  grid[2][5].color = 0; grid[8][5].color = 0;
  grid[1][6].color = 0; grid[2][6].color = 0; grid[3][6].color = 0; grid[7][6].color = 0; grid[9][6].color = 0;
  grid[5][7].color = 0; grid[7][7].color = 0;
  grid[0][8].color = 0; grid[6][8].color = 0; grid[9][8].color = 0;
  grid[5][9].color = 0;
  //Görseldeki 10x10 ızgara grafiği elle oluşturuyoruz.
  Problem problem = Problem(10, 10, Coordinate(1,7), Coordinate(6,2), grid); // Görseldeki başlangıç ve amaç durumlarına göre problemi oluşturuyoruz.


  // Toplam derinliği, toplam maliyeti ve eylemlerin Başlangıç durumundan Amaç durumuna kadar olan sıralı listesini yazdıracak.
  //graphSearchDFS(problem); // Eylem listesi -> [[0,1], [1,1], ...., [0,-1]] şeklinde listeyi yazdması yeterli.
  List<Node> expand(Node n, Problem p){
    // Burayı doldurun
    List<Node> children =[];
    Coordinate cor = n.coor;
    for(List<State> s in grid){
      for(State st in s){
        if(st.coor.x==cor.x+1 && st.coor.y==cor.y){
          if(st.color==1){
            Action act=Action(1, 0, 100);
            Node newNode=Node(st.coor, act, n, st);
            children.add(newNode);
          }
        }
        else if(st.coor.x==cor.x-1 && st.coor.y==cor.y){
          if(st.color==1){
            Action act=Action(-1, 0, 100);
            Node newNode=Node(st.coor, act, n, st);
            children.add(newNode);
          }
        }
        else if(st.coor.x==cor.x && st.coor.y==cor.y+1){
          if(st.color==1){
            Action act=Action(0, 1, 100);
            Node newNode=Node(st.coor, act, n, st);
            children.add(newNode);
          }
        }
        else if(st.coor.x==cor.x && st.coor.y==cor.y-1){
          if(st.color==1){
            Action act=Action(0, -1, 100);
            Node newNode=Node(st.coor, act, n, st);
            children.add(newNode);
          }
        }
      }
    }
    /* Bir düğümün çocuk düğümlerini bulmak için izin verilen eylemler (Siyaha gidilemez, sadece yukarı, aşağı, sağa ve sola gidilebilir)
      çerçevesinde oluşturulan düğümleri liste olarak döndürür. Döndürülen listedeki düğümler fonksiyonda açık listeye eklenir. */
    return children;
  }
  List<String> path = [];
  List<String> getPath(Node n){
    // Burayı doldurun
    // Girilen çözüm düğümü için, ilk düğüme ulaşana kadar ebeveyn düğümleri ziyaret edip
    // Ziyaret edilen düğümlerdeki Action öğesini path listesine ekleyecek.
    // Recursive yazmak daha kolay, içine girilen path listesini sonuç olarak yazdırabilirsiniz.
    if(n.parent != null){
      getPath(n.parent);
      String str=n.cost.toString()+" "+n.depth.toString()+" "+n.action.toString()+" "+n.coor.toString();
      path.add(str);
    }
    return path;
  }
  List<String> graphSearchBFS(Problem problem){
    List<State> closed = []; //kordinat ve renk tuatan sınıfın listesi
    Queue<Node> open = Queue();
    State stateNode=State(problem.start, 1);
    Action actionNode = Action(0, 0, 0);
    Node root=Node.initState(problem.start, actionNode,stateNode );
    open.add(root);
    open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
    // Burayı doldurun
    while(true){

      if(open.empty()) {
        break;
      }else{
        Node node=open.pop();
        if(node.state.coor.toString()==problem.goal.toString()){
          return getPath(node);
        }else if(expand(node, problem).isNotEmpty && !closed.contains(node.state)){
          for(Node newNode in expand(node,problem)){
            open.add(newNode);
          }

        }else if(closed.contains(node.state)){
          continue;
        }
        closed.add(node.state);
      }
    }
    return [];
  }
  void Genislet(){
    List<Node> children =[];
  }
  List<String> graphSearchDFS(Problem problem){
    // Burayı doldurun
    List<State> closed =[];
    Stack<Node> open = Stack();
    State stateNode=State(problem.start, 1);
    Action actionNode = Action(0, 0, 0);
    Node root=Node.initState(problem.start, actionNode,stateNode );
    open.add(root);
    open.push(Node.initState(problem.start, Action(0, 0, 0), problem.grid[problem.start.x][problem.start.y]));
    while(true){
      if(open.empty()){
        break;
      }else{
        Node node =open.pop();
        if(node.state.coor.toString()==problem.goal.toString()){
          return getPath(node);
        }
        if(closed.contains(node.state)){
          continue;
        }
        if(expand(node, problem).isNotEmpty && !closed.contains(node.state)) {
          for (Node newNode in expand(node, problem)) {
            open.add(newNode);
          }
        }
        closed.add(node.state);
        open.add(node);
      }
    }
    return [];
  }
  print("---------Breadth-First Search----------");
  for(String str in graphSearchBFS(problem) ){
    print(str);
  }
  print("---------Depth-First Search-------------");
  for(String str in graphSearchDFS(problem) ){
    print(str);
  }
  print("bitti");
}
class Node{ // Arama Ağacındaki Düğümleri temsil eden sınıf
  Node(this.coor, this.action, this.parent, this.state): depth = parent.depth + 1, cost = parent.cost + action.cost;
  Node.initState(this.coor, this.action, this.state): parent = null, depth = 0, cost = 0; // İlk durumu temsil eden düğüm, ebeveyn düğümü null, derinlik ve maliyeti = 0

  Coordinate coor; // Düğümün koordinatı (x, y)
  int depth, cost; // Depth -> derinlik, cost -> düğüme kadar olan maliyet toplamı.
  Action action;   // Düğüme getiren eylem
  var parent;      // Düğümün ebeveyn düğümü, (kök düğüm için null)
  State state;     // Ağaçtaki düğümün graf üzerinde temsil ettiği durum. (Aynı durum birden fazla düğüm tarafından temsil edilebilir.)

  @override
  String toString(){
    return '${coor.toString()}, $depth, $cost, ${(state.color == 0)?'Siyah':'Beyaz'}, $action';
  }
}



class Problem{ // Izgara grafik, başlangıç ve amaç durumların koordinatlarının tutulduğu sınıf
  int w, h; // w ve h ızgara grafiğin enini ve boyunu temsil eder.
  Coordinate start, goal; // start başlangıç durumunun, goal ise amaç durumunun koordinatlarını tutar.
  List<List<State>> grid; // Durumların tutulduğu 2 boyutlu liste, örn. grid[0][0], x = 0 ve y = 0 olan durumu tutar.

  Problem(this.w, this.h, this.start, this.goal, this.grid); // Grafiğin elle girildiği constructor
  Problem.random(this.w, this.h, this.start, this.goal): grid = List<List<State>>.generate(h, (i) => List<State>.generate(w, (index) => State(Coordinate(i, index), Random().nextInt(2)), growable: false), growable: false);

  @override
  String toString(){
    String res = 'Grid $h x $w\n';
    for(int i=0;i<w;i++){
      for(int j=0;j<h;j++){
        res += '${grid[i][j].toString()} | ';
      }
      res += '\n';
    }
    return '$res\n***************';
  }
}



class State{  // Grafikteki durumları temsil eden sınıf.
  Coordinate coor; // x ve y -> 0 ile (problem bouyutu-1) arasında olabilir. Durumun haritadaki konumunu temsil eder.
  int color; // 0 = siyah, 1 = beyaz
  State(this.coor, this.color);

  @override
  String toString(){
    return 'Row: ${coor.x} | Col: ${coor.y} | ${(color == 0) ? 'Siyah' : 'Beyaz'} ';
  }

}
class Coordinate{
  int x, y; // Izgara grafik üzerinde Durumun x ve y koordinatları.
  // (x = 0, y = 0) sol üst köşe, x arttıkça sağa, y arttıkça aşağı yönde ilerler.
  // (x, y) = (3, 4) durumunda, eylem = [0, 1] yapılırsa => (x, y) = (3, 5) durumuna gelinir.

  Coordinate(this.x, this.y);

  @override
  String toString(){
    return '($x, $y)';
  }
}
class Action{ // Ajanın yapabileceği hareketi temsil eden sınıf.
  int x, y; // x ve y [-1, 0, 1] olabilir. Yapılan eylemi temsil eder.
  // [0, 1]  -> Bir adım aşağı
  // [0, -1] -> Bir adım yukarı
  // [1, 0]  -> Bir adım sağa
  // [-1, 0] -> Bir adım sola
  int cost; // Eylemin maliyetini temsil eder.
  Action(this.x, this.y, this.cost);

  @override
  String toString(){
    return '[$x, $y]';
  }
}
class Stack<E>{
  Stack(): _storage = <E>[];

  final List<E> _storage;

  @override
  String toString() {
    return '--- Top ---\n'
        '${_storage.reversed.join('\n')}'
        '\n-----------';
  }
  @override
  void add(E e){
    _storage.add(e);
  }

  void push(E element) => _storage.add(element);
  bool empty() {
    if (_storage.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  E pop() => _storage.removeLast();
  int length() => _storage.length;
}
class Queue<Node>{
  Queue(): _storage = <Node>[];

  final List<Node> _storage;

  @override
  void add(Node node){
    _storage.add(node);
  }
  void addList(List<Node> node){
    for(Node n in node){
      _storage.add(n);
    }
  }
  @override
  String toString() {
    return '--- Top ---\n'
        '${_storage.reversed.join('\n')}'
        '\n-----------';
  }

  void push(Node element) => _storage.add(element);
  bool empty(){
    if(_storage.isEmpty) {
      return true;
    }else{
      return false;
    }

  }
  Node pop() => _storage.removeAt(0);
  int length() => _storage.length;
}