##-----------------------------------------------------------##
##  Task 1                                                   ##
##-----------------------------------------------------------##
# T1. Write a program that prints the numbers from 1 to 100.  #
# But for multiples of three print "Hello" instead of the     #
# number and for the multiples of five print "World".         #
# For numbers which are multiples of both three and five      #
# print "Hello World".                                        #
##-----------------------------------------------------------##

for(i in 1:100){
    if(i%%3 == 0){
        if(i%%5 ==0){
            print("Hello World")
        }else{
            print("Hello")
        }
    }else{
        if(i%%5 ==0){
            print("World")
        }else{
            print(i)
        }
    }
}
