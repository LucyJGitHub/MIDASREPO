/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Blocked Positions Report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6860 - SE Blocked Position Report                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01496             DATE 07OCT94              */
/*       PREV AMEND NO. S10978             DATE 09APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&MODE &BRANCH &CUSTOMER &PORTFOLIO +  */ /*S01496*/
/***********              &SECURITY &DAYNUMBER &DATUM &RTCD)       */ /*S01496*/
/**/                                                                  /*S01496*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01496*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01496*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01496*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01496*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01496*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CUSTOMER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PORTFOLIO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SECURITY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAYNUMBER) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DAYNUM) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DATUM) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(512)
             DCL        VAR(&STATINFO) TYPE(*CHAR) LEN(27)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/**/                                                                  /*S01496*/
/**  Extract value of selected fields from RPARM */                   /*S01496*/
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&MODE) VALUE(%SST(&RPARM 1 1))            /*S01496*/
             CHGVAR     VAR(&BRANCH) VALUE(%SST(&RPARM 2 3))          /*S01496*/
             CHGVAR     VAR(&CUSTOMER) VALUE(%SST(&RPARM 5 6))        /*S01496*/
             CHGVAR     VAR(&PORTFOLIO) VALUE(%SST(&RPARM 11 4))      /*S01496*/
             CHGVAR     VAR(&SECURITY) VALUE(%SST(&RPARM 15 10))      /*S01496*/
             CHGVAR     VAR(&DAYNUMBER) VALUE(%SST(&RPARM 25 5))      /*S01496*/
             CHGVAR     VAR(&DATUM) VALUE(%SST(&RPARM 30 7))          /*S01496*/
             CHGVAR     VAR(&RTCD) VALUE(%SST(&RPARM 37 1))           /*S01496*/
 
             CHGVAR     VAR(&DAYNUM) VALUE(&DAYNUMBER)
             CHGVAR     VAR(&STATINFO) VALUE(' ')
 
             IF         COND(&MODE = '1') THEN(DO)
             CHGVAR     VAR(&STATINFO) VALUE(&BRANCH *TCAT '/' *TCAT +
                          &CUSTOMER *TCAT '/' *TCAT &PORTFOLIO +
                          *TCAT '/' *TCAT &DATUM)
             ENDDO
 
             ELSE       CMD(IF COND(&MODE = '2') THEN(DO))
             CHGVAR     VAR(&STATINFO) VALUE(&BRANCH *TCAT '/' *TCAT +
                          &CUSTOMER *TCAT '/' *TCAT &DATUM)
             ENDDO
 
             ELSE       CMD(IF COND(&MODE = '3') THEN(DO))
             CHGVAR     VAR(&STATINFO) VALUE(&SECURITY *TCAT '/' +
                          *TCAT &DATUM)
             ENDDO
 
             IF         COND(&MODE *NE '0') THEN(DO)
 
/*********** CALL       PGM(SE6860) PARM(&MODE &BRANCH &CUSTOMER + */ /*S01496*/
/***********             &PORTFOLIO &SECURITY &DAYNUM &STATINFO &RTCD)/*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(SE6860) PARM(&MODE &BRANCH &CUSTOMER +
                          &PORTFOLIO &SECURITY &DAYNUM &STATINFO +
                          &RTCD &RSEQ &RLEV &RENT)                    /*S01496*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6860 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             ENDDO
             RETURN
 
 ERROR:      RCVMSG     MSGTYPE(*LAST) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
