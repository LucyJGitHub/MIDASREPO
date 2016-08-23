/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC OPNQRYF for rework DR/CR Av. balances')      */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0240 - OPNQRYF for Rework DR/CR Average Balances             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG12454           Date 06Nov06              */
/*       Prev Amend No. BUG5976            Date 17Feb05              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118387             Date 30Apr99              */
/*                      CMC001             Date 18Mar96              */
/*                      048237             DATE 08DEC92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG12454 - Changed OPNQRYF statements for alpha customer    */
/*                  number                                           */
/*   BUG5976 - Cannot copy query file UPDBALPD to MCPOSTPD *NOCHK as */
/*             the files are different record lengths with ACOD at   */
/*             the end.                                              */
/*   CGL029 - Increase Account Code to 10 digits.                    */
/*   118387 - Override GLHIBLL4, GLAVBLL0 and GLAVBLL1 to            */
/*            prime control group member.                            */
/*   CMC001 - Management Accounts Enhancement for PCA:               */
/*            Amend the filtering of posting details to Management   */
/*            Account by calling MC0310.                             */
/*   048237 - Speed up Management Accounts                           */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&GRPC &RETC)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&GRPC) TYPE(*CHAR) LEN(2) /* Group Code */
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1) /* Return Code */
             DCL        VAR(&RETC2) TYPE(*CHAR) LEN(7) /* Return Code */
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) /* Call Option */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /* Control +
                          Groups data structure */
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256) /* Local Data +
                          Area */
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(10) /* System  */
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) /* xxDPLIB */
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1) /* Posting +
                          basis */
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8) /* Sections */
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10) /* Analysis +
                          codes */
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000) /* +
                          Variable to hold OPNQRYF command for +
                          QCMDEXC */
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(16) /* +
                          Account sections to include */
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Index for Join */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /* Index for +
                          Join */
             DCL        VAR(&K) TYPE(*DEC) LEN(3 0) /* Index for +
                          Group */                                    /*048237*/
             DCL        VAR(&L) TYPE(*DEC) LEN(3 0) /* Index for +
                          Keyfld */                                   /*048237*/
             DCL        VAR(&JF) TYPE(*CHAR) LEN(140) +
                          VALUE('(ACOD   ACODA)(CCY   HBCYCD)(BRCA  +
                          HBBRCD)(CNUM   CNUMA)(ACSQ   ACSQA)(PRFC  +
                          HBPCCD)(BOKC  HBBKCD)(OTTP  HBOTTP)(OTST  +
                          HBTSTY)(ASOC   ASOCA)') /* Join array - +
                          All options*/
             DCL        VAR(&JS) TYPE(*CHAR) LEN(140) /* Join array +
                          - Selected options */
             DCL        VAR(&KY) TYPE(*CHAR) LEN(100) /* Keyfld Array +
                          - Selected options */                       /*048237*/
             DCL        VAR(&GP) TYPE(*CHAR) LEN(100) /* Group Array +
                          - un-Selected options */                    /*048237*/
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CMC001*/
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CMC001*/
/*/COPY WNCPYSRC,MCC0240001                                          */
 
/* Global Monitor Message                                            */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set up copyright                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***Create*GLPOSTL5X*if*is*does*not*exist*to*speedup*OPNQRYF  */      /*048237*/
 
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*048237*/
/*********** CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')       /*048237*/
/************CHKOBJ     OBJ(&DPLIB/GLPOSTL5X) OBJTYPE(*FILE)          /*048237*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(GLPOSTL5) + /*048237*/
/************             TOFILE(&DPLIB/GLPOSTL5X) MBROPT(*ADD) +     /*048237*/
/************             CRTFILE(*YES))                              /*048237*/
 
