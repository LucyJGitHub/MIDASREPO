/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Customer Positions')                  */
/*********************************************************************/
/*                                                                   */
/*         Midas - Securities Trading Module                    */
/*                                                                   */
/*       SEC0606D - UPDATE PAST AND CURRENT CUSTOMER POSITIONS       */
/*                  WITH THE EFFECT OF TRADES, DEPOT MOVEMENTS       */
/*                  AND TRADE SETTLEMENTS                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 096090             Date 16Jul96              */
/*                      101194             Date 11Mar96              */
/*                      S01408             DATE 11MAY95              */
/*                      081358             DATE 09JAN95              */
/*                      E29032             DATE 01OCT91              */
/*                      S01117             DATE 08JAN91              */
/*                      S01189             DATE 08JAN91              */
/*                      E19833             DATE 16OCT89              */
/*                      E16870             DATE 08/03/89             */
/*                      S01179             DATE 16/12/88             */
/*                      E15824             DATE 18/10/88             */
/*                      E15616             DATE 11/10/88             */
/*                      E15549             DATE 06/10/88             */
/*                      S01129             DATE 05/04/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096090 - CLRPFM PMBVALPD as done in PMC0606T                */
/*       101194 - Remove Security Copy of UDEPPD, and removal of     */
/*                Logical members                                   */
/*       S01408 - Addition of core hook SEC0606DMS                  *  *E15549*/
/*       081358 - MISSING OVERRIDE                                  */
/*       E29032 - Empty XUDEPP causes CLRPFM to fall over           */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *  *S01189*/
/*       E19833 - PARAMETER '&ACCRX' BECOMES 'ACCRX'                *  *E19833*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*       S01179 - ABS INCORPORATION                                 *  *S01179*/
/*       E15824 - OVERRIDE OF CPOSHI TO CPOSH MUST BE SHARE(*NO)    *  *E15616*/
/*              - BOTH MUST HAVE AN OVERRIDE OF SHARE(*NO)          *  *E15616*/
/*       E15616 - XDPOSND & XCPOSND MUST ALWAYS BE IN EXISTENCE     *  *E15616*/
/*       E15549 - SECURITIES TRADING  FIXES INVOLVING POSITION      *  *E15549*/
/*                SETTLEMENTS                                       *  *E15549*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM */                                                   /*E15549*/
/********    PGM        PARM(&ACCRX)                          *E15549* *S01189*/
             PGM        PARM(&ACCRX &CNAM &CSEQ)                      /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)                /*E15549*/
 
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/************DCLDTAARA  DTAARA(SESTAT)                              *  *S01179*/
/************DCLDTAARA  DTAARA(SDSTAT)                    *  *S01129*  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)      *S01179E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
/*/COPY WNCPYSRC,SEC0606D01                                          */
                                                                      /*S01129*/
/*           RCVDTAARA DTAARA(SDSTAT)                    *  *S01129*/ /* +
S01179*/
             RTVDTAARA DTAARA(SDSTAT)  RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606DMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606D - Update Customer +
                          Positions')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/*/COPY WNCPYSRC,SEC0606D02                                          */
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES  */
 
             CLRPFM     FILE(SEKEYD) MBR(CPOSN1)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN1)
             CLRPFM     FILE(POSETD) MBR(CPOSN1)
             CLRPFM     FILE(POSETA) MBR(CPOSN1)
             CLRPFM     FILE(MATEXD) MBR(CUSTOMER)            /*AW*/
             CLRPFM     FILE(MATEXA) MBR(CUSTOMER)            /*AW*/
             CLRPFM     FILE(PMBVALPD)                               /*096090*/
/*/COPY WNCPYSRC,SEC0606D03                                          */
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART DISABLE RELATED ACCESS PATHS                          */
 
/********    IF COND(&BUSY = 'NEW') THEN(DO)                          /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
/**/                                                                  /*101194*/
/***************RMVM       FILE(CPOSS) MBR(CPOSS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CPOSO) MBR(CPOSO)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CPOSN) MBR(CPOSN)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPP) MBR(UDEPP)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPH) MBR(UDEPH)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPZ) MBR(UDEPZ)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPS) MBR(UDEPS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDPB) MBR(CUDPB)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDEP) MBR(CUDEP)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDPS) MBR(CUDPS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
 
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(CPOSND)  SEQONLY(*YES 100)
                OVRDBF FILE(CPOSNA)  SEQONLY(*YES 1)
                OVRDBF FILE(UDEPPD)  SEQONLY(*YES 100)
                OVRDBF FILE(UDEPPA)  SEQONLY(*YES 1)
                OVRDBF FILE(XCPOSND) SEQONLY(*YES 100)
                OVRDBF FILE(XCPOSNA) SEQONLY(*YES 1)
/***************OVRDBF FILE(XUDEPPD) SEQONLY(*YES 100)                /*101194*/
/***************OVRDBF FILE(XUDEPPA) SEQONLY(*YES 1)                  /*101194*/
 
