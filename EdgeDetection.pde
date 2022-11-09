//import processing.video.*; 

PImage newImg, _img;
String newUrl, _url;
int[][] kernel = {{-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1}};
float percentChange = 0.10;
int threshold = int(255 * percentChange);
int boost = int(1 / (1 - percentChange));
int viewTime = 2000;
//Capture cam;
boolean imageLoaded = false;

void setup() {
  size(1600, 800);
  //cam = new Capture(this);
  //cam.start();
  thread("loadNewImage");
  //noLoop();
}

void draw() {
  if (imageLoaded) {
    _url = newUrl;
    _img = newImg;
    imageLoaded = false;
    thread("loadNewImage");
    PImage edgeImg = findEdges(_img);
    background(0);
    image(_img, 0, 0, 800, 800); 
    image(edgeImg, 800, 0, 800, 800);
    //saveFrame("./dataset/" + split(_url, '-')[1] + ".png");
    println(frameRate);
  } 
}

void loadNewImage() {
  JSONObject json = loadJSONObject("https://random.imagecdn.app/v1/image?width=800&height=800&format=json");
  String imageUrl = json.getString("url") + ".jpg";
  delay(viewTime);
  newUrl = imageUrl;
  newImg = loadImage(newUrl);
  //cam.read();
  imageLoaded = true;
}

PImage findEdges(PImage img) {
  PImage edgeImg = createImage(img.width, img.height, RGB);
  loadPixels();
  for (int y = 1; y < img.height - 1; y++) {
    for (int x = 1; x < img.width - 1; x++) {
      int sumR = 0, sumG = 0, sumB = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int xpos = x + kx;
          int ypos = y + ky;
          int pos = ypos * img.width + xpos;
          color point = img.pixels[pos];
          int valR = int(red(point));
          int valG = int(green(point));
          int valB = int(blue(point));
          sumR += kernel[ky+1][kx+1] * valR;
          sumG += kernel[ky+1][kx+1] * valG;
          sumB += kernel[ky+1][kx+1] * valB;
        }
      }
      int pos = y * img.width + x;
      int brightness = min(max(boost * (max(sumR, sumG, sumB) - threshold), 0), 255);
      edgeImg.pixels[pos] = color(brightness);
    }
  }
  updatePixels();
  return edgeImg;
}
