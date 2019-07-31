/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Bulk Retail Account Maintenance - Submit Job')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Retail Utilities                                */
/*                                                                   */
/*       EUC0110 - Bulk Retail Account Maintenance - Submit Job      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU022  *CREATE    Date 5JAn98               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CEU022 - EMU Retail Utilities                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPTN &MAPN &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MAPN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/************SBMJOB     CMD(CALL PGM(EUC0120) PARM(&MAPN &OPTN)) +                        /*CSC023*/
/************             JOB(EUC0120) JOBD(MBATCH) JOBQ(*JOBD) +                         /*CSC023*/
/************             USER(*JOBD) INLLIBL(*JOBD) MSGQ(MOPERQ)                         /*CSC023*/
             SBMJOB     CMD(CALL PGM(EUC0120) PARM(&MAPN &OPTN)) +
                          JOB(EUC0120) JOBD(MBATCH) JOBQ(*JOBD) +
                          USER(*JOBD) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)             /*CSC023*/
 
             GOTO       CMDLBL(END)
 
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RTCD) VALUE('1')
             SNDPGMMSG  MSG('EUC0110 - Submit EMU Batch Job has +
                          Ended Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*     Normal termination                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:
             ENDPGM
