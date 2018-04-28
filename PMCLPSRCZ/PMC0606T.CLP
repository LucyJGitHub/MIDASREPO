/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update Customer Positions')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0606T - UPDATE CUSTOMER POSITIONS                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV AMEND NO. S01486             DATE 17JUN94              */
/*                      051103     GB      DATE 18FEB93              */
/*                      049421             DATE 19JAN93              */
/*                      48106      GB      DATE 04DEC92              */
/*                      48107      DW      DATE 18NOV92              */
/*                      S01189             DATE 10APR92              */
/*                      S01189             DATE 10APR92              */
/*                      R05907             DATE 29APR91              */
/*                      R05803             DATE 09APR91              */
/*                      B5773              DATE 04APR91              */
/*                                                                   */
/*********************************************************************/
/*       S01408 - Addition of core hook PMC0606TM1                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       051103 - COB RECOVERY PROCESSING FOR PMC1100                */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       48106  - OVRDBF SEEVNT TO FILE SECED                        */
/*       48107  - PF/PMCPOSZZ NOT COPIED TO BACKUP FILE              */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS                     */
/*       R05907 - AMEND TO USE CORRECT MEMBERS IN POSETDX0           */
/*       R05803 - SET ON SWITCH U4 BEFORE CALLING SE2400             */
/*                IF PM PRESENT                                      */
/*       B5773  - INCLUDE PORTFOLIO MANAGMENT.CHANGES ORDER PGMS     */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&ACCRX)                                    S01189*/
             PGM        PARM(&ACCRX &CNAM &CSEQ)                      /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                   S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                   S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/********    DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)            S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
/*/COPY WNCPYSRC,PMC0606T01                                          */
/* B5773 */
             DCLF       FILE(SDMMODPD)
             RCVF       RCDFMT(SDMMODD0)                              /*E17398*/
 
             RTVDTAARA DTAARA(SDSTAT)  RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01486*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0606TM1                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (1) - UPDATE +
                          CUSTOMER POSITIONS')                          S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606T (1) - UPDATE +
                          CUSTOMER POSITIONS')                        /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
/*/COPY WNCPYSRC,PMC0606T02                                          */
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES  */
 
             CLRPFM     FILE(SEKEYD) MBR(CPOSN1)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN1)
             CLRPFM     FILE(SEKEYD) MBR(CPOSN2)
             CLRPFM     FILE(SEKEYA) MBR(CPOSN2)
 
             CLRPFM     FILE(POSETD) MBR(CPOSN1)
             CLRPFM     FILE(POSETA) MBR(CPOSN1)
             CLRPFM     FILE(POSETD) MBR(CPOSN2)
             CLRPFM     FILE(POSETA) MBR(CPOSN2)
 
             CLRPFM     FILE(MATEXD) MBR(CUSTOMER)
             CLRPFM     FILE(MATEXA) MBR(CUSTOMER)
 
             CLRPFM     FILE(PMBVALPD)                               /*R05803*/
 
/*********** CLRPFM     FILE(POSETDX0) MBR(CPOSN1)             /*R05907 S01486*/
/*********** CLRPFM     FILE(POSETDX0) MBR(CPOSN2)             /*R05907 S01486*/
/*/COPY WNCPYSRC,PMC0606T03                                          */
 
/* OVERRIDE FILES                       */
 
                OVRDBF FILE(CPOSND)  SEQONLY(*YES 100)
                OVRDBF FILE(CAPRHD)  SEQONLY(*YES 100)
                OVRDBF FILE(PRICED)  SEQONLY(*YES 100)
                OVRDBF FILE(XCPOSND) SEQONLY(*YES 100)
                OVRDBF FILE(XCAPRHD) SEQONLY(*YES 100)
                OVRDBF FILE(XPRICED) SEQONLY(*YES 100)
/************** OVRDBF FILE(XPMCPOSPP) SEQONLY(*YES 100)      /*S01189  S01486*/
                OVRDBF FILE(XPMCPOSPD) SEQONLY(*YES 100)              /*S01486*/
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/*********   RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)              S01189*/
 
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/* IF RESTART                                                       */
 
/*********   IF COND(&BUSY = 'NEW') THEN(DO)                            S01189*/
 
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
/* RESTORE FILES                                                    */
 
                CPYF FROMFILE(XCPOSND) TOFILE(CPOSND) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPOSND)
 
                CPYF FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CPOSNA)
 
                CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CAPRHD)
 
                CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CAPRHA)
 
                CPYF       FROMFILE(XPRICED) TOFILE(PRICED) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PRICED)
 
/************** CPYF       FROMFILE(XPMCPOSPP) TOFILE(PMCPOSPP) +
                MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01189  S01486*/
/************** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSPP)                 /*S01189  S01486*/
                CPYF       FROMFILE(XPMCPOSPD) TOFILE(PMCPOSPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)                        /*S01486*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSPD)                         /*S01486*/
 
/************** CPYF       FROMFILE(XPMCPOSZZ) TOFILE(PMCPOSZZ) +
                MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01189  S01486*/
