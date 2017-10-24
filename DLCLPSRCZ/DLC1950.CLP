/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS revaluations')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - FRA/IRS Module                                      */
/*                                                                   */
/*       DLC1950 - FRA/IRS REVALUATION REPORTS CONTROL               */
/*                                                                   */
/*       Function: Calls three Revaluation Reports: - FRA, IRS - RS  */
/*         (I/C)   (Single Currency) and IRS - RX (Cross Currency).  */
/*         (COB)   In Input Cycle, only one of the programs will be  */
/*                 called, depending on Input Parameter &MODE. The   */
/*                 selection parameters passed are from the Prompt   */
/*                 Program, DL1953.                                  */
/*                 In Close of Business, all three reports are       */
/*                 mandatory for all Branch/Currency/Book.           */
/*                                                                   */
/*            &MODE                                                  */
/*       Calls: F - DL1950 - FRA Revaluation Report                  */
/*              S - DL1952 - IRS Revaluation Report (for Single Ccy) */
/*              X - DL1952 - IRS Revaluation Report (for Cross Ccy)  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CGL187             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS008             Date 16Jun04              */
/*                      CAS006             Date 21Jan03              */
/*                      CAS005             Date 16Dec02              */
/*                      CIR012             Date 03Apr03              */
/*                      CAS004             Date 26Jun02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205958             Date 22May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CIR001             Date 13Jun95              */
/*                      S01328             Date 08Mar91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL187 - Amendment to Net Trading Position Report           */
/*       CAS008 - IAS 39 Enhancements                                */
/*       CAS006 - Hedge Accounting Phase B                           */
/*       CAS005 - Enhancemments to CAS001, CAS002 and CAS004         */
/*       CIR012 - Allow report selection by deal.                    */
/*       CAS004 - Hedge Accounting Phase A                           */
/*       205958 - Replace IRS revaluation DL1952 with DL1955 and     */
/*                DL1956.                                            */
/*       CIR001 - Interest Rate Calendars                            */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                   */
/*********************************************************************/
 
             PGM PARM(&MODE &TYPE &SEQ &LVL &ENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL  VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL  VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL  VAR(&SEQ)  TYPE(*CHAR) LEN(5)
             DCL  VAR(&LVL)  TYPE(*CHAR) LEN(1)
             DCL  VAR(&ENT)  TYPE(*CHAR) LEN(3)
             DCL  VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL  VAR(&CCY)  TYPE(*CHAR) LEN(3)
             DCL  VAR(&BOOK) TYPE(*CHAR) LEN(2)
             DCL  VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL  VAR(&RTCD)   TYPE(*CHAR) LEN(7)                     /*CIR001*/
             DCL  VAR(&OPTN)   TYPE(*CHAR) LEN(7)                     /*CIR001*/
             DCL  VAR(&SAR)    TYPE(*CHAR) LEN(6)                     /*CIR001*/
             DCL  VAR(&SCSARD) TYPE(*CHAR) LEN(200)                   /*CIR001*/
             DCL  VAR(&CIR001) TYPE(*CHAR) LEN(1) VALUE('N')          /*CIR001*/
             DCL  VAR(&CGL187) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CGL187*/
             DCL  VAR(&CAS004) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CAS004*/
             DCL  VAR(&CAS005) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CAS005*/
             DCL  VAR(&STAT) TYPE(*CHAR) LEN(1)                                           /*CAS004*/
             DCL  VAR(&CSEQ) TYPE(*DEC) LEN(5)                                            /*CAS004*/
             DCL  VAR(&SYSID) TYPE(*CHAR) LEN(2)                                          /*CAS004*/
             DCL  VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                         /*CAS004*/
             DCL  VAR(&CAS006) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CAS006*/
             DCL  VAR(&DEAL) TYPE(*CHAR) LEN(6)                                           /*CIR012*/
/*/COPY WNCPYSRC,DLC1950004                                          */
             DCL  VAR(&CAS008) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CAS008*/
 
/***  Monitor for any errors and send appropriate message to MOPERQ */
 
             MONMSG (RPG0000 CPF0000 MCH0000) EXEC(GOTO (ERROR))
 
/***  Initialise Switches and LDA  */
 
             CHGJOB SWS(00000000)
             CHGDTAARA (LDA) VALUE(' ')
/*/COPY WNCPYSRC,DLC1950005                                          */
                                                                                          /*CAS004*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CAS004*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CAS004*/
/**/                                                                                      /*CAS004*/
/*  Determine if Hedge Accounting is installed                                            /*CAS004*/
/**/                                                                                      /*CAS004*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS004*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS004*/
           CHGVAR     VAR(&SAR) VALUE('CAS004')                                           /*CAS004*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                        /*CAS004*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CAS004) VALUE('Y'))                                      /*CAS004*/
/**/                                                                                      /*CAS005*/
/*  Determine if CAS005 is installed                                                      /*CAS005*/
/**/                                                                                      /*CAS005*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS005*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS005*/
           CHGVAR     VAR(&SAR) VALUE('CAS005')                                           /*CAS005*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                        /*CAS005*/
           IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                        VAR(&CAS005) VALUE('Y'))                                          /*CAS005*/
