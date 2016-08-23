/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Opening Balance Maintenance Ctl')            */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0225 - Opening Balance Maintenance Control                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG12454           Date 06Nov06              */
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      067849             Date 07Mar94              */
/*                      048237             Date 09Dec92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG12454 - Changed OPNQRYF statements for alpha customer    */
/*                  number                                           */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   067849 - FIELD 2/ACSC NOT ALLOWED IN RECORD FORMAT              */
/*   048237 - Speedup Management Accounts                            */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use                                                  */
 
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
             PGM        PARM(&GCD &PYR &PNO &ANL &SCS &SDT &PBS &RET)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) /* Error +
                          message variable */
             DCL        VAR(&GCD) TYPE(*CHAR) LEN(2) /* Group code */
             DCL        VAR(&PYR) TYPE(*CHAR) LEN(4) /* Period year */
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(2) /* Period +
                          number */
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10) /* Analysis +
                          codes */
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8) /* Sections */
             DCL        VAR(&SDT) TYPE(*CHAR) LEN(5) /* Start date */
             DCL        VAR(&PBS) TYPE(*CHAR) LEN(1) /* Posting +
                          basis */
             DCL        VAR(&RET) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000) /* +
                          Variable to hold OPNQRYF command for +
                          QCMDEXC */
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(16) /* +
                          Account sections to include */
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Index for key sort */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /* Index for key +
                          sort */
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&KU) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC') /* Key +
                          array - not sorted */
             DCL        VAR(&KS) TYPE(*CHAR) LEN(40) /* Key array - +
                          sorted */
/*                                                             START OF 048237*/
/************DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100) +
                          VALUE('KEYFLD(') /* Key list for OPNQRYF */ /*048237*/
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100) +
                                           /* Key list for OPNQRYF */ /*048237*/
             DCL        VAR(&GRPFLD) TYPE(*CHAR) LEN(50)  +
                                           /* GRP list for OPNQRYF */ /*048237*/
             DCL        VAR(&EVDT) TYPE(*CHAR) LEN(4) /* Date field*/ /*048237*/
/*/COPY WNCPYSRC,MCC0225001                                          */
/*                                                               END OF 048237*/
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF1023) /* LDA already exists */
 
/* Reset job switches U7 and U8                                      */
             CHGJOB     SWS(XXXXXX00)
 
/* Set up list of sections to include                                */
             IF         COND(%SST(&SCS 1 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'AS'))
             IF         COND(%SST(&SCS 2 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'LI'))
             IF         COND(%SST(&SCS 3 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'IN'))
             IF         COND(%SST(&SCS 4 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'EX'))
             IF         COND(%SST(&SCS 5 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'CO'))
             IF         COND(%SST(&SCS 6 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'ME'))
             IF         COND(%SST(&SCS 7 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'TR'))
             IF         COND(%SST(&SCS 8 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'CN'))
 
/* Sort keys into order specified in &ANL                            */
/*LOOP1:*****IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))      /*048237*/
 LOOP1:      IF         COND(&I *GT 5) THEN(GOTO CMDLBL(EXIT1))       /*048237*/
             IF         COND(%SST(&ANL &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANL &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KU &I2 4))
                ENDDO
/* Copy Postings to speedup opnqry extracts                    Start of 048237*/
             ELSE       CMD(DO)
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))         /*048237*/
                CHGVAR     VAR(&GRPFLD) VALUE(&GRPFLD *BCAT +
                           %SST(&KU &I2 4))                           /*048237*/
                ENDDO
                                                               /*End of 048237*/
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
 
/* Set up keylist parameter for OPNQRYF                              */
 EXIT1:      CHGVAR     VAR(&I) VALUE(1)
 LOOP2:      IF         COND(&I *GT 40) THEN(GOTO CMDLBL(EXIT2))
             IF         COND(%SST(&KS &I 4) *NE '    ') THEN(CHGVAR +
                          VAR(&KEYFLD) VALUE(&KEYFLD *BCAT '(' +
                          *TCAT %SST(&KS &I 4) *TCAT ')'))
             CHGVAR     VAR(&I) VALUE(&I + 4)
             GOTO       CMDLBL(LOOP2)
