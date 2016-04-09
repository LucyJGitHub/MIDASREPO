/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT UNCLEARED CHEQUES REPORT BY ORBR')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     FUNDS TRANSFER MODULE                         */
/*                                                                   */
/*       FTC0601 - UNCLEARED CHEQUES LISTING BY ORIGINATING BRANCH   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 000000         DATE  DDMMMYY                 */
/*                                                                   */
/*********************************************************************/
 
START:  PGM             PARM(&RSEQ &RLEV &RENT)
 
/**/
        DCL   VAR(&DATA)  TYPE(*CHAR)   LEN(50)
        DCL   VAR(&RSEQ)  TYPE(*CHAR)   LEN(5)
        DCL   VAR(&RLEV)  TYPE(*CHAR)   LEN(1)
        DCL   VAR(&RENT)  TYPE(*CHAR)   LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/** set up override **/
/**/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(UNCHQBB) TOFILE(UNCHQOB) POSITION(*KEY +
                          1 *N &RENT)
             OPNDBF     FILE(UNCHQBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(UNCHQBB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(UNCHQBB) TOFILE(UNCHQOB))
/**/
/***************************************************/
/**  Call Program & Monitor for Untrapped Errors  **/
/***************************************************/
/**/
        CALL       PGM(FT0600) PARM(&RSEQ &RLEV &RENT 'O')
        MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                   SNDPGMMSG  MSG('Transaction Failed. +
                                   Re-input Necessary. +
                                   Press Enter to Continue.') +
                              TOPGMQ(*EXT)
                   GOTO END
        ENDDO
/**/
/****************************************************/
/**  Check for Database Errors Trapped by Program  **/
/****************************************************/
/**/
        IF COND(%SWITCH(XXXXXX11)) THEN(DO)
           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                      TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
/**/
END:
/**/
/** delete overrides **/
/**/
             DLTOVR     FILE(UNCHQBB)
             MONMSG     MSGID(CPF9841)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
        ENDPGM
