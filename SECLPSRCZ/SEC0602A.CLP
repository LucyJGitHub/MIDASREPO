/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Extract Security Actions - COB')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC0602A  EXTRACT SECURITY ACTIONS - CLOSE OF BUSINESS      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 180385             Date 11Jul00              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CSE015             Date 06Dec99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                      066262             Date 04Aug94              */
/*                      S01117             DATE 07JAN91              */
/*                      S01189             DATE 07/04/89             */
/*                      E16870             DATE 08/03/89             */
/*                      E16197             DATE 13/02/89             */
/*                      E15549             DATE 06/10/88             */
/*                      S01129             DATE 30/03/88             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       180385 - CPF5032 I/O error detected in file SEDEL, pgm      */
/*                SE2100 statement 137100.  Fix patterned to 144477  */
/*                which used a different update file to prevent      */
/*                locking problem.                                   */
/*       CSE015 - Forward Valued Depot Movements                     */
/*       S01408 - Addition of core hook SEC0602AMS                   */
/*       066262 - Remove overrides so that records written can be    */
/*                read to make sure no duplicate coupon actions are  */
/*                generated.                                         */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2             */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     */
/*       E16197 - RESET START OF BUSINESS TRADES FILE FOR ACCRUAL    */
/*                NON-WORKING DAY RUN.                               */
/*       E15549 - SECURITIES TRADING  FIXES INVOLVING                */
/*                POSITION SETTLEMENTS                               */
/*                                                                   */
/*********************************************************************/
/************PGM */                                                   /*E15549*/
/********    PGM        PARM(&ACCRX)                       /*E15549*/ /*S01189*/
             PGM        PARM(&ACCRX &CNAM &CSEQ)                      /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)                /*E15549*/
/*/COPY WNCPYSRC,SEC0602A10                                          */
 
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)     /*S01179E16870*/
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)/*E16870*/ /*S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
/*/COPY WNCPYSRC,SEC0602A11                                          */
                MONMSG MSGID(CPF2817)                                 /*S01129*/
/*/COPY WNCPYSRC,SEC0602A12                                          */
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0602AMS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                          */
 
 
             CHGVAR     VAR(&MSG) VALUE('SEC0602A - EXTRACT SECURITY +
                          ACTIONS')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                    */
 
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES                                   */
 
 
             CLRPFM     FILE(SECACD) MBR(SECACD)
             CLRPFM     FILE(SECACA) MBR(SECACA)
 
/* CHECK FOR COMPONENT RESTART                  */
 
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART, DISABLE ACCESS PATHS                       */
 
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
                RMVM       FILE(SECTYLCD) MBR(SECTYLCD)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(SECTR)    MBR(SECTR)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(SECTN)    MBR(SECTN)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(SEDEV)    MBR(SEDEV)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(SEDEVLCD) MBR(SEDEVLCD)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
                MONMSG     MSGID(CPF0000)
 
/* IF RESTART, OVERRIDE TO SEQONLY(*YES 100)          */
 
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVA)  SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC0602A03                                          */
 
/* AND COPY FILES                                      */
 
 
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
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SNDEVA)
                CPYF       FROMFILE(XSEDEVD) TOFILE(SEDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SEDEVD)
                CPYF       FROMFILE(XSEDEVA) TOFILE(SEDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM SEDEVA)
/*/COPY WNCPYSRC,SEC0602A04                                          */
 
/* CHANGE DATA AREA TO 'OLD'                        */
 
 
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
 
 
/*  OVERRIDE TO SEQONLY(*YES 100)                */
 
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA)  SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVD)  SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVA)  SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC0602A05                                          */
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
 
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                                                                      /*S01129*/
/*/COPY WNCPYSRC,SEC0602A06                                          */
/* AND COPY FILES                                  */
 
 
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
/*              CPYF       FROMFILE(SEDEVD) TOFILE(XSEDEVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XSEDEVD)                     *  *S01129*/
/*              CPYF       FROMFILE(SEDEVA) TOFILE(XSEDEVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                         EXEC(CLRPFM XSEDEVA)                     *  *S01129*/
 
                                                                      /*S01129*/
             CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)  /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSECTYD)                       /*S01129*/
             CPYF       FROMFILE(SNDEVD) TOFILE(&TOLIB/XSNDEVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVD)                       /*S01129*/
             CPYF       FROMFILE(SNDEVA) TOFILE(&TOLIB/XSNDEVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSNDEVA)                       /*S01129*/
             CPYF       FROMFILE(SEDEVD) TOFILE(&TOLIB/XSEDEVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSEDEVD)                       /*S01129*/
             CPYF       FROMFILE(SEDEVA) TOFILE(&TOLIB/XSEDEVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XSEDEVA)                       /*S01129*/
                                                                      /*S01129*/
