/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Fwd Recovery(Last 'xx' Transactions)')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1795- FORWARD RECOVERY (LAST 'XX' TRANSACTIONS)         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.096044         DATE  29MAR96                 */
/*       PREV AMEND NO.S01194         DATE  21FEB90                 */
/*                     E13205         DATE  11/03/89                */
/*                     S01179         DATE  13/09/88                */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       096044  -  Convert to AS/400 naming conventions            */
/*       S01194  -  NEW STANDING DATA                               */
/*       E13205  -  Delete data area RCD in QTEMP on entry          */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/**/
        PGM    PARM(&PARM &LRTP)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
           DCL   VAR(&CNT)   TYPE(*DEC) LEN(2 0)
           DCL   VAR(&SEQN1) TYPE(*DEC) LEN(10 0)
           DCL   VAR(&PARM)  TYPE(*DEC) LEN(2 0)
           DCL   VAR(&OPTN)  TYPE(*DEC) LEN(2 0)
           DCL   VAR(&LRTP)  TYPE(*CHAR) LEN(10)
           DCL   VAR(&LRTPD) TYPE(*DEC) LEN(10 0)
           DCL   VAR(&RSEQ)  TYPE(*DEC) LEN(10 0)
           DCL   VAR(&RENT)  TYPE(*CHAR) LEN(2)
           DCL   VAR(&RJRN)  TYPE(*CHAR) LEN(576)
           DCL   VAR(&CRRNT)  TYPE(*CHAR) LEN(8)
/***       DCL   VAR(&MEM)   TYPE(*CHAR) LEN(44)                   */ /*S01194*/
           DCL   VAR(&MEM)   TYPE(*CHAR) LEN(50)                      /*S01194*/
/********  DCLDTAARA  DTAARA(LDA)                                   *  *S01179*/
           DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                  /*S01179*/
/********  DCLDTAARA  DTAARA(JNSTAT)                                *  *S01179*/
           DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)               /*S01179*/
/**/
/*  GLOBAL MONITOR MESSAGE  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Forward Recovery (Last XX Transactions')  +
                        TOMSGQ(MRUNQ)
/*                                                                 */ /*E13205*/
/*  Delete data area RCD.QTEMP but expect to be not found          */ /*E13205*/
/*                                                                 */ /*E13205*/
/*******   DLTDTAARA  DTAARA(RCD.QTEMP)                    /*E13205*/ /*096044*/
           DLTDTAARA  DTAARA(QTEMP/RCD)                               /*096044*/
           MONMSG     MSGID(CPF2105)                                  /*E13205*/
/*******   CRTDTAARA   DTAARA(RCD.QTEMP) TYPE(*CHAR) LEN(576)         /*096044*/
           CRTDTAARA   DTAARA(QTEMP/RCD) TYPE(*CHAR) LEN(576)         /*096044*/
           CHGVAR      VAR(&LRTPD) VALUE(&LRTP)
           CHGVAR      VAR(&SEQN1) VALUE(&LRTPD-1)
           CLRPFM      FILE(JRNEX1)
/**/
/********  RCVDTAARA  DTAARA(JNSTAT)                                *  *S01179*/
           RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                  /*S01179*/
           CHGVAR &CRRNT (%SST(&JNSTAT 1 8))
/**/
/* SEARCH FOR 'ER'&'CM' JOURNAL ENTRIES TILL 'XX' TRANSACTIONS FOUND */
/**/
LOOP:      RTVJRNE     JRN(ICJRN) RCVRNG(&CRRNT ICRCV001)         +
                     FROMENT(&SEQN1) TOENT(*FIRST) SEARCH(*DESCEND)   +
                     ENTTYP(CM ER) RTNSEQNBR(&RSEQ) RTNENTTYP(&RENT) +
                     RTNJRNE(&RJRN)
           MONMSG MSGID(CPF7073) EXEC(GOTO CALL)
/**/
           IF     COND(&RENT *EQ 'ER') THEN(CHGVAR &SEQN1 (%SUBSTRING+
                  (&RJRN 126 10)))
           ELSE
                IF  COND((%SUBSTRING(&RJRN 176 1)) *EQ ' ') +
                    THEN(DO)
                      CHGVAR &SEQN1 (&RSEQ-1)
                      GOTO LOOP
                    ENDDO
                ELSE
                   DO
/**/
/* CALL SD1795  TO WRITE TRANSACTION TO JOURNAL EXTRACT FILE    */
/**/
                     CHGDTAARA RCD (&RJRN)
                     CALL SD1795
                     CHGVAR &CNT (&CNT+1)
                     IF   COND(&CNT *EQ &PARM) THEN(GOTO CALL)
                     CHGVAR &SEQN1 (&RSEQ-1)
                   ENDDO
            GOTO LOOP
/**/
/*  CALL PROGRAM TO REPORT SELECTED ENTIES  */
/**/
CALL:       OVRDBF     FILE(TABLE) TOFILE(TABICD)
            CHGVAR     VAR(&OPTN) VALUE(4)
            CALL       PGM(SD1794) PARM(&OPTN &PARM)
            IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
            CLRPFM JRNEX1
/*********  DLTDTAARA RCD.QTEMP                                       /*096044*/
            DLTDTAARA  DTAARA(QTEMP/RCD)                              /*096044*/
                         GOTO END
/**/
/*  ABNORMAL TERMINATION PROCESSING  */
/**/
ABNOR:       SNDPGMMSG  MSG('Forward Recovery (LAST XX TRANSACTIONS) +
                        ENDED ABNORMALLY') TOPGMQ(*EXT)              +
                        TOMSGQ(MOPERQ MRUNQ)
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
