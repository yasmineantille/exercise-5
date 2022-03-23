/* Initial beliefs */
angularDisplacement(200,150,0).
angularDisplacement(150,200,256).
angularDisplacement(100,150,512).
angularDisplacement(150,100,768).

/* Initial goals */
!linkArtifacts.

/* Plan for achieving linkArtifacts */
+!linkArtifacts : true <-
  lookupArtifact(leubot1,Leubot1Id);
  lookupArtifact(detector1,Detector1Id);
  linkArtifacts(Leubot1Id,"detector1",Detector1Id);
.
