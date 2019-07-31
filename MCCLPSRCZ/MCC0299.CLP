/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC OPNQRYF for Movement Extract')               */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0299 - OPNQRYF for Movement Extract                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG12454           Date 06Nov06              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118386             Date 30Apr99              */
/*                      CMC001             Date 18Mar96              */
/*                      048237             DATE 12MAR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG12454 - Changed OPNQRYF statements for alpha customer    */
/*                  number                                           */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   118386 - Close OPNQRYF after use on MCFMVMPD.                   */
/*   CMC001 - Management Accounts Enhancement for PCA:               */
/*            Modify the account posting details for update to       */
/*            the Management Accounts.                               */
/*   048237 - Speed up Management Accounts                           */
/*                                                                   */
/*********************************************************************/
 
 
             PGM        PARM(&PSET &PBAS &SDAT &SCS &ANL &TYP &STIM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PSET) TYPE(*CHAR) LEN(1) /* Period set */
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1) /* Posting +
                          basis */
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(5) /* Start date */
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8) /* Sections */
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10) /* Analysis +
                          codes */
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(1) /* Type of +
                          extract */
             DCL        VAR(&STIM) TYPE(*CHAR) LEN(6) /* Start time */
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
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100) /* Key +
                          list for OPNQRYF */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CMC001*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*CMC001*/
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CMC001*/
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CMC001*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CMC001*/
/*/COPY WNCPYSRC,MCC0299001                                          */
/**/                                                                  /*CMC001*/
/**  Global Monitor Message:                                       */ /*CMC001*/
/**   If an unmonitorred message occurs perform error processing   */ /*CMC001*/
/**/                                                                  /*CMC001*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CMC001*/
 
/* Set up copyright                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*CMC001*/
/**  Check if Management Accounts Enhancement is installed.        */ /*CMC001*/
/**/                                                                  /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)                                     /*CMC001*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&CMC001) VALUE('Y'))                    /*CMC001*/
 
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
 LOOP1:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))
             IF         COND(%SST(&ANL &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANL &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KU &I2 4))
                ENDDO
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
 
 EXIT2:      CLOF       OPNID(UPDBALPD)
             MONMSG     MSGID(CPF4520)
 
