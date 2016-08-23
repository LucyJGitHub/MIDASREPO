/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Forward revaluations')                       */
/********************************************************************/
/*                                                                  */
/*        Midas - Dealing Module                                    */
/*                                                                  */
/*       DLC0608 - FORWARD REVALUATION                              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 242842             Date 11Oct06              */
/*       Prev Amend No. 240553             Date 28Jun06              */
/*                      CDL048             Date 26Jun06              */
/*                      237367             Date 02Mar06              */
/*                      228542             Date 05Aug04              */
/*                      CAS005             Date 16Dec02              */
/*                      CAS004             Date 26Jun02              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      211357             Date 07Jan03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS001             Date 23Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAC002             Date 15Sep96              */
/*                      S01408             Date 16Jun95              */
/*                      S01117             Date 18/07/89             */
/*                        S01194           DATE 18/07/89             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       242842 - Avoid DB error in CB0180.                          */
/*                Apply fix 240553.                                  */
/*       240553 - No need to define value for &CSEQ since it is now  */
/*                included in the parameters being passed to this    */
/*                component. Apply fix 237367.                       */
/*       CDL048 - IAS Forward Revaluation Processing                 */
/*       237367 - Annotated as 240553.                               */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*       211357  - If CAS001 is not switched on, use the pre CAS001  */
/*                 input file for DL0410/DL0411. This will ensure    */
/*                 the Book Code is not included in the Primary file */
/*                 key.                                              */
/*       CAS004 - Hedge Accounting Phase A                           */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*       CAC002  - Profit Centre Accounting Development Phase 2:    */
/*                 Call program DL0411 instead of DL0410 if         */
/*                 Analytical Accounting module is installed.       */
/*       S01408  - Addition of core hook DLC0608MPS                 */
/*                 Addition of core hook DLC0608MP1                 */
/*                 Addition of core hook DLC0608MP2                 */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01117  -  MULTIBRANCHING                                  */
/********************************************************************/
/*********** PGM        PARM(&FREVAL)                                 /*S01117*/
 
/* &RLEV IS A STANDARD RCF PARAMETER, IT IS NOT USED BY THIS PROGRAM */
/*/COPY WNCPYSRC,DLC0608004                                          */
/**********  PGM PARM(&FREVAL &RSEQ &RLEV &RENT)                               /*S01117*/ /*CAS004*/
             PGM PARM(&CNAM &CSEQ &FREVAL &RSEQ &RLEV &RENT)                              /*CAS004*/
