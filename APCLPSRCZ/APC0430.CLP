/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AP Confirmations Submit Job')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0430   - Start Confirmations job                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. AR1080280           Date 21Jan13             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG2381  *CREATE    Date 13May04             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1080280 - System has been reopened with error             */
/*       BUG2381 - Batch submit of confirmations programs            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,APC0430INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,APC0430MPS                                          */
 
             ALCOBJ     OBJ((APCONF *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((APCONF *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/* Clear END CONFIRMATION Data Queue */
 
             CALL       PGM(QCLRDTAQ) PARM('APCONFDTQ ' '*LIBL     ')
 
             SBMJOB     JOB(APCONFS) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          APC0420') INLLIBL(*JOBD) OUTQ(*JOBD)                         /*AR1080280*/
/**********               APC0420') INLLIBL(*JOBD)                   */                /*AR1080280*/
 
/*/COPY WNCPYSRC,APC0430MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,APC0430ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,APC0430END                                          */
 
ENDPGM
