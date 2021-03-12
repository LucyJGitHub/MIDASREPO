/*********************************************************************/
/*                                                                   */
/*       SCC07MP4   - LUC109 - Delete SV files                       */
/*                                                                   */
/*       (c) Finastra International Banking Systems Ltd. 2016        */
/*                                                                   */
/*       Last Amend No. LUC109             Date 19Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/*                                                                    
/** Check for Switchable Feature LUC109.                              
/** If active, restore xxINTFLIB from savefile xxDILIB/DBIF.          
/*                                                                    
                                                                      
             CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' 'LUC109') 
             IF         COND(&PRTCD *EQ ' ') THEN(DO)                 
             CHGVAR     VAR(&LIB3) VALUE(&LIBID *CAT 'INTFLIB')       
 /**/                                                                 
             DLTDTAARA  DTAARA(&LIB3/SDSTAT)                          
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/ACCOLDSV)                          
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/EODCLPDSV)                         
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/FEANADSDSV)                        
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/FECRFTIPSV)                        
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/FEPOLTIPSV)                        
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             DLTF       FILE(&LIB3/FEPTFTIPSV)                        
             MONMSG     MSGID(CPF0000)                                
 /**/                                                                 
             RSTLIB     SAVLIB(&LIB3) DEV(*SAVF) SAVF(&LIB2/DBIF) +
                          OUTPUT(*PRINT)                              
             ENDDO       
/*********************************************************************/
/* End of hook SCC07MP4                                              */
/*********************************************************************/
