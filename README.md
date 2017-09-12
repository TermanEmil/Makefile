# Makefile
A general recursive makefile

![alt text](https://github.com/TermanEmil/Makefile/blob/master/.images/qwewq.jpg)

This makefile can be used for any project (you only have to modify the compiler name and the .c and .o extension)
It will recompile only the modified .c files, storing all objects in objs directory.

There has to be src and includes folders. In includes all .h files are stored and in src -- all .c files.
The makefile will search recursively in these directories.

It works only on linux.

An example of how to use it is attached: run `make' or `make re'.

rules:
  make
  clean   
  fclean
  run
  sure
