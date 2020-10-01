# TDiff
Delphi component to list differences between two integer arrays.  Typically, this component is used to diff 2 text files.

 Component	TDiff                                                      
 Version:	4.1                                                        
 Date:		7 November 2009                                            
 Compilers:	Delphi 7 - Delphi 2009                                     
 Author:	Angus Johnson - angusj-AT-myrealbox-DOT-com                
 Copyright:	© 2001-2009 Angus Johnson                                  
                                                                              
## Licence to use, terms and conditions:                                        
The code in the TDiff component is released as freeware provided you agree to the following terms & conditions:    
 1. the copyright notice, terms and conditions are left unchanged                                             
 2. modifications to the code by other authors must be clearly documented and accompanied by the modifier's name. 
 3. the TDiff component may be freely compiled into binary format and no acknowledgement is required. However, a discrete acknowledgement would be appreciated (eg. in a program's 'About Box').                                    
                                                                              
##  Description:
Component to list differences between two integer arrays using a "longest common subsequence" algorithm.            
Typically, this component is used to diff 2 text files once their individuals lines have been hashed.             
                                                                              
## Acknowledgements: 
The key algorithm in this component is based on:           
"An O(NP) Sequence Comparison Algorithm"  by Sun Wu, Udi Manber & Gene Myers                         
And uses a "divide-and-conquer" technique to avoid using exponential amounts of memory as described in:       
"An O(ND) Difference Algorithm and its Variations" By E Myers - Algorithmica Vol. 1 No. 2, 1986, pp. 251-266  
