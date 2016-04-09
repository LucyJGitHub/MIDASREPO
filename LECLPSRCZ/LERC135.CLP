/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fee Calcs, Update & Acc Key Gen')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC135 - Fee calculations & accruals (COB)                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD027396           Date 19Aug14              */
/*       Prev Amend No. AR996830           Date 25Nov12              */
/*                      AR1055539          Date 12Nov12              */
/*                      263074             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/*                      CLE139             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      243496B            Date 12Apr07              */
/*                      245803             Date 20Feb07              */
/*                      243496             Date 24Nov06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL045             Date 14Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 153736             Date 11Feb99              */
/*                      CLE007             Date 22May97              */
/*                      095606             Date 08Nov95              */
/*                      BH3479             Date 14Aug92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027396 - XPSTTOM not being cleared before component starts*/
/*                  that causes previous days posting posts again.   */
/*       AR996830 - Incorrect accrual postings after holiday.        */
/*                  Skip transfer of PSTTOM to LKEYFED in LERC135    */
/*                  seq 00003 as LKEYFEx is being cleared when       */
/*                  LERC13 seq 00001 runs. Also apply AR966477 as    */
/*                  preventive fix. (Child: AR996832)                */
/*       AR1055539 - Various errors encountered in COB during       */
/*                   Link Test                                      */
/*       263074 - Wrong Postings when interest and principal are     */
/*                paid on the same day (Recompile)                   */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CLE139 - Lending Fee Capitalisation                         */
/*       243496B- Reinstated fix 243496.                             */
/*       245803 - Reverse fix 243496.                                */
/*       243496 - Use the Fee Adjustment Amt FEAMTA from PF/LEFEAM   */
/*                Applied 216123 (plus re-open & 221326 correction). */
/*              - Clear PF/LEFEAM before calling LER135.             */
/*       CDL045 - Copy out Account Keys file to Extract library      */
/*                as specified on the System Value parameter.        */
/*                'AccountKeysSavedLib'                              */
/*                Upgrade CAR to Midas Plus 1.2                      */
/*       153736 - Restart recovery processing added for LEFHST       */
/*       CLE007 - Customer Lending Enhancements - Others             */
/*       095606 - Moved clearing of LEFEEAD from LERC17 to here as   */
/*                fee settlements/adjustment/write-off were not      */
/*                being processed as LERC17 was made to run first    */
/*                after having applied fix 045700.                   */
/*       BH3479 - Correction to posting of payment date fee accruals */
/*                                                                   */
/*********************************************************************/
 
/**********PGM  PARM(&CNAM &CSEQ)           */                                            /*CLE139*/
/*PGM  PARM(&CNAM &CSEQ &CCAP) */                                                  /*CLE139 CLE134*/
             PGM        PARM(&CNAM &CSEQ &CCAP &RERUN)                                    /*CLE134*/
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
     DCL VAR(&CCAP) TYPE(*CHAR) LEN(1)                                                    /*CLE139*/
             DCL        VAR(&RERUN)  TYPE(*CHAR) LEN(10)                                  /*CLE134*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CLE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CLE007*/
             DCL        VAR(&CLE007) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CLE007*/
             DCL        VAR(&CLE005) TYPE(*CHAR) LEN(1) VALUE(' ')    /*153736*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CDL045*/
             DCL        VAR(&LKEY1) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&LKEY2) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                                   /*CDL045*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CLE134*/
             DCL        VAR(&SLC) TYPE(*CHAR) LEN(512)                                    /*CLE134*/
             DCL        VAR(&TOLIB)   TYPE(*CHAR) LEN(10)                                 /*CLE134*/
/*/COPY WNCPYSRC,LEH01134                                            */
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                    */          /*CDL045*/
                                                                                          /*CDL045*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CLE134*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRFX *TCAT 'DPLIB')                            /*CLE134*/
             CHGVAR     VAR(&SLC) VALUE('FECALT *NE ''90''')                              /*CLE134*/
/**/                                                                                      /*CLE134*/
/*/COPY WNCPYSRC,LEH01135                                            */
/* Check if Enhancement Number CDL045 is present.   */                                    /*CDL045*/
/*                                                  */                                    /*CDL045*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL045*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL045*/
             CHGVAR     VAR(&SAR) VALUE('CDL045')                                         /*CDL045*/
                                                                                          /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL045) VALUE('Y'))                                        /*CDL045*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                                                 /*CDL045*/
                                                                                          /*CDL045*/
         IF  COND(&CDL045 *EQ 'Y') THEN(DO)                                               /*CDL045*/
                                                                                          /*CDL045*/
      /* Call AOSVALR0 to get system values for 'AccountKeysSavedLib' */                  /*CDL045*/
                                                                                          /*CDL045*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC  +
                          'AccountKeysSavedLib' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CDL045*/
                                                                                          /*CDL045*/
