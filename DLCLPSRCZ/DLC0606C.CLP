/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Generate Accounting Entries')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0606C - GENERATE ACCOUNTING ENTRIES                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG23276           Date 10Mar09              */
/*                      CER044             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9812            Date 08Feb06             */
/*                      215832             Date 20Mar03             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001             Date 18Apr01             */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186804             Date 23Nov00              */
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30Oct95              */
/*                      CIR001             Date 13Jun95             */
/*                      E23407             DATE  14SEP90            */
/*                      LN0465             DATE  03JUL90            */
/*                      S01117             DATE  25/04/89           */
/*                      S01194             DATE  25/04/89           */
/*                      E18                DATE  31OCT89            */
/*                      S01179             DATE  12/09/88           *  *S05452*/
/*                      S05452             DATE  20/08/87           *  *S05452*/
/*                      S01098             DATE  22/09/86           *  *S01098*/
/*                      S01094             DATE  22/09/86           *  *S01094*/
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23276 - Items with Customers set up as Banks not shown   */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*       BUG9812 - Do not clear the keys generated if there were    */
/*                 no missing account keys found. The keys should   */
/*                 remain for CMR001 and CRN001 reporting features. */
/*                 The keys will be cleared at end of COB by DLC10. */
/*       215832 - In case of error in DL0295, EOD continues because */
/*                U7U8 not checked before calling MXC0490. And this */
/*                program resets U7U8...                            */
/*       CMX001 - Meridian Export                                   */
/*       186804 - Distinguish if program was called from             */
/*                input cycle termination or initiation              */
/*       CDL008 - Continuous Linked Settlement                      */
/*       S01408 - Apply Core Hooks DLC0606004                       */
/*       S01408 - Apply Core Hooks DLC0606C01                       */
/*                Apply Core Hooks DLC0606C02                       */
/*                Apply Core Hooks DLC0606C03                       */
/*       CIR001 - Interest Rate Calendars.                          */
/*       E23407 - CHECK FOR MODULES RE(RETAIL 2 - MMOD POSITION     */
/*                16) OR IA(INTEREST ON ACCOUNTS - MMOD POSITION    */
/*                23), RATHER THAN RT(RETAIL 1 - MMOD POSITION      */
/*                3).                                               */
/*       LN0465  -  AMENDED TO CALL CB0175 TO SET ON HALT AFTER     */
/*                  COMPONENT FLAG IF APPROPRIATE                   */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES                           */
/*       S01179  -  AS400 CONVERSION                                */
/*       S05452  -  INCLUSION OF AUTO RECONCILIATIONS               *  *S05452*/
/*       S01098  -  Buffer GEDLPD                                   *  *S01098*/
/*       S01094  -  TO IMPROVE PERFORMANCE OF DL0295, TABLED NO     *  *S01094*/
/*                  LONGER USED AND THEREFORE OVERRIDE REMOVED.     *  *S01094*/
/*       E18     -  REMOVE CALLING PARAMETERS                       */
/*                                                                  */
/********************************************************************/
/*********   PGM PARM(&POST)                                          /*LN0465*/
             PGM PARM(&POST &NAM &SEQ)                                /*LN0465*/
