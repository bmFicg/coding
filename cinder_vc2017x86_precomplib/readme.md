
<br />

Going through the very first tutorials on [Cinder](https://libcinder.org/)  
Unfortunately Cinder supports for now only VC++2015.  
And when the dependencies were up-to-date, back then Bresenham was experimenting with a line drawing algorithm.
<br />
<br />
###  Make sure you have a local copy of [Cinder 0.9.2dev](https://github.com/cinder/Cinder)
```bash 
mkdir C:\[floder of your choice]\CinderDev
cd CinderDev
git clone --recursive https://github.com/cinder/Cinder.git
```  
<br />

### How use the precompiled lib

=> download & unzip  
=> drag and drop to the existing Cinder folder (e.g CinderDev)  
=> in the Windows No file overwrite prompt  
=> Confirm with yes!  
##### It is important that you don't change the path, it shold be: lib > x86 > debug /release folder > v141 > cinder.lib 
The build on my machine takes up to 1,6Gb. I uploading just the Debug/Release libraries make sure you choose the right settings in your Visual Studio Build Configruration  
DEBUG_ANGLE therefore is not supported  
For reason of Githubs upload limitations (25Mb per file) i hosted the files on mediafire  

 Start coding! :art:
 <br />   
---   
##### Build with:
- [Visual Studio 2017 Community](https://www.visualstudio.com/de/vs/community/)
- [boost 1.64.0](http://www.boost.org/) 
- [GLM 0.9.8.4](http://glm.g-truc.net/0.9.8/index.html)
- [Notepad++](https://notepad-plus-plus.org/)

http://www.mediafire.com/file/5lcmz2p24d778dh/cinder_vc2017x86_precomplib.zip
