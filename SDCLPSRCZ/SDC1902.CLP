/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Fee Charge Group/Fee Rate Codes Control')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC1902 - Fee Charge Group/Fee Rate Codes Control           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PMODE)
 
/* Declare variables */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        AUT(*EXCLUDE)
                        ENDDO
 
/* Reset external switches */
 
             CHGJOB     SWS(XXXXXX00)
/**  Check if Transaction Enhancements is installed */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE010')
             CHGVAR     VAR(&CSE010) VALUE('N')
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE010) VALUE('Y')
             ENDDO
 
/** Override files. */
 
 
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)
                OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)
                OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)
             ENDDO
 
/* Call program */
 
             OVRDBF     FILE(SDCGFRXX) TOFILE(SDCGFRL0) SHARE(*NO)
             CALL       PGM(SD1902) PARM(&PMODE)
             DLTOVR     FILE(SDCGFRXX)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        ROLLBACK
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
                        ENDDO
 
             COMMIT
             GOTO       CMDLBL(END)
 
/* Error processing */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        SDC1902 ended abnormally - see job log') +
                        TOMSGQ(MOPERQ)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
