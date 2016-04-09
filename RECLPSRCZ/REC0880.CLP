/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail advices print')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC0880 - RETAIL ADVICES PRINT                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD029076           Date 03Mar15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 241672A            Date 09Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG2714            Date 25May04              */
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/*                      192597             Date 01May01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      136208             Date 12Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      103220             DATE 23MAY96              */
/*                      088206             DATE 14JUN95              */
/*                      S01522             DATE 09JAN95              */
/*                      S01413             DATE 13APR93              */
/*                      S01229 (S01251)    DATE 04APR90              */
/*                      S01117                  16MAR90              */
/*                      S01194                  09MAR90              */
/*                      E19313                  01NOV89              */
/*                      E18562                  27JUN89              */
/*                      E17597                  26JAN89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD029076 - REC0880 create dumps in Module GOGLOBGL calling  */
/*                  GPGLJENHPD                                       */
/*       241672A - REC0880 in MSGW.  Generate report to determine    */
/*                 which jobs are locking the GLJENHPD.              */
/*       BUG2714 - STRCMTCTL should separately be done here because  */
/*                 the scope of the commitment control by java, is   */
/*                 for QZDASOINIT job only. Thus, this component is  */
/*                 not affected because it is submitted. Reverse     */
/*                 CSC022 changes.                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       192597 - Silly error in 136208. Conditioning for UDCs needs */
/*                to be added to CGC5217 as well as CG4900.          */
/*       136208 - UDC advices are not printing as the UDC print      */
/*                program not called - add call to CGC5217.          */
/*              - Add ABNOR processing.                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       103220 - Create data area LDA if it doesn't exist.          */
/*       088206 - REC0880 fails due to msg file CGUSRMSG not found.  */
/*                It should be overridden to the xxCGUSRMSG, where   */
/*                'xx' is the language of the user.                  */
/*       S01522  - User Defined Correspondence                       */
/*                                                                   */
/*       S01413  - OVRMSGF MIDAS to appropriate language.            */
/*                                                                   */
/*       S01251  - Synon Name Changes                                */
/*                                                                   */
/*       S01229  - Synon File Name Changes                           */
/*                                                                   */
/*       S01117  - Multibranching                                    */
/*                                                                   */
/*       S01194  - New Standing Data                                 */
/*                                                                   */
/*       E19313  - Override added because of new file in RE0880      */
/*                 file added to avoid record locking.               */
/*                                                                   */
/*       E18562  - Termination Message Incorrect                     */
/*                                                                   */
/*       E17597  - Call Program with correct parameters and          */
/*                 under Commitment Control                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&BNUM &WRKSTN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&MSG)   TYPE(*CHAR) LEN(50)
/*           DCL VAR(&BNUM)  TYPE(*DEC)  LEN(3 0)                     /*E17597*/
             DCL VAR(&BNUM)  TYPE(*CHAR) LEN(3)                       /*E17597*/
             DCL VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
/************DCL VAR(&MEM) TYPE(*CHAR) LEN(44)             /*E17597*/ /*S01194*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01194*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*E17597*/
/* START OF FIX S01413 */
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)
/* END OF FIX S01413 */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&CGMSGF) TYPE(*CHAR) LEN(10)              /*088206*/
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)                               /*CCG015*/
/**********  DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE('N') */         /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WCMTSK) TYPE(*CHAR) LEN(1) VALUE('N') */         /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WSCCMTJOB) TYPE(*CHAR) LEN(256) */               /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WCMTNUM) TYPE(*DEC) LEN(3 0) */                  /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WCMTJOB) TYPE(*CHAR) LEN(100) */                 /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&PRTN) TYPE(*CHAR) LEN(7) */                      /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&POPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') */     /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&PSAR) TYPE(*CHAR) LEN(6) VALUE('CSC022') */      /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200) */                    /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WJOB) TYPE(*CHAR) LEN(10) */                     /*CSC022*/ /*BUG2714*/
/**********  DCL        VAR(&WSTR) TYPE(*DEC) LEN(2 0) VALUE(1) */            /*CSC022*/ /*BUG2714*/
             DCL        VAR(&GLHLCK) TYPE(*CHAR) LEN(1) VALUE('N')                       /*241672A*/
/*/COPY WNCPYSRC,REC0880001                                          */
                                                                      /*E17597*/
/*  Global Monitor Message                                            /*136208*/
                                                                      /*136208*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*136208*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('REC0880 - Retail Advices print: batch' +
                          *BCAT &BNUM *BCAT 'from device' +
                          *BCAT &WRKSTN) TOMSGQ(MRUNQ)                                   /*241672A*/
