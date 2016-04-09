/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Save Securities Telekurs File by Tape')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5981 - Save Securities File for Servitia by Tape         */
/*                                                                   */
/*       Function: Save Security File (i.e Securities requesting     */
/*                 for Telekur Update) to Tape.                      */
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
/*/COPY WNCPYSRC,SEC5981001                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&REPLY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPMSG)   TYPE(*CHAR) LEN(41)
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
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ERROR))
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
             SNDPGMMSG  MSG('LOAD SERVITIA TAPE ON ' *CAT &TAPE *CAT +
                          '  - Press ENTER to continue,or enter C to +
                          cancel') TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&REPMSG)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&REPMSG) WAIT(*MAX) +
                          MSG(&REPLY)
 
/**/
/** IF REPLY 'C'CANCEL,ELSE CONTINUE                                 */
/**/
             IF        ((&REPLY *EQ 'C') *OR (&REPLY *EQ 'c')) THEN(DO)
 
/**/
/** UPDATE SESTAT                                                    */
/**/
                ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
                RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
                CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('C')
                CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
                DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/** CREATE TAPE FILE IN QTEMP                                        */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CRTTAPF    FILE(QTEMP/STTLK) DEV(&TAPE) VOL(ACT) +
                             SEQNBR(1) LABEL(SETKSEPD) TEXT('telekurs +
                             tape processing') RCDLEN(15) BLKLEN(3600) +
                             RCDBLKFMT(*V) ENDOPT(*UNLOAD) AUT(*ALL)                      /*CSE009*/
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
             CRTTAPF    FILE(QTEMP/STTLK) DEV(&TAPE) VOL(ACT) +
                          SEQNBR(1) LABEL(STSECPO2) TEXT('telekurs +
                          tape processing') RCDLEN(15) BLKLEN(3600) +
                          RCDBLKFMT(*V) ENDOPT(*UNLOAD) AUT(*ALL)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDDO                                                                        /*CSE009*/
 
/**/
/** INITIALISE TAPE                                                  */
/**/
             INZTAP     DEV(&TAPE) NEWVOL(ACT) NEWOWNID(MIDAS) +
                          CHECK(*NO) DENSITY(1600)
             MONMSG     MSGID(CPF7310)
 
/**/
/** COPY FROM TAPE FILE TO DISK FILE                                 */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CPYTOTAP   FROMFILE(SETKSEPD) TOFILE(QTEMP/STTLK)                         /*CSE009*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                        /*CSE009*/
                SNDPGMMSG  MSG('SERVITIA TAPE LOAD ENDED ABNORMALLY') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                  /*CSE009*/
                ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))                                    /*CSE009*/
                RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                                 /*CSE009*/
                CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('C')                            /*CSE009*/
                CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)                                  /*CSE009*/
                DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))                                    /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ENDDO                                                                        /*CSE009*/
             ELSE CMD(DO)                                                                 /*CSE009*/
             CPYTOTAP   FROMFILE(STSECPO2) TOFILE(QTEMP/STTLK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('SERVITIA TAPE LOAD ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
                RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
                CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('C')
                CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
                DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             ENDDO
             ENDDO                                                                        /*CSE009*/
 
/**/
/** PROMPT FOR TO UNLOAD TAPE                                        */
/**/
             SNDPGMMSG  MSG('PLEASE UNLOAD TAPE ON ' *CAT &TAPE) +
                          TOPGMQ(*EXT)
             GOTO    CMDLBL(END)
 
/**/
ERROR:      SNDPGMMSG  MSG('SERVITIA TAPE LOAD ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
            ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
            RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
            CHGVAR     VAR(%SST(&SESTAT 133 1)) VALUE('C')
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
            CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
            DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
            MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,SEC5981002                                          */
            ENDPGM
