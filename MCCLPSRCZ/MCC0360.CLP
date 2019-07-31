/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Extract Management A/c Balances')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0360 - Extract Management FX & In/Ex A/c Balances        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG7549            Date 11May05              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      133360             Date 12Feb98              */
/*                      CMC001 *CREATE     Date 18Mar96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      BUG7549- Spt revals not created when PCA is on               */
/*      CGL029 - Increase Account Code to 10 digits                  */
/*      133360 - Change OPNQRYF to include zero balance records.     */
/*               If not included spot revaluations can be wrong.     */
/*      CMC001 - Management Accounts Enhancement for PCA:            */
/*               Created for PCA.                                    */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) /*        +
                          Return Code */
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7) /*        +
                          Period Set */
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(7) /*        +
                          Posting Basis */
 /*          DCL        VAR(&SPAC) TYPE(*CHAR) LEN(4) VALUE('0000')  */                  /*BUG7549*/
             DCL        VAR(&SPAC) TYPE(*CHAR) LEN(10) VALUE('0000000000')               /*BUG7549*/
                          /* Spot Trade Account code */
             DCL        VAR(&PGCD) TYPE(*CHAR) LEN(4) /*        +
                          Primary Control Group code */
             DCL        VAR(&PDCT) TYPE(*CHAR) LEN(2) /*        +
                          Period Century */
             DCL        VAR(&PDYR) TYPE(*CHAR) LEN(2) /*        +
                          Period Year */
             DCL        VAR(&PDNY) TYPE(*CHAR) LEN(2) /*        +
                          Period Number within Year */
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(5) /*        +
                          Diary Event Date */
             DCL        VAR(&PSTD) TYPE(*CHAR) LEN(5) /*        +
                          Posting Date */
             DCL        VAR(&FTFR) TYPE(*CHAR) LEN(1) /*        +
                          FX Transfer Date? */
             DCL        VAR(&BTFR) TYPE(*CHAR) LEN(1) /*        +
                          Base Ccy Transfer Date? */
             DCL        VAR(&SRVL) TYPE(*CHAR) LEN(1) /*        +
                          Spot Revaluation Date? */
             DCL        VAR(&IN) TYPE(*CHAR) LEN(2) VALUE('**') /* +
                          A/c Section Income Literal */
             DCL        VAR(&EX) TYPE(*CHAR) LEN(2) VALUE('**') /* +
                          A/c Section Expense Literal */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
             DCL        VAR(&BCCY) TYPE(*CHAR) LEN(3) VALUE('   ') +
                          /* Base ccy */
             DCLF       FILE(SDBANKPD) /* Bank ICD */
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/                                                                  /*EE9201*/
             SNDPGMMSG  MSG('MCC0360 - Extract Management A/c +
                          Balances') TOMSGQ(MRUNQ)                    /*ER9201*/
/**/                                                                  /*ER9201*/
             CHGJOB     SWS(XXXXXX00)
             CLRPFM     FILE(MCBLEXPD)
/**/
/* Access Last Diary Event to check for Transfer Date */
/**/
             CALL       PGM(AODIRYR0) PARM(&RTCD '*LAST' ' '  +
                          &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&DEVD) VALUE(%SST(&DSFDY 1 5))
             CHGVAR     VAR(&FTFR) VALUE(%SST(&DSFDY 8 1))
             CHGVAR     VAR(&BTFR) VALUE(%SST(&DSFDY 9 1))
             CHGVAR     VAR(&SRVL) VALUE(%SST(&DSFDY 10 1))
/**/
/* If No Transfer today Terminate Program */
/**/
             IF         COND(&FTFR *NE 'Y' *AND &BTFR *NE 'Y' *AND +
                          &SRVL *NE 'Y') THEN(GOTO CMDLBL(END))
/**/
/* Access Bank ICD for Base Currency & Run Date */
/**/
             RCVF
             CHGVAR     VAR(&PSTD) VALUE(&BJRDNB)
/**/
/* Set Extract paramters  */
/**/
             IF         COND(&BTFR *NE 'Y') +
                          THEN(CHGVAR VAR(&BCCY) VALUE(&BJCYCD))
/*/COPY WNCPYSRC,MCC0360001                                          */
 
             IF         COND(&BTFR *EQ 'Y' *OR &FTFR *EQ 'Y') THEN(DO)
                 CHGVAR VAR(&IN) VALUE('IN')
                 CHGVAR VAR(&EX) VALUE('EX')
             ENDDO
 
             IF         COND(&SRVL *EQ 'Y') THEN(DO)
/**/
/* Access Trading ICD for spot trade a/c Code */
/**/
                 CALL       PGM(AOTRADR0) PARM(&RTCD '*FIRST' &DSFDY)
                 IF         COND(&RTCD *NE '       ') +
                               THEN(GOTO CMDLBL(ABNOR))
 /*              CHGVAR     VAR(&SPAC) VALUE(%SST(&DSFDY 19 4)) */                       /*BUG7549*/
                 CHGVAR     VAR(&SPAC) VALUE(%SST(&DSFDY 74 10))                         /*BUG7549*/
 
             ENDDO
/**/
/**  Access PCA ICD for Primary Mgmt A/C Control Group               */
/**/
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PGCD) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Access Primary Control Group for Period Set & Posting Basis     */
/**/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PGCD &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CHGVAR     VAR(&PBAS) VALUE(%SST(&DSFDY 34 1))
 
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR VAR(&DEVD) +
                          VALUE(&PSTD))
