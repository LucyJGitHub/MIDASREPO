/*********************************************************************/
/*                                                                   */
/*       SCC2454MP9 - LUC109 - Delete BOB savf                       */
/*                                                                   */
/*       (c) Finastra International Banking Systems Ltd. 2016        */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/**/                                                                  
/* Attempt to delete BOB INTERFACE save savfile */                    
/**/                                                                  
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                
             CHGVAR     VAR(&INT_SAVF) VALUE(&BOB_SAVF)               
             CHGVAR     VAR(%SST(&INT_SAVF 1 2)) VALUE('IF')          
             DLTF       FILE(&LIB/&INT_SAVF)                          
             MONMSG     MSGID(CPF2105)                                
/**/                                                                  
/* CREATE INT save file in ASP defined in data variable &CB_AUTO */   
/**/                                                                  
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))          
             CRTSAVF    FILE(&LIB/&INT_SAVF) TEXT('INTERFACE BOB +
                          save file for Auto COB') ASP(&ASP) +
                          AUT(*LIBCRTAUT)                             
/**/                                                                  
/* Save the database library                     */                   
/**/                                                                  
             CHGVAR     VAR(&library) VALUE(&SYSID *CAT 'INTFLIB')    
                                                                      
             CHGVAR     VAR(&save_type) VALUE('DISK')                 
                                                                      
             CHGVAR     VAR(&SAVE_FILE) VALUE('IFxxx     xxDILIB   ') 
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&INT_SAVF)    
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)      
                                                                      
             CHGVAR     VAR(&DEVICE) VALUE('          ')              
             CHGVAR     VAR(&VOLID) VALUE(&BOB_SAVF)                  
                                                                      
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)                  
                                                                      
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                         
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO) 
                   CHGJOB     SWS(XXXXXX11)                           
                   GOTO       CMDLBL(ABNORMAL)                        
             ENDDO       
                                                                      
             ELSE       CMD(SNDPGMMSG MSG('Database save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))        
                                                                      
             ENDDO       
/*********************************************************************/
/* End of hook SCC2454MP9                                            */
/*********************************************************************/
