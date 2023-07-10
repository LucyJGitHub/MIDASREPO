/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Generate Accounting Entries')                */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Dealing Module                                 */
/*                                                                   */
/*       DLC0606C - GENERATE ACCOUNTING ENTRIES                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD021383A          Date 16Jun23              */
/*                      MD029765           Date 06Feb23              */
/*                      MD046248           Date 27Oct17              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23276           Date 10Mar09              */
/*                      CER044             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9812            Date 08Feb06              */
/*                      215832             Date 20Mar03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001             Date 18Apr01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186804             Date 23Nov00              */
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30Oct95              */
/*                      CIR001             Date 13Jun95              */
/*                      E23407             DATE  14SEP90             */
/*                      LN0465             DATE  03JUL90             */
/*                      S01117             DATE  25/04/89            */
/*                      S01194             DATE  25/04/89            */
/*                      E18                DATE  31OCT89             */
/*                      S01179             DATE  12/09/88            *  *S05452*/
/*                      S05452             DATE  20/08/87            *  *S05452*/
/*                      S01098             DATE  22/09/86            *  *S01098*/
/*                      S01094             DATE  22/09/86            *  *S01094*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD021383A - Credit lines shadow posting correction.         */
/*                   Amend to cater for a rerun to process IAS       */
/*                   postings.                                       */
/*                 - MD061267 - Credit Lines (CLE025) fixes          */
/*       MD029765 - Seton U6 only on the first run of DL0295         */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23276 - Items with Customers set up as Banks not shown   */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*       BUG9812 - Do not clear the keys generated if there were     */
/*                 no missing account keys found. The keys should    */
/*                 remain for CMR001 and CRN001 reporting features.  */
/*                 The keys will be cleared at end of COB by DLC10.  */
/*       215832 - In case of error in DL0295, EOD continues because  */
/*                U7U8 not checked before calling MXC0490. And this  */
/*                program resets U7U8...                             */
/*       CMX001 - Meridian Export                                    */
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
                          Finastra International Limited +
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
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +                             */ /*MD021383A*/
/**********               VALUE('       ')                                   */ /*CIR001 MD021383A*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +                             */ /*MD021383A*/
/**********               VALUE('*VERIFY')                                   */ /*CIR001 MD021383A*/
/**********  DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +                             */ /*MD021383A*/
/**********               VALUE('CIR001')                                    */ /*CIR001/MD021383A*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                    */ /*CIR001 MD021383A*/
/**********  DCL        VAR(&CIR001) TYPE(*CHAR) LEN(1) VALUE('N')           */ /*CIR001 MD021383A*/
/**********  DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE('N')           */ /*CDL008 MD021383A*/
/**********  DCL        VAR(&CMX001) TYPE(*CHAR) LEN(1) VALUE('N')           */ /*CMX001 MD021383A*/
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
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CDL008*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*CDL008*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  +
                          DPLIB')                                     /*CDL008*/
             DCL        VAR(&CER044) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CER044*/
                                                                                       /*MD021383A*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 RNX0000) +
                          EXEC(GOTO CMDLBL(ABNOR))                                     /*MD021383A*/
                                                                                       /*MD021383A*/
/*/COPY WNCPYSRC,DLC0606C05                                          */
/**/                                                                  /*CIR001*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)         */ /*CIR001 MD021383A*/
/**********  IF         COND(&RTCD *EQ '       ') +                                 */ /*MD021383A*/
/**********      THEN(CHGVAR VAR(&CIR001) VALUE('Y'))                        */ /*CIR001 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********  CHGVAR     VAR(&SAR) VALUE('CDL008')                            */ /*CDL008 MD021383A*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)         */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********  IF         COND(&RTCD = '       ') +                                   */ /*MD021383A*/
/**********      THEN(CHGVAR VAR(&CDL008) VALUE('Y'))                        */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CMX001 MD021383A*/
/**********  CHGVAR     VAR(&SAR) VALUE('CMX001')                            */ /*CMX001 MD021383A*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)         */ /*CMX001 MD021383A*/
/*****************************************************************************/ /*CMX001 MD021383A*/
/**********  IF         COND(&RTCD = '       ') +                                   */ /*MD021383A*/
/**********      THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                        */ /*CMX001 MD021383A*/
/*                                                  */                                  /*MD049139*/
/* Check if Feature CLE025 is switched ON.          */                                  /*MD049139*/
/*                                                  */                                  /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
                                                                                        /*MD049139*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD049139*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CIR001) VALUE('Y'))                                   /*MD049139*/
                                                                                        /*MD049139*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                                       /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD049139*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CDL008) VALUE('Y'))                                   /*MD049139*/
                                                                                        /*MD049139*/
             CHGVAR     VAR(&SAR) VALUE('CMX001')                                       /*MD049139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*MD049139*/
             IF         COND(&RTCD = '       ') +
                 THEN(CHGVAR VAR(&CMX001) VALUE('Y'))                                   /*MD049139*/
             ENDDO                                                                      /*MD049139*/
                                                                      /*CDL008*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*CDL008*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)     /*CDL008*/
