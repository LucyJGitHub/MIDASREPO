/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Split Todays Actions by Book Pos.')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602F  SPLIT TODAY'S ACTIONS BY BOOK POSITION           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 05Feb18              */
/*       Prev Amend No. CSE111             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      S01189             Date 07Jan91              */
/*                      S01117                  DATE  10DEC90       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  31/03/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                             */
/*       CSE111 - Suppress Account Keys on Back-Value of dividends  */
/*       S01408 - Addition of core hook SEC0602FMS                  */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       S01117 - MULTIBRANCHING                                    */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *   E16870*/
/*                                                                  */
/********************************************************************/

/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)              *  *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/

/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602FMS                                          */
                                                                      /*S01408*/

/* SETUP AND SEND PGM MESSAGE    */

             CHGVAR     VAR(&MSG) VALUE('SEC0602F - SPLIT TODAYS +
                          ACTIONS BY BOOK POSITION')

             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)

/* SET OFF SWITCHES             */

             CHGJOB     SWS(00000000)

/* CHECK FOR COMPONENT RESTART                                   */

/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/* IF RESTART, COPY FILES                                        */

/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
                CPYF       FROMFILE(XPRICED) TOFILE(PRICED) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM PRICED)
                CPYF       FROMFILE(XPRICEA) TOFILE(PRICEA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM PRICEA)

/* CHANGE DATA AREA TO 'OLD'                                    */

/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/**/

             ENDDO
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICEA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/

/* AND COPY FILES                                                */

/*              CPYF       FROMFILE(PRICED) TOFILE(XPRICED) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XPRICED)                     *  *S01129*/
/*              CPYF       FROMFILE(PRICEA) TOFILE(XPRICEA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XPRICEA)                     *  *S01129*/
             CPYF       FROMFILE(PRICED) TOFILE(&TOLIB/XPRICED) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XPRICED)                       /*S01129*/
             CPYF       FROMFILE(PRICEA) TOFILE(&TOLIB/XPRICEA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XPRICEA)                       /*S01129*/


/* Preserve data from BPACxD Ref referral 4/SE0720              */

                CPYF       FROMFILE(BPACBD) TOFILE(BPACBZ) +
                            MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BPACBZ)

                CPYF       FROMFILE(BPACCD) TOFILE(BPACCZ) +
                            MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM BPACCZ)

/* CHANGE DATA AREA TO 'NEW'                                    */

/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/**/

/* CLEAR OUTPUT FILES           */

             CLRPFM     FILE(BPACCD) MBR(BPACCD)
             CLRPFM     FILE(BPACBD) MBR(BPACBD)
             CLRPFM     FILE(BPACCA) MBR(BPACCA)
             CLRPFM     FILE(BPACBA) MBR(BPACBA)
             CLRPFM     FILE(BPACCAPD) MBR(BPACCAPD)                                      /*CSE111*/
             CLRPFM     FILE(BPACBVPD) MBR(BPACBVPD)                                      /*CSE111*/


/* CALL THE PROGRAM            */

             CALL       PGM(SE2110)

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA   */

 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))  *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602F - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO

/* FOR FILE IMBALANCE ERROR */

             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602F - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/*  IF NO ERRORS CLEAR FILES                                     */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/*           CLRPFM     FILE(XPRICED)                               *  *S01129*/
/*           CLRPFM     FILE(XPRICEA)                               *  *S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICEA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/

             ENDDO

/*ENDPGM:*****ENDPGM                                                 * *S01117*/
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')
             ENDPGM                                                   /*S01117*/
