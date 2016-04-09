/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Instrument Type Maintenance')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       PBC0030  - Instrument Type Maintenance                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPB001  *CREATE    Date  7Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB001 - 'Private Banking' Module                           */
/*                                                                   */
/*********************************************************************/
              PGM
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
              DCL       VAR(&MEM) TYPE(*CHAR) LEN(50)
 
              MONMSG    MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Create LDA if not present */
              CHKOBJ    OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
              MONMSG    MSGID(CPF9801) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
              ENDDO
 
             CHGJOB SWS(00000000)
 
/* PERFORM FILE OVERRIDES                                            */
             OVRDBF     FILE(SDPLINXX) TOFILE(SDPLINL0) SHARE(*NO)
 
/* Call program */
              CALL      PGM(PB0030)
 
             DLTOVR     FILE(*ALL)
 
              IF        COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO      CMDLBL(ABNOR)
              ENDDO
 
              GOTO      CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
