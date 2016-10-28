/*********************************************************************/
/*                                                                   */
/*       SCC2454MP9 - LUC109 - Delete BOB savf                       */
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
/* Attempt to delete BOB INTERFACE save savfile */                    /*LUC109*/
/**/                                                                  /*LUC109*/
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                /*LUC109*/
             CHGVAR     VAR(&INT_SAVF) VALUE(&BOB_SAVF)               /*LUC109*/
             CHGVAR     VAR(%SST(&INT_SAVF 1 2)) VALUE('IF')          /*LUC109*/
             DLTF       FILE(&LIB/&INT_SAVF)                          /*LUC109*/
             MONMSG     MSGID(CPF2105)                                /*LUC109*/
/**/                                                                  /*LUC109*/
/* Create INT save file in ASP defined in data variable &CB_AUTO */   /*LUC109*/
/**/                                                                  /*LUC109*/
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))          /*LUC109*/
             CRTSAVF    FILE(&LIB/&INT_SAVF) TEXT('INTERFACE BOB +
                          save file for Auto COB') ASP(&ASP) +
                          AUT(*LIBCRTAUT)                             /*LUC109*/
/**/                                                                  /*LUC109*/
/* Save the database library                     */                   /*LUC109*/
/**/                                                                  /*LUC109*/
             CHGVAR     VAR(&library) VALUE(&SYSID *CAT 'INTFLIB')    /*LUC109*/
                                                                      /*LUC109*/
             CHGVAR     VAR(&save_type) VALUE('DISK')                 /*LUC109*/
                                                                      /*LUC109*/
             CHGVAR     VAR(&SAVE_FILE) VALUE('IFxxx     xxDILIB   ') /*LUC109*/
             CHGVAR     VAR(%SST(&SAVE_FILE 1 5)) VALUE(&INT_SAVF)    /*LUC109*/
             CHGVAR     VAR(%SST(&SAVE_FILE 11 2)) VALUE(&SYSID)      /*LUC109*/
                                                                      /*LUC109*/
             CHGVAR     VAR(&DEVICE) VALUE('          ')              /*LUC109*/
             CHGVAR     VAR(&VOLID) VALUE(&BOB_SAVF)                  /*LUC109*/
                                                                      /*LUC109*/
             CALL       PGM(SCC1767) PARM(&LIBRARY &SAVE_TYPE +
                          &SAVE_FILE &DEVICE &VOLID)                  /*LUC109*/
                                                                      /*LUC109*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              /*LUC109*/
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error in SCC1767')                         /*LUC109*/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO) /*LUC109*/
                   CHGJOB     SWS(XXXXXX11)                           /*LUC109*/
                   GOTO       CMDLBL(ABNORMAL)                        /*LUC109*/
             ENDDO       /*LUC109*/
                                                                      /*LUC109*/
             ELSE       CMD(SNDPGMMSG MSG('Database save completed +
                          successfully') TOMSGQ(MOPERQ MRUNQ))        /*LUC109*/
                                                                      /*LUC109*/
             ENDDO       /*LUC109*/
/*********************************************************************/
/* End of hook SCC2454MP9                                            */
/*********************************************************************/