/* Set up command string for OPNQRYF for UPDBALPD                    */
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPOSTL5X) +
                          (GLPERDPD)) FORMAT(UPDBALPD) +
                          QRYSLT(''DTPSTC *EQ ''''' *CAT &PSET *CAT +
                          ''''' *AND (DTRPDN *LT 1 *OR DTSPDD *LE +
                          EVDT) *AND SECLIST *CT ACSC *AND')          /*048237*/
 
/*/COPY WNCPYSRC,MCC0299002                                          */
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((GLACPHPD)) FORMAT(UPDBALPD) +
                          QRYSLT(''SECLIST *CT ACSC *AND')            /*048237*/
 
             IF         COND(&TYP *EQ 'R') THEN(CHGVAR VAR(&OPNQRYF) +
                          VALUE(&OPNQRYF *BCAT 'EVDT *GE' *BCAT +
                          &SDAT *BCAT ''')'))
 
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(PSTD *GT' *BCAT &SDAT *BCAT '*OR +
                          (PSTD *EQ' *BCAT &SDAT *BCAT '*AND PTIM +
                          *GT' *BCAT &STIM *BCAT '))'')'))
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, sort the     */ /*CMC001*/
/**  query records in account code, profit centre, associated      */ /*CMC001*/
/**  customer and event date order.                                */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD( +
                          (ACOD) (PRFC) (ASOC) (EVDT))'))             /*CMC001*/
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +
                          *TCAT &KEYFLD )                             /*048237*/
                                                                      /*048237*/
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          '(PSTD)'))                                  /*048237*/
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(VALD)'))                            /*048237*/
/************                                                         /*048237*/
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD(' +/*048237*/
/************             *TCAT &KEYFLD *TCAT '(CPNB) (EVDT)) +       /*048237*/
/************             JFLD((EVDT DTEPDD *LE)) GRPFLD(' *TCAT +    /*048237*/
/************             &KEYFLD)                                    /*048237*/
/************                                                         /*048237*/
/************IF         COND(&PBAS *EQ 'P') THEN(CHGVAR VAR(&OPNQRYF) +*048237*/
/************             VALUE(&OPNQRYF *BCAT '(CPNB) (PSTD)'))      /*048237*/
/************ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +     /*048237*/
/************             *BCAT '(CPNB) (VALD)'))                     /*048237*/
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(VOIN) +
                          (DRCR) (GETP) (ACSC)) MAPFLD((WAMT ''PSTA +
                          - (PSTA * DRCR * 2)'') (WTIME ''(PSTD * +
                          1000000 + PTIM)'') (SECLIST ''''''' *CAT +
                          &SECTIONS *TCAT ''''''') (ACODQQ 0) (EVDT')                     /*CGL029*/
/**********               &SECTIONS *TCAT ''''''') (EVDT')           */                   /*CGL029*/
 
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))
/*/COPY WNCPYSRC,MCC0299003                                          */
 
             IF         COND(%SST(&ANL 1 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACOD 0)'))
             IF         COND(%SST(&ANL 2 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CCY +
                          ''''''   '''''')'))
             IF         COND(%SST(&ANL 3 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BRCA +
                          ''''''   '''''')'))
/**********  IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +                      /*BUG12454*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM 0)')) */            /*BUG12454*/
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
 
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +   /*048237*/
/************             ''%MAX(WTIME)'') (CPNB ''DTPDCT *CAT +      /*048237*/
/************             DTPDYR *CAT DTPDNY'') (PAMT +               /*048237*/
/************             ''%SUM(WAMT)'') (ACODA ACOD *CHAR 4)) +     /*048237*/
/************             IGNDECERR(*YES) OPNID(UPDBALPD)')           /*048237*/
                                                                      /*048237*/
/*/COPY WNCPYSRC,MCC0299004                                          */
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +
                          ''%MAX(WTIME)'') (CPNB 0) (PAMT +
                          ''%SUM(WAMT)'')) OPNID(UPDBALPD) +
                          OPTALLAP(*YES)')                            /*048237*/
/*/COPY WNCPYSRC,MCC0299005                                          */
 
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, copy query   */ /*CMC001*/
/**  records to PF/MCPOSTPD.                                       */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(+
                CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(MCPOSTPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP))                         /*CGL029*/
/**********                  MBROPT(*REPLACE) FMTOPT(*NOCHK))        */            /*CMC001 CGL029*/
             ELSE       CMD(DO)                                       /*CMC001*/
                                                                      /*048237*/
             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*048237*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CLOF       OPNID(UPDBALPD)                               /*048237*/
             MONMSG     MSGID(CPF4520)                                /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(%SST(&OPNQRYF 15 8)) VALUE('APOSTPD ')    /*048237*/
                                                                      /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)              /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, copy query   */ /*CMC001*/
/**  records to PF/MCPOSTPD.                                       */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(+
                CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(MCPOSTPD) +
                             MBROPT(*ADD) FMTOPT(*MAP *DROP))                             /*CGL029*/
/**********                  MBROPT(*ADD) FMTOPT(*NOCHK))            */            /*CMC001 CGL029*/
             ELSE       CMD(DO)                                       /*CMC001*/
                                                                      /*048237*/
             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*048237*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CLOF       OPNID(UPDBALPD)                               /*048237*/
             MONMSG     MSGID(CPF4520)                                /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, call MC0310  */ /*CMC001*/
/**  to filter the selected MCPOSTPD records onto PF/MCFMVMPD.     */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(DO)                /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Clear output files and perform file overrides */                 /*CMC001*/
/**/                                                                  /*CMC001*/
                CLRPFM     FILE(MCFMVMPD)                             /*CMC001*/
                OVRDBF     FILE(MCPOSTPD) SHARE(*YES) +
                             SEQONLY(*YES 352)                        /*CMC001*/
                OVRDBF     FILE(MCFMVMPD) SEQONLY(*YES 352)           /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Call Postings filter program and check for database error        /*CMC001*/
/**/                                                                  /*CMC001*/
                CALL       PGM(MC0310)                                /*CMC001*/
                DLTOVR     FILE(MCPOSTPD MCFMVMPD)                    /*CMC001*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           /*CMC001*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)       /*CMC001*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)           /*CMC001*/
                   GOTO       CMDLBL(ABNOR)                           /*CMC001*/
                ENDDO                                                 /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Summarise the filtered postings */                               /*CMC001*/
/**/                                                                  /*CMC001*/
                CLOF       OPNID(MCFMVMPD)                            /*CMC001*/
                MONMSG     MSGID(CPF4520)                             /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                             FILE((MCFMVMPD))')                       /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             'GRPFLD(' *TCAT &KEYFLD *BCAT '(EVDT) +
                             (VOIN) (GETP) (ACSC) (ATYP)) +
                             MAPFLD((ACODQQ 0) ')                                         /*CGL029*/
/**********                  MAPFLD(')                               */            /*CMC001 CGL029*/
/**/                                                                  /*CMC001*/
                IF         COND(%SST(&ANL 1 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             '(ACOD 0)'))                             /*CMC001*/
                IF         COND(%SST(&ANL 2 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CCY +
                             ''''''   '''''')'))                      /*CMC001*/
                IF         COND(%SST(&ANL 3 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BRCA +
                             ''''''   '''''')'))                      /*CMC001*/
/**********     IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +                   /*BUG12454*/
/**********                  VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +                       /*BUG12454*/
/**********                  '(CNUM 0)')) */                                 /*CMC001*/ /*BUG12454*/
                IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM +
                          ''''''      '''''')'))                                        /*BUG12454*/
                IF         COND(%SST(&ANL 5 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             '(ACSQ 0)'))                             /*CMC001*/
                IF         COND(%SST(&ANL 6 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +
                             ''''''    '''''')'))                     /*CMC001*/
                IF         COND(%SST(&ANL 7 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BOKC +
                             ''''''  '''''')'))                       /*CMC001*/
                IF         COND(%SST(&ANL 8 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTTP +
                             ''''''           '''''')'))              /*CMC001*/
                IF         COND(%SST(&ANL 9 1) *EQ ' ') THEN(CHGVAR +
                             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTST +
                             ''''''           '''''')'))              /*CMC001*/
/**********     IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +                  /*BUG12454*/
/**********                  VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +                       /*BUG12454*/
/**********                  '(ASOC 0)')) */                                 /*CMC001*/ /*BUG12454*/
                IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ASOC +
                          ''''''      '''''')'))                                        /*BUG12454*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +
                             ''%MAX(1/PDTM)'') (CPNB 0) (PAMT +
                             ''%SUM(1/PAMT)'') (PNAR '''''' '''''')) +
                             OPTALLAP(*YES)')                         /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Run OPNQRYF to SUMMARISE Midas Generated postings again */       /*CMC001*/
/**/                                                                  /*CMC001*/
                RCLRSC                                                /*CMC001*/
                CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)           /*CMC001*/
/**/                                                                  /*CMC001*/
                CPYFRMQRYF FROMOPNID(MCFMVMPD) TOFILE(UPDBALPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                          /*CGL029*/
/**********                  MBROPT(*REPLACE) FMTOPT(*NOCHK)         */            /*CMC001 CGL029*/
                                                                      /*118386*/
             CLOF       OPNID(MCFMVMPD)                               /*118386*/
             MONMSG     MSGID(CPF4520)                                /*118386*/
/**/                                                                  /*CMC001*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) +
                          (UPDBALPD)) FORMAT(UPDBALPD) +
                          QRYSLT(''DTPSTC *EQ PSET'')')               /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, omit closed  */ /*CMC001*/
/**  periods                                                       */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(CHGVAR +
                          VAR(%SST(&OPNQRYF 77 20)) VALUE(' *AND +
                          DTCLSD *EQ 0'')'))                          /*CMC001*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'JFLD((DTEPDD EVDT *GE) +
                          (SPDD EVDT *LE)) JORDER(*FILE)')            /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD(' +
                          *TCAT &KEYFLD *TCAT '(CPNB) (EVDT))')       /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'MAPFLD((CPNB ''DTPDCT *CAT DTPDYR *CAT +
                          DTPDNY'') (ONE 1) (PSET ''''''' *CAT +
                          &PSET *CAT ''''''' *CHAR 1) (SPDD +
                          ''DTSPDD * %MIN(%MAX(DTRPDN 0) 1)'')) +
                          OPNID(UPDBALPD)')                           /*048237*/
                                                                      /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)              /*048237*/
             GOTO       CMDLBL(PGMEND)                                /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Error Processing:                                             */ /*CMC001*/
/**   Dump the program if error occurred in this program           */ /*CMC001*/
/**/                                                                  /*CMC001*/
 ABNOR:      DMPCLPGM                                                 /*CMC001*/
             CHGJOB     SWS(XXXXXX11)                                 /*CMC001*/
             SNDMSG     MSG('Job terminated - OPNQRYF for Movement +
                        Extract ended in error') TOMSGQ(MOPERQ MRUNQ) /*CMC001*/
 
/**/                                                                  /*CMC001*/
/**  End of Program:   */                                             /*CMC001*/
 PGMEND:                                                              /*CMC001*/
             ENDPGM