/*/COPY WNCPYSRC,DLC0608005                                          */
/**/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FREVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*CAC002*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0608MPS                                           /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CAS001*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CAS001*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CAS001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS001*/
             DCL        VAR(&CAS001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS001*/
             DCL        VAR(&CAS005) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS005*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                     /*CAS004*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                    /*CAS004*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                                      /*CAS004*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CAS004*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CAS004*/
             DCL        VAR(&CDL048) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL048*/
 
             SNDMSG     MSG('FORWARD REVALUATION')  TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
             IF         COND(&FREVAL = Y) THEN(CHGJOB  SWS(10000000))
             CLRPFM     FILE(GEFRHH)
             CLRPFM     FILE(GEFRPD)
             CLRPFM     FILE(GEFRZZ)
                                                                                          /*CDL048*/
/* Clear PF/DLNPVLPP when CDL048 is on */                                                 /*CDL048*/
                                                                                          /*CDL048*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CDL048*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CDL048*/
             CHGVAR     VAR(&PSARD) VALUE('CDL048')                                       /*CDL048*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CDL048*/
                                                                                          /*CDL048*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CDL048*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                 TOMSGQ(MOPERQ)                                                           /*CDL048*/
               GOTO   CMDLBL(ABNOR)                                                       /*CDL048*/
             ENDDO                                                                        /*CDL048*/
                                                                                          /*CDL048*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CDL048) VALUE('Y'))                                        /*CDL048*/
                                                                                          /*CDL048*/
             IF         COND(&CDL048 = 'Y') THEN(DO)                                      /*CDL048*/
               CLRPFM     DLNPVLPP                                                        /*CDL048*/
             ENDDO                                                                        /*CDL048*/
                                                                                          /*CAS001*/
/* Clear PF/DLNPVLPD when CAS001 is on */                                                 /*CAS001*/
                                                                                          /*CAS001*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CAS001*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CAS001*/
             CHGVAR     VAR(&PSARD) VALUE('CAS001')                                       /*CAS001*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CAS001*/
                                                                                          /*CAS001*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAS001*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                 TOMSGQ(MOPERQ)                                                           /*CAS001*/
               GOTO   CMDLBL(ABNOR)                                                       /*CAS001*/
             ENDDO                                                                        /*CAS001*/
                                                                                          /*CAS001*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CAS001) VALUE('Y'))                                        /*CAS001*/
                                                                                          /*CAS001*/
             IF         COND(&CAS001 = 'Y') THEN(DO)                                      /*CAS001*/
               CLRPFM     DLNPVLPD                                                        /*CAS001*/
             ENDDO                                                                        /*CAS001*/
                                                                                          /*CAS005*/
/** Check if CAS005 is installed **/                                                      /*CAS005*/
                                                                                          /*CAS005*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CAS005*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CAS005*/
             CHGVAR     VAR(&PSARD) VALUE('CAS005')                                       /*CAS005*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAS005*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                 TOMSGQ(MOPERQ)                                                           /*CAS005*/
               GOTO   CMDLBL(ABNOR)                                                       /*CAS005*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CAS005) VALUE('Y'))                                        /*CAS005*/
                                                                                          /*CAS004*/
/** Restart/Recovery Processing **/                                                       /*CAS004*/
                                                                                          /*CAS004*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CAS004*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CAS004*/
/**********  CHGVAR     VAR(&CSEQ) VALUE(10001) */                             /*CAS005*/ /*240553*/
                                                                                          /*CAS004*/
/* Call program CB0160 to get value of restart indicator */                               /*CAS004*/
                                                                                          /*CAS004*/
             CALL       PGM(CB0160) PARM('DLC0608' &CSEQ &STAT)                           /*CAS004*/
                                                                                          /*CAS004*/
/* If it is not a restart */                                                              /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                                      /*CAS004*/
                  DLTF       FILE(XDEALSDB)                                               /*CAS004*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS004*/
                  IF         COND(&CAS005 *EQ 'Y') THEN(DO)                               /*CAS005*/
                     DLTF       FILE(XDLPOSTPD)                                           /*CAS005*/
                     MONMSG     MSGID(CPF2105)                                            /*CAS005*/
                  ENDDO                                                                   /*CAS005*/
                                                                                          /*CAS004*/
/* Create a backup for DEALSDB */                                                         /*CAS004*/
                                                                                          /*CAS004*/
                  CPYF       FROMFILE(DEALSDB) TOFILE(&DPLIB/XDEALSDB) +
                             CRTFILE(*YES)                                                /*CAS004*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
                  IF         COND(&CAS005 *EQ 'Y') THEN(DO)                               /*CAS005*/
                     CPYF       FROMFILE(DLPOSTPD) TOFILE(&DPLIB/XDLPOSTPD) +
                                CRTFILE(*YES)                                             /*CAS005*/
                     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                            /*CAS005*/
                  ENDDO                                                                   /*CAS005*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS004*/
/* If it is a restart */                                                                  /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                                      /*CAS004*/
                  CPYF       FROMFILE(&DPLIB/XDEALSDB) TOFILE(DEALSDB) +
                             MBROPT(*REPLACE)                                             /*CAS004*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS004*/
                  IF         COND(&CAS005 *EQ 'Y') THEN(DO)                               /*CAS005*/
                  CPYF       FROMFILE(XDLPOSTPD) TOFILE(DLPOSTPD) +
                             MBROPT(*REPLACE)                                             /*CAS005*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS005*/
                  ENDDO                                                                   /*CAS005*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS004*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                             /*CAS004*/
                                                                                          /*CAS004*/
/* Call CB0150 to update restart indicator */                                             /*CAS004*/
                                                                                          /*CAS004*/
             CALL       PGM(CB0150) PARM('DLC0608' &CSEQ &STAT)                           /*CAS004*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABDLEI)                  /*S01194*/
/*********** CALL       PGM(DL0410)                                   /*S01117*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0608MP1                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/                                                                  /*CAC002*/
/**  If Analytical Accounting module is present, call program      */ /*CAC002*/
/**  DL0411 instead of DL0410                                      */ /*CAC002*/
/**/                                                                  /*CAC002*/
             CALL       PGM(AOMMODR0) PARM('*DBERR' '*FIRST' &MMOD)   /*CAC002*/
/**/                                                                  /*CAC002*/
/************IF         COND(%SST(&MMOD 100 1) *EQ 'Y') THEN(+ */                         /*211357*/
/************             CALL       PGM(DL0411) PARM(&RSEQ &RENT))*/          /*CAC002*/ /*211357*/
             IF         COND(%SST(&MMOD 100 1) *EQ 'Y') THEN(DO)                          /*211357*/
                IF         COND(&CAS001 *NE 'Y') THEN(OVRDBF +
                             FILE(DLEVNPL4) TOFILE(DLEVNTLB))                             /*211357*/
                CALL       PGM(DL0411) PARM(&RSEQ &RENT)                                  /*211357*/
                IF         COND(&CAS001 *NE 'Y') THEN(DLTOVR +
                             FILE(DLEVNPL4))                                              /*211357*/
             ENDDO                                                                        /*211357*/
             ELSE       CMD(DO)                                       /*CAC002*/
/*/COPY WNCPYSRC,DLC0608001                                          */
             IF         COND(&CDL048 = 'Y') THEN(+
                          CALL       PGM(DL0412) PARM(&RSEQ &RENT))                       /*CDL048*/
             ELSE       CMD(DO)                                                           /*CDL048*/
             IF         COND(&CAS001 *NE 'Y') THEN(OVRDBF +
                          FILE(DLEVNPL1) TOFILE(DLEVNAL1))                                /*211357*/
             CALL       PGM(DL0410) PARM(&RSEQ &RENT)
             IF         COND(&CAS001 *NE 'Y') THEN(DLTOVR +
                          FILE(DLEVNPL1))                                                 /*211357*/
/*/COPY WNCPYSRC,DLC0608002                                          */
             ENDDO                                                                        /*CDL048*/
             ENDDO                                                    /*CAC002*/
/**/                                                                  /*CAC002*/
             IF         COND(&CDL048 = 'Y') THEN(+
                          CALL       PGM(DL0413))                                         /*CDL048*/
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0608MP2                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                         MSG('Job Terminated - database in error') +
                            TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                            MSG('File controls out of balance') TOMSGQ(MOPERQ))
                                                                                          /*CAS004*/