/*  Get Group details via access program, DB Error if not found  */
             CHGVAR     VAR(&RETC2) VALUE(*MSG)
             CHGVAR     VAR(&OPTN) VALUE('*KEY   ')
             CALL       PGM(AOHBCGR0) PARM(&RETC2 &OPTN &GRPC &DSFDY)
             IF         COND(&RETC2 *NE '       ') THEN(GOTO ABNOR)
 
             CHGVAR VAR(&PBAS) VALUE(%SST(&DSFDY 34 1))
             CHGVAR VAR(&SCS) VALUE(%SST(&DSFDY 54 8))
             CHGVAR VAR(&ANL) VALUE(%SST(&DSFDY 44 10))
/**/                                                                  /*CMC001*/
/**  If the control group does not maintain DR/CR average */          /*CMC001*/
/**  balances, terminate the process normally */                      /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(%SST(&DSFDY 41 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(ENDPGM))                             /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Check if Management Accounts Enhancement is installed. */        /*CMC001*/
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
                CHGVAR     VAR(&J) VALUE(1 + ((&I -1)  * 14))
                CHGVAR     VAR(%SST(&JS &J 14)) VALUE(%SST(&JF &J 14))
                CHGVAR     VAR(&L) VALUE(1 + ((&I -1)  * 5))          /*048237*/
                CHGVAR     VAR(&K) VALUE(2 + ((&I -1)  * 14))         /*048237*/
                CHGVAR    VAR(%SST(&KY &L 4)) VALUE(%SST(&JF &K 4))   /*048237*/
                ENDDO
             ELSE       CMD(DO)                                       /*048237*/
                CHGVAR     VAR(&K) VALUE(2 + ((&I -1)  * 14))         /*048237*/
                CHGVAR     VAR(&L) VALUE(1 + ((&I -1)  * 5))          /*048237*/
                CHGVAR    VAR(%SST(&GP &L 4)) VALUE(%SST(&JF &K 4))   /*048237*/
                ENDDO                                                 /*048237*/
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
 
 EXIT1:      CLOF       OPNID(UPDBALPD)
             MONMSG     (CPF4520)
/************OVRDBF     FILE(UPDBALPD) TOFILE(GLPOSTL5X) SHARE(*YES)  /*048237*/
/*                                                                    /*048237*/
/* Set up command string for OPNQRYF for UPDBALL0                    */
/************CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +                /*048237*/
/************             FILE((GLPOSTL5X) (GLHIBLL4' *BCAT &GRPC +   /*048237*/
/************             *TCAT ')) FORMAT(UPDBALPD) QRYSLT(''EVDT +  /*048237*/
/************             *GE HBSPDD *AND EVDT *LE HBEPDD *AND GETP + /*048237*/
/************             *NE ''''X'''' *AND GETP *NE +               /*048237*/
/************             ''''Y'''' '')')                             /*048237*/
/************                                                         /*048237*/
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +          /*048237*/
/************             'KEYFLD(BRCA CCY ACOD CNUM ACSQ PRFC BOKC + /*048237*/
/************             OTTP OTST ASOC CPNB EVDT) JFLD(' *TCAT +    /*048237*/
/************             &JS *TCAT ') GRPFLD(BRCA CCY ACOD CNUM +    /*048237*/
/************             ACSQ PRFC BOKC OTTP OTST ASOC')             /*048237*/
/************                                                         /*048237*/
/************IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +             /*048237*/
/************             VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD')) /*048237*/
/************ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +     /*048237*/
/************             *BCAT 'VALD'))                              /*048237*/
/************                                                         /*048237*/
/************CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'VOIN +    /*048237*/
/************             DRCR GETP ACSC CPNB) MAPFLD((WAMT ''PSTA +  /*048237*/
/************             - (PSTA * DRCR * 2)'') (WTIME ''(PSTD * +   /*048237*/
/************             1000000 + PTIM)'') (SECLIST ''''''' *CAT +  /*048237*/
/************             &SECTIONS *TCAT ''''''') (EVDT')            /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &GRPC *TCAT ') (GLACPHPD)) +
                          FORMAT(UPDBALPD) QRYSLT(''HBLMDT *EQ +
                          99999 *AND EVDT *GE HBSPDD *AND EVDT *LE +
                          HBEPDD'')')                                 /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed */               /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(DO)                /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Sort query records in a/c code, profit centre, associated */     /*CMC001*/
/**  customer and event date order.                            */     /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             'KEYFLD((ACOD) (PRFC) (ASOC) (EVDT))')   /*CMC001*/
/**/                                                                  /*CMC001*/
/**  Select all postings with the same branch, currency, account */   /*CMC001*/
/**  code, customer, and account sequence number.                */   /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             'JFLD((BRCA HBBRCD) (CCY HBCYCD) +
                             (ACOD ACODA) (CNUM CNUMA) +
                             (ACSQ ACSQA))')                          /*CMC001*/
             ENDDO                                                    /*CMC001*/
