/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Merge todays retail postings')               */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                         */
/*                                                                   */
/*       REC3065 - RETAIL ACCOUNT POSTINGS MERGE - DAILY POSTINGS    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1012196          Date 14Jan13              */
/*                      CER049             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27658           Date 13May10              */
/*                      BUG27433           Date 20Apr10              */
/*                      CGL030             Date 18Dec09              */
/*                      CGL047             Date 30Jun06              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSD008             Date 05Feb01              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      154688             Date 05Feb99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      121058             Date 09Feb98              */
/*                      CPM005             DATE 05AUG96              */
/*                      CMC001             Date 18Mar96              */
/*                      098700             DATE 09JUL96              */
/*                      CRE003             DATE 25APR96              */
/*                      S01408             DATE 23JUN95              */
/*                      CRT001             DATE 28FEB95              */
/*                      S01421             DATE 09AUG93              */
/*                      S01427             DATE 12JUL93              */
/*                      S01413 *CREATE          13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1012196 - GE-TX postings is not included in postings      */
/*                   file merge. Reverse BUG27658. (CHILD:AR1012197) */
/*       CER049 - Stamp Tax                                          */
/*       BUG27658 - Incorrect computation of available balance       */
/*       BUG27433 - Interest adjustment is not calculated for        */
/*                  backvalued transaction in Account Transfer       */
/*       CGL030 - Sundry Postings                                    */
/*       CGL047 - Generic Posting Interface                          */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*       154688 - Retail Teller transactions/Postings missing from   */
/*                Retail history file.                               */
/*       121058 - Retail Statement Charges Fix:                      */
/*                Process records from CLEARPD with SPOS = 'GE-SF'   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       CMC001 - Management Accounts Enhancement for PCA:           */
/*                Copy retail postings GERTPD to REEODPF if Manage-  */
/*                ment Accounts Enhancement for PCA is installed.    */
/*       098700 - Retail History not updated with Safe Custody Fees. */
/*                Copy records from GESCPD to REEODPF if Safe Cust.  */
/*                Fees installed.                                    */
/*       CRE003 - Ledger Balance Accruals                            */
/*       S01408 - Addition of core hook REC3065MPE                   */
/*       CRT001 - Retail Teller System.                              */
/*       S01421  -  BLI development phase one.                       */
/*                  - Includes changes for:                          */
/*                    S01423 - Merge new postings files GEHMPD       */
/*                             and GENAPD into REEODPF.              */
/*       S01427  -  Inclusion of Chips/Midas online interface        */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*/COPY WNCPYSRC,REC3065002                                          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/************DCL********VAR(&FRF) TYPE(*CHAR) LEN(7) VALUE(TABTB55)    *CRE003*/
             DCL        VAR(&FRF) TYPE(*CHAR) LEN(8) VALUE(SDRETLPD)  /*CRE003*/
             DCL        VAR(&TOF) TYPE(*CHAR) LEN(7) VALUE(REEODPF)
             DCL        VAR(&S01423) TYPE(*CHAR) LEN(7)               /*S01421*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*S01421*/
             DCL        VAR(&CPSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CRT001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CRT001*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*098700*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CRT001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CRT001*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CPM005*/
/*/COPY WNCPYSRC,REC3065001                                          */
/************DCLF*******FILE(TABTB55) RCDFMT(TABTB55F)                 *CRE003*/
             DCLF       FILE(SDRETLPD) RCDFMT(SDRETLD0)               /*CRE003*/
             RCVF
             MONMSG     MSGID(CPF4101) EXEC(GOTO CMDLBL(EXIT1))
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)
             RTVDTAARA  DTAARA(CPSTAT) RTNVAR(&CPSTAT)                /*S01427*/
