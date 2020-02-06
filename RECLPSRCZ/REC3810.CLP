/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE History reconciliation report')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                                   */
/*                                                                   */
/*       REC3810 - A/C BAL. & HISTORY BAL. RECONCILIATION REPORT     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083BG           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      TDA103             Date 31Mar03              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      167673             Date 11Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      121058             Date 09FEB98              */
/*                      CRE003             DATE 22APR96              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083BG - COB Restructure - RE COB Optimisation Phase 1    */
/*       TDA103 - Renamed incorrect OPNQRYF parameter ZACDQQ         */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       167673 - Change OPNQRYF parameter from JDFTVAL(*ONLYDFT) to */
/*                JDFTVAL(*YES), else records may be omitted under   */
/*                some circumstances.                                */
/*       121058 - Retail Statement Charges Fix                       */
/*       CRE003 - Ledger Balance Accruals                            */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/************PGM                                                        CRE003*/
             PGM        PARM(&PCNAME &PCSEQ)                          /*CRE003*/
/**/                                                                  /*CRE003*/
             DCL        VAR(&WMSGMBR) TYPE(*CHAR) LEN(50)             /*CRE003*/
             DCL        VAR(&WTOLIB) TYPE(*CHAR) LEN(10)              /*CRE003*/
             DCL        VAR(&WPREFIX) TYPE(*CHAR) LEN(2)              /*CRE003*/
             DCL        VAR(&WLDA) TYPE(*CHAR) LEN(256)               /*CRE003*/
             DCL        VAR(&WSDSTAT) TYPE(*CHAR) LEN(256)            /*CRE003*/
             DCL        VAR(&PCNAME) TYPE(*CHAR) LEN(10)              /*CRE003*/
/**********  DCL        VAR(&PCSEQ) TYPE(*CHAR) LEN(5)               */      /*CRE003*/ /*CRE083BG*/
             DCL        VAR(&PCSEQ) TYPE(*DEC) LEN(5 0)                                 /*CRE083BG*/
             DCL        VAR(&WCSTAT) TYPE(*CHAR) LEN(1)               /*CRE003*/
                                                                                        /*CRE083BG*/
/* Journalling variables */                                                             /*CRE083BG*/
                                                                                        /*CRE083BG*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083BG*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083BG*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083BG*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083BG*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083BG*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083BG*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083BG*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083BG*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083BG*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083BG*/
                                                                                        /*CRE083BG*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SDRETLPD)                                /*CRE003*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(DBERR))       /*CRE003*/
/**/
             SNDPGMMSG MSG('REC3810 - A/C Balance & History Balance +
                   Reconciliation Report') TOMSGQ(MRUNQ)
                                                                                        /*CRE083BG*/
/* Start Journalling */                                                                 /*CRE083BG*/
                                                                                        /*CRE083BG*/
             CHGVAR     VAR(&CSEQA) VALUE(&PCSEQ)                                       /*CRE083BG*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &PCNAME +
                           *CAT &CSEQA)                                                 /*CRE083BG*/
             CHGVAR     VAR(&SEVENT) VALUE(&PCNAME *TCAT &CSEQA)                        /*CRE083BG*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&PCNAME) CMPSEQ(&PCSEQ) +
                           FLAG('S') TEXT(&STEXT)                                       /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Set Switches */                                                    /*CRE003*/
             CHGJOB     SWS(00000000)                                 /*CRE003*/
             RCVF       RCDFMT(SDRETLD0)                              /*CRE003*/
/**/                                                                  /*121058*/
/*  Call RE3809 if system is on Ledger Balance Accruals even if */    /*121058*/
/*  Last Day Accruals indicator is 'Y'                          */    /*121058*/
/**/                                                                  /*121058*/
/*********** IF         COND(&BMCBAI *NE 'Y' *AND &BMLDAI *NE 'Y') +
/***********   THEN(DO)     */                                 /*CRE003 121058*/
/**/                                                                  /*121058*/
             IF         COND(&BMCBAI *NE 'Y') THEN(DO)                /*121058*/
                 CALL       PGM(CB0160) PARM(&PCNAME &PCSEQ &WCSTAT)  /*CRE003*/
                 RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&WSDSTAT)           /*CRE003*/
                 CHGVAR     VAR(&WPREFIX) VALUE(%SST(&WSDSTAT 6 2))   /*CRE003*/
                 CHGVAR     VAR(&WTOLIB) VALUE(&WPREFIX *CAT 'DPLIB') /*CRE003*/
             IF         COND(&WCSTAT = 'N') +
             THEN(DO)                                                 /*CRE003*/
