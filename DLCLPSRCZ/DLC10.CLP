/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL SHADOW POSTING FOR DEALING')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC10 - SHADOW POSTING FOR DEALING                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD048795           Date 15Jan18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      BUG23732           Date 23Apr09              */
/*                      BUG23123           Date 09Mar09              */
/*                      BUG23008           Date 20Feb09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      234650             Date 04Jul05              */
/*                      CAS009             Date 04May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007             Date 11May01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186804             Date 23Nov00              */
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CDL002             Date 22Sep97              */
/*                      S01408             Date 03Sep96              */
/*                      S01408            DATE  30AUG96             */
/*                      090404            DATE  27SEP95             */
/*                      075876            DATE  28OCT94             */
/*                      BHF124            DATE  12JUN90             */
/*                      S01117            DATE  17/07/89            */
/*                      S01194            DATE  17/07/89            */
/*                      S05452            DATE  20/08/87            */
/*                      E10216            DATE  25/03/87            */
/*                      E10090            DATE  28/11/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD048795 - Added FX0960 call for FX Netting Projections     */
/*                  generation when settlement is retail             */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG23732- Joint Account threshold                           */
/*       BUG23123 - Report: Does not show Retail Account Number      */
/*                          Date is not Midas Standard Date          */
/*                          Period should be actual int. calc. period*/
/*                          Secondary Tax amount is not printed      */
/*                          Added field TSSLID                       */
/*                          (Recompile)                              */
/*       BUG23008 - Cannot Agree Thresholds or Utilisations after COB*/
/*       234650 - Tax amount does not appear on Projected A/c        */
/*                Movement.                                          */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CIR007 - Overnight Index Swaps                              */
/*       186804 - Distinguish if program was called from             */
/*                input cycle termination or initiation              */
/*       CDL008 - Continuous Linked Settlement                       */
/*       CDL002 - FX Netting. Clear Netting Actions file before     */
/*                DL0295                                            */
/*       S01408  -  Add hook DLC10END                               */
/*       S01408  -  Add hook DLC10INT                               */
/*               -  Add hook DLC10MPS                               */
/*               -  Add hook DLC10MPE                               */
/*       090404  -  WHEN CALLING DL0265 AND DL0280 THE RUNDATE SEEMS*/
/*                  TO BEEN THE PREVIOUS ONE.                       */
/*       075876  -  CLEAR OUT FILES DAPCLI, DAPCLH AND DAPCLJ       */
/*                  AND RUN DL4040 TO PREVENT FCOOB IN DL0280       */
/*                  IF DBASE RESTORED FROM NDSU BACKUP.             */
/*       BHF124  -  CALLS TO DL0280,DL0295 NEED NO PARAMETERS       *  *S05452*/
/*       S01117  -  MULTIBRANCHING                                  *  *S05452*/
/*       S01194  -  STANDING DATA CHANGES                           *  *S05452*/
/*       S05452  -  INCLUSION OF AUTO RECONCILIATIONS               *  *S05452*/
/*       E10216  -  IF PROGRAM FAILS DUE TO POSTING REF BEING       *  *E10216*/
/*                  OTHER THAN '1' MESSAGE AND REPORT DO NOT        *  *E10216*/
/*                  REFLECT THIS.                                   *  *E10216*/
/*       E10090  -  CALL SD0670 BEFORE CALLING DL0280 TO PUT        *  *E10090*/
/*                  RECORDS INTO TABTG30, THUS AVOIDING DB ERROR    *  *E10090*/
/*                  DURING FIRST I/C INITIATION AFTER UPGRADE TO R21*  *E10090*/
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01117*/
/************PGM PARM(&RSEQ &RLEV &RENT)                   /*S01117*/ /*BHF124*/
             PGM                                                      /*BHF124*/
/**/
/*/COPY WNCPYSRC,DLC10003                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number * /*S01117**BHF124*/
/**DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)/*S01117**BHF124*/
/**DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code       /*S01117**BHF124*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)       /*S05452* /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE(*FREE)    /*090404*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*090404*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CDL002*/
           DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')  /*090404*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CDL008*/
             DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL008*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*CDL008*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  +
                          DPLIB')                                     /*CDL008*/
             DCL        VAR(&CIR007) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CIR007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CAS009*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CAS009*/
                                                                                          /*CAS009*/
