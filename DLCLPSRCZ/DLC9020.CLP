/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Control cheque printing')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                              */
/*                                                                   */
/*       DLC9020 - PROGRAM TO CONTROL THE CHEQUE PRINTING.           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 051880             DATE 07JAN94              */
/*       PREV AMEND NO. 051380             DATE 07JAN94              */
/*                      048524             DATE 19MAR93              */
/*                      S01390             DATE 04AUG92              */
/*                      S01179             DATE 17/01/89             */
/*                      AUS006             DATE 18DEC90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       051880 - Reinstate part deleted by S01390 on printer        */
/*                control.                                           */
/*              - Messages should be sent to user.                   */
/*       051380 - Set up print indicator on CQSTAT if this           */
/*                program has run.                                   */
/*       048524 - On investigation it was found that CASK -          */
/*                Customer Alpha Sort Code is an optional            */
/*                field so processing is changed to base on          */
/*                CSNM - Customer Short Name which is mand-          */
/*                atory avoiding errors in Stmt print.               */
/*       S01390 - Release 10 Changes for Australianisation           */
/*       S01179 - AS/400 CONVERSION                                  */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY              */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01390*/
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&WTR) TYPE(*CHAR) LEN(10)                * *S01390*/
             DCL        VAR(&WTR) TYPE(*CHAR) LEN(10)                /*051880*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPT1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRINT) TYPE(*CHAR) LEN(1)               /*051380*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01390*/
             DCL        VAR(&STRNO) TYPE(*CHAR) LEN(6)                /*S01390*/
 
/*           DCLDTAARA  DTAARA(CQSTAT)  * Cheque status data area *     S01179*/
/* AUS006    DCL        VAR(&CQSTAT) TYPE(*CHAR) LEN(256) /* Cheque +
                          status data area *                            S01179*/
/* AUS006 */ DCL        VAR(&CQSTAT) TYPE(*CHAR) LEN(512) /* Cheque +
                          status data area *                            S01179*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01390*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01390*/
/**/                                                                  /*S01390*/
/*/COPY WNCPYSRC,DLC9020001                                          */
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS006')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))                                /*S01390*/
 
             CHGVAR     VAR(&STRNO) VALUE(%SST(&RPARM 1 6))           /*S01390*/
                                                                      /*S01390*/
/*/COPY WNCPYSRC,DLC9020002                                          */
      /* RETRIEVE JOB NAME, USER NAME AND JOB NUMBER              */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NUMB)
 
/*/COPY WNCPYSRC,DLC9020015                                          */
/* */                                                                /*051380*/
/** Retrieve PRINT indicator from data area CQSTAT.  This         */ /*051380*/
/** program should execute if this indicator is blank.            */ /*051380*/
/* */                                                                /*051380*/
             RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&CQSTAT)       /*051380*/
             CHGVAR     VAR(&PRINT) VALUE(%SST(&CQSTAT 273 1))       /*051380*/
             IF         COND(&PRINT *NE ' ') THEN(DO)                /*051380*/
/************     SNDPGMMSG  MSG('Cheques have already been +     */ /*051880*/
/************                     printed.  Reprint option is +   */ /*051880*/
/************                     available.') +            */ /*051380 051880*/
/************                     TOMSGQ(MOPERQ) +          */ /*051380 051880*/
/************                     MSGTYPE(*INFO)            */ /*051380 051880*/
/*/COPY WNCPYSRC,DLC9020007                                          */
                  SNDUSRMSG  MSG('Cheques have already been +
                                  printed.  Reprint option is +
                                  available.') MSGTYPE(*INFO)        /*051880*/
/*/COPY WNCPYSRC,DLC9020008                                          */
                  GOTO       CMDLBL(END)                             /*051380*/
             ENDDO                                                   /*051380*/
/*/COPY WNCPYSRC,DLC9020016                                          */
      /**RETRIEVE*WRITER*NAME*FROM*DATA*AREA.**UPDATE*THE*DATA******   *S01390*/
/***/                                                                /*051380*/
/********UPDATE*THE*DATA************************************/ /*S01390 051380*/
/********AREA*WITH*JOB*NAME,*USER*NAME*AND*JOB*NUMBER.*************/ /*051380*/
/* */                                                                /*051380*/
/** Update the data area with Job Name, User Name and Job Number. */ /*051380*/
/** Also update the PRINT indicator to indicate Cheque Print      */ /*051380*/
/** Option has been selected.                                     */ /*051380*/
/* */                                                                /*051380*/
             RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&CQSTAT)
             CHGVAR VAR(%SST(&CQSTAT 1 10)) VALUE(&JOB)
             CHGVAR VAR(%SST(&CQSTAT 11 10)) VALUE(&USER)
             CHGVAR VAR(%SST(&CQSTAT 21 6)) VALUE(&NUMB)
             CHGVAR     VAR(%SST(&CQSTAT 273 1)) VALUE('P')          /*051380*/