/* Call CB0150 to update restart indicator */                                             /*CAS004*/
                                                                                          /*CAS004*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CAS004*/
               CHGVAR     VAR(&STAT) VALUE('N')                                           /*CAS004*/
               CALL       PGM(CB0150) PARM('DLC0608' &CSEQ &STAT)                         /*CAS004*/
               DLTF       FILE(XDEALSDB)                                                  /*CAS004*/
               MONMSG     MSGID(CPF2105)                                                  /*CAS004*/
               IF         COND(&CAS005 *EQ 'Y') THEN(DO)                                  /*CAS005*/
                  DLTF       FILE(XDLPOSTPD)                                              /*CAS005*/
                  MONMSG     MSGID(CPF2105)                                               /*CAS005*/
               ENDDO                                                                      /*CAS005*/
             ENDDO                                                                        /*CAS004*/
                                                                                          /*CAS005*/
/* Reorganize PF/DLPOSTPD if CAS005 is on */                                              /*CAS005*/
                                                                                          /*CAS005*/
             IF         COND(&CAS005 = 'Y') THEN(DO)                                      /*CAS005*/
/**********    RGZPFM     FILE(DLPOSTPD)                                       /*CAS005*/ /*228542*/
/**********    MONMSG     MSGID(CPF2995 CPF2981)                               /*CAS005*/ /*228542*/
               CALL       PGM(SCC000060) PARM('DLPOSTPD' '*FIRST')                        /*228542*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS001*/
             GOTO       CMDLBL(END)                                                       /*CAS001*/
                                                                                          /*CAS001*/
ABNOR:                                                                                    /*CAS001*/
             CPYF       FROMFILE(&DPLIB/XDEALSDB) TOFILE(DEALSDB) +
                          MBROPT(*REPLACE)                                                /*CAS004*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CAS004*/
             CHGJOB     SWS(XXXXXX11)                                                     /*CAS001*/
             SNDPGMMSG  MSG('DLC0608 - Forward Revaluation  +
                           ended abnormally') TOMSGQ(MOPERQ MRUNQ)                        /*CAS001*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*CAS001*/
                                                                                          /*CAS001*/
END:                                                                                      /*CAS001*/
/**/
/*/COPY WNCPYSRC,DLC0608003                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
