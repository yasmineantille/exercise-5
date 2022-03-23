package sim;

import cartago.Artifact;
import cartago.LINK;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import java.util.*;

public class BlockDetector extends Artifact {

private int simCounter = 0;
private State state = State.NEUTRAL;
private Map<Block, Double> detections = new HashMap();
private final Block blockA = new Block("A", 100, 150, 0);
private final Block blockB = new Block("B", 150, 100, 0);
private final Block blockC = new Block("C", 100, 150, 5);


private enum State {

    NEUTRAL,
    PIKCUP_LOCATION,
    PLACE_LOCATION;

    static Block blockOfInterest = null;
  }

  @OPERATION
  private void detect() {

    switch(simCounter) {
      case 0:
        detections.put(blockA, 0.2);
        detections.put(blockB, 0.2);
        detections.put(blockC, 0.9);
        break;
      case 1:
        detections.put(blockA, 0.9);
        detections.put(blockB, 0.9);
        detections.put(blockC, 0.9);
        break;
      default:
        break;
    }

    for (Block block : detections.keySet()) {
      Double weight = detections.get(block);
      signal("positioned", block.getName(), block.getX(), block.getY(), block.getZ(), weight);
    }

    simCounter++;
  }

  @LINK
  public void updateDetections(List<Integer> coordinates) {
    List<Block> possibleMoves = new ArrayList<Block>();
    for (Block block : detections.keySet()) {
      if (coordinates.get(0).equals(block.getX()) &&
        coordinates.get(1).equals(block.getY())) {
          possibleMoves.add(block);
        }
    }
    Optional<Block> upperBlock = possibleMoves.stream().max(Comparator
      .comparing(Block::getZ));
    if (upperBlock.isPresent() && this.state == State.NEUTRAL) {
      this.state = State.PIKCUP_LOCATION;
      State.blockOfInterest = upperBlock.get();
      //if ("C".equals(upperBlock.get().getName())) {
      //  simulateExternalIntervention();
      //}
    }
    else if (upperBlock.isPresent() && this.state == State.PIKCUP_LOCATION) {
      this.state = State.PLACE_LOCATION;
      Block boi = State.blockOfInterest;
      int newZ = upperBlock.get().getZ() + 5;
      boi.updateLocation(coordinates.get(0), coordinates.get(1), newZ);
      signal("positioned", boi.getName(), boi.getX(), boi.getY(), boi.getZ(), 0.9);
      this.state = State.NEUTRAL;
    }
    else if (!upperBlock.isPresent() && this.state == State.PIKCUP_LOCATION) {
      this.state = State.PLACE_LOCATION;
      Block boi = State.blockOfInterest;
      boi.updateLocation(coordinates.get(0), coordinates.get(1), 0);
      signal("positioned", boi.getName(), boi.getX(), boi.getY(), 0, 0.9);
      this.state = State.NEUTRAL;
    }
  }


  private void simulateExternalIntervention(){
    blockB.updateLocation(150, 200, 0);
    detections.put(blockB, 0.9);
    signal("positioned", blockB.getName(), blockB.getX(), blockB.getY(), 0, 0.9);
  }
}
