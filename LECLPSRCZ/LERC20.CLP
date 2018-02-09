/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Automatic Facility update')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC20  - Automatic facility update                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD022082           Date 22Aug13              */
/*                      MD020634           Date 26May13              */
/*                      AR1042505          Date 24Apr13              */
/*                      262509             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE041             Date 11Oct04              */
/*                      BUG3282            Date 17Jun04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005             Date 22May97              */
/*                      CLE004             Date 19Mar97              */
/*                      S01473             Date 20Jul94              */
/*                      BH3524             Date 20Sep92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD022082 - FCLTYFN Differences after check COB 6            */
/*       MD020634 - FCLTYFM/FAMT Difference between C1 and RU        */
/*       AR1042505 - MFU is not included on rebuild of fclty exposure*/
/*                   Call new function LE007057 to update FCLTYFN    */
/*                   with MFU events. (Child: AR1042506)             */
/*       262509 - Empty STAT flag returned by COB                    */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       BUG3282 - Non-RVCR facility amount reduction for maturing   */
/*                 MM loans                                          */
/*       CLE005 - Customer Lending Enhancements - Others             */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       S01473 - Midas Leo Integration.                             */
/*                Addition of processing to update non-revolving     */
/*                facilities for LEO generated repayments.           */
/*       BH3524 - Take security copy of EM facility file.            */
/*                                                                   */
/*********************************************************************/
 
/**********PGM  PARM(&CNAM &CSEQ)    */                                                   /*CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
                                                                      /*S01473*/
/* Declare the variables to check the enhancements file */            /*S01473*/
     DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                         /*S01473*/
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*S01473*/
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473')         /*S01473*/
     DCL        VAR(&SARN) TYPE(*CHAR) LEN(6) VALUE('CLE004')         /*CLE004*/
     DCL        VAR(&SARO) TYPE(*CHAR) LEN(6) VALUE('CLE005')         /*CLE005*/
     DCL        VAR(&SAR1) TYPE(*CHAR) LEN(6) VALUE('CLE025')                            /*BUG3282*/
     DCL        VAR(&CLE005) TYPE(*CHAR) LEN(1) VALUE('N')            /*CLE005*/
     DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                                /*CLE041*/
     DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                        /*S01473*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CLE134*/
 
 
     SNDPGMMSG  MSG('Automatic Facility Update') +
                                       TOMSGQ(MRUNQ)
 
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/* Check the current status of this component */
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CLE134*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *TCAT 'DPLIB')                            /*CLE134*/
             ENDDO                                                                        /*CLE134*/
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/**********IF COND(&STAT *EQ 'N') THEN(DO)                                                /*262509*/
     IF COND(&STAT *NE 'Y') THEN(DO)                                                      /*262509*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
/* Copy records from ACTNPDK to ACTN5DK to be processed by new */                         /*CLE134*/
/* run of LER020 (after PDCL process) ACTNPDK contains MR, RE  */                         /*CLE134*/
/* events that have not  been processed by the first run of    */                         /*CLE134*/
/* LER020 (called by LERC20) because the repayments were subject*/                        /*CLE134*/
/* to funds pre-check Now ACTNPDK contains the actual amount paid*/                       /*CLE134*/
/* and can be processed by LER020. Once LER020 has run,XACTN5DK */                        /*CLE134*/
/* is copied back to ACTN5DK */                                                           /*CLE134*/
/**/                                                                                      /*CLE134*/
            DLTF       FILE(&DPLIB/XACTN5DK)                                              /*CLE134*/
            MONMSG     MSGID(CPF2105)                                                     /*CLE134*/
            CPYF       FROMFILE(ACTN5DK) TOFILE(&DPLIB/XACTN5DK) +
                         MBROPT(*REPLACE) CRTFILE(*YES)                                   /*CLE134*/
            MONMSG     MSGID(CPF2817 CPF2869)                                             /*CLE134*/
            ENDDO                                                                         /*CLE134*/
 
