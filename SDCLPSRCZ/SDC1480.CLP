/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initiate market data feed')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Standing Data Module                              */
/*                                                                   */
/*       SDC1480 - Initiate Market Data Feed                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CSD006  *CREATE    Date 13Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MSGDT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MDFSTA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Monitor for error messages not trapped in the rest of the program */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(*BLANK)
             CHGJOB     SWS(XXXXXX00)
 
/* Allocate initialisation data area SDC1480                         */
 
             ALCOBJ     OBJ((SDC1480 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))
             OVRDBF     FILE(MDFIL0) TOFILE(SDMDFIL0) SHARE(*NO)
             CALL       PGM(SD1480)
 
/* Dbase Error when calling SD1480                                   */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ERROR))
 
             DLCOBJ     OBJ((SDC1480 *DTAARA *EXCL))
 
/* Retrieve MDF status from the dataarea                             */
 
             RTVDTAARA  DTAARA(SDMDFSTS (1  5)) RTNVAR(&MDFSTA)
 
/* Initialise the data area if not yet initialised                   */
 
             IF         COND(&MDFSTA *EQ '     ') THEN(DO)
             CHGDTAARA  DTAARA(SDMDFSTS (1 5)) VALUE('00300')
             ENDDO
 
/************SBMJOB     CMD(CALL PGM(SDC1490) PARM(&RTNCD &MSGDT)) +                      /*CPK014*/
/************             JOB(MDFSCHED) JOBQ(MEJOBQ)                                      /*CPK014*/
/************SBMJOB     CMD(CALL PGM(SDC1490) PARM(&RTNCD &MSGDT)) +                      /*CSC023*/
/************             JOB(MDFSCHED) JOBD(MBATCH) JOBQ(MEJOBQ) +                       /*CSC023*/
/************             USER(*JOBD)                                          /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SDC1490) PARM(&RTNCD &MSGDT)) +
                          JOB(MDFSCHED) JOBD(MBATCH) JOBQ(MEJOBQ) +
                          USER(*JOBD) OUTQ(*JOBD)                                         /*CSC023*/
             GOTO       CMDLBL(ENDPGM)
 
 MSG:
             RTVMSG     MSGID(SCM0180) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
/*           CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')           */
             CALL       PGM(SCC0010) PARM('SDC1480' 'ENTER' ' ')
             GOTO       CMDLBL(ENDPGM)
 
ERROR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SDC1480 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
