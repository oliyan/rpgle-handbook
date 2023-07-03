**free                                                        
  exec sql SET OPTION COMPILEOPT = 'DBGVIEW(*SOURCE)';        
                                                              
                                                              
  dcl-s count packed(2) inz(1);                               
  dcl-s result packed(2);                                     
  dcl-s finalResult varchar(50);                              
                                                              
  dcl-c TRUE const('1');                                      
  dcl-c START const(1);                                       
  dcl-c END const(20);                                        
  dcl-c COMMA const (',');                                    
                                                              
  for count = START to END;                                   
    if count = START;                                         
      finalResult = %char(count);                             
      else;                                                         
    finalResult = %trim(finalResult) + COMMA + %char(count);    
  endif;                                                        
endfor;                                                         
                                                                
dsply finalResult;                                              
*inlr = TRUE;                                                   