/**/                                                                                      /*CAS006*/
/* Determine if Hedge Accounting Phase B is installed */                                  /*CAS006*/
/**/                                                                                      /*CAS006*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS006*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS006*/
           CHGVAR     VAR(&SAR) VALUE('CAS006')                                           /*CAS006*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                        /*CAS006*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CAS006) VALUE('Y'))                                      /*CAS006*/
                                                                                          /*CAS006*/
/**/                                                                                      /*CAS008*/
/* Determine if Hedge Accounting Phase B is installed */                                  /*CAS008*/
/**/                                                                                      /*CAS008*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS008*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS008*/
           CHGVAR     VAR(&SAR) VALUE('CAS008')                                           /*CAS008*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                        /*CAS008*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CAS008) VALUE('Y'))                                      /*CAS008*/
                                                                                          /*CAS004*/
             IF         COND(&MODE *EQ 'F' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(1))                                      /*CAS004*/
             IF         COND(&MODE *EQ 'S' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(2))                                      /*CAS004*/
             IF         COND(&MODE *EQ 'X' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(3))                                      /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&CAS004 *EQ 'Y') THEN(DO)                                    /*CAS004*/
                IF        COND(&MODE *EQ 'F' *AND &TYPE *EQ '1') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10011))                                /*CAS004*/
                IF        COND(&MODE *EQ 'S' *AND &TYPE *EQ '1') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10012))                                /*CAS004*/
                IF        COND(&MODE *EQ 'X' *AND &TYPE *EQ '1') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10013))                                /*CAS004*/
                IF        COND(&MODE *EQ 'F' *AND &TYPE *EQ '2') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(4))                                    /*CAS004*/
                IF        COND(&MODE *EQ 'S' *AND &TYPE *EQ '2') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(5))                                    /*CAS004*/
                IF        COND(&MODE *EQ 'X' *AND &TYPE *EQ '2') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(6))                                    /*CAS004*/
                IF        COND(&MODE *EQ 'F' *AND &TYPE *EQ '3') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10014))                                /*CAS004*/
                IF        COND(&MODE *EQ 'S' *AND &TYPE *EQ '3') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10015))                                /*CAS004*/
                IF        COND(&MODE *EQ 'X' *AND &TYPE *EQ '3') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(10016))                                /*CAS004*/
                IF        COND(&MODE *EQ 'F' *AND &TYPE *EQ '4') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(7))                                    /*CAS004*/
                IF        COND(&MODE *EQ 'S' *AND &TYPE *EQ '4') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(8))                                    /*CAS004*/
                IF        COND(&MODE *EQ 'X' *AND &TYPE *EQ '4') THEN+
                          (CHGVAR VAR(&CSEQ) VALUE(9))                                    /*CAS004*/
                                                                                          /*CAS004*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS004*/
/* Call program CB0160 to get value of restart indicator */                               /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&TYPE *NE 'I') THEN(DO)                                      /*CAS004*/
             CALL       PGM(CB0160) PARM('DLC1950' &CSEQ &STAT)                           /*CAS004*/
                                                                                          /*CAS004*/
/* If it is not a restart */                                                              /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                                      /*CAS004*/
                  DLTF       FILE(XDEALSDG)                                               /*CAS004*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS004*/
             IF         COND(&MODE *EQ 'S') THEN(DO)                                      /*CAS005*/