/**********      DLTF       FILE(XREACRD)                             */     /*CRE003*/ /*CRE083BG*/
/**********      MONMSG     MSGID(CPF0000)                            */     /*CRE003*/ /*CRE083BG*/
/**********      CPYF       FROMFILE(REACRD) TOFILE(&WTOLIB/XREACRD) + */               /*CRE083BG*/
/**********                  MBROPT(*REPLACE) CRTFILE(*YES)           */     /*CRE003*/ /*CRE083BG*/
/**********      MONMSG     MSGID(CPF2869) */ /* file empty */               /*CRE003*/ /*CRE083BG*/
                 CHGVAR     VAR(&WCSTAT) VALUE('Y')                   /*CRE003*/
                 CALL       PGM(CB0150) PARM(&PCNAME &PCSEQ &WCSTAT)  /*CRE003*/
             ENDDO                                                    /*CRE003*/
             ELSE       CMD(DO)                                       /*CRE003*/
                 CPYF       FROMFILE(XREACRD) TOFILE(REACRD) +
                             MBROPT(*REPLACE)                         /*CRE003*/
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM FILE(REACRD))                /*CRE003*/
                                                                                        /*CRE083BG*/
/* Begin recovery if Restarted */                                                       /*CRE083BG*/
/* Retrieve attributes of current job */                                                /*CRE083BG*/
                                                                                        /*CRE083BG*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Retrieve the most recent journal entry sequence number for the */                    /*CRE083BG*/
/* specific job. */                                                                     /*CRE083BG*/
                                                                                        /*CRE083BG*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                           TOENT(*FIRST) SEARCH(*DESCEND) +
                           JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                           RTNRCV(&SJRNRCVR)                                            /*CRE083BG*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CRE083BG*/
                  CHGVAR     VAR(&START) VALUE(0)                                       /*CRE083BG*/
             ENDDO                                                                      /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Determine starting journal sequence number of current job. */                        /*CRE083BG*/
                                                                                        /*CRE083BG*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Remove journal changes. */                                                           /*CRE083BG*/
                                                                                        /*CRE083BG*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                           THEN(DO)                                                     /*CRE083BG*/
                  RMVJRNCHG  JRN(ICJRN) FILE(REACRD)  +
                                FROMENT(&START) TOENT(&FINISH) +
                                RCVRNG(&SJRNRCVR &FJRNRCVR)                             /*CRE083BG*/
                  MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                     /*CRE083BG*/
             ENDDO                                                                      /*CRE083BG*/
                                                                                        /*CRE083BG*/
             ENDDO                                                    /*CRE003*/
/**/                                                                  /*121058*/
/*  If type of run is 'Accrual Day followed by a Non-Working Day', */ /*121058*/
/*  override GESFPD file to GESF2PD                                */ /*121058*/
/**/                                                                  /*121058*/
             IF         COND(%SST(&WSDSTAT 116 1) *EQ '3') +
                          THEN(OVRDBF FILE(GESFPD) TOFILE(GESF2PD))   /*121058*/
/**/                                                                  /*121058*/
             CALL       PGM(RE3809)                                   /*CRE003*/
/**/                                                                  /*121058*/
             DLTOVR     FILE(GESFPD)                                  /*121058*/
             MONMSG     MSGID(CPF0000)                                /*121058*/
/**/                                                                  /*121058*/
             IF         COND(%SWITCH(XXXXXX11)) +
             THEN(DO)                                                 /*CRE003*/
               RTVDTAARA  DTAARA(*LDA) RTNVAR(&WLDA)                  /*CRE003*/
               CHGVAR     VAR(&WMSGMBR) VALUE(%SST(&WLDA 134 50))     /*CRE003*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          /*CRE003*/
               GOTO       CMDLBL(FINISH)                              /*CRE003*/
             ENDDO                                                    /*CRE003*/
             ENDDO                                                    /*CRE003*/