/*/COPY WNCPYSRC,DLC0606C06                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
/*********** DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)      /*S05452* /*S01117*/
/*********** DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/*********** DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*LN0465*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*LN0465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*CIR001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CIR001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +
                          VALUE('CIR001')                             /*CIR001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CIR001*/
             DCL        VAR(&CIR001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CIR001*/
             DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL008*/
             DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CMX001*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CDL008*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*CDL008*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  +
                          DPLIB')                                     /*CDL008*/
             DCL        VAR(&CER044) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CER044*/
/*/COPY WNCPYSRC,DLC0606C05                                          */
/**/                                                                  /*CIR001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CIR001*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CIR001) VALUE('Y'))                 /*CIR001*/
                                                                      /*CDL008*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                     /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CDL008*/
                                                                      /*CDL008*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CDL008) VALUE('Y'))                 /*CDL008*/
                                                                      /*CDL008*/
                                                                      /*CMX001*/
             CHGVAR     VAR(&SAR) VALUE('CMX001')                     /*CMX001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CMX001*/
                                                                      /*CMX001*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                 /*CMX001*/
                                                                      /*CDL008*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*CDL008*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)     /*CDL008*/
/**/                                                                  /*CDL008*/
/*    Call program CB0160 to get value of restart indicator.          /*CDL008*/
/**/                                                                  /*CDL008*/
             CALL       PGM(CB0160) PARM(&NAM &SEQ &STAT)             /*CDL008*/
/**/                                                                  /*CDL008*/
/*  If it not a restart. Backup pay-in schedule header file.          /*CDL008*/
/**/                                                                  /*CDL008*/
                 IF         COND(&STAT = 'N') THEN(DO)                /*CDL008*/
                                                                      /*CDL008*/
                  IF         COND(&CDL008 = 'Y') THEN(DO)             /*CDL008*/
                   DLTF       FILE(XFXCLSPSH)                         /*CDL008*/
                   MONMSG     MSGID(CPF2105)                          /*CDL008*/
                                                                      /*CDL008*/
             CPYF       FROMFILE(FXCLSPSH) TOFILE(&DPLIB/XFXCLSPSH) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*CDL008*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          /*CDL008*/
                  ENDDO                                               /*CDL008*/
                                                                      /*CDL008*/
                 ENDDO                                                /*CDL008*/
/**/                                                                  /*CDL008*/
/*  If it a restart. Restore backup pay-in schedule header file.      /*CDL008*/
/**/                                                                  /*CDL008*/
                 IF         COND(&STAT = 'Y') THEN(DO)                /*CDL008*/
                                                                      /*CDL008*/
                  IF         COND(&CDL008 = 'Y') THEN(DO)             /*CDL008*/
                   CPYF       FROMFILE(XFXCLSPSH) TOFILE(FXCLSPSH) +
                              MBROPT(*REPLACE)                        /*CDL008*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(FXCLSPSH))             /*CDL008*/
                  ENDDO                                               /*CDL008*/
                                                                      /*CDL008*/
                 ENDDO                                                /*CDL008*/
/**/                                                                  /*CDL008*/
/** Call CB0150 to update restart indicator                           /*CDL008*/
/**/                                                                  /*CDL008*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CDL008*/
             CALL       PGM(CB0150) PARM(&NAM &SEQ &STAT)             /*CDL008*/
                                                                      /*CDL008*/
 
/*/COPY WNCPYSRC,DLC0606C01                                        */ /*S01408*/
 
 
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
/*   CLEAR GEDL PFS                                             */
             CHGJOB     SWS(10000000)
             IF         COND(&POST *EQ '1') THEN(DO)
                CLRPFM     FILE(GEDLHH)
                CLRPFM     FILE(GEDLPD)
                CLRPFM     FILE(GEDLZZ)
             ENDDO
             CLRPFM     FILE(GEDL2HH)
             CLRPFM     FILE(GEDL2PD)
             CLRPFM     FILE(GEDL2ZZ)
/*  IF RETAIL MOD SWITCH 2 - GENERATE ACCOUNTING ENTRIES - CLEAR GEDL*/
/*********** RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/
/************IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y') THEN(DO)    E23407*/
             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 23 1) = 'Y')) THEN(DO)    /*E23407*/
                CHGJOB     SWS(X1XXXXXX)
             ENDDO
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
/************OVRDBF     FILE(TABLED) TOFILE(TABDLEE)      */          /*S01094*/
             IF         COND(&POST *EQ '5') THEN(DO)
                OVRDBF     FILE(GEDLHH) TOFILE(GEDL2HH)
