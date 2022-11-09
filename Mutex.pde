class Mutex {
  boolean isAvailable = true;
  boolean read() {
    return isAvailable;
  }
  void take() {
    while (!isAvailable);
    isAvailable = false;
  }
  void give() {
    if (isAvailable) return;
    else isAvailable = true;
    delay(1); // probably not necessary
  }
}