/**/                                                                  /*CDL008*/
/*    Call program CB0160 to get value of restart indicator.          /*CDL008*/
/**/                                                                  /*CDL008*/
             CALL       PGM(CB0160) PARM(&NAM &SEQ &STAT)             /*CDL008*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/***If*it*not*a*restart.*Backup*pay-in*schedule*header*file.******************/ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********      IF         COND(&STAT = 'N') THEN(DO)                       */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********       IF         COND(&CDL008 = 'Y') THEN(DO)                    */ /*CDL008 MD021383A*/
/**********        DLTF       FILE(XFXCLSPSH)                                */ /*CDL008 MD021383A*/
/**********        MONMSG     MSGID(CPF2105)                                 */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********  CPYF       FROMFILE(FXCLSPSH) TOFILE(&DPLIB/XFXCLSPSH) +               */ /*MD021383A*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)                     */ /*CDL008 MD021383A*/
/**********        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 */ /*CDL008 MD021383A*/
/**********       ENDDO                                                      */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********      ENDDO                                                       */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/***If*it*a*restart.*Restore*backup*pay-in*schedule*header*file.**************/ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********      IF         COND(&STAT = 'Y') THEN(DO)                       */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********       IF         COND(&CDL008 = 'Y') THEN(DO)                    */ /*CDL008 MD021383A*/
/**********        CPYF       FROMFILE(XFXCLSPSH) TOFILE(FXCLSPSH) +                */ /*MD021383A*/
/**********                   MBROPT(*REPLACE)                               */ /*CDL008 MD021383A*/
/**********        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +                      */ /*MD021383A*/
/**********                   EXEC(CLRPFM FILE(FXCLSPSH))                    */ /*CDL008 MD021383A*/
/**********       ENDDO                                                      */ /*CDL008 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/**********      ENDDO                                                       */ /*CDL008 MD021383A*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
/**/                                                                                    /*MD049139*/
/*  If it not a restart. Backup pay-in schedule header file.                            /*MD049139*/
/**/                                                                                    /*MD049139*/
                 IF         COND(&STAT = 'N') THEN(DO)                                  /*MD049139*/
                                                                                        /*MD049139*/
                  IF         COND(&CDL008 = 'Y') THEN(DO)                               /*MD049139*/
                   DLTF       FILE(XFXCLSPSH)                                           /*MD049139*/
                   MONMSG     MSGID(CPF2105)                                            /*MD049139*/
                                                                                        /*MD049139*/
             CPYF       FROMFILE(FXCLSPSH) TOFILE(&DPLIB/XFXCLSPSH) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                /*MD049139*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                            /*MD049139*/
                  ENDDO                                                                 /*MD049139*/
                                                                                        /*MD049139*/
                 ENDDO                                                                  /*MD049139*/