/**/                                                                  /*CMC001*/
             ELSE       CMD(DO)                                       /*CMC001*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'JFLD(' +
                          *TCAT &JS *TCAT ')')                        /*048237*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +
                          *TCAT &KY *BCAT &GP *BCAT 'VOIN DRCR +
                          GETP ACSC HBPDCT HBPDYR HBPDNY')            /*048237*/
                                                                      /*048237*/
/*/COPY WNCPYSRC,MCC0240002                                          */
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                         VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))                             /*048237*/
                                                                      /*048237*/
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +          */       /*048237*/ /*CGL029*/
/**********               'MAPFLD((WPAMT ''PSTA - (PSTA * DRCR * +    */       /*048237*/ /*CGL029*/
/**********               2)'') (WPDTM ''(PSTD * 1000000 + PTIM)'') + */       /*048237*/ /*CGL029*/
/**********               (EVDT')                                     */       /*048237*/ /*CGL029*/
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'MAPFLD((ACODQQ 0) (WPAMT ''PSTA - (PSTA * DRCR * +
                          2)'') (WPDTM ''(PSTD * 1000000 + PTIM)'') +
                          (EVDT')                                                         /*CGL029*/
 
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                         VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))
/*/COPY WNCPYSRC,MCC0240003                                          */
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, do not       */ /*CMC001*/
/*   include branch, customer, and a/c sequence in MAPFLD parm     */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *NE 'Y') THEN(DO)                /*CMC001*/
 
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
/**/                                                                  /*CMC001*/
             ENDDO                                                    /*CMC001*/
/**/                                                                  /*CMC001*/
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
/************             ''%MAX(WTIME)'') (CPNB ''HBPDCT *CAT +      /*048237*/
/************             HBPDYR *CAT HBPDNY'') (PAMT ''%SUM(WAMT) +  /*048237*/
/************             '') (ACODA ACOD *CHAR 4) (CNUMA CNUM +      /*048237*/
/************             *CHAR 6) (ACSQA ACSQ *CHAR 2) (ASOCA +      /*048237*/
/************             ASOC *CHAR 6)) IGNDECERR(*YES) +            /*048237*/
/************             OPNID(UPDBALPD)')                           /*048237*/
/************                                                         /*048237*/
/*/COPY WNCPYSRC,MCC0240004                                          */
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CPNB +  */        /*048237*/ /*CGL029*/
/**********               ''HBPDCT *CAT HBPDYR *CAT HBPDNY'') +      */        /*048237*/ /*CGL029*/
/**********               (ACODA HBACCD *ZONED 4) (CNUMA HBCUST +    */        /*048237*/ /*CGL029*/
/**********               *ZONED 6) (ACSQA HBACSN *ZONED 2) (ASOCA +           /*048237*/ /*CGL029*/
/**********               HBACNB *ZONED 6) (PDTM ''%MAX(WPDTM)'') +            /*048237*/ /*CGL029*/
/**********               (PAMT ''%SUM(WPAMT)'')) OPNID(UPDBALPD) +            /*048237*/ /*CGL029*/
/**********               OPTALLAP(*YES)')                                     /*048237*/ /*CGL029*/
 
