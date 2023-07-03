**free                                            
     dcl-c TRUE const('1');                       
     dcl-c FALSE const('0');                      
                                                  
      dcl-s wk_num packed(5) Inz(5);              
      dcl-s wk_num1 packed(5) Inz(5);             
     monitor;                                     
       wk_num1 = 0;                               
       wk_num = wk_num/wk_num1;                   
     on-error;                                    
       dsply 'trying to divide by zero';          
     endmon;                                      
     wk_num = 5;                                  
     *inlr = TRUE;                                