/************** OVRDBF     FILE(GEDLPD) TOFILE(GEDL2PD)   */          /*S01098*/
                OVRDBF     FILE(GEDLPD) TOFILE(GEDL2PD) +
                              SEQONLY(*YES 250)                       /*S01098*/
                OVRDBF     FILE(GEDLZZ) TOFILE(GEDL2ZZ)
             ENDDO                                                    /*S01098*/
             IF         COND(&POST *EQ '1') THEN(DO)                  /*S01098*/
                OVRDBF     FILE(GEDLPD) SEQONLY(*YES 250)             /*S01098*/
             ENDDO
             SNDPGMMSG  MSG('Deal Generated Account Or Retail Shadow +
                        Postings') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/************CALL       PGM(DL0295)                                   /*S01117*/
/************CALL       PGM(DL0295) PARM(&RSEQ &RENT)         /*E18     S01117*/
 
/*/COPY WNCPYSRC,DLC0606C02                                        */ /*S01408*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER044*/
             CHGVAR     VAR(&SAR) VALUE('CER044')                                         /*CER044*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CER044*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CER044*/
             CHGVAR     VAR(&CER044) VALUE('Y')                                           /*CER044*/
             CPYF       FROMFILE(DKEYSDP) TOFILE(QTEMP/XXDKEYSDP) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CER044*/
             ENDDO                                                                        /*CER044*/
                                                                                          /*CER044*/
             CALL       PGM(DL0295)                           /*E18     S01117*/
/** Clear Extract file   */                                                               /*CER044*/
             IF         COND(&CER044 *EQ 'Y') THEN(DO)                                    /*CER044*/
/**********  CLRPFM     FILE(GLAWVDPD)  */                                   /*CER044*/ /*BUG23276*/
/**********  CLRPFM     FILE(GLAWXDPD)  */                                   /*CER044*/ /*BUG23276*/
             CALL       PGM(DL000298)                                                     /*CER044*/
             DLTF       FILE(QTEMP/XXDKEYSDP)                                             /*CER044*/
             ENDDO                                                                        /*CER044*/
                                                                                          /*CER044*/
             DLTOVR     FILE(GEDLPD)                                  /*S01098*/
                                                                      /*CMX001*/
             IF         COND(&CMX001 = 'Y') THEN(DO)                  /*CMX001*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*215832*/
             CALL       PGM(MXC0490) PARM('DLC0606C' &POST)           /*CMX001*/
             ENDDO                                                    /*215832*/
             ENDDO                                                    /*CMX001*/
                                                                      /*CMX001*/
                                                                      /*CDL008*/
             IF         COND(&CDL008 = 'Y') THEN(DO)                  /*CDL008*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CDL008*/
/*********** CALL       PGM(DL0296) */                     /*CDL008*/ /*186804*/
             CALL       PGM(DL0296) PARM('Y')                         /*186804*/
             ENDDO                                                    /*CDL008*/
             ENDDO                                                    /*CDL008*/
 
/*/COPY WNCPYSRC,DLC0606C03                                        */ /*S01408*/
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                IF         COND(&POST *EQ '1') THEN(DO)
                   CLRPFM     FILE(GEDLHH)
                   CLRPFM     FILE(GEDLPD)
                   CLRPFM     FILE(GEDLZZ)
                ENDDO
                IF         COND(&POST *EQ '5') THEN(DO)
                   CLRPFM     FILE(GEDL2HH)
                   CLRPFM     FILE(GEDL2PD)
                   CLRPFM     FILE(GEDL2ZZ)
                ENDDO
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)
/****************  RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM) S05452  S01117*/
/****************  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +            /*S01117*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)       /*S01117*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) +
                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)                  /*S05452*/
                ENDDO
                ELSE       CMD(SNDPGMMSG MSG('FILE CONTROLS OUT OF +
                             BALANCE') TOMSGQ(MOPERQ MRUNQ))
             ENDDO
             ELSE       CMD(IF COND(%SWITCH(XXX0XXXX)) THEN(DO))
/**********     CLRPFM        FILE(DKEYSHH)                                           */ /*BUG9812*/
/**********     CLRPFM        FILE(DKEYSDP)                                           */ /*BUG9812*/
/**********     CLRPFM        FILE(DKEYSZZ)                                           */ /*BUG9812*/
             ENDDO
             ELSE          CMD(DO)
/**/
/*              RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01179*/
/**/
                IF         COND(%SUBSTRING(&DLSTAT 15 1) *EQ 'Y')    +
                             THEN(SNDPGMMSG MSG('DEALING +
                             A/C KEYS MISSING - PROCESSING +
                             CONTINUED') TOMSGQ(MRUNQ))
/**/
                ELSE       CMD(DO)
/**/
                   SNDPGMMSG  MSG('DEALING A/C KEYS +
                                MISSING - PROCESSING HALTED') +
                                TOMSGQ(MOPERQ MRUNQ)
/**/                                                                  /*LN0465*/
                   CALL       PGM(CB0175) PARM(&NAM &SEQ)             /*LN0465*/
/**/
                ENDDO
/**/
/*/COPY WNCPYSRC,DLC0606C04                                        */ /*S01408*/
/**/
             ENDDO
/**/                                                                  /*CIR001*/
/*    If CIR001 is switched ON, override LF/DEALSX and           */   /*CIR001*/
/*    run DL4100 to set processed indicators on IRS change files */   /*CIR001*/
             IF         COND(&CIR001 *EQ 'Y') THEN(DO)                /*CIR001*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*CIR001*/
               CHGJOB     SWS(00000000)                               /*CIR001*/
               OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)       /*CIR001*/
               CALL       PGM(DL4100)                                 /*CIR001*/
               DLTOVR     FILE(DEALSX)                                /*CIR001*/
               IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)            /*CIR001*/
                   SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)                  /*CIR001*/
                   RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       /*CIR001*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)                  /*CIR001*/
               ENDDO                                                  /*CIR001*/
             ENDDO                                                    /*CIR001*/
             ENDDO                                                    /*CIR001*/
/**/                                                                  /*CDL008*/
/*  If no error occured in the program, delete backup file.           /*CDL008*/
/**/                                                                  /*CDL008*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            /*CDL008*/
/**/                                                                  /*CDL008*/
/** Call CB0150 to update restart indicator */                        /*CDL008*/
/**/                                                                  /*CDL008*/
                CHGVAR     VAR(&STAT) VALUE('N')                      /*CDL008*/
                CALL       PGM(CB0150) PARM(&NAM &SEQ &STAT)          /*CDL008*/
                IF         COND(&CDL008 = 'Y') THEN(DO)               /*CDL008*/
                     DLTF       FILE(XFXCLSPSH)                       /*CDL008*/
                     MONMSG     MSGID(CPF2105)                        /*CDL008*/
                ENDDO                                                 /*CDL008*/
               ENDDO                                                  /*CDL008*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
