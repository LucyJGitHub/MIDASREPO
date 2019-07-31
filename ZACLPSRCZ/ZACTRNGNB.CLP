/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ZA Control trans num. gen. - batch')            */
/*********************************************************************/
/*                                                                   */
/*       Midas Standard routines                                     */
/*                                                                   */
/*       ZACTRNGNB - Control Batch Trans. Number Generation          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC024             Date 09Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP003  *CREATE    Date 24May98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC024 - Open Month End                                     */
/*                Avoid duplicate record in file ZAAVx when generate */
/*       CAP003 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RETURNCODE &MODU &TRTY)
/**/
/** Declares                                                         */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code, module, transaction type **/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODU      ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TRTY      ) TYPE(*CHAR) LEN(1)
 
/** No. of transactions **/
             DCL        VAR(&TRANC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TRANS) TYPE(*DEC)  LEN(6 0)
 
/** +
    The global monitor sends an escape message, which will end the +
    program instantly if it is executed. +
**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area')
             MONMSG     MSGID(CPF0000)
 
 /**/
 /** Retrieve no. of transactions from the appropriate data-area */
 /**/
             IF         COND(&MODU *EQ 'SE' *AND &TRTY *EQ 'T') +
                          THEN(DO)
             RTVDTAARA  DTAARA(ZATRAN (1 5)) RTNVAR(&TRANC)
             ENDDO
             IF         COND(&MODU *EQ 'SE' *AND &TRTY *EQ 'D') +
                          THEN(DO)
             RTVDTAARA  DTAARA(ZATRAN (6 5)) RTNVAR(&TRANC)
             ENDDO
             IF         COND(&MODU *EQ 'FF') +
                          THEN(DO)
             RTVDTAARA  DTAARA(ZATRAN (11 5)) RTNVAR(&TRANC)
             ENDDO
 
             IF         COND(&TRANC *EQ '     ') THEN(DO)
             CHGVAR     VAR(&TRANC) VALUE('01000')
             ENDDO
 
             CHGVAR     VAR(&TRANS) VALUE(&TRANC)
             CHGVAR     VAR(&TRANS) VALUE(&TRANS / 5)
/**/
/**  Attempt to allocate transaction number generation program */
/**/
             ALCOBJ     OBJ((ZATRNGEN *PGM *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                GOTO    CMDLBL(END)
             ENDDO
 
     /*BEGIN CSC024 */
             OVRDBF     FILE(ZAAVSTXX) TOFILE(ZAAVSTL0) SHARE(*NO)
             OVRDBF     FILE(ZAAVFFXX) TOFILE(ZAAVFFL0) SHARE(*NO)
             OVRDBF     FILE(ZAAVSDXX) TOFILE(ZAAVSDL0) SHARE(*NO)
     /*END   CSC024 */
/**/
/**  Call the transaction number generation program */
/**  to create 20% of the daily transaction numbers */
/**/
             CALL       PGM(ZATRNGEN) PARM(&RETURNCODE &MODU &TRTY +
                          &TRANS)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO    CMDLBL(ABNOR)
             ENDDO
     /*BEGIN CSC024  */
             DLTOVR     FILE(ZAAVSTXX)
             DLTOVR     FILE(ZAAVFFXX)
             DLTOVR     FILE(ZAAVSDXX)
     /*END   CSC024  */
 
/**/
/**  If error found, end this program */
/**/
             IF         COND(&RETURNCODE = 'Error') THEN(DO)
                GOTO    CMDLBL(ABNOR)
             ENDDO
 
             RETURN
 
ABNOR:
             CHGVAR     VAR(&RETURNCODE) VALUE('Error')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          while generating transaction numbers') +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
/**/
/**  Deallocate transaction number generation program */
/**/
END:
             DLCOBJ     OBJ((ZATRNGEN *PGM *EXCL))
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