/**********/                                                                  /*CSC022*/ /*BUG2714*/
/**Retrieve*Commitment*Control*Jobs*data*area*************************/       /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTN &POPT &PSAR &PFMT) */        /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  IF         COND(&PRTN *EQ *BLANKS) THEN(DO) */                   /*CSC022*/ /*BUG2714*/
/**********  CHGVAR     VAR(&CSC022) VALUE('Y') */                            /*CSC022*/ /*BUG2714*/
/**********  CHGVAR     VAR(&WCMTSK) VALUE('N') */                            /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  RTVDTAARA  DTAARA(SCCMTJOB) RTNVAR(&WSCCMTJOB) */                /*CSC022*/ /*BUG2714*/
/**********  CHGVAR     VAR(&WCMTNUM) VALUE(%SST(&WSCCMTJOB 1 3)) */          /*CSC022*/ /*BUG2714*/
/**********  CHGVAR     VAR(&WCMTJOB) VALUE(%SST(&WSCCMTJOB 4 103)) */        /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  IF         COND(&WCMTNUM *GT 0) THEN(DO) */                      /*CSC022*/ /*BUG2714*/
/**********  RTVJOBA    JOB(&WJOB) */                                         /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/*SCAN:****   IF         COND(&WJOB *EQ %SST(&WCMTJOB &WSTR 10)) +
                          THEN(CHGVAR VAR(&WCMTSK) VALUE('Y')) */             /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  ELSE       CMD(DO) */                                            /*CSC022*/ /*BUG2714*/
/**********  CHGVAR     VAR(&WSTR) VALUE(&WSTR + 10) */                       /*CSC022*/ /*BUG2714*/
/**********  IF         COND(&WSTR *LT 100) THEN(GOTO CMDLBL(SCAN)) */        /*CSC022*/ /*BUG2714*/
/**********  ENDDO */                                                         /*CSC022*/ /*BUG2714*/
/*********************************************************************/       /*CSC022*/ /*BUG2714*/
/**********  ENDDO */                                                         /*CSC022*/ /*BUG2714*/
/**********  ENDDO */                                                         /*CSC022*/ /*BUG2714*/
/**********  ELSE       CMD(IF COND(&PRTN *NE '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))) */                                  /*CSC022*/ /*BUG2714*/
                                                                      /*E17597*/
/**********  STRCMTCTL  LCKLVL(*CHG)                           /*E17597 CPK009*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */           /*CSC022*/ /*BUG2714*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
/**********  ENDDO */                                                         /*CSC022*/ /*BUG2714*/
                                                                      /*E19313*/
                                                                      /*103220*/
/* */                                                                 /*103220*/
/* Create LDA if it does not already exist */                         /*103220*/
/**/                                                                  /*103220*/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                     /*103220*/
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))                     /*103220*/
/* */                                                                 /*103220*/
/* START OF FIX S01413 */
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)
             CHGVAR     VAR(&CGMSGF) VALUE(&MULT *CAT 'CGUSRMSG')     /*088206*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGMSGF)                /*088206*/
/* END OF FIX S01413 */
/************OVRDBF     FILE(GLBTXXX1) TOFILE(GLBTREL1) SHARE(*NO)    /*S01229*/
             OVRDBF     FILE(GLJEXXX1) TOFILE(GLJENPL1) SHARE(*NO)    /*S01229*/
                                                                      /*E19313*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
/************GOTO       CMDLBL(ENDPGM)                         /*S01522 136208*/
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*S01522*/
                                                                                          /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                                                                                          /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
/************IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)/S01522/*205448*/
             CALL       PGM(CG4900) PARM(&BNUM &W0RTN)                /*S01522*/
                                                                      /*S01522*/
/**********  RCLRSC */                                                           /*S01522 MD029076*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             SNDPGMMSG  MSG('User Defined Correspondence Extract +
                          failure') TOMSGQ(MOPERQ)
/************GOTO       CMDLBL(ENDPGM)                         /*S01522 136208*/
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*S01522*/
/************ENDDO                                             /S01522/*205448*/
                                                                                          /*CCG015*/
/** Call Custom-Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                                 /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ABNOR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
             ENDDO                                                                        /*205448*/
 
/*/COPY WNCPYSRC,REC0880002                                          */
             CALL PGM(RE0880) PARM(&BNUM)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*136208*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)         /*136208*/
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*136208*/
                                                                      /*136208*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*192597*/
             CALL       PGM(CGC5217) PARM('')                         /*136208*/
                                                                      /*136208*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*136208*/
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*136208*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)         /*136208*/
             GOTO       CMDLBL(ABNOR)                                 /*136208*/
             ENDDO                                                    /*136208*/
             ENDDO                                                    /*192597*/
 
             SNDPGMMSG  MSG('REC0880 - Ended normally for batch' +
                          *BCAT &BNUM *BCAT 'from device' +
                          *BCAT &WRKSTN) TOMSGQ(MRUNQ)                                   /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
                                                                                         /*241672A*/
             GOTO       CMDLBL(ENDPGM)                                /*136208*/
 