/* If there is an error finding any system value then end abnormally */                   /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(DBERR))                                                  /*CDL045*/
                                                                                          /*CDL045*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)           */            /*CDL045 CLE134*/
                                                                                          /*CDL045*/
/* Set value of extract library */                                                        /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&LKEY1) VALUE(&PRFX *CAT 'LKEYFED')                           /*CDL045*/
             CHGVAR     VAR(&LKEY2) VALUE(&PRFX *CAT 'LKEYFED2')                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/**/                                                                                      /*CLE134*/
/** Check if Enhancement Number CLE134 is present. */                                     /*CLE134*/
/**/                                                                                      /*CLE134*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE134*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE134*/
             CHGVAR     VAR(&SAR) VALUE('CLE134')                                         /*CLE134*/
/**/                                                                                      /*CLE134*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE134*/
/**/                                                                                      /*CLE134*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                           VAR(&CLE134) VALUE('Y'))                                       /*CLE134*/
/*                                                  */                /*CLE007*/
/* Check if Enhancement Number CLE007 is present.   */                /*CLE007*/
/*                                                  */                /*CLE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE007*/
             CHGVAR     VAR(&SAR) VALUE('CLE007')                     /*CLE007*/
                                                                      /*CLE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CLE007*/
                                                                      /*CLE007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE007) VALUE('Y'))                    /*CLE007*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                             /*CLE007*/
     SNDPGMMSG  MSG('Fee Accruals and Account Key Generation') +
                TOMSGQ(MRUNQ)
                                                                      /*153736*/
/* Check if Enhancement Number CLE005 is present.   */                /*153736*/
/*                                                  */                /*153736*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*153736*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*153736*/
             CHGVAR     VAR(&SAR) VALUE('CLE005')                     /*153736*/
                                                                      /*153736*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*153736*/
                                                                      /*153736*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE005) VALUE('Y'))                    /*153736*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(DBERR)))                             /*153736*/
                                                                      /*153736*/
     SNDPGMMSG  MSG('Fee Accruals and Account Key Generation') +
                TOMSGQ(MRUNQ)                                         /*153736*/
/**/                                                                                      /*CLE134*/
     IF         COND(&RERUN *EQ '      ') THEN(DO)                                        /*CLE134*/
     CLRPFM     FILE(LEPK2DPD)                                                            /*CLE134*/
     CLRPFM     FILE(LEPK2ZZ)                                                             /*CLE134*/
     CLRPFM     FILE(LEPK2HH)                                                             /*CLE134*/
     ENDDO                                                                                /*CLE134*/
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
     IF COND(&STAT *EQ 'Y') THEN(DO)
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             CPYF       FROMFILE(XLEFEAM) TOFILE(LEFEAM) +
                          MBROPT(*REPLACE)                                                /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEFEAM))                                                   /*CLE134*/
             CPYF       FROMFILE(XLEPK2DPD) TOFILE(LEPK2DPD) +
                          MBROPT(*REPLACE)                                                /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPK2DPD))                                                 /*CLE134*/
             CPYF       FROMFILE(XLEPK2ZZ) TOFILE(LEPK2ZZ) +
                          MBROPT(*REPLACE)                                                /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEPK2ZZ))                                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
 
            CPYF FROMFILE(XLEFEED) TOFILE(LEFEED) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEFEED))
            CPYF FROMFILE(XLEPFFD) TOFILE(LEPEFFD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFFD))
            CPYF FROMFILE(XLEPFFZ) TOFILE(LEPEFFZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEFFZ))
            CPYF FROMFILE(XLKEYFD) TOFILE(LKEYFED) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LKEYFED))
            CPYF FROMFILE(XLKEYFZ) TOFILE(LKEYFEZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LKEYFEZ))
             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                                /*CLE134*/
            CPYF FROMFILE(XLOAMSDK) TOFILE(LOAMSDK) MBROPT(*REPLACE)                      /*CLE139*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LOAMSDK))                                             /*CLE139*/
            CPYF FROMFILE(XLOAMSZ1) TOFILE(LOAMSZ1) MBROPT(*REPLACE)                      /*CLE139*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LOAMSZ1))                                             /*CLE139*/
             ENDDO                                                                        /*CLE134*/
