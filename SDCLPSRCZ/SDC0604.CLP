/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas On Request Reports')                            */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                   */
/*       SDC0604 - ON REQUEST REPORTS                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BG12497           DATE.  20Nov06             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL002            DATE.  24APR97             */
/*                      S01408            DATE.  29APR96             */
/*                      E23570            DATE.  12SEP90            */
/*                      S01263            DATE.  30MAR90            */
/*                      S01168            DATE.  15MAR90            */
/*                      E21252            DATE.  03MAR90            */
/*                      S01236            DATE.  28NOV89            */
/*                      S01189            DATE.  06/04/89           */
/*                      E17706            DATE.  12/04/89           */
/*                      S01179            DATE.  12/09/88           */
/*                      S01129            DATE.  13/07/87           *  *S01129*/
/*                      S01147            DATE.  08/02/88           */
/*                      E80939            DATE.  16/09/86           */
/*                      E80830            DATE.  12/06/86           */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BG12497 -  SD0630 made redundant.                          */
/*       CDL002  -  FX Netting                                      */
/*       S01408  -  Addition of core hook SDC0604001                */
/*       E23570  -  CHANGE CALL FOR SE CLIENTS LIST  REF: S01168    *  *E23570*/
/*       S01263  -  ON REQUEST REPORT REVIEW                        *  *S01263*/
/*       S01168  -  REWRITE OF AUDIT REPORTS                        *  *S01168*/
/*       E21252  -  PROGRAM RECOMPILED FOR SD0560 PARAMETER         *  *E21252*/
/*       S01236  -  SYNON REWRITE. SD0560 REQUIRES PARAMETER        */
/*       S01189  - STANDARDISE DATABASE ERROR JOB SWITCH SETTINGS   */
/*       E17706  -  CORRECT THE SETTING OF SWITCH U2.               *  *E17706*/
/*       S01179  -  AS400 CONVERSION                                */
/*       S01129  -  OVERRIDE ADDED FOR SECURITY CUSTOMER DETAILS    *  *S01129*/
/*       S01147  -  RELEASE 22                                      */
/*       E80939  -  DESCRIPTION OF CHANGE - DUPLICATED LINE, ONE    */
/*                  'ENDDO35 TAG' CHANGED TO 'ENDDO36 TAG'.         */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PRM01)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                            */
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        &SWS          TYPE(*CHAR)  LEN(8)
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
 
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/**********  RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
 
/*                                                                  */
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
/********************************************************************/
/*                                                                  */
             CHGVAR     &MSG VALUE(' REQUESTED REPORTS EXECUTING')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