ABNOR:                                                                /*136208*/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)                                 /*241672A*/
             CHGVAR     VAR(&GLHLCK) VALUE('Y')                                          /*241672A*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                   /*241672A*/
             ENDDO                                                                       /*241672A*/
 
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
             ENDDO                                                                        /*205448*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */           /*CSC022*/ /*BUG2714*/
                ROLLBACK
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                /*136208*/
/**********  ENDDO */                                                         /*CSC022*/ /*BUG2714*/
/**********  ELSE       CMD(CHGJOB     SWS(XXXXXX11)) */                      /*CSC022*/ /*BUG2714*/
                SNDPGMMSG  MSG('Retail Advice Print failed') +
                        TOMSGQ(&WRKSTN MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                /*136208*/
             DMPCLPGM                                                 /*136208*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                /*136208*/
/***************GOTO ENDPGM                                           /*136208*/
/************ENDDO                                                    /*136208*/
 
/*/COPY WNCPYSRC,REC0880003                                          */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                    /*E17597*/
               MONMSG     MSGID(RPG0000 CPF0000 MCH0000)              /*136208*/
/******CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44)) /*E17597*/ /*S01194*/
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))    /*S01194*/
               MONMSG     MSGID(RPG0000 CPF0000 MCH0000)              /*136208*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*E17597*/
               MONMSG     MSGID(RPG0000 CPF0000 MCH0000)              /*136208*/
/****          CHGVAR     VAR(&MEM) VALUE('GLC0880 - Job Termination, + E18562*/
               CHGVAR     VAR(&MEM) VALUE('REC0880 - Job Termination, +
                          Database in Error')                         /*E17597*/
               MONMSG     MSGID(RPG0000 CPF0000 MCH0000)              /*136208*/
               SNDPGMMSG  MSG(&MEM) TOMSGQ(&WRKSTN MOPERQ)            /*E17597*/
               MONMSG     MSGID(RPG0000 CPF0000 MCH0000)              /*136208*/
/**************ROLLBACK                                        /*E17597 136208*/
/*           CHGVAR   VAR(&MSG) VALUE('JOB TERMINATED - DATABASE IN + /*E17597*/
/*                        ERROR')                                     /*E17597*/
/*              ROLLBACK                                              /*E17597*/
/*                                                                    /*E17597*/
/*              SNDPGMMSG  MSG(&MSG) TOMSGQ(&WRKSTN MOPERQ) +         /*E17597*/
/*                        MSGTYPE(*INFO)                              /*E17597*/
             ENDDO
                                                                                         /*241672A*/
/** Generate report for jobs locking GLJENHPD */                                         /*241672A*/
                                                                                         /*241672A*/
             IF         COND(%SWITCH(XX1XXXXX) *OR +
                            (&GLHLCK *EQ 'Y')) THEN(DO)                                  /*241672A*/
                CALL       PGM(SCDOBJLCK) PARM('GLJENHPD' '*LIBL' +
                             '*FILE' '*PRINT')                                           /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
                                                                                         /*241672A*/
                CHGJOB     SWS(XXXXXX11)                                                 /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('REC0880 - Unable to allocate record on +
                          GLJENHL0, batch ' *BCAT &BNUM *CAT ', see +
                          joblog and dumps') TOMSGQ(MRUNQ MOPERQ)                        /*241672A*/
                MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                                /*241672A*/
             ENDDO                                                                       /*241672A*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('REC0880 - Ended in error for batch' +
                          *BCAT &BNUM *BCAT 'from device' +
                          *BCAT &WRKSTN) TOMSGQ(MRUNQ MOPERQ)                            /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
 
/*DPGM:      ENDPGM                                                   /*E17597*/
/*DPGM:******ENDCMTCTL                                                /*E17597*/
/*ENDPGM:**/                                                                  /*CSC022*/ /*BUG2714*/
/**********  IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO) */           /*CSC022*/ /*BUG2714*/
/**********  ENDCMTCTL */                                                     /*CSC022*/ /*BUG2714*/
  ENDPGM:                                                                                /*BUG2714*/
             ENDCMTCTL                                                                   /*BUG2714*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                /*136208*/
/**********  ENDDO                                                            /*CSC022*/ /*BUG2714*/
             RCLRSC                                                   /*S01117*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)                /*136208*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*E17597*/
