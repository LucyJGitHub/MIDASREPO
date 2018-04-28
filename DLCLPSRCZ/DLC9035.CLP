/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Restart Statement with cheque print')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                              */
/*                                                                   */
/*       DLC9035 - PROGRAM TO CONTROL THE CHEQUE RE-PRINT            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 051880             DATE 07JAN94              */
/*       PREV AMEND NO. S01390             DATE 04AUG92              */
/*                      S01179             DATE 17/01/89             */
/*                      AUS006             DATE 18DEC90              */
/*                      EA001              DATE 07/06/88             */
/*                      E36317             DATE 20/05/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       051880 - Reinstate part deleted by S01390 on                */
/*                interactive printing.                              */
/*              - Message should be sent to user.                    */
/*       S01390 - Release 10 Changes for Australianisation           */
/*       S01179 - AS/400 CONVERSION                                  */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY              */
/*       EA001  - AUSTRALIAN RELEASE ERROR FIX                       */
/*       E36317 - STANDARD CHARTERED BANK ERROR                      */
/*                ALLOW BYPAS IF CMD 1                               */
/*                                                                   */
/********************************************************************/
/************PGM                                                     * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01390*/
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&WTR) TYPE(*CHAR) LEN(10)                * *S01390*/
             DCL        VAR(&WTR) TYPE(*CHAR) LEN(10)                /*051880*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPT1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01390*/
             DCL        VAR(&STRNO) TYPE(*CHAR) LEN(6)                /*S01390*/
             DCL        VAR(&SCUS) TYPE(*CHAR) LEN(6)                 /*S01390*/
             DCL        VAR(&ECUS) TYPE(*CHAR) LEN(6)                 /*S01390*/
/*/COPY WNCPYSRC,DLC9035007                                          */
 
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
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS006')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))                                /*S01390*/
/*/COPY WNCPYSRC,DLC9035008                                          */
 
             CHGVAR     VAR(&SCUS) VALUE(%SST(&RPARM 1 6))            /*S01390*/
             CHGVAR     VAR(&ECUS) VALUE(%SST(&RPARM 7 6))            /*S01390*/
                                                                      /*S01390*/
      /* RETRIEVE JOB NAME, USER NAME AND JOB NUMBER              */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NUMB)
 
/*EA001  RESET SWITCHES                                                 E36317*/
/*EA001*/    CHGJOB     SWS(0XXXXXXX)                                 /*E36317*/
 
      /**RETRIEVE*WRITER*NAME*FROM*DATA*AREA.**UPDATE*THE*DATA******   *S01390*/
      /* UPDATE THE DATA                                          */  /*S01390*/
      /* AREA WITH JOB NAME, USER NAME AND JOB NUMBER.            */
             RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&CQSTAT)
             CHGVAR VAR(%SST(&CQSTAT 1 10)) VALUE(&JOB)
             CHGVAR VAR(%SST(&CQSTAT 11 10)) VALUE(&USER)
             CHGVAR VAR(%SST(&CQSTAT 21 6)) VALUE(&NUMB)
/************CHGVAR VAR(&WTR) VALUE(%SST(&CQSTAT 31 10))             * *S01390*/
             CHGVAR     VAR(&WTR) VALUE(%SST(&CQSTAT 274 10))        /*051880*/
             CHGVAR     VAR(&STRNO) VALUE(%SST(&CQSTAT 31 6))         /*S01390*/
/*           SNDDTAARA  DTAARA(CQSTAT)                                  S01179*/
             CHGDTAARA  DTAARA(CQSTAT) VALUE(&CQSTAT)                 /*S01179*/
 
      /**CANCEL*PROGRAM*IF*WRITER*PARAMETER*IS*BLANK***************    *S01390*/
/************IF COND(&WTR *EQ '          ') THEN(DO)                 * *S01390*/
/************SNDPGMMSG  MSG('ERROR - Writer name in CQSTAT (pos. 31 +* *S01390*/
/************             to 40) is blank.')                         * *S01390*/
/************GOTO END                                                * *S01390*/
/************ENDDO                                                   * *S01390*/
             IF         COND(&WTR *EQ '          ') THEN(DO)         /*051880*/
