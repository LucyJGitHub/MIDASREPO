/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Backup System Setup')                           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1751 - APPLY JOURNAL CHANGES ON BACKUP MACHINE          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886           DATE  23May08             */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG18886           DATE  27FEB90             */
/*                      E00000            DATE  00/00/00            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       BG18886 - Replace non-standard codes.                      */
/*       E20839  -  EOD RUNS IN 38 MODE NOT NATIVE BECAUSE             *E20839*/
/*                  QCAEXEC IS CALLED AND NOT QCMDEXC                  *E20839*/
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FRPNT &TOPNT &LRCV)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&FRPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FRPNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOPNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LRCV) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(560)
/**/
             DCLF       FILE(JRNFIL)
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Apply Journal Changes to the Database') +
                        TOMSGQ(MRUNQ)
/**/
/*   APPLY JOURNAL CHANGES PROCESSING                               */
/**/
/*                                                                  */
/*      EACH RECORD IN THE FILE JRNFIL CONTAINS A LIST OF PHYSICAL  */
/*      FILES TO WHICH JOURNAL CHANGES HAVE TO BE APPLIED. THE      */
/*      PROGRAM WILL PROCESS EACH RECORD IN TURN UNTIL THERE ARE NO */
/*      FURTHUR RECORDS.                                            */
/*       (CPF0864 INDICATES END OF FILE)                            */
/**/
READREC:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
/**/
/* CONVERT THE NUMERIC VALUES OF FROM AND TO POINTS TO ALPHA VALUES  */
/**/
             CHGVAR     VAR(&FRPNA) VALUE(&FRPNT)
             CHGVAR     VAR(&TOPNA) VALUE(&TOPNT)
/**/
/* SETUP THE APPLY JOURNAL CHANGES COMMAND IN A VARIABLE TO EXECUTE  */
/**UNDER*QCAEXEC*AND*CALL*QCAEXEC***********************************/ /*E20839*/
/* UNDER QCMDEXC AND CALL QCMDEXC                                      *E20839*/
/**/
/************CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) +
                          FILE(' *CAT &FILEA *CAT &FILEB *CAT ') +
                          RCVRNG(ICRCV001 '** &LRCV *<') FROMENT(' +
                          ** &FRPNA *< ') TOENT(' ** &TOPNA *< ') +
                          CMTBDY(*YES)')                             */ /*BG18886*/
             CHGVAR     VAR(&MSG) VALUE('APYJRNCHG JRN(ICJRN) FILE(' +
                          *CAT &FILEA *CAT &FILEB *CAT ') +
                          RCVRNG(ICRCV001 ' *CAT &LRCV *TCAT ') +
                          FROMENT(' *CAT &FRPNA *TCAT ') TOENT(' +
                          *CAT &TOPNA *TCAT ') CMTBDY(*YES)')           /*BG18886*/
/**/
/************CALL*******PGM(QCAEXEC) PARM(&MSG 560)*/                 /*E20839*/
             CALL       PGM(QCMDEXC) PARM(&MSG 560)                   /*E20839*/
/* IF THE FROM OR TO POINT IS NOT ON A COMMITMENT BOUNDARY, CONTINUE */
/* PROCESSING                                                        */
             MONMSG     MSGID(CPF7039 CPF7067) EXEC(GOTO READREC)
/**/
             GOTO READREC
/**/
ABNOR:       SNDPGMMSG  MSG('Apply Journal Changes to the Database +
                        - ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
