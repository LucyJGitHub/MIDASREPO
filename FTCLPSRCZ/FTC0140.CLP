/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments Awaiting LvL 2')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FUNDS TRANSFER MODULE                           */
/*                                                                   */
/*       FTC0140 - OUTGOING PAYMENTS  AWAITING LEVEL 2               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01494             DATE 25MAY94              */
/*                      042167             DATE 21JUL92              */
/*                      E29970             DATE 28JUN91              */
/*                      S01117             DATE 07SEP90              */
/*                      S01194             DATE 24AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01494  -  BLI Funds Transfer Enhancements                  */
/*       042167  -  Include CL Program for record locking            */
/*       E29970  -  COMMAND 7 IN FT0045 PROCESSING                   */
/*       S01117  -  RELEASE 10 MULTIBRANCHING CHANGES                */
/*       S01194  -  STANDING DATA CHANGES                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     /*S01117*/
/************PGM        PARM(&BRCH &BORO &PCMD)            */ /*S01117 S01494*/
             PGM        PARM(&BRCH &BORO &PCMD &RNTP)                /*S01494*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01194*/
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&BORO) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)                /*S01494*/
 
                                                                     /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)              /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)             /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)             /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)              /*042167*/
 
 
/************CHGJOB*****SWS(XXXXXX00)                                /*E29970*/
/*  SWITCH ON U5 FOR ENABLING CMD7 ON FT0045                         /*E29970*/
             CHGJOB     SWS(XXXX1X00)                                /*E29970*/
/**/                                                                 /*S01494*/
/** Check run type                                                */ /*S01494*/
/**/                                                                 /*S01494*/
             IF         COND(&RNTP *EQ 'FTM2503') THEN(DO)           /*S01494*/
             OVRDBF     FILE(OTLV2BB) TOFILE(RPLV2BB) SHARE(*NO)     /*S01494*/
             OVRDBF     FILE(OTLV2OB) TOFILE(RPLV2OB) SHARE(*NO)     /*S01494*/
             ENDDO                                                   /*S01494*/
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
/************CALL       PGM(FT0140)                                  /*S01117*/
/************CALL       PGM(FT0140) PARM(&BRCH &BORO &PCMD)*/ /*S01117 S01494*/
             CALL       PGM(FT0140) PARM(&BRCH &BORO &PCMD &RNTP)    /*S01494*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)            /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
/**END:        ENDPGM                                                /*S01117*/
 END:        CHGJOB     SWS(XXXX0XXX)                                /*E29970*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*042167*/
/* CALL AOC8000 to release locks */                                   /*042167*/
/* */                                                                 /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/**/                                                                 /*S01117*/
            ENDPGM                                                   /*S01117*/
 
