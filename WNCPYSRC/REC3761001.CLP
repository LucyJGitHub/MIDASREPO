/*********************************************************************/             
/*                                                                   */             
/*       REC3761001 - LUC114 - Switchability   REC3761               */             
/*                                                                   */             
/*       (c) Finastra International Banking Systems Ltd. 2019        */             
/*                                                                   */             
/*       Last Amend No. LUC114             Date 24Jan19              */             
/*                                                                   */             
/*-------------------------------------------------------------------*/             
/*                                                                   */             
/*       LUC114 - Change Layout of Interest Capitalization Report    */             
/*                                                                   */             
/*********************************************************************/             
/* Check if LUC114 is enabled. */                                                   
                                                                                    
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                
             CHGVAR     VAR(&PSARD) VALUE('LUC114')                                 
             CHGVAR     VAR(&LUC114) VALUE('N')                                     
                                                                                    
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)            
                                                                                    
             IF COND(&PRTCD *EQ '       ') THEN(DO)                                 
             CHGVAR     VAR(&LUC114) VALUE('Y')                                     
             ENDDO                                                                  
                                                                                    
             IF         COND(&LUC114 *EQ 'Y') THEN(DO)                              
             OVRPRTF    FILE(XX3764DR) TOFILE(*LIBL/XX3764DR) +
                          SPLFNAME(RE3764DR)                                        
             OVRPRTF    FILE(XX3764CR) TOFILE(*LIBL/XX3764CR) +
                          SPLFNAME(RE3764CR)                                        
             CALL       PGM(XX3761) PARM(&BJLANG)                                   
             ENDDO                                                                  
             ELSE       CMD(DO)                                                     
/*********************************************************************/             
/* End of hook REC3761001                                            */             
/*********************************************************************/             