/**/                                                                                    /*MD049139*/
/*  If it a restart. Restore backup pay-in schedule header file.                        /*MD049139*/
/**/                                                                                    /*MD049139*/
                 IF         COND(&STAT = 'Y') THEN(DO)                                  /*MD049139*/
                                                                                        /*MD049139*/
                  IF         COND(&CDL008 = 'Y') THEN(DO)                               /*MD049139*/
                   CPYF       FROMFILE(XFXCLSPSH) TOFILE(FXCLSPSH) +
                              MBROPT(*REPLACE)                                          /*MD049139*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(FXCLSPSH))                               /*MD049139*/
                  ENDDO                                                                 /*MD049139*/
                                                                                        /*MD049139*/
                 ENDDO                                                                  /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ELSE       CMD(DO)                                                         /*MD049139*/
                                                                                       /*MD021383A*/
             IF         COND((&SEQ *EQ 00003) *OR (&SEQ *EQ +
                          00004)) THEN(DO)                                             /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *NE 'Y') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      DLTF       FILE(XGEDLPD)                                         /*MD021383A*/
                      MONMSG     MSGID(CPF2105)                                        /*MD021383A*/
                      DLTF       FILE(XGEDLZZ)                                         /*MD021383A*/
                      MONMSG     MSGID(CPF2105)                                        /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(GEDLPD) +
                                   TOFILE(&DPLIB/XGEDLPD) CRTFILE(*YES)                /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GEDLZZ) +
                                   TOFILE(&DPLIB/XGEDLZZ) CRTFILE(*YES)                /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      DLTF       FILE(XGEDL2PD)                                        /*MD021383A*/
                      MONMSG     MSGID(CPF2105)                                        /*MD021383A*/
                      DLTF       FILE(XGEDL2ZZ)                                        /*MD021383A*/
                      MONMSG     MSGID(CPF2105)                                        /*MD021383A*/
                                                                                       /*MD021383A*/
                      CPYF       FROMFILE(GEDL2PD) +
                                   TOFILE(&DPLIB/XGEDL2PD) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CPYF       FROMFILE(GEDL2ZZ) +
                                   TOFILE(&DPLIB/XGEDL2ZZ) +
                                   CRTFILE(*YES)                                       /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)                                /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(XGEDLPD) TOFILE(GEDLPD) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEDLPD))                           /*MD021383A*/
                      CPYF       FROMFILE(XGEDLZZ) TOFILE(GEDLZZ) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEDLZZ))                           /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(XGEDL2PD) TOFILE(GEDL2PD) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEDL2PD))                          /*MD021383A*/
                      CPYF       FROMFILE(XGEDL2ZZ) TOFILE(GEDL2ZZ) +
                                   MBROPT(*REPLACE)                                    /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                   EXEC(CLRPFM FILE(GEDL2ZZ))                          /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
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
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 00001) *OR (&SEQ *EQ +   */            /*MD021383A MD049139*/
/**********               00002)) THEN(DO)                      */            /*MD021383A MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&SEQ *EQ 00001) *OR +
                               (&SEQ *EQ 00002))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
                                                                                       /*MD021383A*/
             IF         COND(&POST *EQ '1') THEN(DO)
                CLRPFM     FILE(GEDLHH)
                CLRPFM     FILE(GEDLPD)
                CLRPFM     FILE(GEDLZZ)
             ENDDO
             CLRPFM     FILE(GEDL2HH)
             CLRPFM     FILE(GEDL2PD)
             CLRPFM     FILE(GEDL2ZZ)
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 00003) *OR (&SEQ *EQ +   */            /*MD021383A MD049139*/
/**********               00004)) THEN(DO)                      */            /*MD021383A MD049139*/
             IF         COND((&CLE025 *EQ 'Y') *AND +
                             ((&SEQ *EQ 00003) *OR +
                              (&SEQ *EQ 00004))) THEN(DO)                               /*MD049139*/
                                                                                       /*MD021383A*/
                IF         COND(&POST *EQ '1') THEN(DO)                                /*MD021383A*/
                   CLRPFM     FILE(GEDL3HH)                                            /*MD021383A*/
                   CLRPFM     FILE(GEDL3PD)                                            /*MD021383A*/
                   CLRPFM     FILE(GEDL3ZZ)                                            /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                CLRPFM     FILE(GEDL4HH)                                               /*MD021383A*/
                CLRPFM     FILE(GEDL4PD)                                               /*MD021383A*/
                CLRPFM     FILE(GEDL4ZZ)                                               /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
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
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 00001) *OR (&SEQ *EQ +   */            /*MD021383A MD049139*/
/**********               00002)) THEN(DO)                      */            /*MD021383A MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              ((&SEQ *EQ 00001) *OR +
                               (&SEQ *EQ 00002))) *OR +
                             (&CLE025 *NE 'Y')) THEN(DO)                                /*MD049139*/
                                                                                       /*MD021383A*/
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
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 00003) *OR (&SEQ *EQ +   */            /*MD021383A MD049139*/
/**********               00004)) THEN(DO)                      */            /*MD021383A MD049139*/
             IF         COND((&CLE025 *EQ 'Y') *AND +
                             ((&SEQ *EQ 00003) *OR +
                              (&SEQ *EQ 00004))) THEN(DO)                               /*MD049139*/
                IF         COND(&POST *EQ '1') THEN(DO)                                /*MD021383A*/
                   OVRDBF     FILE(GEDLHH) TOFILE(GEDL3HH)                             /*MD021383A*/
                   OVRDBF     FILE(GEDLPD) TOFILE(GEDL3PD) +
                                SEQONLY(*YES 250)                                      /*MD021383A*/
                   OVRDBF     FILE(GEDLZZ) TOFILE(GEDL3ZZ)                             /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND(&POST *EQ '5') THEN(DO)                                /*MD021383A*/
                   OVRDBF     FILE(GEDLHH) TOFILE(GEDL4HH)                             /*MD021383A*/
                   OVRDBF     FILE(GEDLPD) TOFILE(GEDL4PD) +
                                SEQONLY(*YES 250)                                      /*MD021383A*/
                   OVRDBF     FILE(GEDLZZ) TOFILE(GEDL4ZZ)                             /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
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
/**********  IF         COND((&SEQ *EQ 00001) *OR (&SEQ *EQ +   */             /*MD029765 MD049139*/
/**********             00002)) THEN(DO)                        */             /*MD029765 MD049139*/
             IF         COND((&CLE025 *EQ 'Y') *AND +
                             ((&SEQ *EQ 00001) *OR +
                              (&SEQ *EQ 00002))) THEN(DO)                               /*MD049139*/
             CHGJOB SWS(XXXXX1XX)                                                       /*MD029765*/
             ENDDO                                                                      /*MD029765*/
                                                                                        /*MD029765*/
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
                                                                                       /*MD021383A*/
/**********  IF         COND((&SEQ *EQ 00003) *OR (&SEQ *EQ +   */            /*MD021383A MD049139*/
/**********               00004)) THEN(DO)                      */            /*MD021383A MD049139*/
             IF         COND((&CLE025 *EQ 'Y') *AND +
                             ((&SEQ *EQ 00003) *OR +
                              (&SEQ *EQ 00004))) THEN(DO)                               /*MD049139*/
                DLTOVR     FILE(GEDLHH)                                                /*MD021383A*/
                DLTOVR     FILE(GEDLZZ)                                                /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                      /*CMX001*/
/**********  IF         COND(&CMX001 = 'Y') THEN(DO)                         */ /*CMX001 MD021383A*/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                     */ /*215832 MD021383A*/
/**********  CALL       PGM(MXC0490) PARM('DLC0606C' &POST)                  */ /*CMX001 MD021383A*/
/**********  ENDDO                                                           */ /*215832 MD021383A*/
/**********  ENDDO                                                           */ /*CMX001 MD021383A*/
/*****************************************************************************/ /*CMX001 MD021383A*/
/*****************************************************************************/ /*CDL008 MD021383A*/
/*********** IF         COND(&CDL008 = 'Y') THEN(DO)                         */ /*CDL008 MD021383A*/
/*********** IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                     */ /*CDL008 MD021383A*/
/*********** CALL       PGM(DL0296) */                     /*CDL008*/ /*186804*/
/*********** CALL       PGM(DL0296) PARM('Y')                                */ /*186804 MD021383A*/
/*********** ENDDO                                                           */ /*CDL008 MD021383A*/
/*********** ENDDO                                                           */ /*CDL008 MD021383A*/
             IF         COND(&CLE025 *NE 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND(&CMX001 = 'Y') THEN(DO)                                    /*MD049139*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                /*MD049139*/
             CALL       PGM(MXC0490) PARM('DLC0606C' &POST)                             /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
                                                                                        /*MD049139*/
             IF         COND(&CDL008 = 'Y') THEN(DO)                                    /*MD049139*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                /*MD049139*/
             CALL       PGM(DL0296) PARM('Y')                                           /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/

/*/COPY WNCPYSRC,DLC0606C03                                        */ /*S01408*/

             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                  /*MD049139*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                               /*MD021383A*/
                IF         COND((&SEQ *EQ 00001) *OR (&SEQ *EQ +
                             00002)) THEN(DO)                                          /*MD021383A*/
                   CLRPFM     FILE(DKEYS1DP)                                           /*MD021383A*/
                   CLRPFM     FILE(DKEYS1ZZ)                                           /*MD021383A*/
                                                                                       /*MD021383A*/
                   CPYF       FROMFILE(DKEYSDP) TOFILE(DKEYS1DP) +
                                MBROPT(*REPLACE)                                       /*MD021383A*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                           /*MD021383A*/
                   CPYF       FROMFILE(DKEYSZZ) TOFILE(DKEYS1ZZ) +
                                MBROPT(*REPLACE)                                       /*MD021383A*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                           /*MD021383A*/
                                                                                       /*MD021383A*/
                   CLRPFM     FILE(DKEYSDP)                                            /*MD021383A*/
                   CALL       PGM(DL000150) PARM('DKEYSZZ' 'Reset')                    /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
                IF         COND((&SEQ *EQ 00003) *OR (&SEQ *EQ +
                             00004)) THEN(DO)                                          /*MD021383A*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(GEDL3PD) TOFILE(GEDLPD) +
                                   MBROPT(*ADD)                                        /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CALL       PGM(DL000150) PARM('GEDL3ZZ' 'Update')                /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      CPYF       FROMFILE(GEDL4PD) TOFILE(GEDL2PD) +
                                   MBROPT(*ADD)                                        /*MD021383A*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                        /*MD021383A*/
                      CALL       PGM(DL000150) PARM('GEDL4ZZ' 'Update')                /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/

/* Bring records from DKEYS1xx to DKEYSxx */

                  CPYF       FROMFILE(DKEYS1DP) TOFILE(DKEYSDP) MBROPT(*ADD)           /*MD021383A*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                            /*MD021383A*/
                                                                                       /*MD021383A*/
                  CALL       PGM(DL000150) PARM('DKEYSZZ' 'Update')                    /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                     /*MD021383A*/
                                                                                       /*MD021383A*/
             ENDDO                                                                      /*MD049139*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**********     IF         COND((&SEQ *EQ 00001) *OR (&SEQ *EQ + */           /*MD021383A MD049139*/
/**********                  00002)) THEN(DO)                    */           /*MD021383A MD049139*/
                IF         COND(((&CLE025 *EQ 'Y') *AND +
                                 ((&SEQ *EQ 00001) *OR +
                                  (&SEQ *EQ 00002))) *OR +
                                (&CLE025 *NE 'Y')) THEN(DO)                             /*MD049139*/
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
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
/**********     IF        COND((&SEQ *EQ 00003) *OR (&SEQ *EQ + */            /*MD021383A MD049139*/
/**********                 00004)) THEN(DO)                    */            /*MD021383A MD049139*/
                IF        COND((&CLE025 *EQ 'Y') *AND +
                               ((&SEQ *EQ 00003) *OR +
                                (&SEQ *EQ 00004))) THEN(DO)                             /*MD049139*/
                   IF         COND(&POST *EQ '1') THEN(DO)                             /*MD021383A*/
                      CLRPFM     FILE(GEDL3HH)                                         /*MD021383A*/
                      CLRPFM     FILE(GEDL3PD)                                         /*MD021383A*/
                      CLRPFM     FILE(GEDL3ZZ)                                         /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                                                                                       /*MD021383A*/
                   IF         COND(&POST *EQ '5') THEN(DO)                             /*MD021383A*/
                      CLRPFM     FILE(GEDL4HH)                                         /*MD021383A*/
                      CLRPFM     FILE(GEDL4PD)                                         /*MD021383A*/
                      CLRPFM     FILE(GEDL4ZZ)                                         /*MD021383A*/
                   ENDDO                                                               /*MD021383A*/
                ENDDO                                                                  /*MD021383A*/
                                                                                       /*MD021383A*/
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
/*****If*CIR001*is*switched*ON,*override*LF/DEALSX*and************************/ /*CIR001 MD021383A*/
/*****run*DL4100*to*set*processed*indicators*on*IRS*change*files**************/ /*CIR001 MD021383A*/
/**********  IF         COND(&CIR001 *EQ 'Y') THEN(DO)                       */ /*CIR001 MD021383A*/
/**********  IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                     */ /*CIR001 MD021383A*/
/**********    CHGJOB     SWS(00000000)                                      */ /*CIR001 MD021383A*/
/**********    OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)              */ /*CIR001 MD021383A*/
/**********    CALL       PGM(DL4100)                                        */ /*CIR001 MD021383A*/
/**********    DLTOVR     FILE(DEALSX)                                       */ /*CIR001 MD021383A*/
/**********    IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                   */ /*CIR001 MD021383A*/
/**********        SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +              /*MD021383A*/
/**********                     TOMSGQ(MOPERQ MRUNQ)                         */ /*CIR001 MD021383A*/
/**********        RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)              */ /*CIR001 MD021383A*/
/**********        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +                             /*MD021383A*/
/**********        MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)                         */ /*CIR001 MD021383A*/
/**********    ENDDO                                                         */ /*CIR001 MD021383A*/
/**********  ENDDO                                                           */ /*CIR001 MD021383A*/
/**********  ENDDO                                                           */ /*CIR001 MD021383A*/
             IF         COND((&CLE025 *NE 'Y') *AND +
                             (&CIR001 *EQ 'Y')) THEN(DO)                                /*MD049139*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                                /*MD049139*/
               CHGJOB     SWS(00000000)                                                 /*MD049139*/
               OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)                         /*MD049139*/
               CALL       PGM(DL4100)                                                   /*MD049139*/
               DLTOVR     FILE(DEALSX)                                                  /*MD049139*/
               IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                              /*MD049139*/
                   SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)                                    /*MD049139*/
                   RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)                         /*MD049139*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)                                    /*MD049139*/
               ENDDO                                                                    /*MD049139*/
             ENDDO                                                                      /*MD049139*/
             ENDDO                                                                      /*MD049139*/
                                                                                       /*MD021383A*/
             GOTO       CMDLBL(ENDPGM)                                                 /*MD021383A*/
                                                                                       /*MD021383A*/
