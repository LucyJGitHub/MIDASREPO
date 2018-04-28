/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Initial group job program (non-retail)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC440C - Controlling Program for Group Job Session(Non-RE) */
/*                 Based on GLC440                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL037  *CREATE    Date 14Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL037 - Account Access Security                            */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&RTNCDE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT)   TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&POINTER) TYPE(*DEC)  LEN(5 0) VALUE(1)
 
             DCL        VAR(&GRPLIST) TYPE(*CHAR) LEN(1056)
             DCL        VAR(&GRPNUM)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&GRPJOBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GRPJOBCNT) TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&JOBLOG)  TYPE(*CHAR) LEN(7) VALUE('*LIST')
             DCL        VAR(&TEST)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&COUNT2)  TYPE(*DEC)  LEN(2 0) VALUE(1)
             DCL        VAR(&MITEM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN)   TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD)   TYPE(*CHAR) LEN(6) +
                          VALUE('CGL037')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Setup a Group Job session and immediately transfer to   */
/* the first enquiry program.  Control will only return    */
/* to this program when a return is to be made back to the */
/* midas menus.                                            */
 
             CHGJOB     SWS(00000000)
 
/* Set U5 on, so that the user is allowed to access only   */
/* non-retail accounts or retail accounts with a/c subtype */
/* 'V'(vostro) or 'I'(internal) if CGL037 is on            */
 
/* Determine if CGL037 is installed */
 
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
 
/* Error */
 
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CGL037 installed */
 
             IF         COND(&SRTCD *EQ '       ') THEN(DO)
                CHGJOB     SWS(00001000)
             ENDDO
 
             RTVGRPA    GRPJOB(&GRPJOBNAM) GRPJOBCNT(&GRPJOBCNT)
 
             MONMSG     MSGID(CPF0000)
             IF         COND(&GRPJOBCNT *EQ 0) THEN(DO)
                CHGGRPA    GRPJOB(GLCJOB0) TEXT('Group Control program')
                CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(GLCJOB0)
             ENDDO
             ELSE       CMD(DO)
                CHGDTAARA  DTAARA(*GDA (450 10)) VALUE(&GRPJOBNAM)
                SETATNPGM  PGM(SFC4460)
             ENDDO
 
             CHGDTAARA  DTAARA(*GDA (2 51)) VALUE(' ')
             RTVDTAARA  DTAARA(ZMITEM (1 10)) RTNVAR(&MITEM)
             CHGDTAARA  DTAARA(*GDA (101 10)) VALUE(&MITEM)
             TFRGRPJOB  GRPJOB(GLCJOB1) INLGRPPGM(GLC441) TEXT('Acc & +
                          Stmt Details')
 
/* When a return has been made to this program consider */
/* if an error occured in any of the enquiry programs.  */
/* And if so display an appropriate error message       */
 
             RTVDTAARA  DTAARA(*GDA (460 1)) RTNVAR(&RTNCDE)
 
             IF         COND(&RTNCDE *EQ '1') THEN(DO)
                RTVDTAARA  DTAARA(*GDA (134 44)) RTNVAR(&MEM)
                CHGDTAARA  DTAARA(LDA (134 50)) VALUE(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(&RTNCDE *EQ '2') THEN(DO)
                SNDPGMMSG  MSG('Account Enquiries ended in ERROR - see +
                             joblogs for GLCJOB1/2/3/4 to determine +
                             error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(&RTNCDE *EQ '3') THEN(DO)
                SNDPGMMSG  MSG('Transfer between Enquiries or Data Areas +
                             was unsuccessful - see program dumps to +
                             determine error') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/* Before a return is made to the midas menus all spawned */
/* group jobs must be terminated and the group job        */
/* session ended.                                         */
 
 GRPEND:     IF         COND(&RTNCDE *EQ '0') THEN(CHGVAR +
                          VAR(&JOBLOG) VALUE('*NOLIST'))
 
             RTVGRPA    GRPJOBL(&GRPLIST) +
                          GRPJOBCNT(&GRPNUM)
 
 
 LOOP:       IF         COND(&COUNT *LT &GRPNUM) THEN(DO)
                CHGVAR     VAR(&POINTER) VALUE(&POINTER + 66)
 
/* Only end those jobs started by the linked enquiries */
 
             IF         COND(%SST(&GRPLIST &POINTER 6) *EQ 'GLCJOB') +
                          THEN(DO)
                ENDGRPJOB  GRPJOB(%SST(&GRPLIST &POINTER 10)) LOG(&JOBLOG)
                CHGDTAARA  DTAARA(*GDA (1 299)) VALUE(' ')
             ENDDO
                CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
                GOTO       CMDLBL(LOOP)
             ENDDO
             RTVDTAARA  DTAARA(*GDA (450 10)) RTNVAR(&GRPJOBNAM)
 
             IF         COND(&GRPJOBNAM *NE 'GLCJOB0') THEN(GOTO +
                          CMDLBL(RETRN))
 
 LOOP2:      IF         COND(&COUNT2 *GT 50) THEN(GOTO CMDLBL(ABNOR))
             CHGGRPA    GRPJOB(*NONE)
 
/* If jobs are still ending then retry the CHGGRPA command */
 
             MONMSG     MSGID(CPF1306) EXEC(DO)
                DLYJOB     DLY(10)
                CHGVAR     VAR(&COUNT2) VALUE(&COUNT2 + 1)
                GOTO       CMDLBL(LOOP2)
             ENDDO
 
 RETRN:      RETURN
 
/* If an error occurs within this program then dump this */
/* program and return via processing at LOOP if group    */
/* job session is active                                 */
 
 ABNOR:      SNDPGMMSG  MSG('Error occured in program GLC440C - See +
                          program dump listing') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
 
             DMPCLPGM
 
             RTVGRPA    GRPJOB(&TEST)
             IF         COND(&TEST *NE '*NONE     ') +
                          THEN(GOTO CMDLBL(GRPEND))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