/**/
/**********  OVRDBF     REACCNJL REACRD SHARE(*YES)  */                                 /*CRE083BG*/
/**/                                                                  /*CRE003*/
/**********  IF         COND(&BMCBAI *NE 'Y') +                */                       /*CRE083BG*/
/**********  THEN(DO)                                          */            /*CRE003*/ /*CRE083BG*/
/**********                                                          */        /*CRE003*/ /*CGL029*/
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +  */        /*CRE003*/ /*CGL029*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +            */        /*CRE003*/ /*CGL029*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +   */        /*CRE003*/ /*CGL029*/
/**********               (ZASEQ)) JFLD((ACCNTAB/BRCA +              */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZBRCA) (ACCNTAB/CNUM +             */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZCUST) (ACCNTAB/CCY +              */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZACCY) (ACCNTAB/ACOD +             */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZACOD) (ACCNTAB/ACSQ +             */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZASEQ) (ACCNTAB/LDBL +             */        /*CRE003*/ /*CGL029*/
/**********               *MAPFLD/ZLDBL)) JDFTVAL(*ONLYDFT) +        */        /*CRE003*/ /*CGL029*/
/**********               MAPFLD((ZLDBL '1/HISB - 1/GADI + 1/GACI' + */        /*CRE003*/ /*CGL029*/
/**********               *DEC 15 0) (ZBRCA '1/BRCA') (ZCUST +       */        /*CRE003*/ /*CGL029*/
/**********               '1/CUST') (ZACCY '1/ACCY') (ZACOD +        */        /*CRE003*/ /*CGL029*/
/**********               '1/ACOD') (ZASEQ '1/ASEQ') (ZHISB +        */        /*CRE003*/ /*CGL029*/
/**********               '1/HISB') (ZGADI '1/GADI') (ZGACI +        */        /*CRE003*/ /*CGL029*/
/**********               '1/GACI')) IGNDECERR(*YES)                 */        /*CRE003*/ /*CGL029*/
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +                       /*TDA103*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +                                 /*TDA103*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +                        /*TDA103*/
/**********               (ZASEQ)) JFLD((ACCNTAB/BRCA +                                   /*TDA103*/
/**********               *MAPFLD/ZBRCA) (ACCNTAB/CNUM +                                  /*TDA103*/
/**********               *MAPFLD/ZCUST) (ACCNTAB/CCY +                                   /*TDA103*/
/**********               *MAPFLD/ZACCY) (ACCNTAB/ACOD +                                  /*TDA103*/
/**********               *MAPFLD/ZACOD) (ACCNTAB/ACSQ +                                  /*TDA103*/
/**********               *MAPFLD/ZASEQ) (ACCNTAB/LDBL +                                  /*TDA103*/
/**********               *MAPFLD/ZLDBL) (ACCNTAB/ACODQQ +                                /*TDA103*/
/**********               *MAPFLD/ZACDQQ)) JDFTVAL(*ONLYDFT) +       */                   /*TDA103*/
/**********               MAPFLD((ZLDBL '1/HISB - 1/GADI + 1/GACI' +                      /*TDA103*/
/**********               *DEC 15 0) (ZBRCA '1/BRCA') (ZCUST +                            /*TDA103*/
/**********               '1/CUST') (ZACCY '1/ACCY') (ZACOD +                             /*TDA103*/
/**********               '1/ACOD') (ZASEQ '1/ASEQ') (ZHISB +                             /*TDA103*/
/**********               '1/HISB') (ZGADI '1/GADI') (ZGACI +                             /*TDA103*/
/**********               '1/GACI') (ZACDQQ '1/ACODQQ')) +                                /*TDA103*/
/**********               IGNDECERR(*YES)                                      /*CGL029*/ /*TDA103*/
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) + */                  /*CRE083BG*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +           */                  /*CRE083BG*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +  */                  /*CRE083BG*/
/**********               (ZASEQ)) JFLD((ACCNTAB/BRCA +             */                  /*CRE083BG*/
/**********               *MAPFLD/ZBRCA) (ACCNTAB/CNUM +            */                  /*CRE083BG*/
/**********               *MAPFLD/ZCUST) (ACCNTAB/CCY +             */                  /*CRE083BG*/
/**********               *MAPFLD/ZACCY) (ACCNTAB/ACOD +            */                  /*CRE083BG*/
/**********               *MAPFLD/ZACOD) (ACCNTAB/ACSQ +            */                  /*CRE083BG*/
/**********               *MAPFLD/ZASEQ) (ACCNTAB/LDBL +            */                  /*CRE083BG*/
/**********               *MAPFLD/ZLDBL) (ACCNTAB/ACODQQ +          */                  /*CRE083BG*/
/**********               *MAPFLD/ZACOQQ)) JDFTVAL(*ONLYDFT) +       */                 /*CRE083BG*/
/**********               MAPFLD((ZLDBL '1/HISB - 1/GADI + 1/GACI' + */                 /*CRE083BG*/
/**********               *DEC 15 0) (ZBRCA '1/BRCA') (ZCUST +      */                  /*CRE083BG*/
/**********               '1/CUST') (ZACCY '1/ACCY') (ZACOD +    */                     /*CRE083BG*/
/**********               '1/ACOD') (ZASEQ '1/ASEQ') (ZHISB +    */                     /*CRE083BG*/
/**********               '1/HISB') (ZGADI '1/GADI') (ZGACI +    */                     /*CRE083BG*/
/**********               '1/GACI') (ZACOQQ '1/ACODQQ')) +       */                     /*CRE083BG*/
/**********               IGNDECERR(*YES)                        */          /*TDA103*/ /*CRE083BG*/
/**********  ENDDO                                               */          /*CRE003*/ /*CRE083BG*/
/**/                                                                  /*CRE003*/
/**********  IF         COND(&BMCBAI *EQ 'Y') +                  */                     /*CRE083BG*/
/**********  THEN(DO)                                            */          /*CRE003*/ /*CRE083BG*/
/*********** OPNQRYF    FILE((REACRD) (ACCNTAB)) +                     *CRE003*/
/***********              FORMAT(REACCNJL) KEYFLD((ZBRCA) +            *CRE003*/
/***********              (ZCUST) (ZACCY) +                            *CRE003*/
/***********              (ZACOD) (ZASEQ)) +                           *CRE003*/
/***********              QRYSLT('REACRD/RECI *EQ "D"') +              *CRE003*/
/***********              JFLD((*MAPFLD/HSGA ACCNTAB/CLBL)) +          *CRE003*/
/***********              JDFTVAL(*ONLYDFT) MAPFLD((HSGA '1/HISB - +   *CRE003*/
/***********             1/GADI + 1/GACI' *DEC 15 0) (ZBRCA '1/BRCA') +*CRE003*/
/***********              (ZCUST '1/CUST') (ZACCY '1/ACCY') +          *CRE003*/
/***********              (ZACOD '1/ACOD') (ZASEQ '1/ASEQ') +          *CRE003*/
/***********              (ZHISB '1/HISB') (ZGADI '1/GADI') +          *CRE003*/
/***********              (ZGACI '1/GACI')) IGNDECERR(*YES)            *CRE003*/
/*********** OPNQRYF    FILE((REACRD)Y(ACCNTAB)) FORMAT(REACCNJL) +    *167673*/
/***********              QRYSLT('REACRD/RECI *EQ "D"') +              *167673*/
/***********              KEYFLD((ZBRCA))(ZCUST) (ZACCY) (ZACOD) +     *167673*/
/***********              (ZASEQ))RJFLD((*MAPFLD/ZBRCA +               *167673*/
/***********              ACCNTAB/BRCA)S(*MAPFLD/ZCUST +               *167673*/
/***********              ACCNTAB/CNUM)S(*MAPFLD/ZACCY ACCNTAB/CCY) +  *167673*/
/***********              (*MAPFLD/ZACOD)ACCNTAB/ACOD) +               *167673*/
/***********              (*MAPFLD/ZASEQ)ACCNTAB/ACSQ) +               *167673*/
/***********              (*MAPFLD/HSGASACCNTAB/CLBL)) +               *167673*/
/***********              JDFTVAL(*ONLYDFT) MAPFLD((HSGA '1/HISB - +   *167673*/
/***********              1/GADIE+R1/GACI' *DEC 15 0) (ZBRCA +         *167673*/
/***********              '1/BRCA')((ZCUST '1/CUST') (ZACCY +          *167673*/
/***********              '1/ACCY')((ZACOD '1/ACOD') (ZASEQ +          *167673*/
/***********              '1/ASEQ')((ZHISB '1/HISB') (ZGADI +          *167673*/
/***********              '1/GADI')((ZGACI '1/GACI')) +                *167673*/
/***********              IGNDECERR(*YES)                      /*CRE003*167673*/
 
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +  */        /*167673*/ /*CGL029*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +            */        /*167673*/ /*CGL029*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +   */        /*167673*/ /*CGL029*/
/**********               (ZASEQ)) JFLD((*MAPFLD/ZBRCA +             */        /*167673*/ /*CGL029*/
/**********               ACCNTAB/BRCA) (*MAPFLD/ZCUST +             */        /*167673*/ /*CGL029*/
/**********               ACCNTAB/CNUM) (*MAPFLD/ZACCY ACCNTAB/CCY) +*/        /*167673*/ /*CGL029*/
/**********               (*MAPFLD/ZACOD ACCNTAB/ACOD) +             */        /*167673*/ /*CGL029*/
/**********               (*MAPFLD/ZASEQ ACCNTAB/ACSQ) +             */        /*167673*/ /*CGL029*/
/**********               (*MAPFLD/HSGA ACCNTAB/CLBL)) +             */        /*167673*/ /*CGL029*/
/**********               JDFTVAL(*YES) MAPFLD((HSGA '1/HISB - +     */        /*167673*/ /*CGL029*/
/**********               1/GADI + 1/GACI' *DEC 15 0) (ZBRCA +       */        /*167673*/ /*CGL029*/
/**********               '1/BRCA') (ZCUST '1/CUST') (ZACCY +        */        /*167673*/ /*CGL029*/
/**********               '1/ACCY') (ZACOD '1/ACOD') (ZASEQ +        */        /*167673*/ /*CGL029*/
/**********               '1/ASEQ') (ZHISB '1/HISB') (ZGADI +        */        /*167673*/ /*CGL029*/
/**********               '1/GADI') (ZGACI '1/GACI')) +              */        /*167673*/ /*CGL029*/
/**********               IGNDECERR(*YES)                            */        /*167673*/ /*CGL029*/
 
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +                       /*TDA103*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +                                 /*TDA103*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +                        /*TDA103*/
/**********               (ZASEQ)) JFLD((*MAPFLD/ZBRCA +                                  /*TDA103*/
/**********               ACCNTAB/BRCA) (*MAPFLD/ZCUST +                                  /*TDA103*/
/**********               ACCNTAB/CNUM) (*MAPFLD/ZACCY ACCNTAB/CCY) +                     /*TDA103*/
/**********               (*MAPFLD/ZACOD ACCNTAB/ACOD) +                                  /*TDA103*/
/**********               (*MAPFLD/ZASEQ ACCNTAB/ACSQ) +                                  /*TDA103*/
/**********               (*MAPFLD/HSGA ACCNTAB/CLBL)  +                                  /*TDA103*/
/**********               (*MAPFLD/ZACDQQ ACCNTAB/ACODQQ)) +                              /*TDA103*/
/**********               JDFTVAL(*YES) MAPFLD((HSGA '1/HISB - +                          /*TDA103*/
/**********               1/GADI + 1/GACI' *DEC 15 0) (ZBRCA +                            /*TDA103*/
/**********               '1/BRCA') (ZCUST '1/CUST') (ZACCY +                             /*TDA103*/
/**********               '1/ACCY') (ZACOD '1/ACOD') (ZASEQ +                             /*TDA103*/
/**********               '1/ASEQ') (ZHISB '1/HISB') (ZGADI +                             /*TDA103*/
/**********               '1/GADI') (ZGACI '1/GACI') (ZACDQQ +                            /*TDA103*/
/**********               '1/ACODQQ')) +                                                  /*TDA103*/
/**********               IGNDECERR(*YES)                                      /*CGL029*/ /*TDA103*/
/**********  OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) + */                  /*CRE083BG*/
/**********               QRYSLT('REACRD/RECI *EQ "D"') +           */                  /*CRE083BG*/
/**********               KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +  */                  /*CRE083BG*/
/**********               (ZASEQ)) JFLD((*MAPFLD/ZBRCA +            */                  /*CRE083BG*/
/**********               ACCNTAB/BRCA) (*MAPFLD/ZCUST +            */                  /*CRE083BG*/
/**********               ACCNTAB/CNUM) (*MAPFLD/ZACCY ACCNTAB/CCY) + */                /*CRE083BG*/
/**********               (*MAPFLD/ZACOD ACCNTAB/ACOD) +            */                  /*CRE083BG*/
/**********               (*MAPFLD/ZASEQ ACCNTAB/ACSQ) +           */                   /*CRE083BG*/
/**********               (*MAPFLD/HSGA ACCNTAB/CLBL)  +           */                   /*CRE083BG*/
/**********               (*MAPFLD/ZACOQQ ACCNTAB/ACODQQ)) +      */                    /*CRE083BG*/
/**********               JDFTVAL(*YES) MAPFLD((HSGA '1/HISB - +  */                    /*CRE083BG*/
/**********               1/GADI + 1/GACI' *DEC 15 0) (ZBRCA +   */                     /*CRE083BG*/
/**********               '1/BRCA') (ZCUST '1/CUST') (ZACCY +    */                     /*CRE083BG*/
/**********               '1/ACCY') (ZACOD '1/ACOD') (ZASEQ +    */                     /*CRE083BG*/
/**********               '1/ASEQ') (ZHISB '1/HISB') (ZGADI +    */                     /*CRE083BG*/
/**********               '1/GADI') (ZGACI '1/GACI') (ZACOQQ +   */                     /*CRE083BG*/
/**********               '1/ACODQQ')) +                         */                     /*CRE083BG*/
/**********               IGNDECERR(*YES)                        */          /*TDA103*/ /*CRE083BG*/
/**********  ENDDO                                               */          /*CRE003*/ /*CRE083BG*/
/**********  CALL       PGM(RE3810)                              */                     /*CRE083BG*/
/**********  CLOF       OPNID(REACRD)                            */                     /*CRE083BG*/
             GOTO       CMDLBL(FINISH)                                /*CRE003*/