/************** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSZZ)                 /*S01189  S01486*/
                CPYF       FROMFILE(XPMCPOSPA) TOFILE(PMCPOSPA) +
                MBROPT(*REPLACE) FMTOPT(*NONE)                        /*S01486*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM PMCPOSPA)                         /*S01486*/
 
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')             S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
 
/* DELETE SAVE FILES                    */
 
                DLTF       FILE(XCPOSNA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XPRICED)
                   MONMSG MSGID(CPF0000)
/************** DLTF       FILE(XPMCPOSPP)                     /*S01189 S01486*/
/***************** MONMSG MSGID(CPF0000)                       /*S01189 S01486*/
/************** DLTF       FILE(XPMCPOSZZ)                     /*S01189 S01486*/
/***************** MONMSG MSGID(CPF0000)                       /*S01189 S01486*/
                DLTF       FILE(XPMCPOSPD)                            /*S01486*/
                   MONMSG MSGID(CPF0000)                              /*S01486*/
                DLTF       FILE(XPMCPOSPA)                            /*S01486*/
                   MONMSG MSGID(CPF0000)                              /*S01486*/
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCPOSND)
 
             CPYF       FROMFILE(CPOSNA) TOFILE(&TOLIB/XCPOSNA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCPOSNA)
 
             CPYF       FROMFILE(CAPRHD) TOFILE(&TOLIB/XCAPRHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCAPRHD))
 
             CPYF       FROMFILE(CAPRHA) TOFILE(&TOLIB/XCAPRHA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCAPRHA))
 
             CPYF       FROMFILE(PRICED) TOFILE(&TOLIB/XPRICED) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPRICED))
 
/*********** CPYF       FROMFILE(PMCPOSPP) TOFILE(&TOLIB/XPMCPOSPP) +
                MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)   /*S01189 S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPP))                     /*S01189 S01486*/
             CPYF       FROMFILE(PMCPOSPD) TOFILE(&TOLIB/XPMCPOSPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPD))                            /*S01486*/
 
/* >>> 48107 >>> */
/*********** CPYF       FROMFILE(PMCPOSZZ) TOFILE(&TOLIB/XPMCPOSZZ) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)   S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSZZ))                              S01486*/
             CPYF       FROMFILE(PMCPOSPA) TOFILE(&TOLIB/XPMCPOSPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPA))                            /*S01486*/
/* <<< 48107 <<< */
 
             CPYF       FROMFILE(PRICED) TOFILE(&TOLIB/XPRICED) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01189*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPRICED))                              /*S01189*/
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/*********   CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')                S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* OVERRIDE FILES                       */
 
             OVRDBF     FILE(SEKEYD) MBR(CPOSN1)
             OVRDBF     FILE(SEKEYA) MBR(CPOSN1)
             OVRDBF     FILE(POSETD) MBR(CPOSN1)
             OVRDBF     FILE(POSETA) MBR(CPOSN1)
             OVRDBF     FILE(CPOSHI) TOFILE(CPOSH)  SHARE(*NO)
             OVRDBF     FILE(MATEXD) MBR(CUSTOMER)
             OVRDBF     FILE(MATEXA) MBR(CUSTOMER)
             OVRDBF     FILE(SECEDI) TOFILE(SECED) SHARE(*NO)         /*R05803*/
             OVRDBF     FILE(SECET) SHARE(*NO)                        /*R05803*/
             OVRDBF     FILE(PMBVALP1) TOFILE(PMBVALPD) SHARE(*NO)    /*R05803*/
/*********** OVRDBF     FILE(POSETDX0) MBR(CPOSN1)             /*R05907 S01486*/
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)        /* 48106 */
/*/COPY WNCPYSRC,PMC0606T04                                          */
 
/*  CALL SE2380 (UPDATE) */
 
             CALL       PGM(SE2380) PARM(&ACCRX)
 
/*  DELETE OVERIDES      */
 
             DLTOVR     *ALL
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))     S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01486*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606T (1) - JOB TERMINATED,+
                          DATABASE IN ERROR')                           S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606T (1) - JOB TERMINATED,+
                          DATABASE IN ERROR')                         /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606T (1) - FILE CONTROLS +
                         OUT OF BALANCE')                               S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606T (1) - FILE CONTROLS +
                         OUT OF BALANCE')                             /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* SEND PGM MESSAGE */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (3) - UPDATE +
                          CUSTOMER AVERAGE PRICES')                     S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606T (3) - UPDATE +
                          CUSTOMER AVERAGE PRICES')                   /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* IF PM INSTALLED SET ON SWITCH U4 BEFORE CALLING PROGRAM */
 
             IF         COND(&BGPFMG *EQ 'Y') THEN(CHGJOB +
                          SWS(00010000))                    /* B5773 */
 
/* CALL PROGRAM TO EXTRACT TODAY'S CUSTOMER AVERAGE PRICES */
 
                CALL       PGM(SE2405)
 