/************CHGVAR VAR(&WTR) VALUE(%SST(&CQSTAT 31 10))             * *S01390*/
             CHGVAR     VAR(&WTR) VALUE(%SST(&CQSTAT 274 10))        /*051880*/
             CHGVAR     VAR(%SST(&CQSTAT 31 6)) VALUE(&STRNO)         /*S01390*/
/*           SNDDTAARA  DTAARA(CQSTAT)                                  S01179*/
             CHGDTAARA  DTAARA(CQSTAT) VALUE(&CQSTAT)                 /*S01179*/
 
/*/COPY WNCPYSRC,DLC9020017                                          */
      /**CANCEL*PROGRAM*IF*WRITER*PARAMETER*IS*BLANK***************    *S01390*/
/************IF COND(&WTR *EQ '          ') THEN(DO)                 * *S01390*/
/************SNDPGMMSG  MSG('ERROR - Writer name in CQSTAT (pos. 31 +* *S01390*/
/************             to 40) is blank.')                         * *S01390*/
/************GOTO END                                                * *S01390*/
/************ENDDO                                                   * *S01390*/
             IF         COND(&WTR *EQ '          ') THEN(DO)         /*051880*/
/*/COPY WNCPYSRC,DLC9020009                                          */
                  SNDUSRMSG  MSG('ERROR - Writer name in CQSTAT +
                                  (pos. 274 to 283) is blank.') +
                                  MSGTYPE(*INFO)                     /*051880*/
/*/COPY WNCPYSRC,DLC9020010                                          */
                  GOTO       CMDLBL(END)                             /*051880*/
             ENDDO                                                   /*051880*/
 
/*/COPY WNCPYSRC,DLC9020003                                          */
      /**CANCEL*WRITER********************************************** * *S01390*/
/*           CNLWTR     WTR(&WTR) OPTION(*IMMED)                        S01179*/
/************ENDWTR     WTR(&WTR) OPTION(*IMMED)              *S01179* *S01390*/
/************MONMSG     MSGID(CPF3313)                               * *S01390*/
/************DLYJOB     DLY(10)                                      * *S01390*/
             ENDWTR     WTR(&WTR) OPTION(*IMMED)                     /*051880*/
             MONMSG     MSGID(CPF3313)                               /*051880*/
             DLYJOB     DLY(10)                                      /*051880*/
 
      /**ALLOCATE*WRITER*TO*CURRENT*JOB******************************* *S01390*/
      /**IF*ERROR*ALLOW*RE-TRY OPTION OR CANCEL                   **** *S01390*/
/****TAG001:     ALCOBJ     OBJ((&WTR *DEVD *EXCLRD))                * *S01390*/
/************MONMSG     MSGID(CPF0001) EXEC(DO)                      * *S01390*/
/************SNDUSRMSG  MSG('Error trying to allocate printer, Do you +*S01390*/
/************             wish to retry ? (Y or N)') VALUES('Y' 'N') + *S01390*/
/************             DFT('Y') MSGRPY(&OPT)                      * *S01390*/
/************IF         COND(&OPT *EQ 'Y') THEN(GOTO CMDLBL(TAG001)) * *S01390*/
/************IF         COND(&OPT *EQ 'N') THEN(GOTO CMDLBL(END))    * *S01390*/
/************ENDDO                                                    /*S01390*/
 TAG001:     ALCOBJ     OBJ((&WTR *DEVD *EXCLRD))                    /*051880*/
             MONMSG     MSGID(CPF0001) EXEC(DO)                      /*051880*/
/*/COPY WNCPYSRC,DLC9020011                                          */
                  SNDUSRMSG  MSG('Error trying to allocate +
                                  printer.  Do you wish to retry ? +
                                  (Y or N)') VALUES('Y' 'N') +
                                  DFT('Y') MSGRPY(&OPT)              /*051880*/
/*/COPY WNCPYSRC,DLC9020012                                          */
                  IF         COND(&OPT *EQ 'Y') +
                                  THEN(GOTO CMDLBL(TAG001))          /*051880*/
                  IF         COND(&OPT *EQ 'N') +
                                  THEN(GOTO CMDLBL(END))             /*051880*/
             ENDDO                                                   /*051880*/
 
      /**OVERRIDE*PRINTER*FILE*SO*AS*NOT*TO*SPOOL*OUTPUT***********    *S01390*/
/************OVRPRTF    FILE(DL9020P1) DEV(&WTR) SPOOL(*NO)          * *S01390*/
             OVRPRTF    FILE(DL9020P1) DEV(&WTR) SPOOL(*NO)          /*051880*/
/*/COPY WNCPYSRC,DLC9020004                                          */
 
/*           CLRPFM     FILE(CHQNOAA.*LIBL)                             S01179*/
             CLRPFM     FILE(CHQNOAA)                                 /*S01179*/
/*           CLRPFM     FILE(CHQNOZZ.*LIBL)                             S01179*/
             CLRPFM     FILE(CHQNOZZ)                                 /*S01179*/
 
             OVRDBF     FILE(STHSTAA) SHARE(*YES)
 
/************OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "C"') +    * *S01390*/
/************             KEYFLD((BRCD) (CCY) (CASK) (DLNO) (EDAT) + * *S01390*/
/************             (SQNO)) /* Select records where position 68 +*S01390*/
/************             of the file is = to 'C' ie Deposit +       * *S01390*/
/************             statement with cheque records.  The file is +*S01390*/
/************             read in the sequence of branch code, +     * *S01390*/
/************             currency, customer alpha sort key, deal +  * *S01390*/
/************             number event date and asequence number. *  * *S01390*/
/***         OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "C"') +      *048524*/
/***                      KEYFLD((BRCA) (CCY) (CASK) (DLNO) (EDAT) +   *048524*/
/***                      (SQNO)) /* Select records where position 68 +*048524*/
/***                      of the file is = to 'C' ie Deposit +         *048524*/
/***                      statement with cheque records.  The file is +*048524*/
/***                      read in the sequence of branch code, +       *048524*/
/***                      currency, customer alpha sort key, deal +    *048524*/
/***                      number event date and asequence number. *  * *048524*/
/***                                                          *S01390* *048524*/
             OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "C"') +
                          KEYFLD((BRCA) (CCY) (CSNM) (DLNO) (EDAT) +
                          (SQNO)) /* Select records where position 68 +
                          of the file is = to 'C' ie Deposit +
                          statement with cheque records.  The file is +
                          read in the sequence of branch code, +
                          currency, customer alpha sort key, deal +
                          number event date and asequence number. *  * *048524*/
 
/*/COPY WNCPYSRC,DLC9020018                                          */
      /**VERIFY*ALIGNMENT*OF*PRINTER*AND*DETERMINE*IF*THE*PROGRAM**  * *S01390*/
      /**SHOULD*CONTINUE.******************************************  * *S01390*/
/*AG002:     CALL       PGM(DL9020.*LIBL) PARM('N')                     S01179*/
/***TAG002:     CALL       PGM(DL9020) PARM('N')              *S01179* *S01390*/
/**********  SNDUSRMSG  MSG('Do you wish to continue (Y or N) ?') +  * *S01390*/
/**********               VALUES('Y' 'N') DFT('Y') MSGTYPE(*INQ) +   * *S01390*/
/**********               MSGRPY(&OPT1)                              * *S01390*/
/**********  IF         COND(&OPT1 *EQ 'N') THEN(GOTO CMDLBL(TAG002))* *S01390*/
 TAG002:     CALL       PGM(DL9020) PARM('N' &RSEQ &RENT)            /*051880*/
/*/COPY WNCPYSRC,DLC9020013                                          */
             SNDUSRMSG  MSG('Do you wish to continue (Y or N) ?') +
                             VALUES('Y' 'N') DFT('Y') MSGTYPE(*INQ) +
                             MSGRPY(&OPT1)                           /*051880*/
/*/COPY WNCPYSRC,DLC9020014                                          */
             IF         COND(&OPT1 *EQ 'N') +
                             THEN(GOTO CMDLBL(TAG002))               /*051880*/
/*/COPY WNCPYSRC,DLC9020019                                          */
 
      /* CLEAR CHEQUE DETAIL AND HEADER FILES                     */
 
      /* PRINT CHEQUES                                            */
/*           CALL       PGM(DL9020.*LIBL) PARM('Y')                     S01179*/
/************CALL       PGM(DL9020) PARM('Y')                 *S01179* *S01390*/
/************CALL       PGM(DL9020) PARM(&RSEQ &RENT)      */ /*S01390 051880*/
             CALL       PGM(DL9020) PARM('Y' &RSEQ &RENT)            /*051880*/
             CLOF       OPNID(STHSTAA)
             DLTOVR     FILE(STHSTAA)
 
      /**RELEASE*HOLD*ON*PRINTER*AND*DELETE*OVERRIDE*ON*PRINTER*FILE** *S01390*/
/************DLCOBJ     OBJ((&WTR *DEVD *EXCLRD))                    * *S01390*/
/************DLTOVR     FILE(DL9020P1)                               * *S01390*/
/*/COPY WNCPYSRC,DLC9020005                                          */
             DLCOBJ     OBJ((&WTR *DEVD *EXCLRD))                    /*051880*/
/*/COPY WNCPYSRC,DLC9020006                                          */
             DLTOVR     FILE(DL9020P1)                               /*051880*/
 
      /* RECONCILE CHEQUE RANGES                                     */
/*           CALL       PGM(DLC9025.*LIBL)                              S01179*/
/************CALL       PGM(DLC9025)                          *S01179* *S01390*/
             CALL       PGM(DL9026) PARM(&STRNO)                      /*S01390*/
 
      /* PRINT CHEQUE RANGE AUDIT REPORT                             */
/*           CALL       PGM(DL9030.*LIBL) PARM('1')                     S01179*/
/************CALL       PGM(DL9030) PARM('1')                 *S01179* *S01390*/
             CALL       PGM(DL9030) PARM('1' &RSEQ)                   /*S01390*/
/*/COPY WNCPYSRC,DLC9020020                                          */
 
/***END:         ENDPGM                                              * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01390*/
