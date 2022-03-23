package sim;

public class Block {

  private String name;
  private int x;
  private int y;
  private int z;

  public Block(String name, int x, int y, int z) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.z = z;
  }

  protected void updateLocation(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  protected String getName(){
    return this.name;
  }

  protected int getX(){
    return this.x;
  }

  protected int getY(){
    return this.y;
  }

  protected int getZ(){
    return this.z;
  }
}
