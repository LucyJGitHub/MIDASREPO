/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Initial group job program')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC360 - CONTROLLING PROGRAM FOR GROUP JOB SESSION          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSF002             Date 11Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 153379             Date 15Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 09Jun95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSF002 - Global layer.                                      */
/*                Remove the command which sets up SFC0600 as the    */
/*                program to be called when Attention Key is pressed */
/*                since SFC0600 is made redundant already.           */
/*       S01408 - Addition of core hook REC360MP1                    */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COUNT)   TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&POINTER) TYPE(*DEC)  LEN(5 0) VALUE(1)
/**/
             DCL        VAR(&GRPLIST) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&GRPNUM)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&GRPJOBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GRPJOBCNT) TYPE(*DEC) LEN(3 0)
/**/
             DCL        VAR(&JOBLOG)  TYPE(*CHAR) LEN(7) VALUE('*LIST')
             DCL        VAR(&TEST)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&COUNT2)   TYPE(*DEC)  LEN(2 0) VALUE(1)
             DCL        VAR(&COUNT3)   TYPE(*DEC)  LEN(2 0) VALUE(1)
/*/COPY WNCPYSRC,REC360001                                           */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/*************************************************************/
/**                                                          */
/**  Setup a Group Job session and immediately transfer to   */
/**  the first enquiry program.  Control will only return    */
/**  to this program when a return is to be made back to the */
/**  midas menus.                                            */
/**                                                          */
/*************************************************************/
 
             CHGJOB     SWS(00000000)
             RTVGRPA    GRPJOB(&GRPJOBNAM) GRPJOBCNT(&GRPJOBCNT)
             MONMSG     MSGID(CPF0000)
             IF         COND(&GRPJOBCNT *EQ 0) THEN(DO)
              CHGGRPA    GRPJOB(RECJOB0) TEXT('Group Control program')
              CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(RECJOB0)
/**********   SETATNPGM  PGM(SFC0600)                                                     /*CSF002*/
             ENDDO
             ELSE       CMD(DO)
              CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(&GRPJOBNAM)
              SETATNPGM PGM(SFC4460)
             ENDDO
/**/
 LOOP3:      IF         COND(&COUNT3 *GT 12) THEN(DO)
                SNDPGMMSG  MSG('Enquiry not available now.  Other +
                             jobs are active.  Please try later.') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(GRPEND)
                ENDDO
/**/
             ELSE       CMD(DO)
 
             TFRGRPJOB  GRPJOB(RECJOB1) INLGRPPGM(REC361) +
                          TEXT('Retail link enquiry')
/**/
/**  If jobs are still ending then retry the TFRGRPJOB command   */
/**/
                MONMSG     MSGID(CPF0000) EXEC(DO)
                     DLYJOB     DLY(10)
                     CHGVAR     VAR(&COUNT3) VALUE(&COUNT3 + 1)
                     GOTO       CMDLBL(LOOP3)
                     ENDDO
/**/
                 ENDDO
 
/*************************************************************/
/**                                                          */
/**  When a return has been made to this program consider    */
/**  if an error occurred in any of the enquiry programs.     */
/**  And if so display an appropriate error message          */
/**                                                          */
/*************************************************************/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC360MP1                                           */
                                                                      /*S01408*/
             RTVDTAARA  DTAARA(*GDA (460 1)) RTNVAR(&RTNCDE)
/**/
             IF         COND(&RTNCDE *EQ '1') THEN(DO)
                RTVDTAARA  DTAARA(*GDA (134 50)) RTNVAR(&MEM)
                CHGDTAARA  DTAARA(LDA (134 50)) VALUE(&MEM)
/**/
                SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
                ENDDO
/**/
             IF         COND(&RTNCDE *EQ '2') THEN(DO)
             SNDPGMMSG  MSG('Retail Link Enquiry ended in ERROR - see +
                          joblogs for RECJOB1/2/3/4/5 to determine +
                          error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
/**/
             IF         COND(&RTNCDE *EQ '3') THEN(DO)
             SNDPGMMSG  MSG('Transfer between Enquiries or Data Areas +
                          was unsuccessful - see program dumps to +
                          determine error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
 
/*************************************************************/
/**                                                          */
/**   Before a return is made to the midas menus all spawned */
/**   group jobs must be terminated and the group job        */
/**   session ended.                                         */
/**                                                          */
/**                                                          */
/*************************************************************/
 
 GRPEND:     IF         COND(&RTNCDE *EQ '0') THEN(CHGVAR +
                          VAR(&JOBLOG) VALUE('*NOLIST'))
/**/
             RTVDTAARA  DTAARA(*GDA (400 10)) RTNVAR(&LIB)
/**/
             RTVGRPA    GRPJOBL(&GRPLIST) +
                          GRPJOBCNT(&GRPNUM)
/**/
 LOOP:       IF         COND(&COUNT *LT &GRPNUM) THEN(DO)
                CHGVAR     VAR(&POINTER) VALUE(&POINTER + 66)
/**/
/**  Only end those jobs started by the linked enquiries            */
/**/
             IF         COND(%SST(&GRPLIST &POINTER 6) *EQ 'RECJOB') +
                          THEN(DO)
              ENDGRPJOB GRPJOB(%SST(&GRPLIST &POINTER 10)) LOG(&JOBLOG)
              CHGDTAARA  DTAARA(*GDA (1 299)) VALUE(' ')                /*153379*/
                              ENDDO
/**/
                CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
                GOTO       CMDLBL(LOOP)
                ENDDO
/**/
             RTVDTAARA  DTAARA(*GDA (450 10)) RTNVAR(&GRPJOBNAM)
             IF         COND(&GRPJOBNAM *NE 'RECJOB0') THEN(GOTO +
                          CMDLBL(RETRN))
 
 LOOP2:      IF         COND(&COUNT2 *GT 12) THEN(GOTO CMDLBL(ABNOR))
             CHGGRPA    GRPJOB(*NONE)
 
/**/
/**  If jobs are still ending then retry the CHGGRPA command         */
/**/
                MONMSG     MSGID(CPF1306) EXEC(DO)
                     DLYJOB     DLY(10)
                     CHGVAR     VAR(&COUNT2) VALUE(&COUNT2 + 1)
                     GOTO       CMDLBL(LOOP2)
                     ENDDO
/**/
RETRN:       RETURN
 
/*************************************************************/
/**                                                          */
/**   If an error occurs within this program then dump this  */
/**   program and return via processing at LOOP if group     */
/**   job session is active                                  */
/**                                                          */
/*************************************************************/
 
 ABNOR:      SNDPGMMSG  MSG('Error occurred in program REC360 - See +
                          program dump listing') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
/**/
             DMPCLPGM
/**/
             RTVGRPA    GRPJOB(&TEST)
             IF COND(&TEST *EQ '*NONE     ') THEN(GOTO CMDLBL(GRPEND))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