/*/COPY WNCPYSRC,LEH01177                                            */
                                                                      /*153736*/
    IF  COND(&CLE005 *EQ 'Y') THEN(DO)                                /*153736*/
            CPYF FROMFILE(XLEFHST) TOFILE(LEFHST) MBROPT(*REPLACE)    /*153736*/
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEFHST))                          /*153736*/
     ENDDO                                                            /*153736*/
                                                                      /*153736*/
     CPYF       FROMFILE(XPSTTOM) TOFILE(PSTTOM) MBROPT(*REPLACE) /*BH3479*/
     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                CMDLBL(NEXT))                                     /*BH3479*/
 
     IF  COND(&CLE007 *EQ 'Y') THEN(DO)                               /*CLE007*/
     CPYF        FROMFILE(XLEPXTAA) TOFILE(LEPXTAA) MBROPT(*REPLACE)  /*CLE007*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPXTAA)) /*CLE007*/
     CPYF        FROMFILE(XLEPXTAB) TOFILE(LEPXTAB) MBROPT(*REPLACE)  /*CLE007*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPXTAB)) /*CLE007*/
     CPYF        FROMFILE(XLEPXTAC) TOFILE(LEPXTAC) MBROPT(*REPLACE)  /*CLE007*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPXTAC)) /*CLE007*/
     ENDDO                                                            /*CLE007*/
                                                                      /*CLE007*/
     ENDDO
/* Take Security Copy of ALL Files */
     ELSE DO
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             DLTF       FILE(XLEFEAM)                                                     /*CLE134*/
             MONMSG     MSGID(CPF2105)                                                    /*CLE134*/
             DLTF       FILE(XLEPK2DPD)                                                   /*CLE134*/
             MONMSG     MSGID(CPF2105)                                                    /*CLE134*/
             DLTF       FILE(XLEPK2ZZ)                                                    /*CLE134*/
             MONMSG     MSGID(CPF2105)                                                    /*CLE134*/
             CPYF       FROMFILE(LEPK2DPD) TOFILE(&TOLIB/XLEPK2DPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             CPYF       FROMFILE(LEPK2ZZ) TOFILE(&TOLIB/XLEPK2ZZ) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             CPYF       FROMFILE(LEFEAM) TOFILE(&TOLIB/XLEFEAM) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             ENDDO                                                                        /*CLE134*/
 
     CLRPFM XPSTTOM                                                                     /*MD027396*/
     CPYF       FROMFILE(LEFEED) TOFILE(XLEFEED) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFEED))
     CPYF       FROMFILE(LEPEFFD) TOFILE(XLEPFFD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFFD))
     CPYF       FROMFILE(LEPEFFZ) TOFILE(XLEPFFZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPFFZ))
     CPYF       FROMFILE(LKEYFED) TOFILE(XLKEYFD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLKEYFD))
     CPYF       FROMFILE(LKEYFEZ) TOFILE(XLKEYFZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLKEYFZ))
             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                                /*CLE134*/
     CPYF       FROMFILE(LOAMSDK) TOFILE(XLOAMSDK) MBROPT(*REPLACE)                       /*CLE139*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLOAMSDK))                    /*CLE139*/
     CPYF       FROMFILE(LOAMSZ1) TOFILE(XLOAMSZ1) MBROPT(*REPLACE)                       /*CLE139*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLOAMSZ1))                    /*CLE139*/
             ENDDO                                                                        /*CLE134*/
/*/COPY WNCPYSRC,LEH01178                                            */
                                                                      /*153736*/
    IF  COND(&CLE005 *EQ 'Y') THEN(DO)                                /*153736*/
             CPYF       FROMFILE(LEFHST) TOFILE(XLEFHST) +
                          MBROPT(*REPLACE) CRTFILE(*NO)               /*153736*/
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFHST)) /*153736*/
    ENDDO                                                             /*153736*/
                                                                      /*153736*/
                                                                      /*CLE007*/
    IF  COND(&CLE007 *EQ 'Y') THEN(DO)                                /*CLE007*/
    CPYF        FROMFILE(LEPXTAA) TOFILE(XLEPXTAA) MBROPT(*REPLACE)   /*CLE007*/
    MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPXTAA)) /*CLE007*/
    CPYF        FROMFILE(LEPXTAB) TOFILE(XLEPXTAB) MBROPT(*REPLACE)   /*CLE007*/
    MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPXTAB)) /*CLE007*/
    CPYF        FROMFILE(LEPXTAC) TOFILE(XLEPXTAC) MBROPT(*REPLACE)   /*CLE007*/
    MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPXTAC)) /*CLE007*/
    ENDDO                                                             /*CLE007*/
                                                                      /*CLE007*/
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* If there are any account keys from yesterday run the RPG to      BH3479*/
/* copy the account keys and to report them as being for posting    BH3479*/
/* today                                                            BH3479*/
 
     CPYF       FROMFILE(PSTTOM) TOFILE(XPSTTOM) MBROPT(*REPLACE) /*BH3479*/
     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                CMDLBL(NEXT))                                     /*BH3479*/
 
     ENDDO
 
             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                                /*CLE134*/
             IF         COND(&CSEQ *NE 3) THEN(DO)                                      /*AR996830*/
            CALL LER134                                           /*BH3479*/
 
     IF COND(%SWITCH(XXXXXX00)) THEN(DO)                          /*BH3479*/
                                                                  /*BH3479*/
       IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                          /*CLE134*/
         CLRPFM     FILE(LEPKTDPD)                                                        /*CLE134*/
       ENDDO                                                                              /*CLE134*/