/* Copy Postings to speedup opnqry extracts                    Start of 048237*/
/* EXIT2:    CHGVAR     VAR(&KEYFLD) VALUE(&KEYFLD *TCAT ')')         /*048237*/
 EXIT2:
 
/*/COPY WNCPYSRC,MCC0225002                                          */
             IF         COND(&PBS *EQ 'V') THEN(CHGVAR VAR(&EVDT) +
                          VALUE('VALD'))                              /*048237*/
             IF         COND(&PBS *EQ 'P') THEN(CHGVAR VAR(&EVDT) +
                          VALUE('PSTD'))                              /*048237*/
                                                                      /*048237*/
             CPYF       FROMFILE(APOSTPD) TOFILE(QTEMP/GLPOSTX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF &EVDT *GT &SDT))                /*048237*/
             CPYF       FROMFILE(GLACPHPD) TOFILE(QTEMP/GLPOSTX) +
                          MBROPT(*ADD) INCREL((*IF &EVDT *GT &SDT))   /*048237*/
/*/COPY WNCPYSRC,MCC0225003                                          */
 
/* Set up command string for OPNQRYF for GLMOVEPD                    */
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +                /*048237*/
/************             FILE((GLPOSTL5X) ) FORMAT(GLMOVEPD) +       /*048237*/
/************             QRYSLT(''RECDT *GT EVDT *AND SECLIST *CT +  /*048237*/
/************             ACSC'') GRPFLD(BRCA CCY ACOD CNUM ACSQ +    /*048237*/
/************             PRFC BOKC OTTP OTST ASOC ACSC) +            /*048237*/
/************             MAPFLD((EVDT' *BCAT &SDT *CAT ') (PAMT 0) + /*048237*/
/************             (VOIN 0) (GETP '''''' '''''') (SECLIST +    /*048237*/
/************             ''''''' *CAT &SECTIONS *TCAT ''''''') +     /*048237*/
/************             (CPNB' *BCAT &PYR *CAT &PNO *CAT ') +       /*048237*/
/************             (PDTM' *BCAT &SDT *CAT '000000) (RECDT')    /*048237*/
/************                                                         /*048237*/
/************IF         COND(&PBS *EQ 'P') THEN(CHGVAR VAR(&OPNQRYF) +/*048237*/
/************             VALUE(&OPNQRYF *BCAT 'PSTD)'))              /*048237*/
/************ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +     /*048237*/
/************             *BCAT 'VALD)'))                             /*048237*/
/************                                                         /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((GLPOSTX)) FORMAT(GLMOVEPD) +
                          QRYSLT(''SECLIST *CT ACSC'')')              /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'GRPFLD(BRCA CNUM CCY ACOD ACSQ PRFC BOKC +
                          OTTP OTST ASOC ACSC DRCR) MAPFLD((EVDT' +
                          *BCAT &SDT *CAT ') (PAMT 0) (VOIN 0) +
                          (GETP '''''' '''''') (SECLIST ''''''' +
                          *CAT &SECTIONS *TCAT ''''''') (CPNB' +
                          *BCAT &PYR *CAT &PNO *CAT ') (PDTM' *BCAT +
                          &SDT *CAT '000000) (ACODQQ 0)')                                 /*CGL029*/