/**/
/**  Access Current Period Century, Year and Number                  */
/**/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PKEY 0 &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))
             CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))
 
/* Set up OPNQRYF to extract balances */
 
/*           OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCBLEXPD) +     133360 */
/*                        QRYSLT('(HBPDCT *EQ ''' *CAT &PDCT *CAT +   133360 */
/*                        ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +   133360 */
/*                        ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +   133360 */
/*                        ''' *AND HBPDCB *NE 0) *AND ((HBACCD *EQ +  133360 */
/*                        ''' *CAT &SPAC *CAT ''') *OR ((HBACSC *EQ + 133360 */
/*                        ''' *CAT &IN *CAT '''  *OR  HBACSC *EQ +    133360 */
/*                        ''' *CAT &EX *CAT ''') *AND HBCYCD *NE +    133360 */
/*                        ''' *CAT &BCCY *CAT '''))') MAPFLD((BRCA +  133360 */
/*                        HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM +  133360 */
/*                        HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC + 133360 */
/*                        HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC + 133360 */
/*                        HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN + 133360 */
/*                        0) (GETP ''' ''') (ATYP ''' ''') (CPNB +    133360 */
/*                        (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +      133360 */
/*                        &DEVD) (PDTM (&PSTD *CAT '235959')) +       133360 */
/*                        (PNAR ''' '''))                             133360 */
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCBLEXPD) +    */                   /*CGL029*/
/**********               QRYSLT('(HBPDCT *EQ ''' *CAT &PDCT *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +  */                   /*CGL029*/
/**********               ''' ) *AND ((HBACCD *EQ +                  */                   /*CGL029*/
/**********               ''' *CAT &SPAC *CAT ''') *OR ((HBACSC *EQ +*/                   /*CGL029*/
/**********               ''' *CAT &IN *CAT '''  *OR  HBACSC *EQ +   */                   /*CGL029*/
/**********               ''' *CAT &EX *CAT ''') *AND HBCYCD *NE +   */                   /*CGL029*/
/**********               ''' *CAT &BCCY *CAT '''))') MAPFLD((BRCA + */                   /*CGL029*/
/**********               HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM + */                   /*CGL029*/
/**********               HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +*/                   /*CGL029*/
/**********               HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +*/                   /*CGL029*/
/**********               HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN +*/                   /*CGL029*/
/**********               0) (GETP ''' ''') (ATYP ''' ''') (CPNB +   */                   /*CGL029*/
/**********               (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +     */                   /*CGL029*/
/**********               &DEVD) (PDTM (&PSTD *CAT '235959')) +      */                   /*CGL029*/
/**********               (PNAR ''' '''))                            */          /* 133360  CGL029*/
             OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCBLEXPD) +
                          QRYSLT('(HBPDCT *EQ ''' *CAT &PDCT *CAT +
                          ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +
                          ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +
                          ''' ) *AND ((HBACCD *EQ +
                          ''' *CAT &SPAC *CAT ''') *OR ((HBACSC *EQ +
                          ''' *CAT &IN *CAT '''  *OR  HBACSC *EQ +
                          ''' *CAT &EX *CAT ''') *AND HBCYCD *NE +
                          ''' *CAT &BCCY *CAT '''))') MAPFLD((BRCA +
                          HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM +
                          HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +
                          HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +
                          HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN +
                          0) (ACODQQ 0) (GETP ''' ''')         +
                          (ATYP ''' ''') (CPNB +
                          (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +
                          &DEVD) (PDTM (&PSTD *CAT '235959')) +
                          (PNAR ''' '''))                                               /* CGL029 */
/**/
/*  Copy OPNQRYF to MCBLEXPD  */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCBLEXPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
/* Set up OPNQRYF to Base Currency Equivalent balances */
/* If Spot Revaluation required                        */
/**/
             IF         COND(&SRVL *EQ 'Y') THEN(DO)
/**/
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
/**/
/*           OPNQRYF    FILE((GLHIBLPD &PGCD) (SDCURRPD)) +            133360 */
/*                        FORMAT(MCBLEXPD) QRYSLT('(HBPDCT *EQ ''' +   133360 */
/*                        *CAT &PDCT *CAT ''' *AND HBPDYR *EQ ''' +    133360 */
/*                        *CAT &PDYR *CAT ''' *AND HBPDNY *EQ ''' +    133360 */
/*                        *CAT &PDNY *CAT ''' *AND HBPDCB *NE 0 +      133360 */
/*                        *AND HBCYCD *EQ ''' *CAT &BJCYCD *CAT +      133360 */
/*                        ''')') JFLD((HBACCD A6SPAE)) MAPFLD((BRCA +  133360 */
/*                        HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM +   133360 */
/*                        HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +  133360 */
/*                        HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +  133360 */
/*                        HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN +  133360 */
/*                        0) (GETP ''' ''') (ATYP ''' ''') (CPNB +     133360 */
/*                        (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +       133360 */
/*                        &DEVD) (PDTM (&PSTD *CAT '235959')) (PNAR +  133360 */
/*                        ''' '''))                                    133360 */
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD) (SDCURRPD)) +          */                   /*CGL029*/
/**********               FORMAT(MCBLEXPD) QRYSLT('(HBPDCT *EQ ''' + */                   /*CGL029*/
/**********               *CAT &PDCT *CAT ''' *AND HBPDYR *EQ ''' +  */                   /*CGL029*/
/**********               *CAT &PDYR *CAT ''' *AND HBPDNY *EQ ''' +  */                   /*CGL029*/
/**********               *CAT &PDNY *CAT ''' +                      */                   /*CGL029*/
/**********               *AND HBCYCD *EQ ''' *CAT &BJCYCD *CAT +    */                   /*CGL029*/
/**********               ''')') JFLD((HBACCD A6SPAE)) MAPFLD((BRCA +*/                   /*CGL029*/
/**********               HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM + */                   /*CGL029*/
/**********               HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +*/                   /*CGL029*/
/**********               HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +*/                   /*CGL029*/
/**********               HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN +*/                   /*CGL029*/
/**********               0) (GETP ''' ''') (ATYP ''' ''') (CPNB +   */                   /*CGL029*/
/**********               (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +     */                   /*CGL029*/
/**********               &DEVD) (PDTM (&PSTD *CAT '235959')) (PNAR +*/                   /*CGL029*/
/**********               ''' '''))                                  */          /* 133360  CGL029*/
             OPNQRYF    FILE((GLHIBLPD &PGCD) (SDCURRPD)) +
                          FORMAT(MCBLEXPD) QRYSLT('(HBPDCT *EQ ''' +
                          *CAT &PDCT *CAT ''' *AND HBPDYR *EQ ''' +
                          *CAT &PDYR *CAT ''' *AND HBPDNY *EQ ''' +
                          *CAT &PDNY *CAT ''' +
                          *AND HBCYCD *EQ ''' *CAT &BJCYCD *CAT +
                          ''')') JFLD((HBACCD A6SPAE)) MAPFLD((BRCA +
                          HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM +
                          HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +
                          HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +
                          HBACNB) (ACSC HBACSC) (PAMT HBPDCB) (VOIN +
                          0) (ACODQQ 0) (GETP ''' ''') +
                          (ATYP ''' ''') (CPNB +
                          (&PDCT *CAT &PDYR *CAT &PDNY)) (EVDT +
                          &DEVD) (PDTM (&PSTD *CAT '235959')) (PNAR +
                          ''' '''))                                                     /* CGL029 */
/**/
/*  Copy OPNQRYF to MCBLEXPD for Base Ccy Eqivalent Accounts */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCBLEXPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination Processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Program MCC0360 ended abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
