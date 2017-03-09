/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Events by Nostro')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                                  */
/*                                                                   */
/*       GLC0802C - EVENTS BY NOSTRO                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*           1989                                                    */
/*                                                                   */
/*       Last Amend No. MD036589           Date 14Feb16              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG23582           Date 13Apr08              */
/*                      CER037             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CAP204             Date 15Feb10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CGL010             Date 08Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001             Date 04Nov97              */
/*                      S01408             Date 15May96              */
/*                      S01408             DATE 13DEC95              */
/*                      084556             DATE 07MAR95              */
/*                      S01408             DATE 03AUG95              */
/*                      S01473             DATE 20JUL94              */
/*                      048699             DATE 17JAN94              */
/*                      E36449             DATE 11DEC91              */
/*                      BHF892             DATE 18FEB91              */
/*                      E20962             DATE 04OCT90              */
/*                      E22608             DATE 23SEP90              */
/*                      E193               DATE 22FEB90              */
/*                      S01117             DATE 17/07/89             */
/*                      S01194             DATE 17/07/89             */
/*                      S01154             DATE 19/08/88             */
/*                      S01158             DATE 16/05/88             */
/*                      S03220             DATE 06/05/88             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD036589 - FX neeting projection during COB.                */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23582 - Records in REBNODPD are not cleared              */
/*       CER037 - Creation of the Extract File for the Online        */
/*                Dispo Module                                       */
/*       CAP204 - Retail Account Transfer                            */
/*       CGL010 - Future Value Dated Journal Entries for Non-Retail  */
/*                Accounts.                                          */
/*       CTI001 - Midas/TI Interface Phase 1                         */
/*       S01408 - Core hook added, GLC0802C10                        */
/*                Core hook added, GLC0802C09                        */
/*                Core hook added, GLC0802C08                        */
/*                Core hook added, GLC0802C07                        */
/*       S01408 - Core hook added, GLC0802C06                        */
/*       084556 - Clear file NOSEXFF added as part of OTC            */
/*                enhancements (073714)                              */
/*       S01408 - Core hook added, GLC0802C01                        */
/*                Core hook added, GLC0802C02                        */
/*                Core hook added, GLC0802C03                        */
/*                Core hook added, GLC0802C04                        */
/*                Core hook added, GLC0802C05                        */
/*       S01473 - Leo Midas Integration - Lending Enhancements.      */
/*                Addition of PF/NSXBCED - Leo DL Events File        */
/*       048699 - Remove commands RMVM PRONO and ADDLFM PRONO        */
/*       E36449 - FILE NOSEXES REDUNDANT (OLD ST FILE)               */
/*       BHF892 - ADDLFM SHOULD BE SHARE(*YES)                       */
/*       E20962 - PRONOS IS UPDATED TWICE - (BY FT & DL)             */
/*       E22608 - PROGRAM RENAMED FROM DLC0802C AND ALL DL           */
/*                PROGRAMS CALLED CHANGED TO GL                      */
/*       E193   - ADD NOSEX PROCESSING                               */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01194 - NEW STANDING DATA FILES                            */
/*       S01154 - CLEAR DOWN NEW FILE RSACMTPD (R.T.S.)              */
/*       S01158 - POST INCORPORATION DEVELOPMENT FIX                 */
/*       S03220 - FUNDS TRANSFER                                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                   /*S01117*/
 
/* &RLEV IS STANDARD RCF PARM NOT USED IN THIS PROGRAM  */            /*S01117*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,GLC0802C12                                          */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
                                                                      /*S03220*/