/**********       DLTF       FILE(XIRNPVLPD)                         */        /*CAS004*/ /*CAS005*/
                  DLTF       FILE(XIRNPVAPD)                                              /*CAS005*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS004*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 *EQ 'Y' *AND &MODE *EQ 'X') +
                          THEN(DO)                                                        /*CAS005*/
                  DLTF       FILE(XRXNPVAPD)                                              /*CAS005*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS005*/
             ENDDO                                                                        /*CAS005*/
             IF         COND(&CAS006 *EQ 'Y' *AND &MODE *EQ 'F') +
                          THEN(DO)                                                        /*CAS006*/
                       DLTF       FILE(XFRNPVAPD)                                         /*CAS006*/
                       MONMSG     MSGID(CPF2105)                                          /*CAS006*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CAS004*/
/**Create*a*backup*for*DEALSDG,*IRNPVLPD***/                                   /*CAS004*/ /*CAS005*/
/* Create a backup for DEALSDG, IRNPVAPD  */                                              /*CAS005*/
/* and FRNPVAPD  */                                                                       /*CAS006*/
                                                                                          /*CAS004*/
                  CPYF       FROMFILE(DEALSDG) TOFILE(&DPLIB/XDEALSDG) +
                             CRTFILE(*YES)                                                /*CAS004*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             IF         COND(&MODE *EQ 'S') THEN(DO)                                      /*CAS005*/
/**********       CPYF       FROMFILE(IRNPVLPD) TOFILE(&DPLIB/XIRNPVLPD) + */             /*CAS005*/
/**********                  CRTFILE(*YES)                                 */  /*CAS004*/ /*CAS005*/
                  CPYF       FROMFILE(IRNPVAPD) TOFILE(&DPLIB/XIRNPVAPD) +
                             CRTFILE(*YES)                                                /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 *EQ 'Y' *AND &MODE *EQ 'X') +
                          THEN(DO)                                                        /*CAS005*/
                                                                                          /*CAS005*/
/* Create a backup for RXNPVAPD  */                                                       /*CAS005*/
                                                                                          /*CAS005*/
                  CPYF       FROMFILE(RXNPVAPD) TOFILE(&DPLIB/XRXNPVAPD) +
                             CRTFILE(*YES)                                                /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS005*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS006 *EQ 'Y' *AND &MODE *EQ 'F') +
                          THEN(DO)                                                        /*CAS006*/
                       CPYF       FROMFILE(FRNPVAPD) TOFILE(&DPLIB/XFRNPVAPD) +
                                  CRTFILE(*YES)                                           /*CAS006*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*CAS006*/
             ENDDO                                                                        /*CAS006*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS004*/
/* If it is a restart */                                                                  /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                                      /*CAS004*/
                  CPYF       FROMFILE(&DPLIB/XDEALSDG) TOFILE(DEALSDG) +
                             MBROPT(*REPLACE)                                             /*CAS004*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             IF         COND(&MODE *EQ 'S') THEN(DO)                                      /*CAS005*/
