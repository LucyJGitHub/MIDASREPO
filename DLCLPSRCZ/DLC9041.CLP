/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Cancel Cheque Print')                        */
/*******************************************************************/
/*                                                                 */
/*       Midas     - Dealing Module                            */
/*                                                                 */
/*       DLC9041 - CANCEL CHEQUE PRINT.                            */
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
/*          PREV AMEND : AUS006         DATE : 13AUG92             */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       048547 - GET THIS TO WORK.                                */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*******************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)
 
             DCL        VAR(&CQSTAT) TYPE(*CHAR) LEN(512) /* Cheque +
                          status data area */
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10) /* Job  */
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10) /* User  */
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(10) /* Job number */
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(512) /* Data area +
                          variable */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&STRNO) TYPE(*CHAR) LEN(6)
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
 
             RTVDTAARA  DTAARA(CQSTAT (1 512)) RTNVAR(&STAT)
             CHGVAR     VAR(&JOB) VALUE(%SST(&STAT 1 10))
             CHGVAR     VAR(&USER) VALUE(%SST(&STAT 11 10))
             CHGVAR     VAR(&NUMB) VALUE(%SST(&STAT 21 10))
             CHGVAR     VAR(&STRNO) VALUE(%SST(&STAT 31 6))
 
             ENDJOB     JOB(&NUMB/&USER/&JOB) OPTION(*IMMED) LOGLMT(0)
             MONMSG     MSGID(CPF0000)                                /*048547*/
 
/**********  CALL       PGM(DL9025) PARM(&STRNO)                        048547*/
 
             CALL       PGM(DL9030) PARM('2' &RSEQ)
 
END:                                                                  /*S01390*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