/* IF NO ERRORS CALL PROGRAM TO UPDATE CUSTOMER AVERAGE PRICES */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CALL       PGM(SE2410)
             ENDDO
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                        TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (3) -DATABASE ERROR') S01486*/
           CHGVAR     VAR(&MEM) VALUE('PMC0606T (3) -DATABASE ERROR') /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*********** CHGVAR    VAR(&MEM) VALUE('SEC0606T (3) - FILE CONTROLS +
                        OUT OF BALANCE')                              /*S01486*/
             CHGVAR    VAR(&MEM) VALUE('PMC0606T (3) - FILE CONTROLS +
                        OUT OF BALANCE')                              /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/*  B5773  */
/*  CALL PORTFOLIO SE POSITIONS UPDATE. SE2400 MUST RUN AFTER THIS   */
/*  SO THAT POSITION SETTLEMENTS ARE SPLIT BY PORTFOLIO              */
 
             IF   COND(&BGPFMG *EQ 'Y') THEN(DO)
                CALL PMC1100
             ENDDO
 
/* >>> 051103 >>> */
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR    VAR(&MEM) VALUE('PMC1100  - FILE CONTROLS +
                        OUT OF BALANCE')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
/* <<< 051103 <<< */
 
/* SETUP AND SEND PGM MESSAGE                */
 
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (2) - A/C KEYS/+
                          POSN SETTLEMENTS-CUSTOMER POSNS')           /*S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606T (2) - A/C KEYS/+
                          POSN SETTLEMENTS-CUSTOMER POSNS')           /*S01486*/
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES          */
 
             CHGJOB     SWS(00000000)
 
             OVRDBF     FILE(SEKEYD) MBR(CPOSN2)
             OVRDBF     FILE(SEKEYA) MBR(CPOSN2)
             OVRDBF     FILE(POSETD) MBR(CPOSN2)
             OVRDBF     FILE(POSETA) MBR(CPOSN2)
             OVRDBF     FILE(MATEXD) MBR(CUSTOMER)
             OVRDBF     FILE(MATEXA) MBR(CUSTOMER)
                                                                      /*R05803*/
             OVRDBF     FILE(PMCPSSLL) SHARE(*NO)                     /*R05803*/
             OVRDBF     FILE(PMFPSNLL) SHARE(*NO)                     /*R05803*/
             OVRDBF     FILE(PMAPOSLL) SHARE(*NO)                     /*R05803*/
             OVRDBF     FILE(SECET) SHARE(*NO)                        /*R05803*/
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)         /*R05803*/
             OVRDBF     FILE(CPOSH) SHARE(*NO)               /*R05803*/
             OVRDBF     FILE(CPOSS) SHARE(*NO)               /*R05803*/
             OVRDBF     FILE(XCPOSH) SHARE(*NO)              /*R05803*/
/*********** OVRDBF     FILE(POSETDX0) MBR(CPOSN2)             /*R05907 S01486*/
/*/COPY WNCPYSRC,PMC0606T05                                          */
 
/* CALL THE PROGRAM                   */
 
             IF         COND(&BGPFMG *EQ 'Y') THEN(CHGJOB +
                          SWS(00010000))                    /* B5773 */
 
             CALL       PGM(SE2400)
 
/* DELETE OVERRIDE                 */
 
             DLTOVR     *ALL
 
             RCLRSC                                                   /*E15777*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA    */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (144 34)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (2)- JOB TERMINATED,+
                          DATABASE IN ERROR')                           S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606T (2)- JOB TERMINATED,+
                          DATABASE IN ERROR')                         /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*********** CHGVAR     VAR(&MEM) VALUE('SEC0606T (2) - FILE CONTROLS +
                          OUT OF BALANCE')                              S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0606T (2) - FILE CONTROLS +
                          OUT OF BALANCE')                            /*S01486*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
 
 
/* CHANGE DATA AREA   TO 'OLD'          */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')             S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
                CLRPFM     FILE(XCPOSND)
 
/* DELETE COPY FILES                               */
 
                DLTF       FILE(XCPOSNA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHD)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHA)
                   MONMSG MSGID(CPF0000)
                DLTF       FILE(XPRICED)
                   MONMSG MSGID(CPF0000)
/************** DLTF       FILE(XPMCPOSPP)                     /*S01189 S01486*/
/***************** MONMSG MSGID(CPF0000)                       /*S01189 S01486*/
/************** DLTF       FILE(XPMCPOSZZ)                     /*S01189 S01486*/
/***************** MONMSG MSGID(CPF0000)                       /*S01189 S01486*/
                DLTF       FILE(XPMCPOSPD)                            /*S01486*/
                   MONMSG MSGID(CPF0000)                              /*S01486*/
                DLTF       FILE(XPMCPOSPA)                            /*S01486*/
                   MONMSG MSGID(CPF0000)                              /*S01486*/
ENDPGM:                                                               /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/****ENDPGM:      ENDPGM                                                S01486*/
                ENDPGM                                                /*S01486*/
