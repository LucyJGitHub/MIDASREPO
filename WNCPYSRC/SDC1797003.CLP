/*********************************************************************/
/*                                                                   */
/*       SDC1797003 - LUC109 - Save HOR library                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/**/                                                                  /*LUC109*/
/* Save the savefile containing the HOR library  */                   /*LUC109*/
/**/                                                                  /*LUC109*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'LUC109')          /*LUC109*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&LUC109) VALUE('Y'))        /*LUC109*/
/**/                                                                  /*LUC109*/
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                /*LUC109*/
             SAVSAVFDTA SAVF(&FSAV/DBIF) DEV(&DEVI) VOL(*MOUNTED) +
             USEOPTBLK(*NO) OUTPUT(*PRINT)                            /*LUC109*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*LUC109*/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')   /*LUC109*/
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                      /*LUC109*/
               CHGJOB     SWS(XXXXXX11)                               /*LUC109*/
               GOTO       CMDLBL(ENDPGM)                              /*LUC109*/
             ENDDO       /*LUC109*/
             ENDDO       /*LUC109*/
/*********************************************************************/
/* End of hook SDC1797003                                            */
/*********************************************************************/