/**********  CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CPNB +                     /*BUG12454*/
/**********               ''HBPDCT *CAT HBPDYR *CAT HBPDNY'') +                         /*BUG12454*/
/**********               (ACODA HBACCD *ZONED 10) (CNUMA HBCUST +                      /*BUG12454*/
/**********               *ZONED 6) (ACSQA HBACSN *ZONED 2) (ASOCA +                    /*BUG12454*/
/**********               HBACNB *ZONED 6) (PDTM ''%MAX(WPDTM)'') +                     /*BUG12454*/
/**********               (PAMT ''%SUM(WPAMT)'')) OPNID(UPDBALPD) +                     /*BUG12454*/
/**********               OPTALLAP(*YES)') */                                /*CGL029*/ /*BUG12454*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CPNB +
                          ''HBPDCT *CAT HBPDYR *CAT HBPDNY'') +
                          (ACODA HBACCD *ZONED 10) (CNUMA HBCUST +
                          *CHAR 6) (ACSQA HBACSN *ZONED 2) (ASOCA +
                          HBACNB *CHAR 6) (PDTM ''%MAX(WPDTM)'') +
                          (PAMT ''%SUM(WPAMT)'')) OPNID(UPDBALPD) +
                          OPTALLAP(*YES)')                                              /*BUG12454*/
/*/COPY WNCPYSRC,MCC0240005                                          */
                                                                      /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)              /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, copy query   */ /*CMC001*/
/**  records to PF/MCPOSTPD.                                       */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(+
                CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(MCPOSTPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP))          /*BUG5976*/
/***************CPYFRMQRYF*FROMOPNID(UPDBALPD)*TOFILE(MCPOSTPD) + */ /*BUG5976*/
/****************************MBROPT(*REPLACE)*FMTOPT(*NOCHK))   CMC001 BUG5976*/
             ELSE       CMD(DO)                                       /*CMC001*/
                                                                      /*048237*/
             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*048237*/
             ENDDO                                                    /*CMC001*/
/**/                                                                  /*CMC001*/
             CLOF       OPNID(UPDBALPD)                               /*048237*/
             MONMSG     (CPF4520)                                     /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(%SST(&OPNQRYF 29 8)) VALUE('APOSTPD ')    /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)              /*048237*/
/**/                                                                  /*CMC001*/
/**  If Management Accounts Enhancement is installed, copy query   */ /*CMC001*/
/**  records to PF/MCPOSTPD.                                       */ /*CMC001*/
/**/                                                                  /*CMC001*/
             IF         COND(&CMC001 *EQ 'Y') THEN(+
                CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(MCPOSTPD) +
                             MBROPT(*REPLACE) FMTOPT(*MAP))           /*BUG5976*/
/***************CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(MCPOSTPD)*+**/  /*BUG5976*/
/****************************MBROPT(*ADD)*FMTOPT(*NOCHK))**********/  /*CMC001 BUG5976*/
             ELSE       CMD(DO)                                       /*CMC001*/
                                                                      /*048237*/
             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*048237*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CLOF       OPNID(UPDBALPD)                               /*048237*/
             MONMSG     (CPF4520)                                     /*048237*/
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
/**  Select and copy all filtered postings that match the full key */ /*CMC001*/
/**  of a historic balance account with last movement date of      */ /*CMC001*/
/**  99999 to PF/UPDBALPD.                                         */ /*CMC001*/
/**/                                                                  /*CMC001*/
                CLOF       OPNID(MCFMVMPD)                            /*CMC001*/
                MONMSG     MSGID(CPF4520)                             /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                             *BCAT &GRPC *TCAT ') (MCFMVMPD)) +
                             FORMAT(MCFMVMPD) QRYSLT(''HBLMDT *EQ +
                             99999 *AND EVDT *GE HBSPDD *AND EVDT *LE +
                             HBEPDD'')')                              /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             'JFLD(' *TCAT &JS *TCAT ')')             /*CMC001*/
/**/                                                                  /*CMC001*/
                CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                             'GRPFLD(' *TCAT &KY *BCAT &GP *BCAT +
                             'VOIN GETP ACSC EVDT CPNB ATYP)')        /*CMC001*/
