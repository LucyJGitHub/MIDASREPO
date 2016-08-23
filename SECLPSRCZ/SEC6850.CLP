/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Early Redemptions Confirmations')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC6850 - SE Early Redemptions Confirmations                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. 085428             DATE 29MAR95              */
/*                      S01496             DATE 07OCT94              */
/*                      S10978             DATE 29JUN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       085428 - Only end commitment control if it has been started */
/*                by this program.                                   */
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*********************************************************************/
             PGM
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CMT) TYPE(*CHAR) LEN(1) VALUE('N')       /*085428*/
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Send Information Message */
             SNDPGMMSG  MSG('SEC6850 - SE EARLY REDEMPTIONS +
                          CONFIRMATIONS') TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/************MONMSG     MSGID(CPF8351)                               * *085428*/
                                                                      /*085428*/
/** If commitment control is already active, set a flag for later use.  085428*/
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMT) +
                          VALUE('Y'))                                 /*085428*/
/**/                                                                  /*S01496*/
             CLRPFM     FILE(SEERCEPD)                                /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(SE6849)                                   /*S01496*/
/**/                                                                  /*S01496*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)       /*S01496*/
               CHGJOB     SWS(XXXXXX11)                               /*S01496*/
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)           /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6849 ENDED ABNORMALLY FOR JOB ' *CAT +
                           &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                           *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)       /*S01496*/
               GOTO       CMDLBL(ENDPGM)                              /*S01496*/
             ENDDO                                                    /*S01496*/
 
/* Call RPG SE6850 */
/*********** CALL       PGM(SE6850)                                */ /*S01496*/
             CALL       PGM(SE6850) PARM('     ' 'B' 'ALL')           /*S01496*/
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6850 ENDED ABNORMALLY FOR JOB ' *CAT +
                           &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                           *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
                SNDMSG     MSG('SE6850 ENDED ABNORMALLY FOR JOB ' *CAT +
                            &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                            *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***ENDPGM:******ENDCMTCTL                                           * *085428*/
 ENDPGM:     IF         COND(&CMT *EQ 'N') THEN(ENDCMTCTL)            /*085428*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
