/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RETAIL POSTING MERGE ANWD2')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                 */
/*                                                                   */
/*       REC3650 - RETAIL ACCOUNT POSTINGS MERGE - DAILY POSTINGS    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER049             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSD008             Date 05Feb01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM005             Date 05Aug96              */
/*                      098700             Date 09Jul96              */
/*                      CRE003             DATE 25APR96              */
/*                      S01408             DATE 23JUN95              */
/*                      S01421             DATE 09AUG93              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER049 - Stamp Tax                                          */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       098700 - Retail History not updated with Safe Custody Fees. */
/*                Copy records from GESC1PD to REEODPF if Safe Cust. */
/*                Fees installed.                                    */
/*       CRE003  -  Ledger Balance Accruals                          */
/*       S01408  -  Addition of core hook REC3650MPE                 */
/*       S01421  -  BLI development phase one.                       */
/*                  - Includes changes for:                          */
/*                    S01423 - Merge new postings files GEHM2PD      */
/*                             and GENA2PD into REEODPF.             */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/************DCL********VAR(&FRF) TYPE(*CHAR) LEN(8) VALUE(TABTB55)    *CRE003*/
             DCL        VAR(&FRF) TYPE(*CHAR) LEN(8) VALUE(SDRETLPD)  /*CRE003*/
             DCL        VAR(&TOF) TYPE(*CHAR) LEN(7) VALUE(REEODPF)
             DCL        VAR(&S01423) TYPE(*CHAR) LEN(7)               /*S01421*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*S01421*/
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*098700*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*098700*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*098700*/
/*/COPY WNCPYSRC,REC3650001                                          */
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CER049*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CER049*/
/************DCLF*******FILE(TABTB55) RCDFMT(TABTB55F)                 *CRE003*/
             DCLF       FILE(SDRETLPD) RCDFMT(SDRETLD0)               /*CRE003*/
             RCVF
             MONMSG     MSGID(CPF4101) EXEC(GOTO CMDLBL(EXIT1))
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)
/**/
             SNDPGMMSG  MSG('REC3650 - Retail Accounts Posting Merge +
                          - ANWD2') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(REEODPF)
             MONMSG     MSGID(CPF3133 CPF3141) EXEC(GOTO CMDLBL(EXIT2))
             MONMSG     MSGID(CPF3142) EXEC(GOTO CMDLBL(EXIT3))
/**/
/************IF*********COND(&CBAI = 'Y') THEN(DO)                     *CRE003*/
             IF         COND(&BMCBAI = 'Y') THEN(DO)                  /*CRE003*/
             CHGVAR     VAR(&FRF) VALUE(CLEAR2PD)
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/                                                                  /*CRE003*/
             IF         COND(&BMCBAI *NE 'Y') THEN(DO)                /*CRE003*/
             CHGVAR     VAR(&FRF) VALUE(CLEAR2PD)                     /*CRE003*/
             CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RECI *EQ 'P') (*AND RIND *EQ +
                          1) (*AND SPOS *EQ '  GE-IC')) FMTOPT(*MAP +
                          *DROP)                                      /*CRE003*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CRE003*/
             ENDDO                                                    /*CRE003*/
/**/
             IF         COND(%SST(&MMOD 2 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE(GEDL2PD)
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/
             IF         COND((%SST(&MMOD 4 1) = 'Y') *OR (%SST(&MMOD +
                          10 1) = 'Y')) THEN(DO)
             CHGVAR     VAR(&FRF) VALUE(GELE2PD)
             CPYF       FROMFILE(&FRF) TOFILE(&TOF)    +
                          MBROPT(*ADD) INCREL((*IF RIND *EQ 1) (*AND +
                          RECI *EQ 'P')) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO EXIT1)
           ENDDO
/**/
           IF COND((%SST(&MMOD 5 1) = 'Y') *OR +
                (%SST(&MMOD 21 1) = 'Y')) THEN(DO)
               CHGVAR     VAR(&FRF) VALUE(GEST1PD)
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
/* Save custody postings */                                           /*098700*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*098700*/
/* */                                                                 /*098700*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*098700*/
               CHGVAR     VAR(&FRF) VALUE('GESC1PD')                  /*098700*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*098700*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*098700*/
             ENDDO                                                    /*098700*/
             ENDDO
/**/
             IF         COND(%SST(&MMOD 57 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE(GEFP2PD)
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/
             IF         COND(%SST(&MMOD 50 1) = 'Y') THEN(DO)
               CHGVAR     VAR(&FRF) VALUE(GEFF2PD)
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ P)) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))
             ENDDO
/**/                                                                  /*CPM005*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &AOFMT)     /*CPM005*/
             IF         COND((&RTCD *EQ '       ') *AND (%SST(&AOFMT +
                          65 1) *EQ 'Y')) THEN(DO)                    /*CPM005*/
                CHGVAR     VAR(&FRF) VALUE(GEPM2PD)                   /*CPM005*/
                CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                           INCREL((*IF RIND *EQ 1) (*AND RECI *EQ +
                           'P')) FMTOPT(*MAP *DROP)                   /*CPM005*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                           CMDLBL(EXIT1))                             /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*S01421*/
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
               CHGVAR     VAR(&FRF) VALUE('GEHM2PD')                  /*S01421*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*S01421*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*S01421*/
/**/                                                                  /*S01421*/
/* Copy Numbered Account generated entries file to REEODPF */         /*S01421*/
/**/                                                                  /*S01421*/
               CHGVAR     VAR(&FRF) VALUE('GENA2PD')                  /*S01421*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*S01421*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*S01421*/
                                                                      /*S01421*/
             ENDDO                                                    /*S01421*/
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC3650MPE                                           /*S01408*/
/**/                                                                  /*CSD008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER049*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER049*/
             CHGVAR     VAR(&SAR) VALUE('CER049')                                         /*CER049*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CER049*/
/**/                                                                                      /*CER049*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                      /*CER049*/
/**/                                                                                      /*CER049*/
               CHGVAR     VAR(&FRF) VALUE('GLSTDTPD')                                     /*CER049*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                             INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                             FMTOPT(*MAP *DROP)                                           /*CER049*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                             CMDLBL(EXIT1))                                               /*CER049*/
/*                                                                                        /*CER049*/
/**Clear file GLGESTPD                                                                    /*CER049*/
/*                                                                                        /*CER049*/
               CLRPFM     FILE(GLGESTPD)                                                  /*CER049*/
               MONMSG     MSGID(CPF0000)                                                  /*CER049*/
                                                                                          /*CER049*/
             ENDDO                                                                        /*CER049*/
/**/
/*  Check if CSD008 SAR (Customer Service Fees) is switched on */     /*CSD008*/
/**/                                                                  /*CSD008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSD008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CSD008' &AOFMT)                            /*CSD008*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CSD008*/
               CHGVAR     VAR(&FRF) VALUE('GEFE2PD')                  /*CSD008*/
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)                          /*CSD008*/
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(GOTO +
                          CMDLBL(EXIT1))                              /*CSD008*/
             ENDDO                                                    /*CSD008*/
/**/                                                                  /*S01408*/
             GOTO       CMDLBL(ENDCL)
/**/
EXIT1:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &FRF *TCAT ' not +
                          found - REC3650')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
EXIT2:
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('Member of file ' *CAT &TOF +
                          *TCAT ' not found - REC3650')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDCL)
/**/
EXIT3:
/**/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('File ' *CAT &TOF *TCAT ' not +
                          found - REC3650')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCL:
/**/
             ENDPGM
