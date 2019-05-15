/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Save DTAARA for Rec.to Recvr Save')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Standing Data Module                      */
/*                                                                  */
/*     SDC1717 - SAVE DATA AREAS FOR RECOVERY TO RECEIVER SAVE      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1096929          Date 08Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 21Dec05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      096044             DATE 29MAR96              */
/*                      CCM002             DATE 04SEP95              */
/*                      S01449             DATE 10JAN94              */
/*                      S01427             DATE 12JUL93              */
/*                    E40283             DATE 23JUN92               */
/*                    S01319             DATE 20SEP91               */
/*                    S01310             DATE 18SEP91               */
/*                    RT0159             DATE 25JUN91               */
/*                    S01184             DATE 13OCT89               */
/*                    E23394             DATE 10SEP90               */
/*                    S01117             DATE 17/08/89              */
/*                    E13679             DATE 10/06/88              */
/*                    S01127             DATE 01/06/88              */
/*                    S03220             DATE 12/05/88              */
/*                    S05452             DATE 20/08/87              */
/*                    S01133             DATE 31/03/87              */
/*                    S01118             DATE 13/03/87              */
/*                    E81119             DATE 14/09/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     AR1096929 - Device *REQUESTER* not found while opening       */
/*                 SDC0700DF in library B14CBASZ                    */
/*     BUG9619 -  Close of business components run long if journal  */
/*                cache is enabled                                  */
/*     096044  -  Add quite important data area RUNDAT.             */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, save the details in DLCDSTAT.    */
/*     S01449  -  AutoRecs II. Remove call to old RC data area      */
/*     S01427  -  R10 CHIPS INCORPORATION                           */
/*     E40283  -  Remove redundant Data Area SWSTAT                 */
/*             -  Move CHGVAR to before ENDPGM statement            */
/*     S01319  -  Remove redundant processing                       */
/*     S01310  -  SWIFT RATIONALISATION                             */
/*     RT0159  -  Messages should be sent via new Midas Info Screen.*/
/*     S01184  -  CONFIRMATION MATCHING INTERFACE                   */
/*     E23394  -  PROGRAM AMENDED TO CHECK FOR INTEREST ON ACCOUNTS */
/*                AS WELL AS RETAIL2                                */
/*     S01117  -  MULTIBRANCHING                                    */
/*     E13679  -  APPLY EXTRA CHECK FOR SWSTAT MISSED BY S01118     */
/*     S01127  -  FUTURES AND OPTIONS INTERFACE                     */
/*     S03220  -  Interface FUNDS TRANSFER                          */
/*     S05452  -  INCLUSION OF AUTO RECONCILIATIONS                 */
/*     S01133  -  DEALING ROOM SYSTEM                               */
/*     S01118  -  MIDAS/S.W.I.F.T. DIRECT LINK                      */
/*     E81119  -  DESCRIPTION OF CHANGE - THE SWIFT POSITIONS       */
/*                INSTEAD OF THE TELEX POSITIONS ARE CHECKED        */
/*                BEFORE SAVE OF DATA AREAS                         */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&DAREA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ENTRY) TYPE(*CHAR) LEN(272)
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SEQNJS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&SEQNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CCM002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                  /*AR1096929*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                  /*AR1096929*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                   /*AR1096929*/
/*/COPY WNCPYSRC,SDC1717001                                          */
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*/COPY WNCPYSRC,SDC1717002                                          */
/**/
             SNDPGMMSG  MSG('Save Data Areas For Recovery to Receiver +
                          Save') TOMSGQ(MRUNQ)
/**/
/* RETRIEVE SEQUENCE NUMBER OF LAST 'JS' ENTRY ON JOURNAL */
/**/
/*/COPY WNCPYSRC,SDC1717003                                          */
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JRNCDE(U) ENTTYP(JS) +
                          RTNSEQNBR(&SEQNJS)
                MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                             /*AR1096929*/
                   RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                           /*AR1096929*/
                   RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                             SEARCH(*DESCEND) JRNCDE((U)) ENTTYP(JS) +
                             JOB(&NBR/&USR/&JOB) FROMENT(*LAST) +
                             TOENT(*FIRST) RTNSEQNBR(&SEQNJS)                          /*AR1096929*/
                ENDDO                                                                  /*AR1096929*/
 
/*/COPY WNCPYSRC,SDC1717004                                          */
             CHGVAR     VAR(&SEQNA) VALUE(&SEQNJS)
/*/COPY WNCPYSRC,SDC1717005                                          */
/**/
/* RETRIEVE STANDARD DATA AREAS AND SEND CURRENT STATUS TO JOURNAL */
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MOD)
             CHGVAR     VAR(&ENTRY) VALUE(MMOD *CAT '  ' *CAT +
                          &SEQNA *CAT &MOD)
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                   /*BUG9619*/
/**/
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&DAREA)
             CHGVAR     VAR(&ENTRY) VALUE(MNATN *CAT ' ' *CAT +
                          &SEQNA *CAT &DAREA)
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                   /*BUG9619*/
/**/
             RTVDTAARA  DTAARA(REPSEQ) RTNVAR(&DAREA)                 /*S01117*/
             CHGVAR     VAR(&ENTRY) VALUE(REPSEQ *CAT +
                          &SEQNA *CAT &DAREA)                         /*S01117*/
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)                    /*S01117*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
 
/**/                                                                  /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)        /*S01127*/
                RTVDTAARA  DTAARA(NACON) RTNVAR(&DAREA)               /*S01127*/
                CHGVAR     VAR(&ENTRY) VALUE(NACON *CAT ' ' *CAT +
                          &SEQNA *CAT &DAREA)                         /*S01127*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */              /*S01127*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&DAREA)
             CHGVAR     VAR(&ENTRY) VALUE(SDSTAT *CAT &SEQNA *CAT +
                          &DAREA)
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                   /*BUG9619*/
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&DAREA)
             CHGVAR     VAR(&ENTRY) VALUE(GLSTAT *CAT &SEQNA +
                          *CAT &DAREA)
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                            /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                   /*BUG9619*/
/**/
/* CHECK MMOD AND SEND JOURNAL ENTRIES FOR ALL ON-LINE MODULE DATA AREAS */
/**/
             IF         COND(%SST(&MOD 2 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(DLSTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                         /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/**/
             IF         COND(%SST(&MOD 4 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(CLSTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(CLSTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                         /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/**/
             IF         COND(%SST(&MOD 5 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(STSTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(STSTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/**/
/******      IF         COND(%SST(&MOD 6 1) *EQ 'Y') THEN(DO)         /*S01319*/
/******         RTVDTAARA  DTAARA(BCSTAT) RTNVAR(&DAREA)              /*S01319*/
/******         CHGVAR     VAR(&ENTRY) VALUE(BCSTAT *CAT &SEQNA +     /*S01319*/
/******                      *CAT &DAREA)                             /*S01319*/
/******         SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)         /*S01319*/
/******      ENDDO                                                    /*S01319*/
/**/
             IF         COND(%SST(&MOD 7 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(EMSTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                         /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/**/
             IF         COND(%SST(&MOD 10 1) *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(LESTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(LESTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                         /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/**/
/******      IF         COND(%SST(&MOD 11 1) *EQ 'Y') THEN(DO)/*S01133**S01319*/
/******         RTVDTAARA  DTAARA(FDSTAT) RTNVAR(&DAREA)      /*S01133**S01319*/
/******         CHGVAR     VAR(&ENTRY) VALUE(FDSTAT *CAT &SEQNA +
/******                      *CAT &DAREA)                     /*S01133**S01319*/
/******         SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) /*S01133**S01319*/
/******      ENDDO                                            /*S01133**S01319*/
/**/                                                                  /*S01133*/
/******      IF         COND(%SST(&MOD 12 1) *EQ 'Y') THEN(DO)/*S01133**S01319*/
/******         RTVDTAARA  DTAARA(CMSTAT) RTNVAR(&DAREA)      /*S01133**S01319*/
/******         CHGVAR     VAR(&ENTRY) VALUE(CMSTAT *CAT &SEQNA +
/******                      *CAT &DAREA)                     /*S01133**S01319*/
/******         SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) /*S01133**S01319*/
/******      ENDDO                                            /*S01133**S01319*/
/**/                                                                  /*S01133*/
/******                                                               /*S01319*/
/******      IF COND(%SST(&MOD 13 1) *EQ 'Y') THEN(DO)     /*S01133*/ /*S01319*/
/******         RTVDTAARA  DTAARA(FXSTAT) RTNVAR(&DAREA)   /*S01133*/ /*S01319*/
/******         CHGVAR     VAR(&ENTRY) VALUE(FXSTAT *CAT &SEQNA +     /*S01319*/
/******                      *CAT &DAREA)                  /*S01133*/ /*S01319*/
/******         SNDJRNE JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) /*S01133*/ /*S01319*/
/******      ENDDO                                         /*S01133*/ /*S01319*/
/**/                                                                  /*S01133*/
             IF         COND(%SST(&MOD 14 1) *EQ 'Y') THEN(DO)        /*S01133*/
                RTVDTAARA  DTAARA(MMSTAT) RTNVAR(&DAREA)              /*S01133*/
                CHGVAR     VAR(&ENTRY) VALUE(MMSTAT *CAT &SEQNA +
                             *CAT &DAREA)                             /*S01133*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */              /*S01133*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                    /*S01133*/
/**/
/**********  IF         COND(%SST(&MOD 16 1) *EQ 'Y') THEN(DO)        /*E23394*/
             IF         COND((%SST(&MOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MOD 23 1) *EQ 'Y')) THEN(DO)         /*E23394*/
                RTVDTAARA  DTAARA(RESTAT) RTNVAR(&DAREA)
                CHGVAR     VAR(&ENTRY) VALUE(RESTAT *CAT &SEQNA +
                             *CAT &DAREA)
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                         /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) FORCE(*YES)                /*BUG9619*/
             ENDDO
/*   S3220   */
             IF         COND(%SST(&MOD 57 1) *EQ 'Y') THEN(DO)        /*S03220*/
                RTVDTAARA  DTAARA(FTSTAT) RTNVAR(&DAREA)              /*S03220*/
                CHGVAR     VAR(&ENTRY) VALUE(FTSTAT *CAT &SEQNA +
                             *CAT &DAREA)                             /*S03220*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */              /*S03220*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                    /*S03220*/
/**/
/************IF         COND(%SST(&MOD 22 1) *EQ 'Y') THEN(DO) /*S05452*S01449*/
/************   RTVDTAARA  DTAARA(RCSTAT) RTNVAR(&DAREA)       /*S05452*S01449*/
/************   CHGVAR     VAR(&ENTRY) VALUE(RCSTAT *CAT &SEQNA +
/************                *CAT &DAREA)                      /*S05452*S01449*/
/************   SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)  /*S05452*S01449*/
/************ENDDO                                             /*S05452*S01449*/
/**/
/************IF         COND(%SST(&MOD 33 8) *NE 'NNNNNNNN') THEN(DO*  *E81119*/
/********IF*COND(%SST(&MOD 25 8) *NE 'NNNNNNNN') THEN(DO) *  *E81119*  *E13679*/
/************IF         COND(%SST(&MOD 25 8) *NE 'NNNNNNNN' *AND + */ /*E40283*/
/************             %SST(&MOD 18 1) *EQ 'N') THEN(DO)    /*E13679*E40283*/
/************   RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&DAREA)           */ /*E40283*/
/************   CHGVAR     VAR(&ENTRY) VALUE(SWSTAT *CAT &SEQNA +  */ /*E40283*/
/************                *CAT &DAREA)                          */ /*E40283*/
/************   SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)      */ /*E40283*/
/************ENDDO                                                 */ /*E40283*/
/**/
/* SAVE SWIFT DIRECT LINK DATA AREAS                                    S01118*/
/**/                                                                  /*S01118*/
             IF         COND(%SST(&MOD 18 1) *EQ 'Y') THEN(DO)        /*S01118*/
                RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&DAREA)              /*S01118*/
                CHGVAR     VAR(&ENTRY) VALUE(MSSTAT *CAT &SEQNA +
                             *CAT &DAREA)                             /*S01118*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)                 /*S01118*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
/*              RTVDTAARA  DTAARA(MSFCTL) RTNVAR(&DAREA)          S01118S01310*/
/*              CHGVAR     VAR(&ENTRY) VALUE(MSFCTL *CAT &SEQNA +       S01310*/
/*                           *CAT &DAREA)                         S01118S01310*/
/*              SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)     S01118S01310*/
/*              RTVDTAARA  DTAARA(MSFCTLBK) RTNVAR(&DAREA)        S01118S01310*/
/*              CHGVAR     VAR(&ENTRY) VALUE(MSFCTLBK *CAT &SEQNA+S01118S01310*/
/*                           *CAT &DAREA)                         S01118S01310*/
/*              SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)     S01118S01310*/
             ENDDO                                                    /*S01118*/
/**/
/* SAVE TELEX DIRECT LINK DATA AREA                                     S01118*/
/**/                                                                  /*S01118*/
/*           IF         COND(%SST(&MOD 51 1) *EQ 'Y') THEN(DO)    S01118S01310*/
/*              RTVDTAARA  DTAARA(MTFCTL) RTNVAR(&DAREA)          S01118S01310*/
/*              CHGVAR     VAR(&ENTRY) VALUE(MTFCTL *CAT &SEQNA +       S01310*/
/*                           *CAT &DAREA)                         S01118S01310*/
/*              SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)     S01118S01310*/
/*           ENDDO                                                S01118S01310*/
/**/                                                                 /*S01427*/
/*    MIDAS/CHIPS DISKETTE &ONLINE VERSION                        */ /*S01427*/
/**/                                                                 /*S01427*/
             IF COND(%SST(&MOD 41 4) *NE 'NNNN') THEN(DO)            /*S01427*/
                  RTVDTAARA DTAARA(MCSTAT) RTNVAR(&DAREA)            /*S01427*/
                  CHGVAR    VAR(&ENTRY) VALUE(MCSTAT *CAT &SEQNA     /*S01427*/+
                            *CAT &DAREA)                             /*S01427*/
/**********       SNDJRNE   JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)                /*S01427*/ /*BUG9619*/
                  SNDJRNE   JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                   /*S01427*/
/**/                                                                 /*S01427*/
/*    CHIPS/MIDAS                                                 */ /*S01427*/
/**/                                                                 /*S01427*/
             IF COND(%SST(&MOD 45 1) *NE 'N') THEN(DO)               /*S01427*/
                  RTVDTAARA DTAARA(CPSTAT) RTNVAR(&DAREA)            /*S01427*/
                  CHGVAR    VAR(&ENTRY) VALUE(CPSTAT *CAT &SEQNA     /*S01427*/+
                            *CAT &DAREA)                             /*S01427*/
                  RTVDTAARA DTAARA(CPSTAT) RTNVAR(&DAREA)            /*S01427*/
                  CHGVAR    VAR(&ENTRY) VALUE(CPSTAT *CAT &SEQNA     /*S01427*/+
                            *CAT &DAREA)                             /*S01427*/
/**********       SNDJRNE   JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)                /*S01427*/ /*BUG9619*/
                  SNDJRNE   JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                   /*S01427*/
/**/                                                                 /*S01427*/
                                                                     /*S01127*/
/**/                                                                 /*S01127*/
             IF         COND(%SST(&MOD 50 1) *EQ 'Y') THEN(DO)       /*S01127*/
                RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&DAREA)             /*S01127*/
                CHGVAR     VAR(&ENTRY) VALUE(FFSTAT *CAT &SEQNA +
                             *CAT &DAREA)                            /*S01127*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY)                 /*S01127*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                   /*S01127*/
                                                                     /*S01127*/
             IF         COND(%SST(&MOD 60 1) *EQ 'Y') THEN(DO)       /*S01184*/
                RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&DAREA)             /*S01184*/
                CHGVAR     VAR(&ENTRY) VALUE(CFSTAT *CAT &SEQNA +
                             *CAT &DAREA)                            /*S01184*/
/**********     SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */              /*S01184*/ /*BUG9619*/
                SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                   /*S01184*/
                                                                     /*S01184*/
/**/                                                                  /*CCM002*/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active, retrieve the values in       /*CCM002*/
/*    data area DLCDSTAT.                                             /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
               CHGVAR     VAR(&ENTRY) VALUE('DLCDSTAT' *CAT &SEQNA +
                            *CAT &CDSTAT)                             /*CCM002*/
/**********    SNDJRNE    JRN(ICJRN) TYPE('DT') ENTDTA(&ENTRY) */             /*CCM002*/ /*BUG9619*/
               SNDJRNE    JRN(ICJRN) TYPE('DT') ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
             ENDDO                                                    /*CCM002*/
/**/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&DAREA)                 /*096044*/
             CHGVAR     VAR(&ENTRY) VALUE(RUNDAT *CAT &SEQNA *CAT +
                          &DAREA)                                     /*096044*/
/**********  SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) */                 /*096044*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE(DT) ENTDTA(&ENTRY) +
                          FORCE(*YES)                                                    /*BUG9619*/
 
/*/COPY WNCPYSRC,SDC1717006                                          */
             GOTO END
/**/
/*  ABNORMAL TERMINATION PROCESSING */
/**/
/***ABNOR:******SNDPGMMSG  MSG('PROGRAM  Save Data Areas For Recovery+/*RT0159*/
/***********              to Receiver Save - ENDED ABNORMALLY') +     /*RT0159*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*RT0159*/
 ABNOR:                                                               /*RT0159*/
/*/COPY WNCPYSRC,SDC1717007                                          */
             SNDPGMMSG  MSG('PROGRAM  Save Data Areas For Recovery +
                          to Receiver Save - ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1717' 'SDARTRSABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SDC1717008                                          */
 END:        ENDPGM
/*/COPY WNCPYSRC,SDC1717009                                          */
 
/**CHGVAR*VAR(&BISCPY)*VALUE('COPYRIGHT MKI')                      */ /*E40283*/