/**********       CPYF       FROMFILE(&DPLIB/XIRNPVLPD) TOFILE(IRNPVLPD) + */             /*CAS005*/
/**********                  MBROPT(*REPLACE)                              */  /*CAS004*/ /*CAS005*/
                  CPYF       FROMFILE(&DPLIB/XIRNPVAPD) TOFILE(IRNPVAPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                          /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 *EQ 'Y' *AND &MODE *EQ 'X') +
                          THEN(DO)                                                        /*CAS005*/
                  CPYF       FROMFILE(&DPLIB/XRXNPVAPD) TOFILE(RXNPVAPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                          /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS005*/
             ENDDO                                                                        /*CAS005*/
             IF         COND(&CAS006 *EQ 'Y' *AND &MODE *EQ 'F') +
                          THEN(DO)                                                        /*CAS006*/
                       CPYF       FROMFILE(&DPLIB/XFRNPVAPD) TOFILE(FRNPVAPD) +
                                  MBROPT(*REPLACE)                                        /*CAS006*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*CAS006*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CAS005*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS004*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                             /*CAS004*/
                                                                                          /*CAS004*/
/* Call CB0150 to update restart indicator */                                             /*CAS004*/
                                                                                          /*CAS004*/
             CALL       PGM(CB0150) PARM('DLC1950' &CSEQ &STAT)                           /*CAS004*/
             ENDDO                                                                        /*CAS004*/
 
/***  Set up the Parameters for the Reports:                         */
/***  If all Branches are selected, RCF passes 'ALL' as the entity.  */
/***  DL1950 and DL1952 expect blanks, so convert first.             */
/***  In Input Cycle, selection for Currency and Book are passed in  */
/***  &RPARM.  If 'ALL' Currencies were selected then &RPARM will    */
/***  have a value of asterisks to avoid &RPARM being blank. Convert */
/***  this to blanks before calling RPG program.                     */
/***  In COB run, all programs are called and the Branch,            */
/***  Currency and Book parameters must all be blank to indicate     */
/***  that all Deals are to be selected.                             */
 
               IF (&ENT = 'ALL') THEN(CHGVAR (&ENT) VALUE('   '))
 
               CHGVAR (&CCY)  VALUE(%SST(&RPARM 1 3))
               IF (&CCY = '***') THEN(CHGVAR (&CCY) VALUE('   '))
 
               CHGVAR (&BOOK) VALUE(%SST(&RPARM 4 2))
               IF (&BOOK = '**') THEN(CHGVAR (&BOOK) VALUE('  '))
               CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*CGL187*/
               CHGVAR     VAR(&SAR) VALUE('CGL187')                                       /*CGL187*/
               CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*CGL187*/
               CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                    /*CGL187*/
               IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                            VAR(&CGL187) VALUE('Y'))                                      /*CGL187*/
                                                                                          /*CIR012*/
               CHGVAR     VAR(&DEAL) VALUE(%SST(&RPARM 6 6))                              /*CIR012*/
               IF         COND(&DEAL = '******') THEN(CHGVAR +
                            VAR(&DEAL) VALUE('  '))                                       /*CIR012*/
 
/***  Call FRA Revaluation Report  */
 
             IF (&MODE *EQ 'F') THEN(DO)
               SNDMSG ('DLC1950 - FRA Revaluation Report') +
                       TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC1950001                                          */
/**********    CALL (DL1950) PARM(&TYPE &ENT &CCY &BOOK &SEQ) ***/                        /*CIR012*/
               CALL       PGM(DL1950) PARM(&TYPE &ENT &CCY &BOOK &SEQ +
                            &DEAL)                                                        /*CIR012*/
 
