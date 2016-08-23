/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Portfolio Instrument Types')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBC0230  - Instrument Types                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPB001  *CREATE    Date 30Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB001 - 'Private Banking' Module                           */
/*                                                                   */
/*********************************************************************/
              PGM        PARM(&RSEQ &RLEV &RENT)
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
              MONMSG    MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Create LDA if not present */
              CHKOBJ    OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
              MONMSG    MSGID(CPF9801) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
              ENDDO
 
/* Reset external switches */
              CHGJOB    SWS(00000000)
/* Call program */
              CALL      PGM(PB0230) PARM(&RSEQ)
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO      CMDLBL(ABNOR)
              ENDDO
 
              GOTO      CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