/**/
 
             SNDPGMMSG  MSG('REC3065 - Retail Accounts Posting Merge +
                          -Daily Postings') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(GEICPD)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
             CLRPFM     FILE(GEICZZ)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
             CLRPFM     FILE(GEIC2PD)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
             CLRPFM     FILE(GEIC2ZZ)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
             CLRPFM     FILE(REEODPF)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
/**/
/*/COPY WNCPYSRC,REC3065004                                          */
/************IF         COND(&CBAI = 'Y') THEN(DO)                     *CRE003*/
             IF         COND(&BMCBAI = 'Y') THEN(DO)                  /*CRE003*/
               CHGVAR     VAR(&FRF) VALUE('CLEARPD ')
             CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/                                                                  /*CRE003*/
             IF         COND(&BMCBAI *NE 'Y') THEN(DO)                /*CRE003*/
               CHGVAR     VAR(&FRF) VALUE('CLEARPD ')                 /*CRE003*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RECI *EQ 'P') (*AND RIND *EQ +
                          1) (*AND SPOS *EQ '  GE-IC')) FMTOPT(*MAP +
                          *DROP)                                      /*CRE003*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CRE003*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RECI *EQ 'P') (*AND RIND *EQ +
                          1) (*AND SPOS *EQ '  GE-SF')) FMTOPT(*MAP +
                          *DROP)                                      /*121058*/
             ENDDO                                                    /*CRE003*/
/**/
             IF         COND(%SST(&MMOD 1 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE('MANPOPD')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/*/COPY WNCPYSRC,REC3065003                                          */
/**/
               CHGVAR     VAR(&FRF) VALUE('GESFPD')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/**/
               CHGVAR     VAR(&FRF) VALUE('GEFAPD')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/**/
               CHGVAR     VAR(&FRF) VALUE('GESOPD ')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/**/
               CHGVAR     VAR(&FRF) VALUE('GECEPD ')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/**/
               CHGVAR     VAR(&FRF) VALUE('GEAAPD')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/
             IF         COND(%SST(&MMOD 2 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE('GEDLPD ')
             CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/
             IF         COND((%SST(&MMOD 4 1) = 'Y') *OR (%SST(&MMOD +
                          10 1) = 'Y')) THEN(DO)
             CHGVAR     VAR(&FRF) VALUE('GELEPD ')
             CPYF       FROMFILE(&FRF) TOFILE(&TOF)    +
                          MBROPT(*ADD) INCREL((*IF RIND *EQ 1) (*AND +
                          RECI *EQ 'P')) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO EXIT1)
           ENDDO
/**/
           IF COND((%SST(&MMOD 5 1) = 'Y') *OR +
                (%SST(&MMOD 21 1) = 'Y')) THEN(DO)
               CHGVAR     VAR(&FRF) VALUE('GESTPD ')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/* Save custody postings */                                           /*098700*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*098700*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*098700*/
/* */                                                                 /*098700*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*098700*/
               CHGVAR     VAR(&FRF) VALUE('GESCPD ')                  /*098700*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*098700*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*098700*/
             ENDDO                                                    /*098700*/
             ENDDO
/**/
             IF         COND(%SST(&MMOD 57 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE('GEFPPD ')
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/
             IF         COND(%SST(&MMOD 50 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE('GEFFPD ')
             CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/                                                                  /*CPM005*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &DSFDY)     /*CPM005*/
             IF         COND((&RTCD *EQ '       ') *AND (%SST(&DSFDY +
                          65 1) *EQ 'Y')) THEN(DO)                    /*CPM005*/
                CHGVAR     VAR(&FRF) VALUE('GEPMPD ')                 /*CPM005*/
                CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                           INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                           'P')) FMTOPT(*MAP *DROP)                   /*CPM005*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                           CMDLBL(EXIT1))                             /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/
/* Check to see if the customer service fees switchable feature */    /*S01421*/
/* is present in the system and only copy the Hold Mail and     */    /*S01421*/
/* Numbered Account files if the feature is on                  */    /*S01421*/
/**/                                                                  /*S01421*/
             CALL       PGM(AOSARDR0) PARM(&S01423 '*VERIFY' +
                          'S01423' &AOFMT)                            /*S01421*/
/**/                                                                  /*S01421*/
/* Copy Hold Mail generated entries file to REEODPF */                /*S01421*/
/**/                                                                  /*S01421*/
             IF         COND(&S01423 *EQ ' ') THEN(DO)                /*S01421*/
                                                                      /*S01421*/
               CHGVAR     VAR(&FRF) VALUE('GEHMPD')                   /*S01421*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*S01421*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*S01421*/
/**/                                                                  /*S01421*/
/* Copy Numbered Account generated entries file to REEODPF */         /*S01421*/
/**/                                                                  /*S01421*/
               CHGVAR     VAR(&FRF) VALUE('GENAPD')                   /*S01421*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*S01421*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*S01421*/
                                                                      /*S01421*/
             ENDDO                                                    /*S01421*/
/**/                                                                  /*S01427*/
/* Copy Chips interface postings file to REEODPF           */         /*S01427*/
/**/                                                                  /*S01427*/
             IF COND((%SST(&MMOD 45 1) = 'Y') *AND +
                (%SST(&CPSTAT 11 2) = 'YY'))  THEN(DO)                /*S01427*/
/**/                                                                  /*S01427*/
               CHGVAR     VAR(&FRF) VALUE('GECMPD')                   /*S01427*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*S01427*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*S01427*/
             ENDDO                                                    /*S01427*/
/**/                                                                  /*CRT001*/
/*  Check if Retail Teller System is switched on */                   /*CRT001*/
/**/                                                                  /*CRT001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CRT001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CRT001*/
             CHGVAR     VAR(&SAR) VALUE('CRT001')                     /*CRT001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CRT001*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CRT001*/
               CHGVAR     VAR(&FRF) VALUE('GETTPD')                   /*CRT001*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*CRT001*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CRT001*/
             ENDDO                                                    /*CRT001*/
                                                                                          /*154688*/
/* If Retail Teller not switched on check if Cashier is on instead */                     /*154688*/
                                                                                          /*154688*/
             ELSE       CMD(DO)
                CHGVAR     VAR(&RTCD) VALUE('       ')                                    /*154688*/
                CHGVAR     VAR(&SAR) VALUE('CRT002')                                      /*154688*/
                CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                   /*154688*/
                IF         COND(&RTCD *EQ ' ') THEN(DO)                                   /*154688*/
                  CHGVAR     VAR(&FRF) VALUE('GETTPD')                                    /*154688*/
                  CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                               INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                               FMTOPT(*MAP *DROP)                                         /*154688*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                               CMDLBL(EXIT1))                                             /*154688*/
                ENDDO                                                                     /*154688*/
             ENDDO                                                                        /*154688*/
/**/                                                                  /*CMC001*/
/*  Check if CMC001 SAR is switched on */                             /*CMC001*/
/**/                                                                  /*CMC001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CMC001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CMC001*/
             CHGVAR     VAR(&SAR) VALUE('CMC001')                     /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CMC001*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CMC001*/
               CHGVAR     VAR(&FRF) VALUE('GERTPD')                   /*CMC001*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*CMC001*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CMC001*/
             ENDDO                                                    /*CMC001*/
 
/* Copy postings from Generic Posting Interface */                                        /*CGL047*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL047' +
                          &AOFMT)                                                         /*CGL047*/
             IF         COND((&RTCD = ' ') ) THEN(DO)                                     /*CGL047*/
             CPYF       FROMFILE(GEGPIPD) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)                                        /*CGL047*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                                                  /*CGL047*/
             ENDDO                                                                        /*CGL047*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC3065MPE                                           /*S01408*/
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER049*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER049*/
             CHGVAR     VAR(&SAR) VALUE('CER049')                                         /*CER049*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CER049*/
/**/                                                                                      /*CER049*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                      /*CER049*/
/**/                                                                                      /*CER049*/
               CHGVAR     VAR(&FRF) VALUE('GLGESTPD')                                     /*CER049*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                             INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                             FMTOPT(*MAP *DROP)                                           /*CER049*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                             CMDLBL(EXIT1))                                               /*CER049*/
             ENDDO                                                                        /*CER049*/
/*/                                                                                       /*CGL030*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CGL030' &AOFMT)                                                /*CGL030*/
/*/                                                                                       /*CGL030*/
             IF         COND((&RTCD = ' ') ) +
                          THEN(DO)                                                        /*CGL030*/
             CPYF       FROMFILE(GESUPD) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)                                        /*CGL030*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                                                  /*CGL030*/
             ENDDO                                                                        /*CGL030*/
/**/                                                                  /*CSD008*/
/*  Check if CSD008 SAR (Customer Service Fees) is switched on */     /*CSD008*/
/**/                                                                  /*CSD008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSD008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSD008*/
             CHGVAR     VAR(&SAR) VALUE('CSD008')                     /*CSD008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSD008*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CSD008*/
               CHGVAR     VAR(&FRF) VALUE('GEFEPD')                   /*CSD008*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*CSD008*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CSD008*/
             ENDDO                                                    /*CSD008*/
/**/
/*           CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +          */                /*BUG27658*/
/*                        'CAP204' &AOFMT)                            */   /*BUG27433*/ /*BUG27658*/
/*/                                                                                     /*BUG27433*/
/*           IF         COND((&RTCD = ' ') ) +                        */                /*BUG27658*/
/*                        THEN(DO)                                    */   /*BUG27433*/ /*BUG27658*/
/*           CPYF       FROMFILE(GETXPD) TOFILE(&TOF) MBROPT(*ADD) +  */                /*BUG27658*/
/*                        INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +    */                /*BUG27658*/
/*                        'P')) FMTOPT(*MAP *DROP)                    */   /*BUG27433*/ /*BUG27658*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +    */                /*BUG27658*/
/*                        CMDLBL(EXIT1))                              */   /*BUG27433*/ /*BUG27658*/
/*           ENDDO                                                    */   /*BUG27433*/ /*BUG27658*/
/*/                                                                                     /*BUG27433*/
/**/                                                                                   /*AR1012196*/
/* Copy Account Transfer postings to REEODPF if CAP204 is switched ON*/                /*AR1012196*/
/**/                                                                                   /*AR1012196*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CAP204' &AOFMT)                                             /*AR1012196*/
                                                                                       /*AR1012196*/
             IF         COND((&RTCD = ' ') ) +
                          THEN(DO)                                                     /*AR1012196*/
             CPYF       FROMFILE(GETXPD) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                          'P')) FMTOPT(*MAP *DROP)                                     /*AR1012196*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                                               /*AR1012196*/
             ENDDO                                                                     /*AR1012196*/
                                                                                       /*AR1012196*/
             GOTO       CMDLBL(ENDCL)
/**/
EXIT1:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &FRF *TCAT ' not +
                          found - REC3065')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
EXIT2:
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('Member of file ' *CAT &TOF +
                          *TCAT ' not found - REC3065')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
/**/
EXIT3:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &TOF *TCAT ' not +
                          found - REC3065')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCL:
/**/
             ENDPGM
