/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Abnormal Termination Reporting')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1796- ABNORMAL TERMINATION REPORTING                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.S01194         DATE  21FEB90                 */
/*       PREV AMEND NO.S01179         DATE  13/09/88                */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/**/
        PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/***       DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                */ /*S01194*/
           DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                   /*S01194*/
/********  DCLDTAARA  DTAARA(LDA)                                   *  *S01179*/
           DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                  /*S01179*/
/**/
/*  GLOBAL MONITOR MESSAGE  */
/**/
           MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
           SNDPGMMSG  MSG('Abnormal Termination Reporting')            +
                        TOMSGQ(MRUNQ)
/**/
           OVRDBF     FILE(TABLE) TOFILE(TABICD)
/**/
/*  CALL PROGRAM TO REPORT RECORDS IN THE NOTIFY OBJECT  */
/**/
           CALL SD1796
           IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*  CLEAR THE NOTIFY OBJECT  */
/**/
           CLRPFM (MNTYF)
           GOTO END
/**/
/*  ABNORMAL TERMINATION PROCESSING  */
/**/
ABNOR:       SNDPGMMSG  MSG('Abnormal Termination Reporting ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                         GOTO END
/**/
/*  DATABASE ERROR PROCESSING  */
/**/
/** DBERR: ************* RCVDTAARA  DTAARA(LDA) *********************  *S01179*/
DBERR:                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)          /*S01179*/
/***                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44)) */ /*S01194*/
                     CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))    /*S01194*/
                         SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                    MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) +
                                    TOPGMQ(*EXT)
/**/
END:    ENDPGM
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*********************************************************************/
