/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Account Balances Extract')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC3772 -  RETAIL ACCOUNTS BALANCES EXTRACT                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1097352          Date 02Apr13              */
/*       Prev Amend No. CRE083BW           Date 06Aug12              */
/*                      CRE083AF           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      125874             Date 21May98              */
/*                      S01413             Date 20FEB96              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1097352 - V_REACBLK0 and RETACOQ have diff structure thus */
/*          causing data truncation/misalignment in RE3772 processing*/
/*          Introduced V_REACBLK1 w/ the same structure as RETACOQ.  */
/*       CRE083BW  -  COB Restructure - RE COB Optimisation Phase 1  */
/*       CRE083AF  -  COB Restructure - RE COB Optimisation Phase 1  */
/*       125874  -  Change query file second key field from          */
/*                  customer number for customer report name.        */
/*       S01413  -  Addition of core hook REC377201                  */
/*                  Addition of core hook REC377202                  */
/*       S01413  -  Retail 3 Incorporation                           */
/*                  and changes for Release 10 standards.            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,REC3772004                                          */
             PGM
/*/COPY WNCPYSRC,REC3772005                                          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')  */          /*CRE083AF CRE083BW*/
/*/COPY WNCPYSRC,REC3772003                                          */
/**/
             SNDPGMMSG  MSG('REC3772 - Retail Account Balances +
                          Report') TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
/**/
/**********  OVRDBF     FILE(RETACOQ) TOFILE(ACCNTAB) SHARE(*YES)    */                 /*CRE083AF*/
/**/
/**/
/*/COPY WNCPYSRC,REC3772001                                          */
/**/
/*********** OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(RETACOQ) +    /*125874*/
/***********              QRYSLT('(ACCNTAB/RECI *EQ "D" +                125874*/
/***********              *AND ACCNTAB/ATYP *EQ "R")') +                 125874*/
/***********              KEYFLD((ACCNTAB/BRCA) (ACCNTAB/CNUM) +         125874*/
/***********              (ACCNTAB/CCY) (ACCNTAB/ACOD) +                 125874*/
/***********              (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +           125874*/
/***********              CLINTCB/CNUM)) JDFTVAL(*YES) +                 125874*/
/***********              MAPFLD((RECI 'ACCNTAB/RECI') +                 125874*/
/***********              (BRCA 'ACCNTAB/BRCA') (ATYP 'ACCNTAB/ATYP') +  125874*/
/***********              (STYP 'ACCNTAB/STYP') (CNUM 'ACCNTAB/CNUM') +  125874*/
/***********              (CCY 'ACCNTAB/CCY') (ACOD 'ACCNTAB/ACOD') +    125874*/
/***********              (ACSQ 'ACCNTAB/ACSQ') (ACNO 'ACCNTAB/ACNO') +  125874*/
/***********              (CASK 'CLINTCB/CASK') (CRNM 'CLINTCB/CRNM') +  125874*/
/***********              (ACOC 'CLINTCB/ACOC') (EFAC 'ACCNTAB/EFAC') +  125874*/
/***********              (RETB 'ACCNTAB/RETB') (LRCR 'ACCNTAB/LRCR') +  125874*/
/***********              (GRBL 'ACCNTAB/LDBL') (NETBL 'ACCNTAB/CLBL') + 125874*/
/***********              (HELD 'ACCNTAB/HELD') (MINB 'ACCNTAB/MINB') +  125874*/
/***********              (ODLN 'ACCNTAB/ODLN') (ODED 'ACCNTAB/ODED') +  125874*/
/***********              (DLIM 'ACCNTAB/DLIM') (EPGB 'ACCNTAB/EPLB') +  125874*/
/***********              (EPNB 'ACCNTAB/EPCB') (RTLB 'ACCNTAB/RTLB') +  125874*/
/***********              (RTCB 'ACCNTAB/RTCB') (STFQ 'ACCNTAB/STFQ') +  125874*/
/***********              (DACO 'ACCNTAB/DACO')) +                       125874*/
/***********              IGNDECERR(*YES)                                125874*/
/*********** OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(RETACOQ) +                     /*CRE083AF*/
/***********              QRYSLT('(ACCNTAB/RECI *EQ "D" +                               /*CRE083AF*/
/***********              *AND ACCNTAB/ATYP *EQ "R")') +                                /*CRE083AF*/
/***********              KEYFLD((ACCNTAB/BRCA) (CLINTCB/CRNM) +                        /*CRE083AF*/
/***********              (ACCNTAB/CCY) (ACCNTAB/ACOD) +                                /*CRE083AF*/
/***********              (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +                          /*CRE083AF*/
/***********              CLINTCB/CNUM)) JDFTVAL(*YES) +                                /*CRE083AF*/
/***********              MAPFLD((RECI 'ACCNTAB/RECI') +                                /*CRE083AF*/
/***********              (BRCA 'ACCNTAB/BRCA') (ATYP 'ACCNTAB/ATYP') +                 /*CRE083AF*/
/***********              (STYP 'ACCNTAB/STYP') (CNUM 'ACCNTAB/CNUM') +                 /*CRE083AF*/
/***********              (CCY 'ACCNTAB/CCY') (ACOD 'ACCNTAB/ACOD') +                   /*CRE083AF*/
/***********              (ACSQ 'ACCNTAB/ACSQ') (ACNO 'ACCNTAB/ACNO') +                 /*CRE083AF*/
/***********              (CASK 'CLINTCB/CASK') (CRNM 'CLINTCB/CRNM') +                 /*CRE083AF*/
/***********              (ACOC 'CLINTCB/ACOC') (EFAC 'ACCNTAB/EFAC') +                 /*CRE083AF*/
/***********              (RETB 'ACCNTAB/RETB') (LRCR 'ACCNTAB/LRCR') +                 /*CRE083AF*/
/***********              (GRBL 'ACCNTAB/LDBL') (NETBL 'ACCNTAB/CLBL') +                /*CRE083AF*/
/***********              (HELD 'ACCNTAB/HELD') (MINB 'ACCNTAB/MINB') +                 /*CRE083AF*/
/***********              (ODLN 'ACCNTAB/ODLN') (ODED 'ACCNTAB/ODED') +                 /*CRE083AF*/
/***********              (DLIM 'ACCNTAB/DLIM') (EPGB 'ACCNTAB/EPLB') +                 /*CRE083AF*/
/***********              (EPNB 'ACCNTAB/EPCB') (RTLB 'ACCNTAB/RTLB') +                 /*CRE083AF*/
/***********              (RTCB 'ACCNTAB/RTCB') (STFQ 'ACCNTAB/STFQ') +                 /*CRE083AF*/
/***********              (DACO 'ACCNTAB/DACO')) +                                      /*CRE083AF*/
/***********              IGNDECERR(*YES)                                    /*125874*/ /*CRE083AF*/
             CLRPFM     FILE(RETACRE)                                                   /*CRE083AF*/
                                                                                        /*CRE083AF*/
/**********  CALL       PGM(RE003773) PARM(&PRTCD)                 */          /*CRE083AF CRE083BW*/
/**********  IF         COND(&PRTCD *EQ ' ') THEN(DO)              */          /*CRE083AF CRE083BW*/
                                                                                        /*CRE083BW*/
/**********  SCRUNSQL   SQL('declare global temporary table RETACREF +  */             /*AR1097352*/
/**********               as (select * from V_REACBLK0 order by +       */             /*AR1097352*/
/**********               BRCA, CNUM, CCY, ACOD, ACSQ) with data')      */             /*AR1097352*/
             SCRUNSQL   SQL('declare global temporary table RETACREF +
                          as (select * from V_REACBLK1 order by +
                          BRCA, CNUM, CCY, ACOD, ACSQ) with data')                     /*AR1097352*/
                                                                                        /*CRE083BW*/
                                                                                        /*CRE083BW*/
             OVRDBF     FILE(RETACOQ) TOFILE(RETACREF) +
                          NBRRCDS(20000) LVLCHK(*NO) SEQONLY(*YES +
                          20000)                                                        /*CRE083BW*/
/**/
/*/COPY WNCPYSRC,REC3772002                                          */
/**/
/**/
             CALL       PGM(RE3772)
/*/COPY WNCPYSRC,REC3772006                                          */
/**********  DLTOVR     FILE(*ALL)                                   */                 /*CRE083AF*/
/**********  CLOF       OPNID(ACCNTAB)                               */                 /*CRE083AF*/
/**********  ENDDO                                                 */          /*CRE083AF CRE083BW*/
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE3772') +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