/* AND COPY FILES                       */
 
                CPYF FROMFILE(XCPOSND) TOFILE(CPOSND) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPOSND)
 
                CPYF FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPOSNA)
 
/***************CPYF FROMFILE(XUDEPPD) TOFILE(UDEPPD) +               /*101194*/
/***************MBROPT(*REPLACE) FMTOPT(*NONE)                        /*101194*/
/***************MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +              /*101194*/
/***************        EXEC(CLRPFM UDEPPD)                           /*101194*/
/***************                                                      /*101194*/
/***************CPYF FROMFILE(XUDEPPA) TOFILE(UDEPPA) +               /*101194*/
/***************MBROPT(*REPLACE) FMTOPT(*NONE)                        /*101194*/
/***************MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +              /*101194*/
/***************        EXEC(CLRPFM UDEPPA)                           /*101194*/
/*/COPY WNCPYSRC,SEC0606D05                                          */
 
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             OVRDBF FILE(CPOSND) SEQONLY(*YES 100)
             OVRDBF FILE(CPOSNA) SEQONLY(*YES 1)
             OVRDBF FILE(XCPOSND) SEQONLY(*YES 100)
             OVRDBF FILE(XCPOSNA) SEQONLY(*YES 1)
                                                                      /*S01129*/
 
/************CPYF FROMFILE(CPOSND) TOFILE(XCPOSND) +               */ /*S01129*/
/************MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*S01129*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*S01129*/
/************EXEC(CLRPFM XCPOSND)                                  */ /*S01129*/
/************CPYF FROMFILE(CPOSNA) TOFILE(XCPOSNA) +               */ /*S01129*/
/************MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*S01129*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*S01129*/
/************EXEC(CLRPFM XCPOSNA)                                  */ /*S01129*/
 
/************CPYF FROMFILE(UDEPPD) TOFILE(XUDEPPD) +               */ /*S01129*/
/************MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*S01129*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*S01129*/
/************EXEC(CLRPFM XUDEPPD)                                  */ /*S01129*/
/************                                                      */ /*S01129*/
/************CPYF FROMFILE(UDEPPA) TOFILE(XUDEPPA) +               */ /*S01129*/
/************MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*S01129*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +               */ /*S01129*/
/************EXEC(CLRPFM XUDEPPA)                                  */ /*S01129*/
/************CPYF FROMFILE(CPOSND) TOFILE(XCPOSND.&TOLIB) + */        /*E15616*/
/************MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *  *S01129*  * +
E15616*/
             CPYF FROMFILE(CPOSND) TOFILE(XCPOSND) +
             MBROPT(*REPLACE) FMTOPT(*NONE)                           /*E15616*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCPOSND)                                     /*S01129*/
 
             CPYF FROMFILE(CPOSNA) TOFILE(&TOLIB/XCPOSNA) MBROPT(*REPLACE) +
FMTOPT(*NONE) CRTFILE(*YES)             /*S01129*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCPOSNA)                                     /*S01129*/
 
/************CPYF FROMFILE(UDEPPD) TOFILE(&TOLIB/XUDEPPD) MBROPT(*REPLA*101194*/
/*FMTOPT(*NONE)*CRTFILE(*YES)            /*S01129*/                   /*101194*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                  /*101194*/
/************EXEC(CLRPFM XUDEPPD)                         /*S01129*/  /*101194*/
/************MONMSG MSGID(CPF0000)                        /*E29032*/  /*101194*/
/***************                                          /*S01129*/  /*101194*/
/************CPYF FROMFILE(UDEPPA) TOFILE(&TOLIB/XUDEPPA) MBROPT(*REPLA*101194*/
/*FMTOPT(*NONE)*CRTFILE(*YES)            /*S01129*/                   /*101194*/
/************MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +                  /*101194*/
/************EXEC(CLRPFM XUDEPPA)                          /*S01129*/ /*101194*/
/*/COPY WNCPYSRC,SEC0606D06                                          */
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********    CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')              /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('Y')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
/****DISABLE*ACCESS PATHS FOR LOGICALS NOT REQUIRED BY THIS RPG    */ /*101194*/
/***************                                                      /*101194*/
/***************RMVM       FILE(CPOSN) MBR(CPOSN)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CPOSO) MBR(CPOSO)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CPOSS) MBR(CPOSS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPP) MBR(UDEPP)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPH) MBR(UDEPH)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPZ) MBR(UDEPZ)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(UDEPS) MBR(UDEPS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDPB) MBR(CUDPB)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDPP) MBR(CUDPP)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
/***************RMVM       FILE(CUDPS) MBR(CUDPS)                     /*101194*/
/***************MONMSG MSGID(CPF0000)                                 /*101194*/
 
