/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Financial Loans Diary - Extrct & Rpt')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0711 - FINANCIAL LOANS DIARY, EXTRACT AND REPORT         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*       1989                                                        */
/*                                                                   */
/*       Last Amend No. CLE053             Date 27Jul20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE050             Date 09Mar06              */
/*                      CLE025             Date 20Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      098642             Date 27Jun96              */
/*                      080565             Date 27Jan95              */
/*                      055506             DATE 16DEC93              */
/*                  NO. S01339             DATE 09APR92              */
/*                  NO. E37223             DATE 09OCT90              */
/*                  NO. LN0978             DATE 14NOV90              */
/*                  NO. S01194             DATE 07FEB90              */
/*                  NO. S01117             DATE 07FEB90              */
/*                  NO. S01179             DATE 07FEB90              */
/*                  NO. E12672             DATE 21/03/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE053 - Financial Loans Diary Changes                      */
/*       MD046248 - Finastra Rebranding                              */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,LEH00001                                */
/*                  WNCPYSRC,LEH00002                                */
/*                  WNCPYSRC,LEH00003                                */
/*                  WNCPYSRC,LEH00004                                */
/*                  WNCPYSRC,LEH00005                                */
/*                  WNCPYSRC,LEH00006                                */
/*       CLE050 - Change Order of Customer Lending                   */
/*                Financial Loans Diary                              */
/*              - Ignore the Account Officer as the primary sort key.*/
/*       CLE025 - Credit Lines                                       */
/*       098642 - Report LE0691/692/770P1 has no details to report.  */
/*       080565 - For Multibranching report (LE0691) file was being  */
/*                positioned incorrectly. Branch is the second key   */
/*       055506 - Report LE0690 not produced. Allow call of LE0690   */
/*                when &RLEV is blank also.                          */
/*       S01339 - REMOVE SYNDICATED LOANS PROCESSING, DUE TO         */
/*                MODULE REDUNDANCY.                                 */
/*       E37223 - CLOF ALL OPNDBF AT END OF PGM                      */
/*       LN0978 - ADD PARAMETER TO CALL FOR LE0690                   */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01117 - REL.10 MULTIBRANCHING                              */
/*       S01179 - AS400 INCORPORATION                                */
/*       E12672 - CLRPFM COMMAND MISSING FOR FILE LVEDIH2.           */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE025*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE025*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CLE025*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('FINANCIAL LOANS DIARY, EXTRACT AND +
                        REPORT')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CLE050) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE050*/
/*/COPY WNCPYSRC,LEC0711005                                          */
/************DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(LVEDIH2)                                 /*E12672*/
             CLRPFM     FILE(LVEDIF1)
             CLRPFM     FILE(LVEDIT2)
/**/
/**CHECK*FOR*COMMERCIAL*LOANS*MODULE*PRESENT***********/     /*S01339*/
/**/                                                         /*S01339*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)  ***/     /*S01339*/
/************IF      COND(%SST(&MMOD 4 1)=Y) THEN(CHGJOB **/ /*S01339*/
/************************SWS(1XXXXXXX))     *************/   /*S01339*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABLEIC)            */     /*S01194*/
/*/COPY WNCPYSRC,LEC0711006                                          */
/**/
             CALL       PGM(LE0680)
/**/                                                                                      /*CLE025*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                                  /*CLE025*/
/**/                                                                                      /*CLE025*/
/*  Check if feature on */                                                                /*CLE025*/
/**/                                                                                      /*CLE025*/
               CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*CLE025*/
               CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*CLE025*/
               CHGVAR     VAR(&SARD) VALUE('CGL014')                                      /*CLE025*/
               CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                           /*CLE025*/
/**/                                                                                      /*CLE025*/
               IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*CLE025*/
                 CALL       PGM(LE000040)                                                 /*CLE025*/
               ENDDO                                                                      /*CLE025*/
/**/                                                                                      /*CLE050*/
               CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*CLE050*/
               CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*CLE050*/
               CHGVAR     VAR(&SARD) VALUE('CLE050')                                      /*CLE050*/
               CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                           /*CLE050*/
               IF         COND(&RTCD *EQ '       ') +
                          THEN(CHGVAR VAR(&CLE050) VALUE('Y'))                            /*CLE050*/
               ELSE       CMD(CHGVAR VAR(&CLE050) VALUE('N'))                             /*CLE050*/
/**/                                                                                      /*CLE025*/
              ENDDO                                                                       /*CLE025*/
/**/                                                                                      /*CLE025*/
/*/COPY WNCPYSRC,LEC0711007                                          */
/**/
   IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*/COPY WNCPYSRC,LEC0711012                                          */
/***************CALL       PGM(LE0690)                      */        /*S01117*/
/******IF         COND(&RLEV *EQ 'S') THEN(DO)             */ /*S01117 055506*/
/***************      CALL    PGM(LE0690)                     *S01117* *LN0978*/
       IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') THEN(DO)      /*055506*/
/*/COPY WNCPYSRC,LEC0711009                                          */
                   IF         COND(&CLE050 = 'Y') +
                              THEN(CALL    PGM(LE0690A) PARM(&RSEQ))                      /*CLE050*/
                   ELSE       (CALL    PGM(LE0690) PARM(&RSEQ))                           /*CLE050*/
/*****************    CALL    PGM(LE0690) PARM(&RSEQ)                          /*LN0978*/ /*CLE050*/
/*/COPY WNCPYSRC,LEC0711008                                          */
                  ENDDO                                               /*S01117*/
       IF         COND(&RLEV *EQ 'C') THEN(DO)                        /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(LVEDSL2) POSITION(*KEY 1 LVEDIF1F +
                           &RENT)                                     /*S01117*/
                 MONMSG    MSGID(CPF0000)                             /*098642*/
                 OPNDBF    FILE(LVEDSL2) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(LVEDSL2)                         /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,LEC0711010                                          */
                      CALL    PGM(LE0692) PARM(&RSEQ &RENT)           /*S01117*/
/*/COPY WNCPYSRC,LEC0711011                                          */
/**/                                                                  /*098642*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*098642*/
                     DLTOVR     FILE(LVEDSL2)                         /*098642*/
                 MONMSG    MSGID(CPF0000)                             /*098642*/
                 ENDDO                                                /*098642*/
/**/                                                                  /*098642*/
                  ENDDO                                               /*S01117*/
       IF         COND(&RLEV *EQ 'B') THEN(DO)                        /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
/*********** OVRDBF *** FILE(LVEDS) POSITION(*KEY 1 LVEDIF1F &RENT)    *080565*/
/*/COPY WNCPYSRC,LEH00001                                            */
             OVRDBF     FILE(LVEDS) POSITION(*KEY 2 LVEDIF1F &RENT)   /*080565*/
                 MONMSG    MSGID(CPF0000)                             /*098642*/
                 OPNDBF    FILE(LVEDS) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(LVEDS)                           /*S01117*/
                 ENDDO                                                /*S01117*/
/*/COPY WNCPYSRC,LEH00002                                            */
             ENDDO                                                    /*S01117*/
/*/COPY WNCPYSRC,LEC0711003                                          */
             CHGVAR     VAR(&SARD) VALUE('CLE053')                    /*CLE053*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE053*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*CLE053*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE053*/
                                                                      /*CLE053*/
             OVRDBF     FILE(LVEDSL4) POSITION(*KEY 2 LVEDIF1F +
                          &RENT)                                      /*CLE053*/
             MONMSG     MSGID(CPF0000)                                /*CLE053*/
             OPNDBF     FILE(LVEDSL4) OPTION(*ALL)                    /*CLE053*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*CLE053*/
             DLTOVR     FILE(LVEDSL4)                                 /*CLE053*/
                                                                      /*CLE053*/
                 ENDDO                                                /*CLE053*/
                                                                      /*CLE053*/
             CALL       PGM(LE1691) PARM(&RSEQ &RENT)                 /*CLE053*/
             DLTOVR     FILE(LVEDSL4)                                 /*CLE053*/
             MONMSG     MSGID(CPF0000)                                /*CLE053*/
             CLOF       OPNID(LVEDSL4)                                /*CLE053*/
             MONMSG     MSGID(CPF0000)                                /*CLE053*/
             ENDDO                                                    /*CLE053*/
             ELSE       CMD(DO)                                       /*CLE053*/
                      CALL    PGM(LE0691) PARM(&RSEQ &RENT)           /*S01117*/
/*/COPY WNCPYSRC,LEC0711004                                          */
             ENDDO                                                    /*CLE053*/
/**/                                                                  /*098642*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*098642*/
/*/COPY WNCPYSRC,LEH00003                                            */
                     DLTOVR     FILE(LVEDS)                           /*098642*/
                 MONMSG    MSGID(CPF0000)                             /*098642*/
/*/COPY WNCPYSRC,LEH00004                                            */
             ENDDO                                                    /*098642*/
/**/                                                                  /*098642*/
                  ENDDO                                               /*S01117*/
/**/
             CLOF       OPNID(LVEDSL2)                                /*E37223*/
             MONMSG     MSGID(CPF0000)                                /*E37223*/
/*/COPY WNCPYSRC,LEH00005                                            */
             CLOF       OPNID(LVEDS)                                  /*E37223*/
             MONMSG     MSGID(CPF0000)                                /*E37223*/
/*/COPY WNCPYSRC,LEH00006                                            */
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*/COPY WNCPYSRC,LEC0711001                                          */
                   CLRPFM     FILE(LVEDIF1)
                   CLRPFM     FILE(LVEDIT2)
/*/COPY WNCPYSRC,LEC0711002                                          */
/******************CLRPFM     FILE(LDEXFL)          *****/  /*S01339*/
/******************CLRPFM     FILE(CLT2) MBR(LDEX)  *****/  /*S01339*/
                ENDDO
/**/
             ENDDO
/**/
/************DLTOVR        FILE(TABLE)                        */      /*S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