/**/                                                                  /*CMC001*/
/**********     CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +      */        /*CMC001*/ /*CGL029*/
/**********                  'MAPFLD((PDTM ''%MAX(2/PDTM)'') +       */        /*CMC001*/ /*CGL029*/
/**********                  (PAMT ''%SUM(2/PAMT)'') +               */        /*CMC001*/ /*CGL029*/
/**********                  (PNAR '''''' '''''') (ACODA HBACCD +    */        /*CMC001*/ /*CGL029*/
/**********                  *ZONED 4) (CNUMA HBCUST *ZONED 6) +     */        /*CMC001*/ /*CGL029*/
/**********                  (ACSQA HBACSN *ZONED 2) (ASOCA +        */        /*CMC001*/ /*CGL029*/
/**********                  HBACNB *ZONED 6)) OPNID(MCFMVMPD) +     */        /*CMC001*/ /*CGL029*/
/**********                  OPTALLAP(*YES)')                        */        /*CMC001*/ /*CGL029*/
 
/**********     CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +                         /*BUG12454*/
/**********                  'MAPFLD((PDTM ''%MAX(2/PDTM)'') +                          /*BUG12454*/
/**********                  (PAMT ''%SUM(2/PAMT)'') +                                  /*BUG12454*/
/**********                  (PNAR '''''' '''''') (ACODA HBACCD +                       /*BUG12454*/
/**********                  *ZONED 10) (ACODQQ 0) (CNUMA HBCUST *ZONED 6) +            /*BUG12454*/
/**********                  (ACSQA HBACSN *ZONED 2) (ASOCA +                           /*BUG12454*/
/**********                  HBACNB *ZONED 6)) OPNID(MCFMVMPD) +                        /*BUG12454*/
/**********                  OPTALLAP(*YES)') */                             /*CGL029*/ /*BUG12454*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'MAPFLD((PDTM ''%MAX(2/PDTM)'') (PAMT +
                          ''%SUM(2/PAMT)'') (PNAR '''''' '''''') +
                          (ACODA HBACCD *ZONED 10) (ACODQQ 0) +
                          (CNUMA HBCUST *CHAR 6) (ACSQA HBACSN +
                          *ZONED 2) (ASOCA HBACNB *CHAR 6)) +
                          OPNID(MCFMVMPD) OPTALLAP(*YES)')                              /*BUG12454*/
/**/                                                                  /*CMC001*/
                RCLRSC                                                /*CMC001*/
                CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)           /*CMC001*/
/**/                                                                  /*CMC001*/
                CPYFRMQRYF FROMOPNID(MCFMVMPD) TOFILE(UPDBALPD) +
                             MBROPT(*REPLACE) FMTOPT(*NOCHK)          /*CMC001*/
/**/                                                                  /*CMC001*/
             ENDDO                                                    /*CMC001*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((UPDBALPD)) ')                         /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD( +
                          BRCA CCY ACOD CNUM ACSQ PRFC BOKC OTTP +
                          OTST ASOC CPNB EVDT) OPNID(UPDBALPD)')      /*048237*/
                                                                      /*048237*/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
 
/* Call Rework Average Balances RPG                                  */
             OVRDBF     FILE(GLHIBLL4) MBR(&GRPC)                     /*118387*/
             OVRDBF     FILE(GLAVBLL0) MBR(&GRPC)                     /*118387*/
             OVRDBF     FILE(GLAVBLL1) MBR(&GRPC)                     /*118387*/
             CALL       PGM(MC0240) PARM(&GRPC &RETC)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                    CHGVAR     VAR(&RETC) VALUE('Y')
                    RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                    MSGDTA(&MEM) TOMSGQ(MOPERQ)
             ENDDO
 
/* Reclaim resources                                                 */
             RCLRSC
             GOTO       ENDPGM
 
ABNOR:       CHGVAR     VAR(&RETC) VALUE('Y')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Rework DR/CR Average Balances ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             RCLRSC
 
ENDPGM:      ENDPGM
