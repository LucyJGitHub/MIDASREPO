/*********************************************************************/
/*                                                                   */
/*       SCC07MP4   - LUC109 - Delete SV files                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 19Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/*                                                                    /*LUC109*/
/** Check for Switchable Feature LUC109.                              /*LUC109*/
/** If active, restore xxINTFLIB from savefile xxDILIB/DBIF.          /*LUC109*/
/*                                                                    /*LUC109*/
                                                                      /*LUC109*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD '*VERIFY' 'LUC109') /*LUC109*/
             IF         COND(&PRTCD *EQ ' ') THEN(DO)                 /*LUC109*/
             CHGVAR     VAR(&LIB3) VALUE(&LIBID *CAT 'INTFLIB')       /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTDTAARA  DTAARA(&LIB3/SDSTAT)                          /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/ACCOLDSV)                          /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/EODCLPDSV)                         /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/FEANADSDSV)                        /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/FECRFTIPSV)                        /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/FEPOLTIPSV)                        /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             DLTF       FILE(&LIB3/FEPTFTIPSV)                        /*LUC109*/
             MONMSG     MSGID(CPF0000)                                /*LUC109*/
 /**/                                                                 /*LUC109*/
             RSTLIB     SAVLIB(&LIB3) DEV(*SAVF) SAVF(&LIB2/DBIF) +
                          OUTPUT(*PRINT)                              /*LUC109*/
             ENDDO       /*LUC109*/
/*********************************************************************/
/* End of hook SCC07MP4                                              */
/*********************************************************************/