/**/                                                                  /*CRE003*/
 DBERR:      CHGJOB     SWS(00000011)                                 /*CRE003*/
             SNDPGMMSG  MSG('REC3810 - A/c Bal & History Bal +
                          Reconciliation Report ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*CRE003*/
                                                                                        /*CRE083BG*/
/* Begin recovery from error */                                                         /*CRE083BG*/
/* Retrieve attributes of current job */                                                /*CRE083BG*/
                                                                                        /*CRE083BG*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Retrieve the most recent journal entry sequence number for the */                    /*CRE083BG*/
/* specific job. */                                                                     /*CRE083BG*/
                                                                                        /*CRE083BG*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                           TOENT(*FIRST) SEARCH(*DESCEND) +
                           JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                           RTNRCV(&SJRNRCVR)                                            /*CRE083BG*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CRE083BG*/
                  CHGVAR     VAR(&START) VALUE(0)                                       /*CRE083BG*/
             ENDDO                                                                      /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Determine starting journal sequence number of current job. */                        /*CRE083BG*/
                                                                                        /*CRE083BG*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Remove journal changes. */                                                           /*CRE083BG*/
                                                                                        /*CRE083BG*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                           THEN(DO)                                                     /*CRE083BG*/
                  RMVJRNCHG  JRN(ICJRN) FILE(REACRD) +
                                FROMENT(&START) TOENT(&FINISH) +
                                RCVRNG(&SJRNRCVR &FJRNRCVR)                             /*CRE083BG*/
                  MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                     /*CRE083BG*/
             ENDDO                                                                      /*CRE083BG*/
                                                                                        /*CRE083BG*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083BG*/
                                                                                        /*CRE083BG*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CRE083BG*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &PCNAME +
                          *CAT &CSEQA)                                                  /*CRE083BG*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&PCNAME) CMPSEQ(&PCSEQ) +
                           FLAG('E') TEXT(&STEXT)                                       /*CRE083BG*/
                                                                                        /*CRE083BG*/
 FINISH:                                                              /*CRE003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