/* OVERRIDE FILES                       */
 
             OVRDBF     FILE(SEKEYD) MBR(CPOSN1)
             OVRDBF     FILE(SEKEYA) MBR(CPOSN1)
             OVRDBF     FILE(POSETD) MBR(CPOSN1)
             OVRDBF     FILE(POSETA) MBR(CPOSN1)
/************OVRDBF     FILE(CPOSHI) TOFILE(CPOSH) */                 /*E15824*/
             OVRDBF     FILE(CPOSHI) TOFILE(CPOSH)  SHARE(*NO)        /*E15824*/
             OVRDBF     FILE(MATEXD) MBR(CUSTOMER)             /*AW*/
             OVRDBF     FILE(MATEXA) MBR(CUSTOMER)             /*AW*/
/*/COPY WNCPYSRC,SEC0606D04                                          */
 
/* SET UP VALUE OF &ACCRX FOR ORDINARY DAY RUN */                     /*S01189*/
 
             IF         COND(&ACCRX *EQ ' ') THEN(CHGVAR VAR(&ACCRX) +
                          VALUE(%SST(&SDSTAT 116 1)))                 /*S01189*/
 
/*  CALL SE2380 (UPDATE) */
 
             OVRDBF     FILE(SECEDI) TOFILE(SECED)                    /*081358*/
             OVRDBF     FILE(PMBVALP1) TOFILE(PMBVALPD) SHARE(*YES) +
                          /*081358*/
/************CALL       PGM(SE2380) */                                /*E15549*/
/************CALL       PGM(SE2380) PARM(ACCRX)       *E15549*         *E19833*/
             CALL       PGM(SE2380) PARM(&ACCRX)                      /*E19833*/
             DLTOVR     FILE(SECEDI)                                  /*081358*/
             DLTOVR     FILE(PMBVALP1)                                /*081358*/
 
/*  DELETE OVERIDES      */
 
             DLTOVR     *ALL
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RCVDTAARA  DTAARA(LDA) ******************************  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0606D - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR    VAR(&MEM) VALUE('SEC0606D - File Controls out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/***************CLRPFM     FILE(XUDEPPD)                   */         /*S01129*/
/***************CLRPFM     FILE(XUDEPPA)                   */         /*S01129*/
/***************CLRPFM     FILE(XCPOSND)                   */
/***************CLRPFM     FILE(XCPOSNA)                   */
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
/***************DLTF       FILE(XUDEPPD)                   /*S01129*/ /*101194*/
/***************   MONMSG MSGID(CPF0000)                   /*S01129*/ /*101194*/
/***************DLTF       FILE(XUDEPPA)                   /*S01129*/ /*101194*/
/***************   MONMSG MSGID(CPF0000)                   /*S01129*/ /*101194*/
/************   DLTF       FILE(XCPOSND) */                 /*S01129*  *E15616*/
/************      MONMSG MSGID(CPF0000) */                 /*S01129*  *E15616*/
                DLTF       FILE(XCPOSNA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC0606D07                                          */
 
             ENDDO
 
/*    ENABLE ACCESS PATHS  */
 
/*ENDPGM:*******ADDLFM   FILE(CPOSN) MBR(CPOSN)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(CPOSO) MBR(CPOSO)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(CPOSS) MBR(CPOSS)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(UDEPP) MBR(UDEPP)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(UDEPH) MBR(UDEPP)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(UDEPZ) MBR(UDEPZ)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(UDEPS) MBR(UDEPS)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(CUDEP) MBR(CUDEP)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(CUDPS) MBR(CUDPS)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
/***************ADDLFM   FILE(CUDPB) MBR(CUDPB)                       /*101194*/
/***************MONMSG  MSGID(CPF0000)                                /*101194*/
 
ENDPGM:                                                               /*101194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                ENDPGM
