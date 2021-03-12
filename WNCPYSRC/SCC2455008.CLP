/*********************************************************************/
/*                                                                   */
/*       SCC2455008 - LUC109 - Save xxINTFLIB                        */
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
/* If this is a test system do not save xxINTFLIB.                    
                                                                      
/*           IF         COND((&SYSID *NE 'CI') *AND (&SYSID *NE +
                          'LN') *AND (&SYSID *NE 'NY') *AND (&SYSID +
                          *NE 'SI') *AND (&SYSID *NE 'UL') *AND +
                          (&SYSID *NE 'UE')) THEN(CHGVAR +
                          VAR(&LUC109) VALUE(' '))                 */ 
             IF         COND((&SYSID *NE 'LS') *AND (&SYSID *NE +
                          'PS') *AND (&SYSID *NE 'MS') *AND (&SYSID +
                          *NE 'AS')) THEN(CHGVAR VAR(&LUC109) +
                          VALUE(' ')) 

             IF         COND((&LIVE *NE 'Y')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          
/**/                                                                  
/* Save the database library XXINTFLIB           */                   
/**/                                                                  
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                
             CHGVAR     VAR(&INT_SAVF) VALUE(&BOB_SAVF)               
             CHGVAR     VAR(%SST(&INT_SAVF 1 2)) VALUE('IF')          
/**/                                                                  
             CHGVAR     VAR(&LIBRARY) VALUE(&SYSID *CAT 'INTFLIB')    
                                                                      
             CHGVAR     VAR(&SAVE_FILE) VALUE('IFxxx     xxDILIB   ') 
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&INT_SAVF)    
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)      
                                                                      
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)                  
/**/                                                                  
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                         
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO) 
                  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO) 
                   CHGJOB     SWS(XXXXXX11)                           
                   GOTO       CMDLBL(ABNORMAL)                        
             ENDDO       
             ELSE       CMD(SNDPGMMSG MSG('Database save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))        
             ENDDO       
/*********************************************************************/
/* End of hook SCC2455008                                            */
/*********************************************************************/
