/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Hist. Bal. Control Groups Maint.')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                      */
/*                                                                   */
/*   MCC0200 - Historic Balance Control Groups Maintenance Control   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. XXXXXX     DATE DDMMMYY                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                      */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Reset job switches U7 and U8                                      */
             CHGJOB     SWS(XXXXXX00)
 
/* Call the Historic Balance Control Group Maintenance program       */
             CALL       PGM(MC0200)
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Historic Balance Control Group +
                          Maintenance ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:     ENDPGM
