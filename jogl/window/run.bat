@echo off
REM recompile everything
REM -d64 not entirely sure if i put the right jogl files, otherwise on x32 system you should get an error
@echo on
del *.class *.jar
javac -cp "lib/*" MyProject.java
jar -cf myexe.jar *.class
java -d64 -Djava.library.path="%cd%\lib" -Dsun.java2d.d3d=false -Djogl.debug.DebugGL -cp "myexe.jar;lib/*" MyProject