/*/COPY WNCPYSRC,DLC9035001                                          */
                  SNDUSRMSG  MSG('ERROR - Writer name in CQSTAT +
                                  (pos. 274 to 283) is blank.') +
                                  MSGTYPE(*INFO)                     /*051880*/
/*/COPY WNCPYSRC,DLC9035002                                          */
                  GOTO       CMDLBL(END)                             /*051880*/
             ENDDO                                                   /*051880*/
/*/COPY WNCPYSRC,DLC9035009                                          */
 
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
/*/COPY WNCPYSRC,DLC9035003                                          */
                  SNDUSRMSG  MSG('Error trying to allocate +
                                  printer.  Do you wish to retry ? +
                                  (Y or N)') VALUES('Y' 'N') DFT('Y') +
                                  MSGRPY(&OPT)                       /*051880*/
/*/COPY WNCPYSRC,DLC9035004                                          */
                  IF         COND(&OPT *EQ 'Y') +
                                  THEN(GOTO CMDLBL(TAG001))          /*051880*/
                  IF         COND(&OPT *EQ 'N') +
                                  THEN(GOTO CMDLBL(END))             /*051880*/
             ENDDO                                                   /*051880*/
 
      /**OVERRIDE*PRINTER*FILE*SO*AS*NOT*TO*SPOOL*OUTPUT***********    *S01390*/
/************OVRPRTF    FILE(DL9020P1) DEV(&WTR) SPOOL(*NO)          * *S01390*/
             OVRPRTF    FILE(DL9020P1) DEV(&WTR) SPOOL(*NO)          /*051880*/
 
/*/COPY WNCPYSRC,DLC9035010                                          */
 
      /**VERIFY*ALIGNMENT*OF*PRINTER*AND*DETERMINE*IF*THE*PROGRAM**  * *S01390*/
      /**SHOULD*CONTINUE.******************************************  * *S01390*/
/*AG002:     CALL       PGM(DL9035.*LIBL) PARM('N')                     S01179*/
/***TAG002:     CALL       PGM(DL9035) PARM('N')              *S01179* *S01390*/
/**********  SNDUSRMSG  MSG('Do you wish to continue (Y or N) ?') +  * *S01390*/
/**********               VALUES('Y' 'N') DFT('Y') MSGTYPE(*INQ) +   * *S01390*/
/**********               MSGRPY(&OPT1)                              * *S01390*/
/**********  IF         COND(&OPT1 *EQ 'N') THEN(GOTO CMDLBL(TAG002))* *S01390*/
 TAG002:     CALL       PGM(DL9035) +
                             PARM('N' &SCUS &ECUS &RSEQ &RENT)       /*051880*/
/*/COPY WNCPYSRC,DLC9035005                                          */
             SNDUSRMSG  MSG('Do you wish to continue (Y or N) ?') +
                             VALUES('Y' 'N') DFT('Y') MSGTYPE(*INQ) +
                             MSGRPY(&OPT1)                           /*051880*/
/*/COPY WNCPYSRC,DLC9035006                                          */
             IF         COND(&OPT1 *EQ 'N') +
                             THEN(GOTO CMDLBL(TAG002))               /*051880*/
 
      /* CLEAR CHEQUE DETAIL AND HEADER FILES                     */
 
      /* PRINT CHEQUES                                            */
/*           CALL       PGM(DL9035.*LIBL) PARM('Y')                     S01179*/
/************CALL       PGM(DL9035) PARM('Y')                 *S01179* *S01390*/
             CALL       PGM(DL9035) PARM('Y' &SCUS &ECUS &RSEQ +
                          &RENT) /*S01390*/
 
      /**RELEASE*HOLD*ON*PRINTER*AND*DELETE*OVERRIDE*ON*PRINTER*FILE** *S01390*/
/************DLCOBJ     OBJ((&WTR *DEVD *EXCLRD))                    * *S01390*/
/************DLTOVR     FILE(DL9020P1)                               * *S01390*/
/*/COPY WNCPYSRC,DLC9035011                                          */
             DLCOBJ     OBJ((&WTR *DEVD *EXCLRD))                    /*051880*/
/*/COPY WNCPYSRC,DLC9035012                                          */
             DLTOVR     FILE(DL9020P1)                               /*051880*/
 
/*EA001  BYPASS REST OF PROCESSING IF CMD 1 TAKEN IN DL9035             E36317*/
/*EA001*/    IF COND(SWITCH *EQ 0XXXXXXX) THEN(DO)                    /*E36317*/
 
      /* RECONCILE CHEQUE RANGES                                     */
/*           CALL       PGM(DLC9025.*LIBL)                              S01179*/
/************CALL       PGM(DLC9025)                          *S01179* *S01390*/
             CALL       PGM(DL9026) PARM(&STRNO)                      /*S01390*/
 
      /* PRINT CHEQUE RANGE AUDIT REPORT                             */
/*           CALL       PGM(DL9030.*LIBL) PARM('1')                     S01179*/
/************CALL       PGM(DL9030) PARM('1')                 *S01179* *S01390*/
             CALL       PGM(DL9030) PARM('1' &RSEQ)                   /*S01390*/
             ENDDO
 
/***END:         ENDPGM                                              * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01390*/
