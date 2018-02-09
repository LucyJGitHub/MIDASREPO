/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Operation code maintenance')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0210  - Operation Codes maintenance                      */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 30Jul01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
/***  Start Program.  ***/
 
 START:      PGM
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare Data String for Midas Error Message.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/***  Override file.  ***/
 
             OVRDBF     FILE(ILCODEXX) TOFILE(ILCODEPD) SHARE(*NO)
 
/***  Call program.  ***/
 
             CALL       PGM(IL0210)
 
/***  Monitor for Error Messages from System.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Execute Roll Back operation to remove uncommited changes.  ***/
 
               ROLLBACK
 
/***  Send Message to User alerting failure.  ***/
 
               SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                            Enter to continue.') TOPGMQ(*EXT)
 
/***  Execute Dump CL program.  ***/
 
               DMPCLPGM
 
/***  Bypass rest of processing.  ***/
 
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/***  Retrieve Error information and set Message data.  ***/
 
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
 
/***  Execute Roll Back operation to remove uncommited changes.  ***/
 
               ROLLBACK
 
/***  Send Midas Error Message.  ***/
 
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
             ENDDO
 
/***  End Program.  ***/
 
 ENDPGM:     DLTOVR     FILE(*ALL)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             CHGVAR &ACTCPY '(c) Finastra International Limited +
                 2005'
             ENDPGM
