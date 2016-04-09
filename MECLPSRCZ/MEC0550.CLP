/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages status')                      */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0550 - Outgoing Messages status                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  E32330           DATE 04NOV91              */
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       E32330 - BHF IMPLEMENTATION SPECIFIC CHANGES                */
/*                o limit users to specific modules                  */
/*                                                                   */
/*********************************************************************/
 
/*           PGM                                               E32330*/
             PGM        PARM(&MODI)                          /*E32330*/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODI) TYPE(*CHAR) LEN(2)        /*E32330*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             OVRDBF     FILE(MGOMSGPD) SHARE(*NO)
             OVRDBF     FILE(MGOREFLU) TOFILE(MGOREFL0) SHARE(*NO)
             OVRDBF     FILE(TABTB11) SHARE(*NO)
 
/*           CALL       PGM(ME0550)                            E32330*/
             CALL       PGM(ME0550) PARM(&MODI)              /*E32330*/
 
/* Check for database errors */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Outgoing messages status summary +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        DLTOVR     FILE(MGOREFLU TABTB11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