/* */
/******      IF         (&PRM01 *EQ 'SD0290') THEN(DO)                *S01263*/
/******         CHGVAR     &MSG VALUE(' SD0290P EXECUTING')           *S01263*/
/******         CHGJOB     SWS(01100000)                              *S01263*/
/**/
             IF         (&PRM01 *EQ 'SD0010P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' SD0010P EXECUTING')          /*S01263*/
                GOTO ENDCHECK
 ENDD001:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0300') THEN(DO)
                CHGJOB     SWS(01100000)
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
                CHGVAR     &MSG VALUE(' SD0300 EXECUTING')
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*******        GOTO ENDCHECK                                        /*S01263*/
 ENDD002:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0480') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0180P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' COUNTRIES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD003:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0530') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0230P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' COMPANIES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD004:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0360') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0060P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' BRANCHES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD005:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0540') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0240P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' BRANCH LOCATIONS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD006:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0420') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0120P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' DEPARTMENTS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD007:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0500') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0200P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' ACCOUNT OFFICERS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD008:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0510') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0210P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' BS/PL CODES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD009:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0330') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0030P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' ACCOUNT CODES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD010:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0320') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0020P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' CURRENCIES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD011:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0380') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0080P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' NARRATIVES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD012:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0610') THEN(DO)
                CHGVAR     &MSG VALUE('CUSTOMER NAMES LIST EXECUTING')
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD013:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0290') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0010P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' CUSTOMER MASTERS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD014:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0630') THEN(DO)                                   /*BG12497*/
/**********     CHGVAR     &MSG VALUE(' AVAILABLE CUSTOMER NUMBERS LIST +                /*BG12497*/
/**********     EXECUTING')                                                              /*BG12497*/
/* */                                                                /*S01263*/
/***Override the TABLE file for use within the called program                 /*S01263*/ /*BG12497*/
/**********  OVRDBF     FILE(TABLE) TOFILE(TABSDU)                            /*S01263*/ /*BG12497*/
/**********  OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                           /*S01263*/ /*BG12497*/
/**********  OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                           /*S01263*/ /*BG12497*/
/* */                                                                /*S01263*/
/**********  SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                               /*S01263*/ /*BG12497*/
/**********  CALL       &PRM01                                                /*S01263*/ /*BG12497*/
/**********  DLTOVR     FILE(*ALL)                                            /*S01263*/ /*BG12497*/
/**********     GOTO END                                                      /*S01263*/ /*BG12497*/
/*********      GOTO ENDCHECK                                        /*S01263*/
/********** ENDD015:    ENDDO */                                                         /*BG12497*/
/* */
             IF         (&PRM01 *EQ 'SD0620') THEN(DO)
                CHGVAR     &MSG VALUE(' CUSTOMERS BY PARENT LIST EXECUTING')
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD016:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0460') THEN(DO)
                CHGVAR     &MSG VALUE(' HOLIDAYS LIST EXECUTING')
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
                   CHGJOB     SWS(01000000)                           /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD017:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0300') THEN(DO)
                CHGVAR     &MSG VALUE(' CUSTOMER MASTER DETAILS CARD PRINT')
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD018:    ENDDO
/* */
/*********   IF         (&PRM01 *EQ 'SD0430') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0130P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' TRANSACTION TYPES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD019:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0470') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0170P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' BASE RATES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD020:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0410') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0110P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' DEAL NUMBER RANGES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD021:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0550') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0250P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' DEAL SUB-TYPES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD022:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0450') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0150P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' NOSTROS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD023:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0520') THEN(DO)
/* */
/*  Override the TABLE file for use within the called program                 */
/* */
             OVRDBF     FILE(TABLE) TOFILE(TABSDM)
             OVRDBF     FILE(TABLEI) TOFILE(TABSDM)
             OVRDBF     FILE(TABLEU) TOFILE(TABSDM)
                   CHGJOB     SWS(01000000)                           /*S01263*/
/* */
               CHGVAR     &MSG VALUE(' COUNTERPARTY NOSTROS LIST EXECUTING')
/*Processing for other Programs to be called                        *  *S01236*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                       /*S01263*/
             CALL       &PRM01                                        /*S01263*/
             DLTOVR     FILE(*ALL)                                    /*S01263*/
                GOTO END                                              /*S01263*/
/*********      GOTO ENDCHECK                                         /*S01263*/
 ENDD024:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0370') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0070P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' BROKERS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD025:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0440') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0140P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' LIMITS TYPES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD026:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0490') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0190P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' REGIONS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD027:    ENDDO
/* */
/*           IF         (&PRM01 *EQ 'SD0291') THEN(DO)                  S01168*/
             IF         (&PRM01 *EQ 'SD0300P') THEN(DO)               /*S01168*/
                CHGVAR     &MSG VALUE(' ALTERNATIVE CUSTOMER MASTER LIST +
                                      EXECUTING')
                CHGJOB     SWS(01100000)
                GOTO ENDCHECK
 ENDD27A:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0301') THEN(DO)
                CHGVAR     &MSG VALUE(' ALTERNATIVE CUSTOMER MASTER CARD +
                                PRINT EXECUTING')
                CHGJOB     SWS(01100000)
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD27B:    ENDDO
/* */
/***         IF         (&PRM01 *EQ 'SD0292') THEN(DO)                *E23570*/
/***            CHGVAR     &MSG VALUE(' SECURITYTRADINGCLIENTSAUDIT + *E23570*/
/***                            LIST EXECUTING')                      *E23570*/
/* */                                                          /*S01263E23570*/
/*  Override the TABLE file for use within the called program  /*S01263E23570*/
/***         OVRDBF     FILE(TABLE) TOFILE(TABSDU)             /*S01263E23570*/
/***         OVRDBF     FILE(TABLEI) TOFILE(TABSDU)            /*S01263E23570*/
/***         OVRDBF     FILE(TABLEU) TOFILE(TABSDU)            /*S01263E23570*/
/* */                                                          /*S01263E23570*/
/***         SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                /*S01263E23570*/
/***         CALL       &PRM01                                 /*S01263E23570*/
/***         DLTOVR     FILE(*ALL)                             /*S01263E23570*/
/***            GOTO END                                       /*S01263E23570*/
/*********      GOTO ENDCHECK                                  /*S01263E23570*/
/*** ENDD27C:    ENDDO                                                 E23570*/
/* */
             IF         (&PRM01 *EQ 'SD0302') THEN(DO)
                CHGVAR     &MSG VALUE(' SECURITY TRADING CLIENTS AUDIT +
                                CARDS LIST EXECUTING')
/* */                                                                /*S01263*/
/*  Override the TABLE file for use within the called program        /*S01263*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)                   /*S01263*/
             OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                  /*S01263*/
             OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                  /*S01263*/
/* */                                                                /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                        /*S01263*/
 ENDD27D:    ENDDO
/* */                                                                 /*S01129*/
/*********   IF         (&PRM01 *EQ 'SD0293') THEN(DO)     *S01129*/  /*S01263*/
             IF         (&PRM01 *EQ 'SD0340P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' SECURITIES TRADING CLIENTS   +
                                AUDIT LIST EXECUTING')                /*S01129*/
                CHGJOB     SWS(00100000)                              /*S01129*/
                OVRDBF     CLNT1  CLINT   SHARE(*NO)                  /*S01129*/
                GOTO ENDCHECK                                         /*S01129*/
 ENDD27E:    ENDDO                                                    /*S01129*/
/* */
 /*  Override the ACCOUNT KEY file for use within the called program          */
             IF         (&PRM01 *EQ 'SD0350') THEN(DO)
                OVRDBF     FILE(ACKEYI) TOFILE(ACKEY)
                OVRDBF     FILE(ACKEYU) TOFILE(ACKEY)
                OVRDBF     FILE(TABLE) TOFILE(TABSDU)                 /*S01263*/
                CHGVAR     &MSG VALUE(' ACCOUNT KEYS LIST EXECUTING')
                   CHGJOB     SWS(01000000)                           /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                      /*S01263*/
             CALL       &PRM01                                       /*S01263*/
             DLTOVR     FILE(*ALL)                                   /*S01263*/
                GOTO END                                             /*S01263*/
/*********      GOTO ENDCHECK                                          *S01263*/
 ENDD028:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0400') THEN(DO)                *S01263*/
             IF         (&PRM01 *EQ 'SD0100P') THEN(DO)              /*S01263*/
                CHGVAR     &MSG VALUE(' LOCAL INDUSTRIES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD029:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0390') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0090P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' LOCAL INSTITUTIONS LIST EXECUTING')
                GOTO ENDCHECK
 ENDD030:    ENDDO
/* */
/*********** IF         (&PRM01 *EQ 'SD0570') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0270P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' FACILITY TYPES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD031:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0580') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0280P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE(' LOAN TYPE/SUB TYPE LIST +
                                      EXECUTING')
                GOTO ENDCHECK
 ENDD31A:    ENDDO
/* */
/**********  IF         (&PRM01 *EQ 'SD0575') THEN(DO)                 *S01263*/
             IF         (&PRM01 *EQ 'SD0320') THEN(DO)                /*S01263*/
                CHGVAR     &MSG VALUE(' FEE CODES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD31B:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0350P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE('DOCUMENT CODES LIST  +
                EXECUTING')                                           /*S01263*/
                GOTO ENDCHECK                                         /*S01263*/
 ENDD31C:    ENDDO                                                    /*S01263*/
/* */
             IF         (&PRM01 *EQ 'SD0380P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE('CURRENCY CLEARING SYSTEMS +
                LIST EXECUTING')                                      /*S01263*/
                GOTO ENDCHECK                                         /*S01263*/
 ENDD31D:    ENDDO                                                    /*S01263*/
/* */                                                                 /*S01263*/
             IF         (&PRM01 *EQ 'SD0400P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE('EXTENDED SETTLEMENT LIST  +
                EXECUTING')                                           /*S01263*/
                GOTO ENDCHECK                                         /*S01263*/
 ENDD31E:    ENDDO                                                    /*S01263*/
/* */                                                                 /*S01263*/
             IF         (&PRM01 *EQ 'SD0530P') THEN(DO)               /*S01263*/
                CHGVAR     &MSG VALUE('STANDARD SETTLEMENT LIST  +
                EXECUTING')                                           /*S01263*/
                GOTO ENDCHECK                                         /*S01263*/
 ENDD31F:    ENDDO                                                    /*S01263*/
/*                                                           */
/*/COPY WNCPYSRC,SDC0604001                                  */       /*S01408*/
/*                                                           */
/* */                                                                 /*S01263*/
             IF         (&PRM01 *EQ 'SD0634') THEN(DO)
 
             IF         COND(%SUBSTRING(&MMOD 6 1) *NE 'Y') THEN(DO)
/*              SNDMSG MSG('Letters of Credit not on +              *  *E80830*/
/*              system.') TOMSGQ(&JOB)                              *  *E80830*/
                SNDMSG MSG('Letters of Credit not on +
                system.') TOMSGQ(MRUNQ)                               /*E80830*/
                GOTO ENDCLPGM
             ENDDO
 
                CHGVAR     &MSG VALUE(' COLLATERAL CODES LIST +
                EXECUTING')
                GOTO ENDCHECK
 ENDD033:    ENDDO
/* */
             IF         (&PRM01 *EQ 'SD0636') THEN(DO)
 
             IF         COND(%SUBSTRING(&MMOD 6 1) *NE 'Y') THEN(DO)
/*                        SNDMSG MSG('Letters of Credit not on +    *  *E80830*/
/*                        system.') TOMSGQ(&JOB)                    *  *E80830*/
                SNDMSG MSG('Letters of Credit not on +
                system.') TOMSGQ(MRUNQ)                               /*E80830*/
             GOTO ENDCLPGM
             ENDDO
 
                CHGVAR     &MSG VALUE(' GOODS CODES LIST EXECUTING')
                GOTO ENDCHECK
 ENDD034:    ENDDO
/* */
/* */
             IF         (&PRM01 *EQ 'SD0560') THEN(DO)
                CHGVAR     &MSG VALUE(' INSTALLATION CONTROL DATA LIST +
                EXECUTING')
 ENDD032:    ENDDO
/* */
             IF         COND(&PRM01 *EQ 'SD0711P') THEN(DO)           /*CDL002*/
             CHGVAR     VAR(&MSG) VALUE('COUNTERPARTY/TRANSACTION +
                          TYPES LIST EXECUTING')                      /*CDL002*/
                GOTO ENDCHECK                                         /*CDL002*/
 ENDD035:    ENDDO                                                    /*CDL002*/
/* */                                                                 /*CDL002*/
/********************************************************************/
/*  Override the TABLE file for use within the called program                 */
/****** ENDCHECK:                                                      *S01263*/
/* */
/********    IF  (&PRM01 *EQ 'SD0293') THEN(GOTO OVRDONE)   *S01129*/ /*S01263*/
/********    IF         (&PRM01 *EQ 'SD0410') THEN(GOTO TABSDM)        *S01263*/
/**********  IF         (&PRM01 *EQ 'SD0430') THEN(GOTO TABSDM)        *S01263*/
/**********  IF         (&PRM01 *EQ 'SD0520') THEN(GOTO TABSDM)        *S01263*/
/**********  IF         (&PRM01 *EQ 'SD0550') THEN(GOTO TABSDM)       /*S01263*/
/**********  IF         (&PRM01 *EQ 'SD0570') THEN(GOTO TABSDM)       /*S01263*/
/**********  IF         (&PRM01 *EQ 'SD0580') THEN(GOTO TABSDM)       /*S01263*/
/**********  IF         (&PRM01 *EQ 'SD0575') THEN(GOTO TABCLI)       /*S01263*/
/* */
TABSDU: /*              Programs using TABSDU                       */
/* */
/*  Override the TABLE file for use within the called program                 */
/*********   OVRDBF     FILE(TABLE) TOFILE(TABSDU)                     *S01263*/
/*********   OVRDBF     FILE(TABLEI) TOFILE(TABSDU)                    *S01263*/
/*********   OVRDBF     FILE(TABLEU) TOFILE(TABSDU)                    *S01263*/
/*********   GOTO       OVRDONE                                        *S01263*/
/* */
TABCLI: /*              Programs using TABCLI                       */
/* */
/*  Override the TABLE file for use within the called program       */
/* */
/**********  OVRDBF     FILE(TABLE) TOFILE(TABCLI)                     *S01263*/
/**********  OVRDBF     FILE(TABCH) TOFILE(TABCLI) SHARE(*NO)          *S01263*/
/**********  GOTO       OVRDONE                                        *S01263*/
/* */
TABSDM: /*              Programs using TABSDM                       */
/* */
/*  Override the TABLE file for use within the called program                 */
/* */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABSDM)                     *S01263*/
/*********** OVRDBF     FILE(TABLEI) TOFILE(TABSDM)                    *S01263*/
/************OVRDBF     FILE(TABLEU) TOFILE(TABSDM)                    *S01263*/
/* */
OVRDONE:
/* */
/* */
/**********  IF         (&PRM01 *NE 'SD0290') THEN(DO)                 *S01263*/
/*           IF         (&PRM01 *NE 'SD0291') THEN(DO)                  S01168*/
/**********  IF         (&PRM01 *NE 'SD0300P') THEN(DO)      S01168*/ /*S01263*/
/*           IF         (&PRM01 *EQ 'SD0293') THEN(DO)           *S01129E17706*/
/* */
/**********     IF         (&PRM01 *NE 'SD0300') THEN(DO)              *S01263*/
/**********     IF         (&PRM01 *NE 'SD0301') THEN(DO)              *S01263*/
/**********     IF         (&PRM01 *NE 'SD0575') THEN(DO)              *S01263*/
/**********        CHGJOB     SWS(01000000)                            *S01263*/
/**********     ENDDO                                                  *S01263*/
/**********     ENDDO                                                  *S01263*/
/**********     ENDDO                                                  *S01263*/
/* */
/*********** ENDDO                                                     *S01263*/
/*NDD035: ** ENDDO ****                                             *  *E80939*/
/**DD036:    ENDDO                                **********E80939*/  /*S01253*/
/*NDD037:    ENDDO                                               *S01129E17706*/
/* */
/******      IF         COND(&PRM01 *EQ 'SD0560') THEN(DO)            /*S01263*/
/*              OVRDBF     FILE(TABLEI) TOFILE(TABICD)              *  *S01236*/
/*              OVRDBF     FILE(TABLEU) TOFILE(TABICD)              *  *S01236*/
/*Processing for SD0560 to be called                                *  *S01236*/
/*********   SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)          *S01236*/    /*S01236*/
/*********   CALL       PGM(SD0560) PARM('R')            *S01236*/    /*S01236*/
/*********   ENDDO                                       *S01236*/    /*S01236*/
/**********  ELSE       CMD(DO)                             *S01236*/ /*S10263*/
/* */                                                                 /*S01168*/
/*********   IF         COND(&PRM01 *EQ 'SD0300P') THEN(DO) *S01168*/ /*S01263*/
/*Processing for SD0300P to be called                       *S01168*/ /*S01263*/
/********    SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)             *S01168*/ /*S01263*/
/*******     CALL       PGM(SD0300P) PARM(' ' 'R')          *S01168*/ /*S01263*/
/*******     ENDDO                                          *S01168*/ /*S01263*/
/*           ELSE       CMD(DO)                             *S01168*/ /*S01263*/
/* */
/*Processing for other Programs to be called                        *  *S01236*/
/*********** SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                        *S01263*/
/*********** CALL       &PRM01                                         *S01263*/
/*********** DLTOVR     FILE(*ALL)                                     *S01263*/
/*********** ENDDO                                          *S01236*/ /*S01263*/
/*********** ENDDO                                          *S01168*/ /*S01262*/
/* */
ENDCHECK:                                                             /*S01263*/
/* CALL ALL NEW VERSION OF ICD REPORT*/                               /*S01263*/
             IF         COND(&PRM01 *EQ 'SD0560') THEN(DO)            /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                       /*S01263*/
             CALL       PGM(SD0560) PARM('R')                         /*S01263*/
             ENDDO                                                    /*S01263*/
             ELSE       CMD(DO)                                       /*S01263*/
/* CALL NEW REPORTS */
                                                                      /*S01263*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                       /*S01263*/
             CALL       PGM(&PRM01) PARM(' ' 'R')                     /*S01263*/
             ENDDO                                                    /*S01263*/
END:
             RTVJOBA    SWS(&SWS)
/* */
             IF         (%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                CHGJOB     SWS(XXXXXX1X)                              /*S01189*/
                CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE IN ERROR')
/*              SNDMSG     TOMSGQ(&JOB) MSG(&MSG)                   *  *E80830*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*E80830*/
             ENDDO
/* */
 ENDCLPGM:
             RETURN
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM     /* END CL PGM */
