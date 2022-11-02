# i571b

**Name**:		Sridhar Madala
**B-Number**:	B00977473
**Email**:		smadala2@binghamton.edu

# Programming Languages - Project 1
===================================

 Implementing Parser for the language spcified by the following grammer 

*       val
          : INT
          | '{' initializers '}'
          ;
        initializers
          : initializer ( ',' initializer )* ','? //optional comma after last init
          | //empty
          ;
        initializer
          : '[' INT '] '=' val              //simple designated initializer
          | '[' INT '...' INT ']' '=' val   //range designated initializer
          | val                             //positional initializer
          ;
        

### Requirements
* Python 3.10

### Usage
* Initiate the 'desig-inits' in termninal
* The program will ask for input
* Input the grammer in the terminal and hit enter
* The output will be printed based on grammer rules specified

## Author

**Sridhar Madala**
**B00977473**

