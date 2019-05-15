/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Initialise Memos-L & 2 O'clock flag files')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC2010 - Intialise Memos-L & 2 O'clock flag files          */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE023R            Date 10Nov05              */
/*                      CRE023  *CREATE    Date 29Jul05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE023R- Clear Memos-L file and 2 O'clock file prior to     */
/*                initialisation.                                    */
/*              - Addition of mode processing.                       */
/*       CRE023 - 2 O'clock Flag Upgrade to MidasPlus                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &MODE)
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NMEMOS) TYPE(*DEC) LEN(6)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                                    /*CRE023R*/
             DCL        VAR(&TOF) TYPE(*CHAR) LEN(7)                                     /*CRE023R*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
                                                                                         /*CRE023R*/
/* Modes 1 and 2 - First and subsequest call */                                          /*CRE023R*/
                                                                                         /*CRE023R*/
             IF         COND((&MODE *EQ '1') *OR (&MODE *EQ '2')) +
                          THEN(DO)                                                       /*CRE023R*/
                SNDPGMMSG  MSG('Initialise REMEMLPD file installation ') +
                             TOMSGQ(MRUNQ)
 
                RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)
                CHGVAR VAR(&NMEMOS) VALUE(%SST(&RESTAT 1 6))
                                                                                         /*CRE023R*/
/** Clear Memos file prior to initialisation */                                          /*CRE023R*/
                                                                                         /*CRE023R*/
                CHGVAR     VAR(&TOF) VALUE('REMEMLPD')                                   /*CRE023R*/
                CLRPFM     FILE(REMEMLPD)                                                /*CRE023R*/
                MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO +
                             CMDLBL(ABNOR2))                                             /*CRE023R*/
 
                CALL       PGM(RE2010)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   ROLLBACK
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                SNDPGMMSG  MSG('Initialise the 2 O''clock file') +
                             TOMSGQ(MRUNQ)
                                                                                         /*CRE023R*/
/** Clear the Two O'clock file prior to initialisation */                                /*CRE023R*/
                                                                                         /*CRE023R*/
                CHGVAR     VAR(&TOF) VALUE('RE2CLKPD')                                   /*CRE023R*/
                CLRPFM     FILE(RE2CLKPD)                                                /*CRE023R*/
                MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO +
                           CMDLBL(ABNOR2))                                               /*CRE023R*/
                CALL       PGM(RE2011)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   ROLLBACK
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO                                                                       /*CRE023R*/
                                                                                         /*CRE023R*/
/* Mode 3 - Deletion */                                                                  /*CRE023R*/
                                                                                         /*CRE023R*/
             IF         COND(&MODE *EQ '3') THEN(DO)                                     /*CRE023R*/
/* No mode 3 processing required */                                                      /*CRE023R*/
             ENDDO                                                                       /*CRE023R*/
                                                                                         /*CRE023R*/
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR ')
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC2010 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO       CMDLBL(END)                                                      /*CRE023R*/
                                                                                         /*CRE023R*/
ABNOR2:                                                                                  /*CRE023R*/
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR ')                                    /*CRE023R*/
             CHGJOB     SWS(XXXXXX11)                                                    /*CRE023R*/
             CHGVAR     VAR(&MSG) VALUE('Member of file ' *CAT &TOF +
                        *TCAT ' not found - REC2010')                                    /*CRE023R*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                                         /*CRE023R*/
             MONMSG     MSGID(CPF0000 MCH0000)                                           /*CRE023R*/
 
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
