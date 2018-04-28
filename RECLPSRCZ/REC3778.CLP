/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE A/C'S TO MAKE INACT (LIST ONLY)')            */
/*********************************************************************/
/*                                                                   */
/*       Midas        Retail Module                              */
/*                                                                   */
/*       REC3778 - ACCOUNTS TO BE TRANSFERRED TO INACTIVE STATUS     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083AV           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 101949             DATE 25FEB97              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE083AV - COB Restructure - Retail CoB Optimisation Phase 1*/
/*       101949 - Removed DLTF of XACCNT** files because missing     */
/*                file or locking might occur if REC3778 finishes    */
/*                execution before REC3777. REC3778 is now dependent */
/*                on REC3777 during COB.                             */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &STAT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&STAT)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE(' ')                       /*CRE083AV*/
/*/COPY WNCPYSRC,REC3778001                                          */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/**/
             SNDPGMMSG  MSG('REC3778 - List of Accounts to be +
                          Transferred to Inactive Status') +
                          TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
/*  BLOCK FILES   */
/**/
             CHGJOB SWS(10000000)
/**/
/**********  OVRDBF     FILE(SAXFI) TOFILE(ACCNTAB) SHARE(*YES)      */                 /*CRE083AV*/
             CHGVAR     VAR(&FROMLIB) VALUE(&PRE *TCAT 'DMLIB')
/**/
/**********  OPNQRYF    FILE((ACCNTAB) (CLINTCB) (SDBANKPD) +
                          (SDRETLPD)) FORMAT(SAXFI AXFIAXF) +
                          QRYSLT('(ACCNTAB/RECI *EQ "D" *AND +
                          ACCNTAB/ATYP *EQ "R" *AND CALC *GT +
                          ACCNTAB/LACD *AND CALC *GT ACCNTAB/DACO ) +
                          *AND (ACCNTAB/RETB *EQ %RANGE(X"00" +
                          X"07") *OR ACCNTAB/RETB *EQ  %RANGE(X"10" +
                          X"17") *OR ACCNTAB/RETB *EQ  %RANGE(X"20" +
                          X"27") *OR ACCNTAB/RETB *EQ  %RANGE(X"30" +
                          X"37") *OR ACCNTAB/RETB *EQ  %RANGE(X"40" +
                          X"47") *OR ACCNTAB/RETB *EQ  %RANGE(X"50" +
                          X"57") *OR ACCNTAB/RETB *EQ  %RANGE(X"60" +
                          X"67") *OR ACCNTAB/RETB *EQ  %RANGE(X"70" +
                          X"77") *OR ACCNTAB/RETB *EQ  %RANGE(X"80" +
                          X"87") *OR ACCNTAB/RETB *EQ  %RANGE(X"90" +
                          X"97") *OR ACCNTAB/RETB *EQ  %RANGE(X"A0" +
                          X"A7") *OR ACCNTAB/RETB *EQ  %RANGE(X"B0" +
                          X"B7") *OR ACCNTAB/RETB *EQ  %RANGE(X"C0" +
                          X"C7") *OR ACCNTAB/RETB *EQ  %RANGE(X"D0" +
                          X"D7") *OR ACCNTAB/RETB *EQ  %RANGE(X"E0" +
                          X"E7") *OR ACCNTAB/RETB *EQ  %RANGE(X"F0" +
                          X"F7"))') KEYFLD((ACCNTAB/BRCA) +
                          (CLINTCB/ACOC) (ACCNTAB/CCY) +
                          (ACCNTAB/CNUM) (ACCNTAB/CCY) +
                          (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +
                          CLINTCB/CNUM)) MAPFLD((RECI +
                          'ACCNTAB/RECI') (BRCA 'ACCNTAB/BRCA') +
                          (ACOC 'CLINTCB/ACOC') (CNUM +
                          'ACCNTAB/CNUM') (CCY 'ACCNTAB/CCY') (ACOD +
                          'ACCNTAB/ACOD') (ACSQ 'ACCNTAB/ACSQ') +
                          (ACNO 'ACCNTAB/ACNO') (CRNM +
                          'CLINTCB/CRNM') (GRBL 'ACCNTAB/LDBL') +
                          (NETB 'ACCNTAB/CLBL') (LACD +
                          'ACCNTAB/LACD') (ZZ002 'ACCNTAB/ZZ002') +
                          (CALC 'SDBANKPD/BJRDNB - SDRETLPD/BMNDBI' +
                          *CALC)) IGNDECERR(*NO)                     */                 /*CRE083AV*/
/**/
/************CALL       PGM(RE3778) */
             CALL       PGM(RE377801) PARM(&ERROR)                                      /*CRE083AV*/
             IF COND(&ERROR *NE 'Y') THEN(DO)                                           /*CRE083AV*/
             CALL       PGM(RE3778) PARM('     ')
             ENDDO                                                                      /*CRE083AV*/
/**********  CLOF       OPNID(ACCNTAB)                               */                 /*CRE083AV*/
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
/**/
/************   DLTF   FILE(XACCNTAA)                              */ /*101949*/
/************   MONMSG MSGID(CPF0000)                              */ /*101949*/
/************   DLTF   FILE(XACCNTAB)                              */ /*101949*/
/************   MONMSG MSGID(CPF0000)                              */ /*101949*/
/************   DLTF   FILE(XACCNTAC)                              */ /*101949*/
/************   MONMSG MSGID(CPF0000)                              */ /*101949*/
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA     DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
                SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE3778') +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
