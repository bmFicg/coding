del *.class *.jar
javac -cp "lib/*" MyProject.java
jar -cf myexe.jar *.class
java -Djava.library.path="%cd%\lib" -Dsun.java2d.d3d=false -Djogl.debug.DebugGL -cp "myexe.jar;lib/*" MyProject
