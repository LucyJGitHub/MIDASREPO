/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Account Keys Print')                         */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/********SDC0606*-*SECURITY COPYING OF DATABASE AND LOG FILES       */
/*       SDC35   -  ACCOUNT KEYS LIST                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E26958            DATE  07OCT91             */
/*       PREV AMEND NO. BHF222            DATE  29JUN90             */
/*                      LN0140            DATE  09MAY90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       E26958 - SWITCHES U1 & U2 WERE NOT BEING SET ON &          */
/*                PARM &RUNTYP ADDED TO INDICATE TYPE OF REPORT     */
/*                'A' = AUDIT  &  'L' = LIST.                       */
/*                REMOVE TABLE FILE OVERRIDE AS IT IS NO LONGER     */
/*                USED IN ACCOUNT KEYS LISTING.                     */
/*       BHF222 - PARAMETERS MISSING                                */
/*       LN0140  WRONG TEXT IN HEADER BOX                           */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**          PGM**/                                                   /*BHF222*/
/************PGM        PARM(&RSEQ &RLEV &RENT)   ***/     /*BHF222*/ /*E26958*/
             PGM        PARM(&RUNTYP &RSEQ &RLEV &RENT)               /*E26958*/
/**/                                                                  /*BHF222*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*BHF222*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*BHF222*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*BHF222*/
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(1)               /*E26958*/
             DCL        VAR(&RUNRPT) TYPE(*CHAR) LEN(1) VALUE('N')    /*E26958*/
             DCL        VAR(&SWS)    TYPE(*CHAR)  LEN(8)              /*E26958*/
             DCL        &MSG          TYPE(*CHAR)  LEN(75)            /*E26958*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************OVRDBF     FILE(TABLE)   TOFILE(TABSDU)    *****/        /*E26958*/
             OVRDBF     FILE(ACKEYI)  TOFILE(ACKEY)  SHARE(*NO)
             OVRDBF     FILE(ACKEYU)  TOFILE(ACKEY)  SHARE(*NO)
                                                                      /*E26958*/
             IF COND(&RUNTYP *EQ 'A') THEN(DO)    /*AUDIT*/           /*E26958*/
 
                CALL    PGM(SD0702) PARM(&RUNRPT)                     /*E26958*/
                RTVJOBA    SWS(&SWS)                                  /*E26958*/
 
                IF         (%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)    /*E26958*/
                CHGVAR  VAR(&MSG) VALUE(' JOB TERMINATED - DATABASE +
                          IN ERROR')                                  /*E26958*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*E26958*/
                GOTO       ENDCLPGM                                   /*E26958*/
                ENDDO                                                 /*E26958*/
 
                IF COND(&RUNRPT *EQ 'Y') THEN(DO)                     /*E26958*/
                CHGJOB SWS(10000000)                                  /*E26958*/
                CALL    PGM(SD0701) PARM(&RSEQ)                       /*E26958*/
                RTVJOBA    SWS(&SWS)                                  /*E26958*/
 
                IF         (%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)    /*E26958*/
                CHGVAR  VAR(&MSG) VALUE(' JOB TERMINATED - DATABASE +
                          IN ERROR')                                  /*E26958*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*E26958*/
                GOTO       ENDCLPGM                                   /*E26958*/
                ENDDO                                                 /*E26958*/
 
                ENDDO                                                 /*E26958*/
 
             ENDDO                                                    /*E26958*/
                                                                      /*E26958*/
             IF COND(&RUNTYP *EQ 'L') THEN(DO)    /*LIST*/            /*E26958*/
                CHGJOB SWS(01000000)                                  /*E26958*/
                CALL    PGM(SD0701) PARM(&RSEQ)                       /*E26958*/
                RTVJOBA    SWS(&SWS)                                  /*E26958*/
 
                IF         (%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)    /*E26958*/
                CHGVAR  VAR(&MSG) VALUE(' JOB TERMINATED - DATABASE +
                          IN ERROR')                                  /*E26958*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*E26958*/
                GOTO       ENDCLPGM                                   /*E26958*/
                ENDDO                                                 /*E26958*/
 
             ENDDO                                                    /*E26958*/
                                                                      /*E26958*/
 /*********  CALL       PGM(SD0350)                                    *BHF222*/
 /*********  CALL       PGM(SD0350) PARM(&RSEQ)  ******/   /*BHF222*/ /*E26958*/
 
             DLTOVR     FILE(ACKEYI)                                  /*E26958*/
             DLTOVR     FILE(ACKEYU)                                  /*E26958*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*******     ENDPGM     ********/                                     /*E26958*/
ENDCLPGM:    ENDPGM                                                   /*E26958*/
