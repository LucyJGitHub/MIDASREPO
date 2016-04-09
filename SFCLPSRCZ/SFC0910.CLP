/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas¦ABS Maintain Restricted Account Code Ranges')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       SFC0910 - MAINTAIN RESTRICTED ACCOUNT CODE RANGES           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE024  *CREATE    Date 07Oct05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE024 - COUNTRY LEVEL SWITCHABLE FEATURE :                 */
/*                SECURITY FEATURES FOR RESTRICTED ACCOUNTS          */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(SFRAAUPA) SHARE(*NO)
 
             CALL       PGM(SF0910)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSG('Restricted Accounts Maintenance ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RTVMSG     MSGID(SFM0011) MSGF(SFUSRMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (261 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SFM0012) MSGF(SFUSRMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (371 50)) VALUE(&MESSAGE)
             CALL       PGM(SFC0700) PARM('SFC0910' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&MKICPY) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
 ENDPGM
