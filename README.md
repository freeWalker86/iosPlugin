iosPlugin
=========

Use NSBundle to implement plugin in iOS. OS X use NSBundle to implement plugin, so i  use it in ios, even though `Xcode` can't create bundle direct from template, but you can create a `OS X` bundle and then change it to `ios`.



Project Explain
================
================

FWPluginBundle 
===============
It is a bundle project, changed from os x bundle project by change arch, and link UIKit framework. It use static library and static framework for test, objective-C class , C Function and so on.
FWStaticFramework,FWStaticLibrary
=================================

It is a simple static framework and Library project which target used in FWPluginBundle.

FWPluginTestStub
================

It is a stub app to dynamic load bundle from local or server ,then run executable file in bundle.

Test Features:  

*  create `principalClass` instance and run.
*  get class from `classNamed`, create instance and run.
*  get C Function pointer and run. 
*  send Notification between stub app and bundle.



The MIT License
---------------
Wax is Copyright (C) 2014 freeWalker86 See the file LICENSE for information of licensing and distribution.