/***  Check for Database Error  */
 
               IF (%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                 GOTO (ERROR)
               ENDDO
             ENDDO
/**/                                                                  /*CIR001*/
/*  Determine if IRS Calendars installed                              /*CIR001*/
/**/                                                                  /*CIR001*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                     /*CIR001*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*CIR001*/
           CHGVAR     VAR(&SAR) VALUE('CIR001')                       /*CIR001*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*CIR001*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CIR001) VALUE('Y'))                  /*CIR001*/
 
/***  Call IRS (Single Currency) Revaluation Report  */
 
/************IF (&MODE *EQ 'S') THEN(DO) ***************************  /*CIR001*/
/**********  IF (&MODE *EQ 'S' *AND &CIR001 *NE 'Y') THEN(DO)          */      /*CIR001*/ /*205958*/
/**********    SNDMSG ('DLC1950 - IRS (Single Currency) Revaluation +  */                 /*205958*/
/**********            Report') TOMSGQ(MRUNQ)                          */                 /*205958*/
/**********    CALL (DL1952) PARM(&MODE &TYPE &ENT &CCY &BOOK &SEQ)    */                 /*205958*/
 
/***  Check for Database Error  */
 
/**********    IF (%SWITCH(XXXXXX11)) THEN(DO)                         */                 /*205958*/
/**********      RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)                 */                 /*205958*/
/**********      SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +   */                 /*205958*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                      */                 /*205958*/
/**********      GOTO (ERROR)                                          */                 /*205958*/
/**********    ENDDO                                                   */                 /*205958*/
/**********  ENDDO                                                     */                 /*205958*/
 
/***  Call IRS (Cross Currency) Revaluation Report  */
 
/************IF (&MODE *EQ 'X') THEN(DO) ***************************  /*CIR001*/
/**********  IF (&MODE *EQ 'X' *AND &CIR001 *NE 'Y') THEN(DO)          */      /*CIR001*/ /*205958*/
/**********    SNDMSG ('DLC1950 - IRS (Cross Currency) Revaluation +   */                 /*205958*/
/**********            Report') TOMSGQ(MRUNQ)                          */                 /*205958*/
/**********    CALL (DL1952) PARM(&MODE &TYPE &ENT &CCY &BOOK &SEQ)    */                 /*205958*/
 
/***  Check for Database Error  */
 
/**********    IF (%SWITCH(XXXXXX11)) THEN(DO)                         */                 /*205958*/
/**********      RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)                 */                 /*205958*/
/**********      SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +   */                 /*205958*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                      */                 /*205958*/
/**********      GOTO (ERROR)                                          */                 /*205958*/
/**********    ENDDO                                                   */                 /*205958*/
/**********  ENDDO                                                     */                 /*205958*/
                                                                      /*CIR001*/
/***  Call IRS (Single Currency) Revaluation Report  */               /*CIR001*/
                                                                      /*CIR001*/
/**********  IF (&MODE *EQ 'S' *AND &CIR001 *EQ 'Y') THEN(DO)  */              /*CIR001*/ /*205958*/
             IF (&MODE *EQ 'S') THEN(DO)                                                  /*205958*/
               SNDMSG ('DLC1950 - IRS (Single Currency) Revaluation +
                       Report') TOMSGQ(MRUNQ)                         /*CIR001*/
                                                                      /*CIR001*/
/***  Revaluation Extract */                                          /*CIR001*/
                                                                      /*CIR001*/
               CLRPFM FILE(DLACTVPD)                                  /*CIR001*/
               CLRPFM FILE(DLCFEVPD)                                  /*CIR001*/
               IF         COND(&CGL187 *EQ 'Y') THEN(CLRPFM +
                           FILE(DLIRSCFPD))                                               /*CGL187*/
/**********    CALL (DL1955) PARM(&MODE &TYPE &ENT &CCY &BOOK &SEQ) ***/       /*CIR001*/ /*CIR012*/
               CALL       PGM(DL1955) PARM(&MODE &TYPE &ENT &CCY &BOOK +
                            &SEQ &DEAL)                                                   /*CIR012*/
                                                                      /*CIR001*/
/***  Revaluation Report  */                                          /*CIR001*/
                                                                      /*CIR001*/
               IF (%SWITCH(XXXXXX00)) THEN(DO)                        /*CIR001*/
/*/COPY WNCPYSRC,DLC1950002                                          */
               IF ((&CAS008 *EQ 'Y' *AND &TYPE *EQ '2') *OR +
                 (&CAS008 *EQ 'Y' *AND &TYPE *EQ '4')) +
                 THEN(CLRPFM FILE(RSCFLAPD))                                              /*CAS008*/
               CALL (DL1956) PARM(&MODE &TYPE &SEQ)                   /*CIR001*/
               ENDDO                                                  /*CIR001*/
                                                                      /*CIR001*/
/***  Check for Database Error  */                                    /*CIR001*/
                                                                      /*CIR001*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CIR001*/
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)                /*CIR001*/
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CIR001*/
                 GOTO (ERROR)                                         /*CIR001*/
               ENDDO                                                  /*CIR001*/
             ENDDO                                                    /*CIR001*/
                                                                      /*CIR001*/
/***  Call IRS (Cross Currency) Revaluation Report  */                /*CIR001*/
                                                                      /*CIR001*/
/**********  IF (&MODE *EQ 'X' *AND &CIR001 *EQ 'Y') THEN(DO)  */              /*CIR001*/ /*205958*/
             IF (&MODE *EQ 'X') THEN(DO)                                                  /*205958*/
               SNDMSG ('DLC1950 - IRS (Cross Currency) Revaluation +
                       Report') TOMSGQ(MRUNQ)                         /*CIR001*/
                                                                      /*CIR001*/
/***  Revaluation Extract */                                          /*CIR001*/
                                                                      /*CIR001*/
               CLRPFM FILE(DLACTVPD)                                  /*CIR001*/
               CLRPFM FILE(DLCFEVPD)                                  /*CIR001*/
/**********    CALL (DL1955) PARM(&MODE &TYPE &ENT &CCY &BOOK &SEQ) ***/       /*CIR001*/ /*CIR012*/
               CALL       PGM(DL1955) PARM(&MODE &TYPE &ENT &CCY &BOOK +
                            &SEQ &DEAL)                                                   /*CIR012*/
                                                                      /*CIR001*/
/***  Revaluation Report  */                                          /*CIR001*/
                                                                      /*CIR001*/
               IF (%SWITCH(XXXXXX00)) THEN(DO)                        /*CIR001*/
/*/COPY WNCPYSRC,DLC1950003                                          */
               IF ((&CAS008 *EQ 'Y' *AND &TYPE *EQ '2') *OR +
                 (&CAS008 *EQ 'Y' *AND &TYPE *EQ '4')) +
                 THEN(CLRPFM FILE(RXCFLAPD))                                              /*CAS008*/
               CALL (DL1956) PARM(&MODE &TYPE &SEQ)                   /*CIR001*/
               ENDDO                                                  /*CIR001*/
                                                                      /*CIR001*/
/***  Check for Database Error  */                                    /*CIR001*/
                                                                      /*CIR001*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CIR001*/
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)                /*CIR001*/
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CIR001*/
                 GOTO (ERROR)                                         /*CIR001*/
               ENDDO                                                  /*CIR001*/
             ENDDO                                                    /*CIR001*/
                                                                                          /*CAS004*/
/* If no error occured in the program */                                                  /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&TYPE *NE 'I') THEN(DO)                                      /*CAS004*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CAS004*/
                                                                                          /*CAS004*/
