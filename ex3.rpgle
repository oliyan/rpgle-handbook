**free                                                      
  exec sql SET OPTION COMPILEOPT = 'DBGVIEW(*SOURCE)';      
                                                            
  dcl-ds nineth_table;                                      
    *n char(4) inz('9 X ');                                 
    this_numc char(2);                                      
    *n char(2) inz('= ');                                   
    result_numc char(2);                                    
  end-ds;                                                   
                                                            
  dcl-s finalResult varchar(50);                            
  dcl-s count packed(2) inz(1);                             
  dcl-s this_num packed(1) inz(9);                          
  dcl-s result_num packed(2);                               
                                                            
  dcl-c TRUE const('1');                                    
  dcl-c START const(1);                                
dcl-c END const(10);                                 
                                                     
                                                     
for count = 1 to 10;                                 
  result_num = count*this_num;                       
  result_numc = %char(result_num);                   
  this_numc = %char(count);                          
  finalResult = %trim(%char(nineth_table));          
  dsply finalResult;                                 
endfor;                                              
                                                     
*inlr = TRUE;                                        