ABNOR:                                                                                 /*MD021383A*/
             CHGJOB     SWS(XXXXXX11)                                                  /*MD021383A*/
             SNDPGMMSG  MSG('Program DLC0606C ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                                         /*MD021383A*/
             MONMSG     MSGID(CPF0000 MCH0000)                                         /*MD021383A*/
                                                                                       /*MD021383A*/
ENDPGM:                                                                                /*MD021383A*/
/**/                                                                  /*CDL008*/
/*  If no error occured in the program, delete backup file.           /*CDL008*/
/**/                                                                  /*CDL008*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            /*CDL008*/
/**/                                                                  /*CDL008*/
/** Call CB0150 to update restart indicator */                        /*CDL008*/
/**/                                                                  /*CDL008*/
                CHGVAR     VAR(&STAT) VALUE('N')                      /*CDL008*/
                CALL       PGM(CB0150) PARM(&NAM &SEQ &STAT)          /*CDL008*/
/**********     IF         COND(&CDL008 = 'Y') THEN(DO)                      */ /*CDL008 MD021383A*/
/**********          DLTF       FILE(XFXCLSPSH)                              */ /*CDL008 MD021383A*/
/**********          MONMSG     MSGID(CPF2105)                               */ /*CDL008 MD021383A*/
/**********     ENDDO                                                        */ /*CDL008 MD021383A*/
                IF         COND((&CLE025 *NE 'Y') *AND +
                                (&CDL008 = 'Y')) THEN(DO)                               /*MD049139*/
                     DLTF       FILE(XFXCLSPSH)                                         /*MD049139*/
                     MONMSG     MSGID(CPF2105)                                          /*MD049139*/
                ENDDO                                                                   /*MD049139*/
               ENDDO                                                  /*CDL008*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