/************DCL        VAR(&FT) TYPE(*CHAR) LEN(1)        /*S03220*   *E20962*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*E193  */
/*                                                                    /*S01473*/
/* Declare the variables to check the enhancements file */            /*S01473*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01473*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01473*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473') /*S01473*/
             DCL        VAR(&SARDI) TYPE(*CHAR) LEN(6)                /*CGL010*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01473*/
             DCL        VAR(&S01473) TYPE(*CHAR) LEN(1)               /*S01473*/
             DCL        VAR(&CGL010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CGL010*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CGL010*/
             DCL        VAR(&TION) TYPE(*CHAR) LEN(1)                 /*CTI001*/
             DCL        VAR(&CAP204) TYPE(*CHAR) LEN(1)                             /*CAP204*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD036589*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC0802C07                                           /*S01408*/
/*                                                                    /*S01408*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &FMT)       /*CTI001*/
/*  Database error handling  */                                       /*CTI001*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CTI001*/
                SNDPGMMSG  MSG('Database error on Midas modules +
                             file') TOMSGQ(MOPERQ MRUNQ)              /*CTI001*/
                GOTO       CMDLBL(ABNOR)                              /*CTI001*/
             ENDDO
/*  Check if TI module is switched on  */                             /*CTI001*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&TION) VALUE('Y'))                      /*CTI001*/
 
                                                                      /*S01473*/
/* Access switchable features file to see if feature S01473     */    /*S01473*/
/* is installed  */                                                   /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01473) VALUE('Y'))                    /*S01473*/
/*                                                                    /*S01473*/
                                                                                    /*CAP204*/
/* Access switchable features file to see if feature CAP204     */                  /*CAP204*/
/* is installed  */                                                                 /*CAP204*/
             CHGVAR     VAR(&SARD) VALUE('CAP204')                                  /*CAP204*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                  /*CAP204*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP204) VALUE('Y'))                                  /*CAP204*/
/*                                                                                  /*CAP204*/
/**/                                                                                    /*MD036589*/
/* Check if switchable feature CDL002 is on                                             /*MD036589*/
/**/                                                                                    /*MD036589*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*MD036589*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD036589*/
             CHGVAR     VAR(&SARD) VALUE('CDL002')                                      /*MD036589*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                      /*MD036589*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL002) VALUE('Y'))                                        /*MD036589*/
/**/                                                                                    /*MD036589*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*E193  */
                                                                      /*S03220*/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,GLC0802C11                                          */
             SNDMSG     MSG('NOSTRO EVENTS EXTRACT') TOMSGQ(MRUNQ)    /*E193  */
/*/COPY WNCPYSRC,GLC0802C13                                          */
/**/                                                                  /*E193  */
             CLRPFM     FILE(NOSEXCC)                                 /*E193  */
             CLRPFM     FILE(NOSEXEC)                                 /*E193  */
             CLRPFM     FILE(NOSEXEL)                                 /*E193  */
/*           CLRPFM     FILE(NOSEXES)                        * /*E193   E36449*/
             CLRPFM     FILE(NOSEXED)                                 /*E193  */
             CLRPFM     FILE(NOSEXZZ)                                 /*E193  */
             CLRPFM     FILE(NOSEXSE)                                 /*E193  */
             CLRPFM     FILE(NOSEXFP)                                 /*E193  */
             CLRPFM     FILE(NOSEXFF)                                 /*084556*/
             IF         COND(&CAP204 = 'Y') THEN(DO)                                /*CAP204*/
             CLRPFM     FILE(NOSEXAT)                                               /*CAP204*/
             ENDDO                                                                  /*CAP204*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C01                                           /*S01408*/
                                                                      /*S01408*/
/*                                                                    /*S01473*/
/*****       IF         COND(&S01473 = 'Y') THEN(DO)          S01473  /*CTI001*/
             IF         COND(&S01473 = 'Y' *OR &TION = 'Y') THEN(DO)  /*CTI001*/
                        CLRPFM     FILE(NSXBCED)                      /*S01473*/
             ENDDO                                                    /*S01473*/
/*                                                                    /*S01473*/
             IF         COND(&PARM = '1') THEN(DO)                    /*E193  */
                                                                      /*E193  */
                IF      COND(%SST(&MMOD 21 1) *NE 'Y') THEN(DO)       /*E193  */
                        OVRDBF FILE(EVNTM) TOFILE(STEVE)              /*E193  */
                        CHGJOB SWS(XXXX1XXX)                          /*E193  */
                ENDDO                                                 /*E193  */
                IF      COND(%SST(&MMOD 21 1) *EQ 'Y') +
                        THEN(OVRDBF FILE(EVNTM) TOFILE(DLMEV))        /*E193  */
                CHGJOB  SWS(XXX1XXXX)                                 /*E193  */
             ENDDO                                                    /*E193  */
