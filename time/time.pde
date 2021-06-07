float s = 0;

//1回のみ繰り返す
void setup(){
  size(600,600);
  //デフォルトは毎秒60フレーム
  frameRate(10);
  background(0);
}

//無限ループ
void draw(){
  //サイズを1ずつ大きくしていく
  s += 1;
  //色の指定
  fill(random(255),0,255,50);
  noStroke();
  //ランダムな場所に円を配置していく
  ellipse(random(width),random(height),s,s);

  //もし、大きさが45より大きくなったら実行される
  if (s > 45) {
    //サイズを0に戻す
    s = 0;
  }

}
