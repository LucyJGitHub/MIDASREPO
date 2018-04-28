/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Account codes authorities maintenance')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility Module                    */
/*                                                                   */
/*       SFC0032  - Account Codes Authorisation                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL008             Date 01Mar99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL008 - Security on Journal Entry Input                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ACTION)
 
/* Declare variables */
     DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
     DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     MONMSG MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(END))
 
/* Create LDA if not present */
     CHKOBJ OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
     MONMSG MSGID(CPF9801) EXEC(DO)
     CRTDTAARA DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
     ENDDO
 
/* Reset external switches */
     CHGJOB SWS(00000000)
 
/* Call program */
             CALL       PGM(SF0032) PARM(&ACTION)
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
     ENDDO
 
     GOTO CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
     ENDPGM