/**/                                                                  /*E193  */
/*                BLOCK LARGE FILES                                 * /*E193  */
/**/                                                                  /*E193  */
             OVRDBF     FILE(NOSEXED) SEQONLY(*YES 100)               /*E193  */
             OVRDBF     FILE(NOSEXCC) SEQONLY(*YES 100)               /*E193  */
/*           OVRDBF     FILE(NOSEXES) SEQONLY(*YES 100)  *  /*E193 */ /*E36449*/
             OVRDBF     FILE(NOSEXSE) SEQONLY(*YES 100)               /*E193  */
/**/                                                                  /*E193  */
/************CALL       PGM(DL0554)                     */ /*E193  */ /*E22608*/
             CALL       PGM(GL0554)                                   /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C02                                           /*S01408*/
                                                                      /*S01408*/
                                                                      /*E193  */
/**/                                                                  /*E193  */
             DLTOVR     FILE(NOSEXED)                                 /*E193  */
             DLTOVR     FILE(NOSEXCC)                                 /*E193  */
/*           DLTOVR     FILE(NOSEXES)                    * /*E193  */ /*E36449*/
             DLTOVR     FILE(NOSEXSE)                                 /*E193  */
/**/                                                                  /*E193  */
             IF         COND(&PARM = '1') THEN(DLTOVR FILE(EVNTM))    /*E193  */
             RTVJOBA    SWS(&SWS)                                     /*E193  */
/**/                                                                  /*E193  */
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(DO)
                        SNDMSG MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ)                                /*E193  */
                        RETURN                                        /*E193  */
                        ENDDO                                         /*E193  */
/**/                                                                  /*E193  */
/**/                                                                                    /*MD036589*/
/* Call DL0405 if switchable feature CDL002 is installed                                /*MD036589*/
/**/                                                                                    /*MD036589*/
             IF         COND(%SUBSTRING(&SWS 7 2) = '00') THEN(DO)                      /*MD036589*/
                 IF        COND(&CDL002 = 'Y') THEN(CALL DL0405)                        /*MD036589*/
             ENDDO                                                                      /*MD036589*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C05                                           /*S01408*/
                                                                      /*CGL010*/
/* Check switchable feature CGL010 if installed.                   */ /*CGL010*/
                                                                      /*CGL010*/
         IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                  /*CGL010*/
           CHGVAR     VAR(&SARDI) VALUE('CGL010')                     /*CGL010*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                     /*CGL010*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARDI &FMT)     /*CGL010*/
           IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&CGL010) VALUE('Y'))                      /*CGL010*/
                                                                      /*CGL010*/
           IF         COND(&CGL010 *EQ 'Y') THEN(DO)                  /*CGL010*/
             SNDPGMMSG MSG('GL0535 - Events processing') +
                         TOMSGQ(MRUNQ)                                /*CGL010*/
             CLRPFM     FILE(NOSEXGL)                                 /*CGL010*/
             CALL       PGM(GL0535)                                   /*CGL010*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CGL010*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)           /*CGL010*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)                      /*CGL010*/
               GOTO       CMDLBL(ABNOR)                               /*CGL010*/
             ENDDO                                                    /*CGL010*/
             ELSE DO                                                  /*CGL010*/
               SNDPGMMSG  MSG('GL0536 - Future Postings Report') +
                            TOMSGQ(MRUNQ)                             /*CGL010*/
               CALL       PGM(GL0536) PARM(&RSEQ)                     /*CGL010*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            /*CGL010*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CGL010*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)                    /*CGL010*/
                 GOTO       CMDLBL(ABNOR)                             /*CGL010*/
               ENDDO                                                  /*CGL010*/
             ENDDO                                                    /*CGL010*/
           ENDDO                                                      /*CGL010*/
         ENDDO                                                        /*CGL010*/
                                                                      /*S01408*/