/* Call CB0150 to update restart indicator */                                             /*CAS004*/
                                                                                          /*CAS004*/
                  CHGVAR     VAR(&STAT) VALUE('N')                                        /*CAS004*/
                  CALL       PGM(CB0150) PARM('DLC1950' &CSEQ &STAT)                      /*CAS004*/
                  DLTF       FILE(XDEALSDG)                                               /*CAS004*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS004*/
             IF         COND(&MODE *EQ 'S') THEN(DO)                                      /*CAS005*/
/**********       DLTF       FILE(XIRNPVLPD)                         */        /*CAS004*/ /*CAS005*/
                  DLTF       FILE(XIRNPVAPD)                                              /*CAS005*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS004*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 *EQ 'Y' *AND &MODE *EQ 'X') +
                          THEN(DO)                                                        /*CAS005*/
                  DLTF       FILE(XRXNPVAPD)                                              /*CAS005*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS005*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS006 *EQ 'Y' *AND &MODE *EQ 'F') +
                          THEN(DO)                                                        /*CAS006*/
                       DLTF       FILE(XFRNPVAPD)                                         /*CAS006*/
                       MONMSG     MSGID(CPF2105)                                          /*CAS006*/
             ENDDO                                                                        /*CAS006*/
             ENDDO                                                                        /*CAS004*/
             ENDDO                                                                        /*CAS004*/
 
             GOTO (END)
 
 ERROR:      IF (&MODE *EQ 'F') +
             THEN(SNDMSG ('FRA Revaluation Report has +
                  terminated abnormally.') TOMSGQ(MOPERQ MRUNQ))
 
             ELSE (IF (&MODE *EQ 'S') +
                   THEN(SNDMSG ('IRS-RS Revaluation Report has +
                        terminated abnormally.') TOMSGQ(MOPERQ MRUNQ)))
 
                   ELSE (SNDMSG ('IRS-RX Revaluation Report has +
                         terminated abnormally.') TOMSGQ(MOPERQ MRUNQ))
                                                                                          /*CAS004*/
                  CPYF       FROMFILE(&DPLIB/XDEALSDG) TOFILE(DEALSDG) +
                             MBROPT(*REPLACE)                                             /*CAS004*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             IF         COND(&MODE *EQ 'S') THEN(DO)                                      /*CAS005*/
/**********       CPYF       FROMFILE(&DPLIB/XIRNPVLPD) TOFILE(IRNPVLPD) + */             /*CAS005*/
/**********                  MBROPT(*REPLACE)                              */  /*CAS004*/ /*CAS005*/
                  CPYF       FROMFILE(&DPLIB/XIRNPVAPD) TOFILE(IRNPVAPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                          /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 *EQ 'Y' *AND &MODE *EQ 'X') +
                          THEN(DO)                                                        /*CAS005*/
                  CPYF       FROMFILE(&DPLIB/XRXNPVAPD) TOFILE(RXNPVAPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                          /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS005*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS006 *EQ 'Y' *AND &MODE *EQ 'F') +
                          THEN(DO)                                                        /*CAS006*/
                       CPYF       FROMFILE(&DPLIB/XFRNPVAPD) TOFILE(FRNPVAPD) +
                                  MBROPT(*REPLACE)                                        /*CAS006*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*CAS006*/
             ENDDO                                                                        /*CAS006*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 END:        ENDPGM
