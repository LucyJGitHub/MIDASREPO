/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Spot Revaluation Report Component')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounting Module                        */
/*                                                                   */
/*       MCC0540 - Spot Revaluation Report Component                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG7058            Date 11May05              */
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMC001 *CREATE     Date 18Mar96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG7058 - Spot revals not created when PCA is on            */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CMC001 - Management Accounts Enhancement for PCA            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
/**  Declare variables */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BCCY) TYPE(*CHAR) LEN(3)
/*           DCL        VAR(&SPTA) TYPE(*CHAR) LEN(4)                                 */ /*BUG7058*/
             DCL        VAR(&SPTA) TYPE(*CHAR) LEN(10)                                   /*BUG7058*/
             DCL        VAR(&PRCG) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSET) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDCT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDNY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(512)
/**/
/**  Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDMSG     MSG('MCC0540 - Spot Revaluation Report +
                          by Profit Centre') TOMSGQ(MRUNQ)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX00)
/**/
/**  Access Bank ICD for Base Currency */
/**/
             CALL       PGM(AOBANKR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&BCCY) VALUE(%SST(&DSFDY 13 3))
/**/
/**  Access Trading ICD for Spot Trade A/c code */
/**/
             CALL       PGM(AOTRADR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
/*           CHGVAR     VAR(&SPTA) VALUE(%SST(&DSFDY 19 4))                           */ /*BUG7058*/
             CHGVAR     VAR(&SPTA) VALUE(%SST(&DSFDY 74 10))                             /*BUG7058*/
/**/
/**  Access PCA ICD for Primary Control Group */
/**/
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PRCG) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Access Historic Balances Control Group File for the 'Period */
/**  Set' code of the Primary Control Group                      */
/**/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PRCG &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PSET) VALUE(%SST(&DSFDY 33 1))
/**/
/**  Access Current Period Century, Year and Number */
/**/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PSET 0 &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))
             CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))
/**/
/**  Select only records for the current period; only spot trade accounts */
/**  for the first GLHIBLPD and only base currency accounts for the second */
/**/
             CHGVAR     VAR(&QRYSLT) VALUE('1/HBPDCT *EQ ''''' *CAT +
                          &PDCT *CAT ''''' *AND 1/HBPDYR *EQ ''''' +
                          *CAT &PDYR *CAT ''''' *AND 1/HBPDNY *EQ +
                          ''''' *CAT &PDNY *CAT ''''' *AND +
                          1/HBACCD *EQ ''''' *CAT &SPTA *CAT +
                          ''''' *AND 2/HBCYCD *EQ ''''' *CAT +
                          &BCCY *CAT '''''')
/**/
/**  If entity not blank & not 'ALL', select particular branch requested */
/**/
             IF         COND(&RENT *NE '   ' *AND &RENT *NE 'ALL') THEN(DO)
                CHGVAR     VAR(&QRYSLT) VALUE(&QRYSLT *BCAT  '*AND +
                             1/HBBRCD *EQ ''''' *CAT &RENT *CAT '''''')
             ENDDO
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &PRCG *TCAT ') (GLHIBLPD' *BCAT &PRCG +
                          *TCAT ') (SDCURRPD)) FORMAT(MCSRRPOQ) +
                          QRYSLT(''' *CAT &QRYSLT *TCAT ''') KEYFLD( +
                          (SRBRCD) (SRCYCD) (SRPCCD))')
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'JFLD( +
                          (1/HBPDCT 2/HBPDCT) (1/HBPDYR 2/HBPDYR) +
                          (1/HBPDNY 2/HBPDNY) (1/HBBRCD 2/HBBRCD) +
                          (1/HBCUST 2/HBCUST) (1/HBACSN 2/HBACSN) +
                          (1/HBPCCD 2/HBPCCD) (1/HBBKCD 2/HBBKCD) +
                          (1/HBOTTP 2/HBOTTP) (1/HBTSTY 2/HBTSTY) +
                          (1/HBACNB 2/HBACNB) (1/HBCGCD 2/HBCGCD) +
                          (1/HBCYCD 3/A6CYCD) (2/HBACCD 3/A6SPAE))')
/**/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'MAPFLD( +*/                   /*CGL029*/
/**********               (SRBRCD ''1/HBBRCD'') (SRCYCD ''1/HBCYCD'')*+                   /*CGL029*/
/**********               (SRACCD ''2/HBACCD'') (SRCUST ''1/HBCUST'')*+                   /*CGL029*/
/**********               (SRACSN ''1/HBACSN'') (SRPCCD ''1/HBPCCD'')*+                   /*CGL029*/
/**********               (SRBKCD ''1/HBBKCD'') (SROTTP ''1/HBOTTP'')*+                   /*CGL029*/
/**********               (SRTSTY ''1/HBTSTY'') (SRASNB ''1/HBACNB'')*+                   /*CGL029*/
/**********               (SREPCB ''1/HBPDCB'') (SRBCEQ ''2/HBPDCB + */                   /*CGL029*/
/**********               * -1'') (SRSPRT A6SPRT) (SRMDIN A6MDIN) +  */                   /*CGL029*/
/**********               (SRNBDP A6NBDP) (SRCYNM A6CYNM))')         */                   /*CGL029*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'MAPFLD( +
                          (SRBRCD ''1/HBBRCD'') (SRCYCD ''1/HBCYCD'') +
                          (SRACCD ''2/HBACCD'') (SRCUST ''1/HBCUST'') +
                          (SRACSN ''1/HBACSN'') (SRPCCD ''1/HBPCCD'') +
                          (SRBKCD ''1/HBBKCD'') (SROTTP ''1/HBOTTP'') +
                          (SRTSTY ''1/HBTSTY'') (SRASNB ''1/HBACNB'') +
                          (SREPCB ''1/HBPDCB'') (SRBCEQ ''2/HBPDCB +
                          * -1'') (SRSPRT A6SPRT) (SRMDIN A6MDIN) +
                          (QQACCD ''1/QQACCD'') +
                          (SRNBDP A6NBDP) (SRCYNM A6CYNM))')                              /*CGL029*/
/**/
/**  Execute OPNQRYF  */
/**/
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
/**/
/**  Perform override on file MCSRRPOQ before calling report program */
/**  and then check for any database errors                          */
/**/
             OVRDBF     FILE(MCSRRPOQ) TOFILE(GLHIBLPD) SHARE(*YES)
             CALL       PGM(MC0540) PARM(&RSEQ &RLEV &RENT)
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
/**/
/**  Abnormal error processing */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MCC0540 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