/**/                                                                                      /*CLE134*/
    CLRPFM PSTTOM                                                 /*BH3479*/
     ENDDO                                                        /*BH3479*/
     ELSE CMD(DO)                                                 /*BH3479*/
            SNDPGMMSG  MSG('Job terminated, database in error.') +
                                        TOMSGQ(MOPERQ MRUNQ)      /*BH3479*/
     GOTO END                                                     /*BH3479*/
 
     ENDDO                                                        /*BH3479*/
             ENDDO                                                                      /*AR996830*/
             ENDDO                                                                        /*CLE134*/
 
 NEXT:
 
/****Clear*PF/LEFEAM*before*calling*LER135*****************************/           /*216123 245803*/
/*           CLRPFM     LEFEAM                                        */           /*216123 245803*/
  /* Clear PF/LEFEAM before calling LER135 */                                            /*243496B*/
             CLRPFM     LEFEAM                                                           /*243496B*/
  /* Call Fee Accruals & account Key Generation Program */
 
             OPNQRYF    FILE((LEFEED)) OPTION(*ALL) QRYSLT(&SLC)                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(OVRDBF +
                          FILE(LKEYFED) TOFILE(LEPK2DPD))                                 /*CLE134*/
/*/COPY WNCPYSRC,LEH01138                                            */
/**********  CALL       LER135                          */                                /*CLE139*/
/**********  CALL       PGM(LER135) PARM(&CCAP)  */                                /*CLE139 CLE134*/
/**********  CALL       PGM(LER135) PARM(&CCAP &CNAM)   */                      /*CLE134 AR1055539*/
             CALL       PGM(LER135) PARM(&CCAP &RERUN)                                 /*AR1055539*/
             CLOF       OPNID(LEFEED)                                                     /*CLE134*/
/*/COPY WNCPYSRC,LEH01139                                            */
 
  /* IF ERROR SEND MSG      */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/***********SNDPGMMSG  MSG('Job terminated, database in error.') +/*  /*CLE007*/
 DBERR:      SNDPGMMSG  MSG('Job terminated, database in error.') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CLE007*/
 
     ENDDO
     ELSE CMD(DO)
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to Extract library   */                         /*CDL045*/
                                                                                          /*CDL045*/
         IF  COND(&CDL045 *EQ 'Y') THEN(DO)                                               /*CDL045*/
                                                                                          /*CDL045*/
 /* If component completes sucessfully, capture files into Extract library */             /*CDL045*/
  /*If Accrual Non-working Day process */                                                 /*CDL045*/
             IF         COND(&CSEQ = 00002) THEN(DO)                                      /*CDL045*/
             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                                /*CLE134*/
             CPYF       FROMFILE(LKEYFED) TOFILE(&EXTLIB/&LKEY2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&LKEY2))                                           /*CDL045*/
             ENDDO                                                                        /*CLE134*/
             ELSE       CMD(DO)                                                           /*CLE134*/
             CPYF       FROMFILE(LKEYFED) TOFILE(&EXTLIB/&LKEY2) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             ENDDO                                                                        /*CLE134*/
                          ENDDO                                                           /*CDL045*/
  /* Daily Run */                                                                         /*CDL045*/
             ELSE       CMD(DO)                                                           /*CDL045*/
             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                                /*CLE134*/
             CPYF       FROMFILE(LKEYFED) TOFILE(&EXTLIB/&LKEY1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&LKEY1))                                                   /*CDL045*/
             ENDDO                                                                        /*CLE134*/
             ELSE       CMD(DO)                                                           /*CLE134*/
             CPYF       FROMFILE(LKEYFED) TOFILE(&EXTLIB/&LKEY1) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             ENDDO                                                                        /*CLE134*/
  /* Clear out ANWD files*/                                                               /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&LKEY2)                                              /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             ENDDO                                                                        /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
 
/* If the component has completed successfully reset the status field */
 
     IF COND(&CLE007 *NE 'Y') THEN(DO)                                /*CLE007*/
     CLRPFM LEFEEAD                                                  /*095606*/
     ENDDO                                                            /*CLE007*/
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*/COPY WNCPYSRC,LEH01136                                            */
 
     ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
