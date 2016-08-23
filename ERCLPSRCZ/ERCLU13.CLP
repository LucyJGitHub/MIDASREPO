/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Product Code/CSSF Product Type Mnt')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting                                  */
/*                                                                   */
/*       ERCLU13  - Midas TI Product Code/CSSF Product Type Maint.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX024  *CREATE    Date 03Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX024 - Trade Innovation/CSSF Reporting Interface          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CODE)
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send program message */
             SNDPGMMSG  MSG('ERCLU13 - Midas TI Product Code / CSSF +
                          Product Type Table Maintenance') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF FILE(ERTIPTZ1)  TOFILE(ERTIPTL0) SHARE(*NO)
 
/* Call program */
             CALL       PGM(ERLU13) PARM(&CODE)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                          Enter to continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
