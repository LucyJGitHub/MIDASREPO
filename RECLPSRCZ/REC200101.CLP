/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Calculation of Start Date')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail T&N Accounts                             */
/*                                                                   */
/*       REC200101 - Midas RE Calculation of Start Date              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CRE015  *CREATE    Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTCD &SYS &TPRD &EVNT &CEDE &NDPD +
                             &NMPD &FREQ &DAYM &VDAT2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2010')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&EVNT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TPRD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CEDE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NDPD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&NMPD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FREQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&VDAT2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('XXXPLIB   ')                                             /*CSC043*/
/**********               VALUE('XXXLIB    ')  */                                         /*CSC043*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(%SST(&XLIB 1 2)) VALUE(&SYS)
 
             CALL       PGM(&XLIB/UPC0014) PARM(&SYS)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program error in executing UPC0014') +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             CALL       PGM(RE200101) PARM(&RTCD &TPRD &EVNT +
                            &CEDE &NDPD &NMPD &FREQ &DAYM &VDAT2)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program error in RE200101') +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(ENDP)
 
ERROR:
             CHGVAR     VAR(&RTCD) VALUE('*ERROR')
             SNDPGMMSG  MSG('Program REC200101 ended abnormally - see job log ') +
                          TOMSGQ(MOPERQ)
 
ENDP:
             ENDPGM