/**********               &SDT *CAT '000000)')                       */            /*048237 CGL029*/
                                                               /*End of 048237*/
 
             IF         COND(%SST(&ANL 1 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACOD 0)'))
             IF         COND(%SST(&ANL 2 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CCY +
                          ''''''   '''''')'))
             IF         COND(%SST(&ANL 3 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BRCA +
                          ''''''   '''''')'))
/**********  IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +                     /*BUG12454*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM 0)')) */           /*BUG12454*/
             IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM +
                          ''''''      '''''')'))                                        /*BUG12454*/
             IF         COND(%SST(&ANL 5 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACSQ 0)'))
             IF         COND(%SST(&ANL 6 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +
                          ''''''    '''''')'))
             IF         COND(%SST(&ANL 7 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BOKC +
                          ''''''  '''''')'))
             IF         COND(%SST(&ANL 8 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTTP +
                          ''''''           '''''')'))
             IF         COND(%SST(&ANL 9 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTST +
                          ''''''           '''''')'))
/**********  IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +                     /*BUG12454*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ASOC 0)')) */            /*BUG12454*/
             IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ASOC +
                          ''''''      '''''')'))                                        /*BUG12454*/
 
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACODA +  /*048237*/
/************             ACOD *CHAR 4)) IGNDECERR(*YES) +            /*048237*/
/************             OPNID(GLMOVEPD)')                           /*048237*/
/************                                                         /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *TCAT +
                          ') OPNID(GLMOVEPD)')                        /*048237*/
                                                                      /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
 
             CPYFRMQRYF FROMOPNID(GLMOVEPD) TOFILE(GLMOVEPD) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(GLMOVEPD)                               /*048237*/
             MONMSG     MSGID(CPF4520)                                /*048237*/
 
/* Set up command string for OPNQRYF for GLBLEXPD                    */
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((ACCNTAB) + /*048237*/
/************             (GLPOSTL5X)) FORMAT(GLBLEXPD) +             /*048237*/
/************             QRYSLT(''(RECDT *GT EVDT *OR LMVD *EQ +     /*048237*/
/************             PSTD) *AND SECLIST *CT ACSC'') +            /*048237*/
/************             JFLD((1/BRCA 2/BRCA) (1/CCY 2/CCY) +        /*048237*/
/************             (1/ACOD 2/ACOD) (1/CNUM +                   /*048237*/
/************             2/CNUM) (1/ACSQ 2/ACSQ)) JDFTVAL(*YES) +    /*048237*/
/************             GRPFLD(1/BRCA 1/CCY 1/ACOD 1/CNUM 1/ACSQ +  /*048237*/
/************             2/ACSC) GRPSLT(''PAMT *NE 0 *OR MXDT *GT +  /*048237*/
/************             EVDT *OR MXLB *NE 0'') MAPFLD((EVDT' +      /*048237*/
/************             *BCAT &SDT *CAT ') (VOIN 0) (GETP '''''' +  /*048237*/
/************             '''''') (SECLIST ''''''' +                  /*048237*/
/************             *CAT &SECTIONS *TCAT ''''''') (CPNB' +      /*048237*/
/************             *BCAT &PYR *CAT &PNO *CAT ') (PDTM' *BCAT + /*048237*/
/************             &SDT *CAT '000000) (RECDT')                 /*048237*/
                                                                      /*048237*/
/************                                                         /*067849*/
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((ACCNTAB) + /*067849*/
/************             (GLPOSTX)) FORMAT(GLBLEXPD) +               /*067849*/
/************             QRYSLT(''(RECDT *GT EVDT *OR LDBL *NE +     /*067849*/
/************             0)'') JFLD((1/BRCA 2/BRCA) (1/CNUM +        /*067849*/
/************             2/CNUM) (1/CCY 2/CCY) (1/ACOD 2/ACOD) +     /*067849*/
/************             (1/ACSQ 2/ACSQ)) JDFTVAL(*YES) +            /*067849*/
/************             GRPFLD(1/BRCA 1/CNUM 1/CCY 1/ACOD 1/ACSQ) + /*067849*/
/************             GRPSLT(''PAMT *NE 0 *OR MXDT *GT EVDT *OR + /*067849*/
/************             MXLB *NE 0'') MAPFLD((EVDT' *BCAT &SDT +    /*067849*/
/************             *CAT ') (VOIN 0) (GETP '''''' '''''') +     /*067849*/
/************             (CPNB' *BCAT &PYR *CAT &PNO *CAT ') +       /*067849*/
/************       (PDTM' *BCAT &SDT *CAT '000000) (RECDT')  /*048237**067849*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (GLPOSTX)) FORMAT(GLBLEXPD) +
                          QRYSLT(''(RECDT *GT EVDT *OR LDBL *NE +
                          0)'') JFLD((1/BRCA 2/BRCA) (1/CNUM +
                          2/CNUM) (1/CCY 2/CCY) (1/ACOD 2/ACOD) +
                          (1/ACSQ 2/ACSQ)) JDFTVAL(*YES) +
                          GRPFLD(1/BRCA 1/CNUM 1/CCY 1/ACOD 1/ACSQ +
                          2/ACSQ) GRPSLT(''PAMT *NE 0 *OR MXDT *GT +
                          EVDT *OR MXLB *NE 0'') MAPFLD((EVDT' +
                          *BCAT &SDT *CAT ') (VOIN 0) (GETP '''''' +
                          '''''') (CPNB' *BCAT &PYR *CAT &PNO *CAT +
                          ') (ACODQQ 0) (PDTM' *BCAT &SDT *CAT '000000) +
                          (RECDT')                                                        /*CGL029*/
/**********               ') (PDTM' *BCAT &SDT *CAT '000000) +       */                   /*CGL029*/
/**********               (RECDT')                                   */            /*067849 CGL029*/
 
/*/COPY WNCPYSRC,MCC0225004                                          */
             IF         COND(&PBS *EQ 'P') THEN(CHGVAR VAR(&OPNQRYF) +
                          VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))
/*/COPY WNCPYSRC,MCC0225005                                          */
 
             IF         COND(%SST(&ANL 1 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACOD 0)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ACOD ''1/ACOD'')'))
 
             IF         COND(%SST(&ANL 2 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CCY +
                          ''''''   '''''')'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CCY ''1/CCY'')'))
 
             IF         COND(%SST(&ANL 3 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BRCA +
                          ''''''   '''''')'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BRCA ''1/BRCA'')'))
 
/**********  IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +                      /*BUG12454*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM 0)')) */            /*BUG12454*/
             IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM +
                          ''''''      '''''')'))                                        /*BUG12454*/
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(CNUM ''1/CNUM'')'))
 
             IF         COND(%SST(&ANL 5 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACSQ 0)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(ACSQ ''1/ACSQ'')'))
 
/************                                                         /*048237*/
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +   /*048237*/
/************             ''''''    '''''') (BOKC ''''''  '''''') +   /*048237*/
/************             (OTTP ''''''           '''''') (OTST +      /*048237*/
/************             ''''''           '''''') (ASOC 0) (ACODA +  /*048237*/
/************             ACOD *CHAR 4) (AMT ''PSTA - (PSTA * DRCR +  /*048237*/
/************             * 2)'') (MXDT ''%MAX(RECDT)'') (MXLB +      /*048237*/
/************             ''%MAX(%ABSVAL(LDBL))'') (WAMT ''AMT * +    /*048237*/
/************             %MIN((%MAX((RECDT + 1) EVDT) - EVDT) +      /*048237*/
/************             1)'') (LAMT ''%SUM(LDBL)'') (PAMT ''LAMT +  /*048237*/
/************             / %COUNT - %SUM(WAMT)'')) IGNDECERR(*YES) + /*048237*/
/************             OPNID(GLBLEXPD)')                           /*048237*/
/************                                                         /*048237*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +  */                   /*CGL029*/
/**********               ''''''    '''''') (BOKC ''''''  '''''') +  */                   /*CGL029*/
/**********               (OTTP ''''''           '''''') (OTST +     */                   /*CGL029*/
/**********               ''''''           '''''') (ASOC 0) (ACODA + */                   /*CGL029*/
/**********               ACOD *CHAR 4) (AMT ''PSTA - (PSTA * DRCR + */                   /*CGL029*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +                     /*BUG12454*/
/**********               ''''''    '''''') (BOKC ''''''  '''''') +                     /*BUG12454*/
/**********               (OTTP ''''''           '''''') (OTST +                        /*BUG12454*/
/**********               ''''''           '''''') (ASOC 0) (ACODA +                    /*BUG12454*/
/**********               ACOD *CHAR 10) (AMT ''PSTA - (PSTA * DRCR +                   /*BUG12454*/
/**********               * 2)'') (MXDT ''%MAX(RECDT)'') (MXLB +                        /*BUG12454*/
/**********               ''%MAX(%ABSVAL(LDBL))'') (WAMT ''AMT * +                      /*BUG12454*/
/**********               %MIN((%MAX((RECDT + 1) EVDT) - EVDT) +                        /*BUG12454*/
/**********               1)'') (LAMT ''%SUM(LDBL)'') (PAMT ''LAMT +                    /*BUG12454*/
/**********               / %COUNT - %SUM(WAMT)'')) +                                   /*BUG12454*/
/**********               OPNID(GLBLEXPD)') */                               /*048237*/ /*BUG12454*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +
                          ''''''    '''''') (BOKC ''''''  '''''') +
                          (OTTP ''''''           '''''') (OTST +
                          ''''''           '''''') (ASOC +
                          ''''''      '''''') (ACODA ACOD *CHAR 10) +
                          (AMT ''PSTA - (PSTA * DRCR * 2)'') (MXDT +
                          ''%MAX(RECDT)'') (MXLB +
                          ''%MAX(%ABSVAL(LDBL))'') (WAMT ''AMT * +
                          %MIN((%MAX((RECDT + 1) EVDT) - EVDT) +
                          1)'') (LAMT ''%SUM(LDBL)'') (PAMT ''LAMT +
                          / %COUNT - %SUM(WAMT)'')) +
                          OPNID(GLBLEXPD)')                                             /*BUG12454*/
 
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
 
/************CPYFRMQRYF FROMOPNID(GLBLEXPD) TOFILE(GLBLEXPD) +        /*048237*/
/************             MBROPT(*REPLACE)                            /*048237*/
             CPYFRMQRYF FROMOPNID(GLBLEXPD) TOFILE(GLBLEXPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*048237*/
             CLOF       OPNID(GLBLEXPD)                               /*048237*/
             MONMSG     MSGID(CPF4520)                                /*048237*/
 
/** GLBLEXPD may have duplicate keys so these records must now be  */
/** summarised into GLOPBLPD and put in key order.                 */
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +                /*048237*/
/************             FILE((GLBLEXPD)) GRPFLD(BRCA CCY ACOD +     /*048237*/
/************             CNUM ACSQ PRFC BOKC OTTP OTST ASOC CPNB +   /*048237*/
/************             EVDT PDTM ACSC VOIN GETP) MAPFLD((PAMT +    /*048237*/
/************             ''%SUM(1/PAMT)'')) IGNDECERR(*YES) +        /*048237*/
/************             OPNID(GLOPBLPD)')                           /*048237*/
 
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((SDACODPD) +
                          (GLBLEXPD)) FORMAT(GLOPBLPD) +
                          QRYSLT(''SECLIST *CT A5ACSC'')')            /*048237*/
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'JFLD((ACODE A5ACCD)) KEYFLD(' *TCAT +
                          &KEYFLD *TCAT ') GRPFLD(' *TCAT &KEYFLD +
                          *BCAT &GRPFLD *BCAT 'PRFC BOKC OTTP OTST +
                          ASOC CPNB EVDT PDTM A5ACSC VOIN GETP +
                          DRCR) MAPFLD((ACODE ACOD *CHAR 10) (ACSC +
                          A5ACSC) (ACODQQ 0) (SECLIST ''''''' *CAT &SECTIONS +
                          *TCAT ''''''') (PAMT ''%SUM(2/PAMT)'') +
                          (DRCR 0)) OPNID(GLOPBLPD) OPTALLAP(*YES)')                      /*CGL029*/
/**********               DRCR) MAPFLD((ACODE ACOD *CHAR 4) (ACSC +  */                   /*CGL029*/
/**********               A5ACSC) (SECLIST ''''''' *CAT &SECTIONS +  */                   /*CGL029*/
/**********               *TCAT ''''''') (PAMT ''%SUM(2/PAMT)'') +   */                   /*CGL029*/
/**********               (DRCR 0)) OPNID(GLOPBLPD) OPTALLAP(*YES)') */            /*048237 CGL029*/
 
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
 
 /***********CPYFRMQRYF FROMOPNID(GLOPBLPD) TOFILE(GLOPBLPD) +
                          MBROPT(*REPLACE)                            /*048237*/
             CPYFRMQRYF FROMOPNID(GLOPBLPD) TOFILE(GLOPBLPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*048237*/
             CLOF       OPNID(GLOPBLPD)                               /*048237*/
             MONMSG     MSGID(CPF4520)                                /*048237*/
 
/* Call the Opening Balance Maintenance program                      */
             CALL       PGM(MC0225) PARM(&GCD &PYR &PNO &RET)
 
/* Reclaim resources                                                 */
             RCLRSC
 
/* Clear the work file GLBLEXPD                                      */
             CLRPFM     FILE(GLBLEXPD)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR     VAR(&RET) VALUE('Y')
                ENDDO      /* End of database error section */
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Opening Balance Maintenance ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&RET) VALUE('C')                          /*048237*/
 
 ENDPGM:     ENDPGM
