/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Chart of Accounts Report Prompt')            */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*   Midas - General Ledger Module                           */
/*                                                                   */
/*   GLC35P  - CHART OF ACCOUNTS REPORT PROMPT                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. E38913     DATE 28APR92                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   E38913 - ALLOW AMEND PROCESSING AND ALSO CORRECT ERROR PROCESS  */
/*                                                                   */
/*********************************************************************/
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ONE) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&TWO) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&THREE) TYPE(*CHAR) LEN(1) VALUE(N)
 
             DCLF       FILE(GLC35DF)
 
             RTVJOBA    JOB(&SWSID) USER(&SUSER)
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SDATE)
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SST(&MMOD 16 1) *EQ 'Y' *OR %SST(&MMOD +
                          23 1) *EQ 'Y') THEN(DO)
                  CHGVAR     VAR(&IN01) VALUE('1')
                  ENDDO
 
             IF         COND(&RACT *EQ 'D') THEN(DO)
                  CHGVAR     VAR(&IN11) VALUE('1')
                  ENDDO
             IF         COND(&RACT *EQ 'E' *OR &RACT *EQ 'D') +
                          THEN(DO)                                    /*E38913*/
                  CHGVAR     VAR(&IN87) VALUE('1')                    /*E38913*/
                  ENDDO
             IF         COND(&RACT *NE 'I') THEN(DO)                  /*E38913*/
                  CHGVAR     VAR(&OPT1) VALUE(%SST(&RPARM 1 1))       /*E38913*/
                  CHGVAR     VAR(&OPT2) VALUE(%SST(&RPARM 2 1))       /*E38913*/
                  CHGVAR     VAR(&OPT3) VALUE(%SST(&RPARM 3 1))       /*E38913*/
                  ENDDO                                               /*E38913*/
             IF         COND(&RACT *EQ 'I') THEN(DO)                  /*E38913*/
                  CHGVAR     VAR(&OPT1) VALUE('N')                    /*E38913*/
                  CHGVAR     VAR(&OPT2) VALUE('N')                    /*E38913*/
                  CHGVAR     VAR(&OPT3) VALUE('N')                    /*E38913*/
                  ENDDO                                               /*E38913*/
 
 RDSPLY:     SNDRCVF    RCDFMT(GLC35DF)
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
                  CHGVAR     VAR(&RCMD) VALUE('E')
                  GOTO       CMDLBL(ENDPGM)
                  ENDDO
 
             IF         COND(&IN10 *EQ '1') THEN(DO)
                  CHGVAR     VAR(&RCMD) VALUE('D')
                  GOTO       CMDLBL(ENDPGM)
                  ENDDO
 
             IF         COND(&IN12 *EQ '1') THEN(DO)
                  CHGVAR     VAR(&RCMD) VALUE('F')
                  GOTO       CMDLBL(ENDPGM)
                  ENDDO
 
             CHGVAR     VAR(&IN02) VALUE('0')
 
             IF         COND(&OPT1 *EQ 'N' *AND &OPT2 *EQ 'N' *AND +
                          &OPT3 *EQ 'N') THEN(DO)                     /*E38913*/
                 CHGVAR     VAR(&IN02) VALUE('1')                     /*E38913*/
             CHGVAR     VAR(&MSGFLD) VALUE('At least one selection +
                          must be made')                              /*E38913*/
                 GOTO       CMDLBL(RDSPLY)                            /*E38913*/
                 ENDDO                                                /*E38913*/
                                                                      /*E38913*/
             IF         COND(&OPT1 *NE 'Y' *AND &OPT1 *NE 'N') THEN(DO)
                 CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSGFLD) VALUE('Must select either Y +
                           or N')                                     /*E38913*/
                 GOTO       CMDLBL(RDSPLY)
                 ENDDO
 
             IF         COND(&OPT2 *NE 'Y' *AND &OPT2 *NE 'N') THEN(DO)
                 CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSGFLD) VALUE('Must select either Y +
                           or N')                                     /*E38913*/
                 GOTO       CMDLBL(RDSPLY)
                 ENDDO
 
             IF         COND(&IN01 *EQ '1') THEN(DO)
                  IF         COND(&OPT3 *NE 'Y' *AND &OPT3 *NE 'N') +
                         THEN(DO)
                      CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&MSGFLD) VALUE('Must select either Y +
                           or N')                                     /*E38913*/
                      GOTO       CMDLBL(RDSPLY)
                      ENDDO
                 ENDDO
 
             IF         COND(&OPT1 *EQ 'Y') THEN(DO)
                 CHGVAR     VAR(&ONE) VALUE('Y')
                 ENDDO
 
             IF         COND(&OPT2 *EQ 'Y') THEN(DO)
                  CHGVAR     VAR(&TWO) VALUE('Y')
                  ENDDO
 
             IF         COND(&OPT3 *EQ 'Y') THEN(DO)
                  CHGVAR     VAR(&THREE) VALUE('Y')
                  ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ENDPGM:
             CHGVAR     VAR(&RPARM) VALUE(&ONE *CAT &TWO *CAT &THREE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