/*/COPY WNCPYSRC,DLC10INT                                             /*S01408*/
/**/
/* CALL AOBANKR0 FIRST WITH *FREE TO RETRIEVE CURRENT VALUE             090404*/
             CALL       PGM(AOBANKR0) PARM(&RTCD &OPTN &FMT)          /*090404*/
/**/
             CHGJOB     SWS(00000000)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CAS009*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CAS009*/
/**/
/*/COPY WNCPYSRC,DLC10004                                            */
             CLRPFM     FILE(GEDLMHH)
             CLRPFM     FILE(GEDLMPD)
             CLRPFM     FILE(GEDLMZZ)
/**/
/*        DEAL AMENDMENTS FILE UPDATE PHASE 2                        */
/**/
/*           CLEAR PF/FILES IN LF/DAMSX                              */
             CLRPFM     FILE(DAMEXDH)      /* CLEAR DEAL AMENDMENTS  */
             CLRPFM     FILE(DAMEXDI)
             CLRPFM     FILE(DAMEXDJ)
             CLRPFM     FILE(DAMBRDH)      /* CLEAR BASE RATE AMENDS */
             CLRPFM     FILE(DAMBRDI)
             CLRPFM     FILE(DAMBRDJ)
             CLRPFM     FILE(DAPCLI)                                  /*075876*/
             CLRPFM     FILE(DAPCLH)                                  /*075876*/
             CLRPFM     FILE(DAPCLJ)                                  /*075876*/
             OVRDBF     FILE(DAOUTDH) TOFILE(DAMEXDH)
             OVRDBF     FILE(DAOUTDI) TOFILE(DAMEXDI)
             OVRDBF     FILE(DAOUTDJ) TOFILE(DAMEXDJ)
                                                                                          /*CIR007*/
/** Check for Switchable feature CIR007                            */                     /*CIR007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR007*/
             CHGVAR     VAR(&SAR) VALUE('CIR007')                                         /*CIR007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                                           &SFMT)                                         /*CIR007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR007) VALUE('Y'))                                        /*CIR007*/
/**/
/*    Clear Net Actions file before reuse in DL0295 if FX Netting on * *CDL002*/
/**/                                                                  /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002' +
                          &SFMT)                                      /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CDL002*/
                CLRPFM     FILE(FXNACTPD)                             /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL008*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                     /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' &SAR +
                          &SFMT)                                      /*CDL008*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL008) VALUE('Y'))                      /*CDL008*/
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS009*/
           CHGVAR     VAR(&SAR)  VALUE('CAS009')                                          /*CAS009*/
                                                                                          /*CAS009*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR  &SCSARD)                       /*CAS009*/
                                                                                          /*CAS009*/
           CHGVAR     VAR(&CAS009) VALUE('N')                                             /*CAS009*/
           IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                                /*CAS009*/
                                                                      /*CDL008*/
             IF         COND(&CDL008 = 'Y') THEN(DO)                  /*CDL008*/
                                                                      /*CDL008*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)        */              /*CDL008 CAS009*/
