/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Extract Market Prices')                      */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0602B  EXTRACT MARKET PRICES                            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CSE112             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend NO. S01408                  DATE 11MAY95        */
/*                      S01117                  DATE  07JAN91       */
/*                      S01189                  DATE  07/04/89      */
/*                      E16870                  DATE  08/03/89      */
/*                      S01129                  DATE  30/03/88      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CSE112 - SE Market Price Updated with Price of Last Trade  */
/*       S01408 - Addition of core hook SEC0602BMS                   */
/*       S01117 - MULTIBRANCHING                                    */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *   E16870*/
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSE112*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE112*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE112*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE112*/
             DCL        VAR(&CSE112) TYPE(*CHAR) LEN(1)                                   /*CSE112*/
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)     /*S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
                MONMSG MSGID(CPF2817)                                 /*S01129*/
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602BMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602B - EXTRACT MARKET +
                          PRICES')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART                                   */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                              */
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
                RMVM       FILE(SECTYLCD) MBR(SECTYLCD)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(SECTR)    MBR(SECTR)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
 
/* IF RESTART, OVERRIDE TO SEQONLY(*YES 100)                     */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XPRICED) SEQONLY(*YES 100)
                OVRDBF     FILE(XPRICEA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(PRICED)  SEQONLY(*YES 100)
                OVRDBF     FILE(PRICEA)  SEQONLY(*YES 100)
 
/* AND COPY FILES                                                */
 
                CPYF       FROMFILE(XSECTYD) TOFILE(SECTYD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SECTYD)
                CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SNDEVD)
                CPYF       FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
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
 
/**/
 
/* DELETE COPY FILES                               */                 /*S01129*/
 
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICEA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                                                                      /*S01129*/
/*  OVERRIDE TO SEQONLY(*YES 100)                                */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XPRICED) SEQONLY(*YES 100)
                OVRDBF     FILE(XPRICEA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(PRICED)  SEQONLY(*YES 100)
                OVRDBF     FILE(PRICEA)  SEQONLY(*YES 100)
 
/* AND COPY FILES                                                */
 
/*              CPYF       FROMFILE(SECTYD) TOFILE(XSECTYD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XSECTYD)                     *  *S01129*/
/*              CPYF       FROMFILE(SNDEVD) TOFILE(XSNDEVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XSNDEVD)                     *  *S01129*/
/*              CPYF       FROMFILE(SNDEVA) TOFILE(XSNDEVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XSNDEVA)                     *  *S01129*/
/*              CPYF       FROMFILE(PRICED) TOFILE(XPRICED) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XPRICED)                     *  *S01129*/
/*              CPYF       FROMFILE(PRICEA) TOFILE(XPRICEA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XPRICEA)                     *  *S01129*/
             CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSECTYD)                       /*S01129*/
             CPYF       FROMFILE(SNDEVD) TOFILE(&TOLIB/XSNDEVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVD)                       /*S01129*/
             CPYF       FROMFILE(SNDEVA) TOFILE(&TOLIB/XSNDEVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVA)                       /*S01129*/
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
 
/* CHANGE DATA AREA TO 'NEW'                                    */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
 
 
/*  DISABLE ACCESS PATHS FOR LFs NOT REQUIRED                    */
 
             RMVM       FILE(SECTYLCD) MBR(SECTYLCD)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(SECTR)    MBR(SECTR)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
 
/* CALL THE PROGRAM                                              */
 
             CALL       PGM(SE2120)
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE112*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE112*/
             CHGVAR     VAR(&SAR) VALUE('CSE112')                                         /*CSE112*/
             CHGVAR     VAR(&CSE112) VALUE('N')                                           /*CSE112*/
                                                                                          /*CSE112*/
/**  Check if Enhancement is installed */                                                 /*CSE112*/
                                                                                          /*CSE112*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE112*/
/**/                                                                                      /*CSE112*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSE112*/
             CHGVAR     VAR(&CSE112) VALUE('Y')                                           /*CSE112*/
             ENDDO                                                                        /*CSE112*/
/**/                                                                                      /*CSE112*/
             IF         COND(&CSE112 *EQ 'Y') THEN(DO)                                    /*CSE112*/
/**/                                                                                      /*CSE112*/
/** Call the Program SE0008 if no errors                                                  /*CSE112*/
                                                                                          /*CSE112*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CSE112*/
             CALL       PGM(SE0008)                                                       /*CSE112*/
             ENDDO                                                                        /*CSE112*/
/**/                                                                                      /*CSE112*/
             ENDDO                                                                        /*CSE112*/
/**/                                                                                      /*CSE112*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))* *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602B - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602B - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF NO ERRORS CLEAR FILES                                     */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*           CLRPFM     FILE(XSECTYD)                               *  *S01129*/
/*           CLRPFM     FILE(XSNDEVD)                               *  *S01129*/
/*           CLRPFM     FILE(XSNDEVA)                               *  *S01129*/
/*           CLRPFM     FILE(XPRICED)                               *  *S01129*/
/*           CLRPFM     FILE(XPRICEA)                               *  *S01129*/
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XPRICEA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                                                                      /*S01129*/
 
             ENDDO
 
/*  ENABLE FILE ACCESS PATHS                                     */
 
ENDPGM:      ADDLFM     FILE(SECTYLCD) MBR(SECTYLCD)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SECTR)    MBR(SECTR)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3V)  MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3T)  MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