/*/COPY WNCPYSRC,SEC0602A07                                          */
/* CHANGE DATA AREA TO 'NEW'                       */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  DISABLE ACCESS PATHS FOR LFs NOT REQUIRED       */
 
 
             RMVM       FILE(SECTYLCD) MBR(SECTYLCD)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(SECTR)    MBR(SECTR)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(SECTN)    MBR(SECTN)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(BKPHJ3V)  MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(BKPHJ3T)  MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(SEDEV)    MBR(SEDEV)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(SEDEVLCD) MBR(SEDEVLCD)
             MONMSG     MSGID(CPF0000)
             DLTOVR     *ALL                                         /*066262*/
 
/* OVERRIDE FILES                                 */
 
             OVRDBF     FILE(SECTYX) TOFILE(SECTY) SHARE(*NO)
             OVRDBF     FILE(SEDELX) TOFILE(SEDEL) SHARE(*NO)
             OVRDBF     FILE(SECEU)  TOFILE(SECET) SHARE(*NO)         /*180385*/
 
/* SET UP VALUE OF &ACCRX FOR ORDINARY DAY RUN */                     /*S01189*/
 
             IF         COND(&ACCRX *EQ ' ') THEN(CHGVAR VAR(&ACCRX) +
                          VALUE(%SST(&SDSTAT 116 1)))                 /*S01189*/
 
/* CALL THE PROGRAM                               */
/*/COPY WNCPYSRC,SEC0602A09                                          */
 
/*           CALL       PGM(SE2100)                                 *   E15549*/
             CALL       PGM(SE2100) PARM(&ACCRX)                      /*E15549*/
/*/COPY WNCPYSRC,SEC0602A13                                          */
 
/* DELETE OVERRIDES                               */
 
             DLTOVR     *ALL
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA      */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 44))* *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0602A - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
            CHGVAR     VAR(&MEM) VALUE('SEC0602A - FILE CONTROLS OUT +
                          OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*  IF NO ERRORS CLEAR FILES                   */
 
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*           CLRPFM     FILE(XSECTYD)                               *  *S01129*/
/*           CLRPFM     FILE(XSNDEVD)                               *  *S01129*/
/*           CLRPFM     FILE(XSNDEVA)                               *  *S01129*/
/*           CLRPFM     FILE(XSEDEVD)                               *  *S01129*/
/*           CLRPFM     FILE(XSEDEVA)                               *  *S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC0602A08                                          */
                                                                      /*S01129*/
/* IF RUN DURING PHASE EDSANWD1, RESET START OF BUSINESS TRADE FILE   /*E16197*/
/*/COPY WNCPYSRC,SEC0602A01                                          */
 
             IF         COND(&ACCRX *EQ '4') THEN(CPYF +
                          FROMFILE(TRADSD) TOFILE(SOBTRD) +
                          MBROPT(*REPLACE))                           /*E16197*/
                                                                      /*CSE015*/
             IF         COND(&ACCRX *EQ '4') THEN(DO)                 /*CSE015*/
                CPYF       FROMFILE(DPTMVD) TOFILE(SOBDMVD) +
                           MBROPT(*REPLACE)                           /*CSE015*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)        +
                           EXEC(CLRPFM SOBDMVD)                       /*CSE015*/
             ENDDO                                                    /*CSE015*/
/*/COPY WNCPYSRC,SEC0602A02                                          */
             ENDDO
 
/*  ENABLE FILE ACCESS PATHS                    */
 
 
ENDPGM:      ADDLFM     FILE(SECTYLCD) MBR(SECTYLCD)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SECTR)    MBR(SECTR)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SECTN)    MBR(SECTN)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3V)  MBR(BKPHJ3V)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(BKPHJ3T)  MBR(BKPHJ3T)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SEDEV)    MBR(SEDEV)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SEDEVLCD) MBR(SEDEVLCD)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
