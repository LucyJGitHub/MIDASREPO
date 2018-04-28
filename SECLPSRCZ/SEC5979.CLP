/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Telekurs Tape Processing')                   */
/*********************************************************************/
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5979 - Telekurs Tape Processing (SERVITIA)               */
/*                                                                   */
/*       Function: Copy Tape file from Servitia to a Telekur file    */
/*                 for Midas processing.                             */
/*                                                                   */
/*       1) Submitted by SEC5977 in Input Cycle.                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE009             Date 16Mar99              */
/*                      S01502  *CREATE    Date 08Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSE009 - Telekurs Changes                                   */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*/COPY WNCPYSRC,SEC5979001                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&REPLY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPMSG) TYPE(*CHAR) LEN(41)
             DCL        VAR(&TAPE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&TELK)   TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CSE009*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                  /*CSE009*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                                   /*CSE009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE009*/
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)                                    /*CSE009*/
                                                                                          /*CSE009*/
             DCLF       FILE(SDBANKPD)                                                    /*CSE009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
                                                                                          /*CSE009*/
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)                                         /*CSE009*/
             RCVF                                                                         /*CSE009*/
             CHGVAR     VAR(&DAYS) VALUE(&BJRDNB)                                         /*CSE009*/
                                                                                          /*CSE009*/
             CHGVAR     VAR(&TELK) VALUE('       ')                                       /*CSE009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE009*/
             CHGVAR     VAR(&SAR)  VALUE('CSE009')                                        /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(AOSARDR0) PARM(&TELK &OPTN &SAR &SCSARD)                      /*CSE009*/
/**/
/** RETRIEVE TAPE UNIT FROM JNSTAT                                   */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
             CHGVAR     VAR(&TAPE) VALUE(%SST(&JNSTAT 25 6))
 
/**/
/** PROMPT FOR TAPE LOAD                                             */
/**/
             SNDPGMMSG  MSG('LOAD TELEKURS TAPE ON ' *CAT &TAPE *CAT +
                          '  - Press ENTER to continue,or C to cancel') +
                          TOPGMQ(*EXT) MSGTYPE(*INQ) KEYVAR(&REPMSG)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&REPMSG) WAIT(*MAX) +
                          MSG(&REPLY)
 
/**/
/** IF REPLY 'C'CANCEL,ELSE CONTINUE                                 */
/**/
             IF        ((&REPLY *EQ 'C') *OR (&REPLY *EQ 'c')) THEN(DO)
 
/**/
/** UPDATE TKSTAT                                                    */
/**/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             CHGVAR     VAR(%SST(&SESTAT 130 1)) VALUE('C')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             GOTO       END
             ENDDO
 
/**/
/** CREATE TAPE FILE IN QTEMP                                        */
/**/
             CRTTAPF    FILE(QTEMP/COURS) DEV(&TAPE) VOL(ACT) +
                          SEQNBR(1) LABEL(COURS) TEXT('Telekurs +
                          Tape Processing') RCDLEN(180) +
                          BLKLEN(1800) ENDOPT(*UNLOAD) AUT(*ALL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/**/
/** CLEAR OLD TELEKUR FILE                                           */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CLRPFM     FILE(SETKURPD)                                                 /*CSE009*/
                MONMSG     MSGID(CPF0000)                                                 /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE       CMD(DO)                                                           /*CSE009*/
                CLRPFM     FILE(TELEKUR2)
                MONMSG     MSGID(CPF0000)
             ENDDO                                                                        /*CSE009*/
 
 
/**/
/** COPY FROM TAPE FILE TO DISK FILE                                 */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CPYFRMTAP  FROMFILE(QTEMP/COURS) TOFILE(SETKURPD) +
                             FROMSEQNBR(2) FROMLABEL(COURS) +
                             TOMBR(*FIRST) MBROPT(*REPLACE)                               /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
                CPYFRMTAP  FROMFILE(QTEMP/COURS) TOFILE(TELEKUR2) +
                             FROMSEQNBR(2) FROMLABEL(COURS) +
                             TOMBR(*FIRST) MBROPT(*REPLACE)
             ENDDO                                                                        /*CSE009*/
 
/**/
/** PROMPT FOR TO UNLOAD TAPE                                        */
/**/
             SNDPGMMSG  MSG('PLEASE UNLOAD TAPE ON ' *CAT &TAPE) +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
 
/**/
/** ERROR PROCESSING                                                 */
/**/
 ERROR:      SNDPGMMSG  MSG('RESTORE OF TELEKURS ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(%SST(&SESTAT 130 1)) VALUE('C')
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        DLTOVR     FILE(*ALL)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SEC5979002                                          */
             ENDPGM
