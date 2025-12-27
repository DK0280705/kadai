PImage img1;
PImage img2;

int currentImageId = 1;

void setup () { 
  size (640, 480, P3D); 
  img1 = loadImage("test1.png");      // 「test.png」という画像ファイルを読み込む 
  img2 = loadImage("test2.png");      // 「test2.png」という画像ファイルを読み込む
  // set resizable
  surface.setResizable(true);
} 
 
// メインルーチン 
void draw() {
  background (160, 255, 255); // 背景を水色にする
  // Get mouse pointer location

  switch (currentImageId) {
    case 1:
      image(img1, mouseX - img1.width/2, mouseY - img1.height/2);      // 画像を x=100, y=50 の位置に描く 
      break;
    case 2:
      image(img2, mouseX - img2.width/2, mouseY - img2.height/2);      // 画像を x=100, y=50 の位置に描く
      break;
  }
}

void keyPressed() {
  if (key == '1') {
    currentImageId = 1;
  } else if (key == '2') {
    currentImageId = 2;
  }
}
