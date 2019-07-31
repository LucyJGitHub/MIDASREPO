/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Operation codes report')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0310  - OPERATION CODES REPORT                           */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 21Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
 
 START:      PGM        PARM(&PTYPE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(1)
 
/***  Declare Data String for Midas Error Message.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/***  Call program.  ***/
 
             CALL       PGM(IL0310) PARM(&PTYPE &RSEQ &RLEV)
 
/***  Monitor for Error Messages from System.  ***/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
 
/***  Send Message to User alerting failure.  ***/
 
               SNDPGMMSG  MSG('Transaction failed. +
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
 
/***  Send Midas Error Message.  ***/
 
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
             ENDDO
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&ACTCPY) VALUE('(c) Finastra International +
                           Limited 2005')
             ENDPGM
