/*********************************************************************/
/*                                                                   */
/*       Midas - /COPY Member (CLP)                                  */
/*                                                                   */
/*       REC3065MPE                                                  */
/*                                                                   */
/*       Last Amend No. LUC140             Date 24Feb21              */
/*       Prev Amend No. 161888             Date 23Jun99              */
/*                      MMI013  *CREATE    Date 14APR98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC140 - Upgrade MMI013 to FM2.1                            */
/*       161888 - Do not clear Stamp Duty postings, as GL0340 will   */
/*                need them.                                         */
/*       MMI013 - Midas Italy Retail Stamp Duty and Account Charges  */
/*                                                                   */
/*********************************************************************/
/*                                                       Begin MMI013*/
/**/
/* Determine whether feature LUC140 (Italian Stamp Duty) is switched */
/* on.  If it is, copy the records from PF/GESDREPP into PF/REEODPF  */
/**/
      /*     CALL       PGM(AOSARDR0) PARM(&MMI013 '*VERIFY' 'MMI013' &AOFMT)     */  /*LUC140*/
             CALL       PGM(AOSARDR0) PARM(&LUC140 '*VERIFY' 'LUC140' &AOFMT) +
                          /*LUC140*/
/**/
/* Copy Stamp Duty Tax RE Generated Entries to PF/REEODPF  */
/**/
 /*          IF         COND(&MMI013 *EQ ' ') THEN(DO)                            */ /*LUC140*/
             IF         COND(&LUC140 *EQ ' ') THEN(DO) /*LUC140*/

                CHGVAR     VAR(&FRF) VALUE('GESDREPP')
             CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL(*NONE) FMTOPT(*MAP *DROP)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/**********/                                                                              /*161888*/
/**Clear*PF/GESDREPP**************************************************/                   /*161888*/
/**********/                                                                              /*161888*/
/**********  CLRPFM     FILE(GESDREPP) */                                                 /*161888*/
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(DO)
             CHGVAR     VAR(&TOF) VALUE('GESDREPP')
             GOTO       CMDLBL(EXIT2)
             ENDDO
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CHGVAR     VAR(&TOF) VALUE('GESDREPP')
             GOTO       CMDLBL(EXIT3)
             ENDDO

             ENDDO
/*                                                         End MMI013*/
/*********************************************************************/
/* End of /COPY REC3065MPE                                           */
/*********************************************************************/
