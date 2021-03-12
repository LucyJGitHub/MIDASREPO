/*********************************************************************/
/*                                                                   */
/*       SDC1797003 - LUC109 - Save HOR library                      */
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
/* Save the savefile containing the HOR library  */                   
/**/                                                                  
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'LUC109')          
             IF (&PRTCD *EQ ' ') (CHGVAR (&LUC109) VALUE('Y'))        
/**/                                                                  
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                
             SAVSAVFDTA SAVF(&FSAV/DBIF) DEV(&DEVI) VOL(*MOUNTED) +
             USEOPTBLK(*NO) OUTPUT(*PRINT)                            
             MONMSG     MSGID(CPF0000) EXEC(DO)                       
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')   
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                      
               CHGJOB     SWS(XXXXXX11)                               
               GOTO       CMDLBL(ENDPGM)                              
             ENDDO       
             ENDDO       
/*********************************************************************/
/* End of hook SDC1797003                                            */
/*********************************************************************/
