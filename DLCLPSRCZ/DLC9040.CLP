/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Cancel Cheque Print Prompt')                 */
/*******************************************************************/
/*                                                                 */
/*       Midas     - Dealing Module                            */
/*                                                                 */
/*       DLC9040 - CANCEL CHEQUE PRINT PROMPT.                     */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND : 048547         DATE : 18MAR93             */
/*          PREV AMEND : S01390         DATE : 04AUG92             */
/*                       S01179         DATE : 17/01/89            */
/*                       AUS006         DATE : 18DEC90             */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       048547 - GET THIS TO WORK.                                */
/*       S01390 - Release 10 Changes for Australianisation         */
/*       S01179 - AS/400 CONVERSION                                */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*******************************************************************/
/************PGM                                                     * *S01390*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01390*/
 
/*           DCLF       FILE(DLC9040FM.*LIBL) RCDFMT(SCRN01)  * +       S01179*/
             DCLF       FILE(DLC9040FM) RCDFMT(SCRN01) /*               S01179*+
                          Display file with operator narrative */
 
/*           DCLDTAARA  DTAARA(CQSTAT)  * Cheque status data area *     S01179*/
             DCL        VAR(&CQSTAT) TYPE(*CHAR) LEN(512) /* Cheque     S01179*+
                          status data area */
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10) /* Job  */
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10) /* User  */
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(10) /* Job number */
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(512) /* Data area +
                          variable */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01390*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&STRNO) TYPE(*CHAR) LEN(6)                /*S01390*/
 
/**********  IF         COND(&RACT *NE 'I') THEN(DO)                   *048547*/
/**********  RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&STAT)   *S01390* 048547*/
/**********  CHGVAR     VAR(&OPR1) VALUE(%SST(&CQSTAT 1 58))    S01390* 048547*/
/**********  CHGVAR     VAR(&OPR2) VALUE(%SST(&CQSTAT 59 58))   S01390* 048547*/
/**********  CHGVAR     VAR(&OPR3) VALUE(%SST(&CQSTAT 117 58))  S01390* 048547*/
/**********  CHGVAR     VAR(&OPR4) VALUE(%SST(&CQSTAT 176 58))  S01390* 048547*/
/**********  CHGDTAARA  DTAARA(CQSTAT) VALUE(&CQSTAT)           S01179* 048547*/
/**********  IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN46) +    048547*/
/**********               VALUE('1'))                           S01390* 048547*/
/**********  IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN45) +    048547*/
/**********               VALUE('1'))                           S01390* 048547*/
/**********  IF         COND((&RACT *NE 'D') *AND (&RACT *EQ 'E')) +    048547*/
/**********               THEN(CHGVAR VAR(&IN45) VALUE('1'))    S01390* 048547*/
/**********  ENDDO                                              S01390* 048547*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)           /*048547*/
             RTVJOBA    JOB(&SWSID) USER(&USRID)                      /*048547*/
             SNDRCVF    RCDFMT(SCRN01)
             IF         COND(&IN03 *EQ '1') THEN(DO)                  /*S01390*/
/**********  CHGVAR     VAR(&RACT) VALUE('E')                 *S01390* *048547*/
             CHGVAR     VAR(&RCMD) VALUE('E')                         /*048547*/
             GOTO CMDLBL(END)                                         /*048547*/
             ENDDO                                                    /*S01390*/
/**********  ELSE       CMD(IF COND(&IN12 *EQ '1') THEN(DO)) *S01390*  *048547*/
             IF         COND(&IN12 *EQ '1') THEN(DO)                  /*048547*/
/*********** CHGVAR     VAR(&RACT) VALUE('F')                *S01390*  *048547*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*048547*/
             GOTO CMDLBL(END)                                         /*048547*/
             ENDDO                                                    /*S01390*/
/**********  ELSE       CMD(IF COND(&IN10 *EQ '1') THEN(DO))    S01390* 048547*/
/**********  CHGVAR     VAR(&RACT) VALUE('D')                   S01390* 048547*/
/**********  ENDDO                                              S01390* 048547*/
 
/************IF COND(&IN01 *EQ '0') THEN(DO)                         * *S01390*/
/**********  ELSE       CMD(IF COND(&IN03 *EQ '0') THEN(DO))  *S01390* *048547*/
 
             RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&STAT)
             CHGVAR VAR(&JOB) VALUE(%SST(&STAT 1 10))
             CHGVAR VAR(&USER) VALUE(%SST(&STAT 11 10))
             CHGVAR VAR(&NUMB) VALUE(%SST(&STAT 21 10))
             CHGVAR VAR(&STRNO) VALUE(%SST(&STAT 31 6))               /*S01390*/
 
/************CHGVAR VAR(%SST(&CQSTAT 41 98)) VALUE(&OPR1)            * *S01390*/
/************CHGVAR VAR(%SST(&CQSTAT 99 156)) VALUE(&OPR2)           * *S01390*/
/************CHGVAR VAR(%SST(&CQSTAT 157 215)) VALUE(&OPR3)          * *S01390*/
/************CHGVAR VAR(%SST(&CQSTAT 216 272)) VALUE(&OPR4)          * *S01390*/
             CHGVAR VAR(%SST(&CQSTAT 41 58)) VALUE(&OPR1)             /*S01390*/
             CHGVAR VAR(%SST(&CQSTAT 99 58)) VALUE(&OPR2)             /*S01390*/
             CHGVAR VAR(%SST(&CQSTAT 157 58)) VALUE(&OPR3)            /*S01390*/
             CHGVAR VAR(%SST(&CQSTAT 216 58)) VALUE(&OPR4)            /*S01390*/
 
/*           SNDDTAARA DTAARA(CQSTAT)                                   S01179*/
             CHGDTAARA  DTAARA(CQSTAT) VALUE(&CQSTAT)                 /*S01179*/
 
/*           CNLJOB     JOB(&JOB.&USER.&NUMB) OPTION(*IMMED) LOGLMT(0)  S01179*/
/*******ENDJOB JOB(&NUMB/&USER/&JOB) OPTION(*IMMED) LOGLMT(0) *S01179* *S01390*/
 
/*           CALL DLC9025.*LIBL                                         S01179*/
/************CALL DLC9025                                     *S01179* *S01390*/
             CALL DL9026 PARM(&STRNO)                                 /*S01390*/
             CHGVAR     VAR(&RPARM) VALUE('DUMMY')                    /*048547*/
 
/*           CALL DL9030.*LIBL PARM('2')                                S01179*/
/************CALL DL9030 PARM('2')                            *S01179* *S01390*/
/**********  CALL DL9030 PARM('2' &RSEQ)                      *S01390* *048547*/
 
/**********  ENDDO                                                     *048547*/
END:                                                                  /*048547*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
