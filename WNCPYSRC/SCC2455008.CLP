/*********************************************************************/
/*                                                                   */
/*       SCC2455008 - LUC109 - Save xxINTFLIB                        */
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
/* If this is a test system do not save xxINTFLIB.                    /*LUC109*/
                                                                      /*LUC109*/
/*           IF         COND((&SYSID *NE 'CI') *AND (&SYSID *NE +
                          'LN') *AND (&SYSID *NE 'NY') *AND (&SYSID +
                          *NE 'SI') *AND (&SYSID *NE 'UL') *AND +
                          (&SYSID *NE 'UE')) THEN(CHGVAR +
                          VAR(&LUC109) VALUE(' '))                 */ /*LUC109*/
             IF         COND((&SYSID *NE 'LS') *AND (&SYSID *NE +
                          'PS') *AND (&SYSID *NE 'MS') *AND (&SYSID +
                          *NE 'AS')) THEN(CHGVAR VAR(&LUC109) +
                          VALUE(' ')) /* LUC109 */

             IF         COND((&LIVE *NE 'Y')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          /*LUC109*/
/**/                                                                  /*LUC109*/
/* Save the database library XXINTFLIB           */                   /*LUC109*/
/**/                                                                  /*LUC109*/
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                /*LUC109*/
             CHGVAR     VAR(&INT_SAVF) VALUE(&BOB_SAVF)               /*LUC109*/
             CHGVAR     VAR(%SST(&INT_SAVF 1 2)) VALUE('IF')          /*LUC109*/
/**/                                                                  /*LUC109*/
             CHGVAR     VAR(&LIBRARY) VALUE(&SYSID *CAT 'INTFLIB')    /*LUC109*/
                                                                      /*LUC109*/
             CHGVAR     VAR(&SAVE_FILE) VALUE('IFxxx     xxDILIB   ') /*LUC109*/
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&INT_SAVF)    /*LUC109*/
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)      /*LUC109*/
                                                                      /*LUC109*/
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)                  /*LUC109*/
/**/                                                                  /*LUC109*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              /*LUC109*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                         /*LUC109*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO) /*LUC109*/
                  SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO) /*LUC109*/
                   CHGJOB     SWS(XXXXXX11)                           /*LUC109*/
                   GOTO       CMDLBL(ABNORMAL)                        /*LUC109*/
             ENDDO       /*LUC109*/
             ELSE       CMD(SNDPGMMSG MSG('Database save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))        /*LUC109*/
             ENDDO       /*LUC109*/
/*********************************************************************/
/* End of hook SCC2455008                                            */
/*********************************************************************/