/**/
             CLRPFM     FILE(PRONTHH)
             CLRPFM     FILE(PRONTPP)
             CLRPFM     FILE(PRONTZX)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC0802C08                                           /*S01408*/
/*                                                                    /*S01408*/
             CLRPFM     FILE(PRONOHH)
             CLRPFM     FILE(PRONOPN)
                                                            /*S01154*/
             CLRPFM     FILE(RSACMTPD)
                                                            /*S01154*/
/**/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC0802C09                                           /*S01408*/
/*                                                                    /*S01408*/
                                                                                          /*CER037*/
             CHGVAR     VAR(&SARD) VALUE('CER037')                                        /*CER037*/
                                                                                          /*CER037*/
             CALL       PGM(AOSARDR0) PARM(&RTCD  &OPTN  &SARD &FMT)                      /*CER037*/
                                                                                          /*CER037*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CER037*/
/**********  CALL       PGM(SCC000060) PARM('REBNODPD' '*FIRST')             /*CER037*/ /*BUG23582*/
/**********  IF         COND(%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)         /*CER037*/ /*BUG23582*/
/**********  CHGVAR     VAR(%SUBSTRING(&SWS 7 2)) VALUE('00')                /*CER037*/ /*BUG23582*/
/**********  ENDDO                                                           /*CER037*/ /*BUG23582*/
             CLRPFM     FILE(REBNODPD)                                                  /*BUG23582*/
             ENDDO                                                                        /*CER037*/
                                                                                          /*CER037*/
             SNDMSG     MSG('CREATE TEMPORARY PROJECTED NOSTRO BALANCES FILE') +
                        TOMSGQ(MRUNQ)
/************OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)  ******         /*S01194*/
             IF         COND(&PARM *EQ '1') THEN(CHGJOB +
                          SWS(XXX1XXXX))
/************CALL       PGM(DL0575)                                */ /*E22608*/
             CALL       PGM(GL0575)                                   /*E22608*/
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC0802C10                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
                SNDMSG     MSG('NOSTRO BALANCES REPORT')  TOMSGQ(MRUNQ)
/************** OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)              /*S01194*/
/***************RMVM       FILE(PRONO) MBR(PRONO)          */ /*S01158 048699*/
              /*RMVM       FILE(PRONOSAV) MBR(PRONO)*/                /*S01158*/
/************** CALL       PGM(DL0580)                                /*S01117*/
/************** CALL       PGM(DL0580) PARM(&RSEQ &RENT)*/ /*S01117*/ /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C03                                           /*S01408*/
                                                                      /*CGL010*/
           IF         COND(&CGL010 *EQ 'Y') THEN(DO)                  /*CGL010*/
             OVRDBF     FILE(NOSEV) TOFILE(GLNOSEL0)                  /*CGL010*/
           ENDDO                                                      /*CGL010*/
                                                                      /*S01408*/
                CALL       PGM(GL0580) PARM(&RSEQ &RENT)              /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C04                                           /*S01408*/
                                                                      /*S01408*/
/*              ADDLFM     FILE(PRONO) MBR(PRONO) */       /*S01158*/ /*BHF982*/
/*************ADDLFM     FILE(PRONO) MBR(PRONO) SHARE(*YES)*/ /*BHF982 048699*/
              /*ADDLFM     FILE(PRONOSAV) MBR(PRONO)*/                /*S01158*/
                RTVJOBA    SWS(&SWS)
                                                                      /*S03220*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802C06                                           /*S01408*/
                                                                      /*S01408*/
/************RTVDTAARA  DTAARA(MMOD (57 1)) RTNVAR(&FT)               /*E20962*/
/************IF COND(&FT *EQ 'Y') THEN(CALL FTC0270)                  /*E20962*/
                                                                      /*S03220*/
             ENDDO
/*/COPY WNCPYSRC,GLC0802C14                                          */
/**/
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
                                                                      /*CTI001*/
ABNOR:
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