/**********  CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)  */              /*CDL008 CAS009*/
             DLTF       FILE(XFXCLSPSH)                               /*CDL008*/
             MONMSG     MSGID(CPF2105)                                /*CDL008*/
                                                                      /*CDL008*/
             CPYF       FROMFILE(FXCLSPSH) TOFILE(&DPLIB/XFXCLSPSH) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*CDL008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CDL008*/
                                                                      /*CDL008*/
             ENDDO                                                    /*CDL008*/
             IF COND((&CAS009) *EQ 'Y') THEN(DO)                                          /*CAS009*/
             DLTF       FILE(XMMEIRDPD)                                                   /*CAS009*/
             MONMSG     MSGID(CPF2105)                                                    /*CAS009*/
             CPYF       FROMFILE(MMEIRDPD) TOFILE(&DPLIB/XMMEIRDPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CAS009*/
             MONMSG     MSGID(CPF2817)                                                    /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/**/                                                                  /*CDL002*/
             OVRDBF     FILE(DAMSIN) TOFILE(DEAMS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/

             CALL       PGM(DL4040)                                   /*075876*/
/**/                                                                  /*075876*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*075876*/
/**/                                                                  /*075876*/
/*PROGRAM ONLY PRODUCES AN AUDIT TRAIL SO NO NEED FOR RCF PROCESSING */
             CALL       PGM(DL0265)
             DLTOVR     FILE(*ALL)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*E10090*/
/**/                                                                  /*E10090*/
             CLRPFM     FILE(TABTG30)                                 /*E10090*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABSDU)         /*E10090*/ /*S01194*/
/*/COPY WNCPYSRC,DLC10006                                            */
             OVRDBF     FILE(PHASD) TOFILE(PHASA)                     /*E10090*/
             CHGJOB     SWS(00000000)                                 /*E10090*/
             CALL       SD0670                                        /*E10090*/
             DLTOVR     FILE(*ALL)                                    /*E10090*/
/**/                                                                  /*E10090*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                CHGJOB     SWS(00000000)
/**/
/*        DEALS FILE UPDATE PHASE 2  (CREATE ACCOUNT KEYS FILES)     */
/**/
                CLRPFM     FILE(DKEYSHH)
                CLRPFM     FILE(DKEYSDP)
                CLRPFM     FILE(DKEYSZZ)
                CLRPFM     FILE(XSDCSINPD)                                                /*234650*/
/************** OVRDBF     FILE(TABLE)  TOFILE(TABDLEI) SHARE(*NO)    /*S01194*/
/************** OVRDBF     FILE(TABLED) TOFILE(TABDLEI) SHARE(*NO)    /*S01194*/
                OVRDBF     FILE(DLUPD) TOFILE(DEALS)
                OVRDBF     FILE(SDCSINPD) TOFILE(XSDCSINPD)                               /*234650*/
                OVRDBF     FILE(SDCSINL6) TOFILE(XSDCSINL6)                               /*234650*/
                CPYF       FROMFILE(SDINPHPD) TOFILE(XSDINPHPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                             /*BUG23008*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XSDINPHPD))                                           /*BUG23008*/
                OVRDBF     FILE(SDINPHL2) TOFILE(XSDINPHL2)                             /*BUG23008*/
                OVRDBF     FILE(SDINPHL1) TOFILE(XSDINPHL1)                             /*BUG23732*/
                OVRDBF     FILE(SDINPHL3) TOFILE(XSDINPHL3)                             /*BUG23732*/
/************** CALL       PGM(DL0280)                                /*S01117*/
/************** CALL       PGM(DL0280) PARM(&RSEQ &RENT)   /*S01117*/ /*BHF124*/
/*/COPY WNCPYSRC,DLC10MPS                                             /*S01408*/
                CALL       PGM(DL0280)                                /*BHF124*/
/*/COPY WNCPYSRC,DLC10MPE                                             /*S01408*/
                DLTOVR     FILE(*ALL)
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                             /*MD048795*/
                  CALL       PGM(FX0960)                                                /*MD048795*/
                ENDDO                                                                   /*MD048795*/
/*/COPY WNCPYSRC,DLC10002                                            */
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/*/COPY WNCPYSRC,DLC10001                                            */
                                                                                          /*CIR007*/
/** If CIR007 is installed, call program DL1654                    */                     /*CIR007*/
             IF         COND(&CIR007 *EQ 'Y') THEN(DO)                                    /*CIR007*/
                                                                                          /*CIR007*/
/* Call DL1654 to merge the OIS posting records into DKEYSDP       */                     /*CIR007*/
             CHGJOB     SWS(X1XXXXXX)                                                     /*CIR007*/
             CALL       PGM(DL1654)                                                       /*CIR007*/
                                                                                          /*CIR007*/
/* If Database error send message else carry on normal processing  */                     /*CIR007*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CIR007*/
             SNDPGMMSG  MSG('DATABASE IN ERROR - DL1654') +
                          TOMSGQ(MRUNQ MOPERQ)                                            /*CIR007*/
             ENDDO                                                                        /*CIR007*/
             ENDDO                                                                        /*CIR007*/
                                                                                          /*CIR007*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                                  /*CIR007*/
                                                                                          /*CIR007*/
/*        SHADOW POST  (CREATE POSTINGS FILES)                       */
                   CHGJOB     SWS(01000000)       /* RETAIL PRESENT  */
/**/
/***************** OVRDBF     FILE(TABLE)  TOFILE(TABDLEI) SHARE(*NO) /*S01194*/
/***************** OVRDBF     FILE(TABLED) TOFILE(TABDLEE) SHARE(*NO) /*S01194*/
                   OVRDBF     FILE(GEDLHH) TOFILE(GEDLMHH)
                   OVRDBF     FILE(GEDLPD) TOFILE(GEDLMPD)
                   OVRDBF     FILE(GEDLZZ) TOFILE(GEDLMZZ)
/***************** CALL       PGM(DL0295)                             /*S01117*/
/***************** CALL       PGM(DL0295) PARM(&RSEQ &RENT)/*S01117*/ /*BHF124*/
                   CALL       PGM(DL0295)                             /*BHF124*/
                   DLTOVR     FILE(*ALL)
/**/
/*/COPY WNCPYSRC,DLC10007                                            */
                                                                                          /*CIR007*/
/* End processing conditional on call to DL1664 not ending in error*/                     /*CIR007*/
                    ENDDO                                                                 /*CIR007*/
                                                                                          /*CIR007*/
                   IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
                      CLRPFM     FILE(DAMEXDH)
                      CLRPFM     FILE(DAMEXDI)
                      CLRPFM     FILE(DAMEXDJ)
                      CLRPFM     FILE(DAMBRDH)
                      CLRPFM     FILE(DAMBRDI)
                      CLRPFM     FILE(DAMBRDJ)
                      CLRPFM     FILE(DKEYSHH)
                      CLRPFM     FILE(DKEYSDP)
                      CLRPFM     FILE(DKEYSZZ)
                                                                      /*CDL008*/
                   IF         COND(&CDL008 = 'Y') THEN(DO)            /*CDL008*/
/***********       CALL       PGM(DL0296) */               /*CDL008*/ /*186804*/
                   CALL       PGM(DL0296) PARM('N')                   /*186804*/
                                                                      /*CDL008*/
/**/                                                                  /*CDL008*/
/*  If no error occured in the program, delete backup file.           /*CDL008*/
/**/                                                                  /*CDL008*/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)        /*CDL008*/
                   DLTF       FILE(XFXCLSPSH)                         /*CDL008*/
                   MONMSG     MSGID(CPF2105)                          /*CDL008*/
                   ENDDO                                              /*CDL008*/
/**/                                                                  /*CDL008*/
/*  If error occured in the program, restore backup file.             /*CDL008*/
/**/                                                                  /*CDL008*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)        /*CDL008*/
                   CPYF       FROMFILE(XFXCLSPSH) TOFILE(FXCLSPSH) +
                              MBROPT(*REPLACE)                        /*CDL008*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(FXCLSPSH))             /*CDL008*/
                   ENDDO                                              /*CDL008*/
                   ENDDO                                              /*CDL008*/
/**/                                                                  /*CDL008*/
/*/COPY WNCPYSRC,DLC10005                                            */
/**/                                                                  /*E10216*/
                      ENDDO                                           /*E10216*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
             ENDDO
/**/
             ENDDO                                                    /*075876*/
/**/                                                                  /*075876*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
                CLRPFM     FILE(GEDLMHH)
                CLRPFM     FILE(GEDLMPD)
                CLRPFM     FILE(GEDLMZZ)
/**/
             ENDDO
/**/
/**********  IF         COND(%SWITCH(XXXXXX01)) THEN(DO)            *  *E10216*/
             IF         COND(%SWITCH(XXXX0X01)) THEN(DO)              /*E10216*/
/**/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - DLC10') +
                             TOMSGQ(MRUNQ MOPERQ)
/**/
             ENDDO
/**/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            *  *E10216*/
             IF         COND(%SWITCH(XXXX0X11)) THEN(DO)              /*E10216*/
/**/
/************   SNDPGMMSG  MSG('DATABASE IN ERROR - DL0295') +
 ************                TOMSGQ(MRUNQ MOPERQ)          */         /*E10090*/
              SNDPGMMSG  MSG('DATABASE IN ERROR - DL0295 OR SD0670') +
                             TOMSGQ(MRUNQ MOPERQ)                     /*E10090*/
/************   RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
/************   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +               /*S01117*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) +
                MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
/**********  IF         COND(%SWITCH(XXX1XX00)) THEN(DO)            *  *E10216*/
             IF         COND(%SWITCH(XXX10X00)) THEN(DO)              /*E10216*/
/**/
                SNDPGMMSG  MSG('ACCOUNT KEYS ARE MISSING - DLC10') +
                             TOMSGQ(MRUNQ MOPERQ)
/**/
             ENDDO
/**/                                                                  /*E10216*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)              /*E10216*/
/**/                                                                  /*E10216*/
             SNDPGMMSG  MSG('ONLY POSTING REFERENCE 1 SHOULD BE USED +
                          FOR THIS ACCRUAL KEY') TOMSGQ(MRUNQ MOPERQ) /*E10216*/
/**/                                                                  /*E10216*/
             ENDDO                                                    /*E10216*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,DLC10END                                         */ /*S01408*/
                                                                     /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