/* IF NOT RERUN Take Security Copy of Facility Files */
 
     CPYF       FROMFILE(FCLTYFM) TOFILE(XFCLTYFM) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XFCLTYFM))
     CPYF       FROMFILE(FCLTYFN) TOFILE(XFCLTYFN) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XFCLTYFN))
     CPYF       FROMFILE(FCLTYZZ) TOFILE(XFCLTYZZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XFCLTYZZ))
/* Start of Change */                                                /*BH3524*/
     CPYF       FROMFILE(EMXT4F1) TOFILE(XEMXT4F1) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XEMXT4F1))
/* End of Change */                                                  /*BH3524*/
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
     ELSE CMD(DO)
 
/* IF RERUN Copy back Security Copy of History Files*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             CLRPFM     FILE(ACTN5DK)                                                     /*CLE134*/
             CPYF       FROMFILE(XACTN5DK) TOFILE(&DPLIB/ACTN5DK) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*CLE134*/
             MONMSG     MSGID(CPF2817 CPF2869)                                            /*CLE134*/
             ENDDO                                                                        /*CLE134*/
     CPYF       FROMFILE(XFCLTYFM) TOFILE(FCLTYFM) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FCLTYFM))
     CPYF       FROMFILE(XFCLTYFN) TOFILE(FCLTYFN) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FCLTYFN))
     CPYF       FROMFILE(XFCLTYZZ) TOFILE(FCLTYZZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FCLTYZZ))
/* Start of Change */                                                /*BH3524*/
     CPYF       FROMFILE(XEMXT4F1) TOFILE(EMXT4F1) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(EMXT4F1))
/* End of Change */                                                  /*BH3524*/
 
     ENDDO
/**/                                                                  /*CLE005*/
/* Check if CLE005 is installed */                                    /*CLE005*/
/**/                                                                  /*CLE005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)    /*CLE005*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE005*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            /*CLE005*/
                 CHGVAR     VAR(&CLE005) VALUE('Y')                   /*CLE005*/
               ENDDO                                                  /*CLE005*/
             ENDDO                                                    /*CLE005*/
/**/                                                                  /*CLE005*/
             IF         COND(&CLE005 = 'Y') THEN(DO)                  /*CLE005*/
               CLRPFM     FILE(LECARDPD)                              /*CLE005*/
               MONMSG     MSGID(CPF3142) EXEC(CHGJOB SWS(XXXXXX11))   /*CLE005*/
             ENDDO                                                    /*CLE005*/
/**/                                                                  /*CLE005*/
/**/                                                                                      /*CLE041*/
/* Check if CLE025 is installed */                                                        /*CLE041*/
/**/                                                                                      /*CLE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR1 &FMT)                        /*CLE041*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE041*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                /*CLE041*/
                 CHGVAR     VAR(&CLE025) VALUE('Y')                                       /*CLE041*/
               ENDDO                                                                      /*CLE041*/
             ENDDO                                                                        /*CLE041*/
/**/                                                                                      /*CLE041*/
             IF         COND(&CLE025 = 'Y') THEN(DO)                                      /*CLE041*/
               CLRPFM     FILE(LEAGRDPD)                                                  /*CLE041*/
               MONMSG     MSGID(CPF3142) EXEC(CHGJOB SWS(XXXXXX11))                       /*CLE041*/
             ENDDO                                                                        /*CLE041*/
/**/                                                                                      /*CLE041*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*MD022082*/
             CALL       PGM(LE007057)                                                  /*AR1042505*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)                       /*AR1042505*/
             ENDDO                                                                      /*MD022082*/
 
/**Add*ACTNPDK*records*to*ACTN5DK***************************************      */ /*CLE134 MD020634*/
/* Add LEACPDPD records to ACTN5DK */                                                   /*MD020634*/
           IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                  /*CLE134*/
/**********CPYF       FROMFILE(ACTNPDK) TOFILE(&DPLIB/ACTN5DK) +
                        MBROPT(*ADD)                                          */ /*CLE134 MD020634*/
           CPYF       FROMFILE(LEACPDPD) TOFILE(&DPLIB/ACTN5DK) +
                        MBROPT(*ADD)                                                    /*MD020634*/
           MONMSG     MSGID(CPF2817 CPF2869)                                              /*CLE134*/
           ENDDO                                                                          /*CLE134*/
           IF         COND(&RERUN *EQ '      ') THEN(DO)                                  /*CLE134*/
             CLRPFM     FILE(LEACPDPD)                                                    /*CLE134*/
           ENDDO                                                                          /*CLE134*/
  /* Call Manual Changes Extract Program */
/**********  CALL LER020 */                                                               /*CLE134*/
             CALL       PGM(LER020) PARM(&RERUN)                                          /*CLE134*/
           IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                  /*CLE134*/
             CLRPFM     FILE(ACTN5DK)                                                     /*CLE134*/
             CPYF       FROMFILE(XACTN5DK) TOFILE(&DPLIB/ACTN5DK) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*CLE134*/
             MONMSG     MSGID(CPF2817 CPF2869)                                            /*CLE134*/
           ENDDO                                                                          /*CLE134*/
/**/                                                                  /*CLE004*/
/* Update of non-revolving participant facilities for repayments */   /*CLE004*/
/* Access switchable features file to see if feature CLE004 */        /*CLE004*/
/* is installed */                                                    /*CLE004*/
/**/                                                                  /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARN &FMT)    /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE004*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CLE004*/
                                                                      /*CLE004*/
/**********  CALL       PGM(LER021) */                                             /*CLE004 CLE134*/
             CALL       PGM(LER021) PARM(&RERUN)                                          /*CLE134*/
                                                                      /*CLE004*/
             ENDDO                                                    /*CLE004*/
             ENDDO                                                    /*CLE004*/
/*                                                                    /*S01473*/
/* Update of non-revolving facilities for LEO repayments. /*          /*S01473*/
/* Access switchable features file to see if feature S01473     +     /*S01473*/
/* is installed                                                       /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01473*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(LER036)                                   /*S01473*/
                                                                      /*S01473*/
             ENDDO                                                    /*S01473*/
             ENDDO                                                    /*S01473*/
/**/                                                                                     /*BUG3282*/
/* Update of non-revolving facilities for Maturing MM Loans  */                          /*BUG3282*/
/* Access switchable features file to see if feature CLE025  */                          /*BUG3282*/
/* is installed */                                                                       /*BUG3282*/
/**/                                                                                     /*BUG3282*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR1 &FMT)                       /*BUG3282*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                               /*BUG3282*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                 /*BUG3282*/
                                                                                         /*BUG3282*/
             CALL       PGM(LE000031)                                                    /*BUG3282*/
                                                                                         /*BUG3282*/
             ENDDO                                                                       /*BUG3282*/
             ENDDO                                                                       /*BUG3282*/
/*                                                                    /*S01473*/
/**/                                                                  /*CLE005*/
/* If CLE005 is installed, call LER022 (Facility Update for */        /*CLE005*/
             IF         COND(&CLE005 = 'Y') THEN(DO)                  /*CLE005*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)            /*CLE005*/
                 CALL       PGM(LER022)                               /*CLE005*/
                 CLRPFM     FILE(LECARDPD)                            /*CLE005*/
                 MONMSG     MSGID(CPF3142) EXEC(CHGJOB SWS(XXXXXX11)) /*CLE005*/
               ENDDO                                                  /*CLE005*/
             ENDDO                                                    /*CLE005*/
/**/                                                                  /*CLE005*/
 
ERROR:                                                                                 /*AR1042505*/
 
  /* IF ERROR, SEND MSG & COPY BACK SECURITY FILES     */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                       TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
     ELSE  CMD(DO)
 
/* If the component has completed successfully reset the status field */
 
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/**********ENDPGM  */                                                                     /*CLE134*/
ENDPGM: ENDPGM                                                                            /*CLE134*/
