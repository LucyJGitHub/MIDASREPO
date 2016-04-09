/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR FRA/IRS revaluations')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - FRA/IRS Module                                      */
/*                                                                   */
/*       IRC1950 - FRA/IRS Revaluation Reports Control               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAS006             Date 21Jan03              */
/*       Prev Amend No. CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAS006 - Hedge Accounting Phase B                           */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
 
             PGM PARM(&MODE &TYPE &SEQ &LVL &ENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             DCL  VAR(&MODE)   TYPE(*CHAR) LEN(1)
             DCL  VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL  VAR(&ENT)    TYPE(*CHAR) LEN(3)                                         /*CAS006*/
             DCL  VAR(&CCY)    TYPE(*CHAR) LEN(3)                                         /*CAS006*/
             DCL  VAR(&BOOK)   TYPE(*CHAR) LEN(2)                                         /*CAS006*/
             DCL  VAR(&SEQ)    TYPE(*CHAR) LEN(5)
             DCL  VAR(&LVL)    TYPE(*CHAR) LEN(1)
             DCL  VAR(&ENT)    TYPE(*CHAR) LEN(3)
             DCL  VAR(&RPARM)  TYPE(*CHAR) LEN(100)
             DCL  VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL  VAR(&STAT)   TYPE(*CHAR) LEN(1)
             DCL  VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL  VAR(&SYSID)  TYPE(*CHAR) LEN(2)
             DCL  VAR(&DPLIB)  TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL  VAR(&PRTCD)  TYPE(*CHAR) LEN(7)                                         /*CAS006*/
             DCL  VAR(&POPTN)  TYPE(*CHAR) LEN(7)                                         /*CAS006*/
             DCL  VAR(&PSARN)  TYPE(*CHAR) LEN(6)                                         /*CAS006*/
             DCL  VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                       /*CAS006*/
             DCL  VAR(&CAS006) TYPE(*CHAR) LEN(1) VALUE('N')                              /*CAS006*/
 
/* Monitor for any errors and send appropriate message to MOPERQ */
 
             MONMSG (RPG0000 CPF0000 MCH0000) EXEC(GOTO (ABNOR))
 
/* Initialise Switches and LDA */
 
             CHGJOB SWS(00000000)
             CHGDTAARA (LDA) VALUE(' ')
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
 
/* Check if CAS006 is enabled. */                                                         /*CAS006*/
                                                                                          /*CAS006*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CAS006*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CAS006*/
             CHGVAR     VAR(&PSARN) VALUE('CAS006')                                       /*CAS006*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARN +
                          &SCSARD)                                                        /*CAS006*/
             IF         COND(&PRTCD *EQ '       ') +
                  THEN(CHGVAR VAR(&CAS006) VALUE('Y'))                                    /*CAS006*/
                                                                                          /*CAS006*/
             IF         COND(&MODE *EQ 'F' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10001))
             IF         COND(&MODE *EQ 'S' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10002))
             IF         COND(&MODE *EQ 'X' *AND &TYPE *EQ '1') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10003))
             IF         COND(&MODE *EQ 'F' *AND &TYPE *EQ '2') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(1))
             IF         COND(&MODE *EQ 'S' *AND &TYPE *EQ '2') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(2))
             IF         COND(&MODE *EQ 'X' *AND &TYPE *EQ '2') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(3))
             IF         COND(&MODE *EQ 'F' *AND &TYPE *EQ '3') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10004))
             IF         COND(&MODE *EQ 'S' *AND &TYPE *EQ '3') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10005))
             IF         COND(&MODE *EQ 'X' *AND &TYPE *EQ '3') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(10006))
             IF         COND(&MODE *EQ 'F' *AND &TYPE *EQ '4') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(4))
             IF         COND(&MODE *EQ 'S' *AND &TYPE *EQ '4') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(5))
             IF         COND(&MODE *EQ 'X' *AND &TYPE *EQ '4') THEN+
                        (CHGVAR VAR(&CSEQ) VALUE(6))
 
/* Call program CB0160 to get value of restart indicator */
 
             IF         COND(&TYPE *NE 'I') THEN(DO)
             CALL       PGM(CB0160) PARM('IRC1950' &CSEQ &STAT)
 
/* If it is not a restart */
 
             IF         COND(&STAT *NE 'Y') THEN(DO)
                  DLTF       FILE(XIRNPVBPD)
                  MONMSG     MSGID(CPF2105)
                  DLTF       FILE(XRXNPVBPD)
                  MONMSG     MSGID(CPF2105)
                                                                                          /*CAS006*/
                  IF         COND(&CAS006 *EQ 'Y') THEN(DO)                               /*CAS006*/
                       DLTF       FILE(XFRNPVLPD)                                         /*CAS006*/
                       MONMSG     MSGID(CPF2105)                                          /*CAS006*/
                  ENDDO                                                                   /*CAS006*/
 
/* Create a backup for IRNPVBPD, RXNPVBPD */
/* and FRNPVLPD. */                                                                       /*CAS006*/
 
                  CPYF       FROMFILE(IRNPVBPD) TOFILE(&DPLIB/XIRNPVBPD) +
                             CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                  CPYF       FROMFILE(RXNPVBPD) TOFILE(&DPLIB/XRXNPVBPD) +
                             CRTFILE(*YES)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                                                                                          /*CAS006*/
                  IF         COND(&CAS006 *EQ 'Y') THEN(DO)                               /*CAS006*/
                       CPYF       FROMFILE(FRNPVLPD) +
                             TOFILE(&DPLIB/XFRNPVLPD) CRTFILE(*YES)                       /*CAS006*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*CAS006*/
                  ENDDO                                                                   /*CAS006*/
                                                                                          /*CAS006*/
             ENDDO
 
/* If it is a restart */
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
                  CPYF       FROMFILE(&DPLIB/XIRNPVBPD) TOFILE(IRNPVBPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                  CPYF       FROMFILE(&DPLIB/XRXNPVBPD) TOFILE(RXNPVBPD) +
                             MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                                                                                          /*CAS006*/
                  IF         COND(&CAS006 *EQ 'Y') THEN(DO)                               /*CAS006*/
                       CPYF       FROMFILE(&DPLIB/XFRNPVLPD) +
                                  TOFILE(FRNPVLPD) MBROPT(*REPLACE)                       /*CAS006*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                          /*CAS006*/
                  ENDDO                                                                   /*CAS006*/
                                                                                          /*CAS006*/
             ENDDO
 
             CHGVAR     VAR(&STAT) VALUE('Y')
 
/* Call CB0150 to update restart indicator */
 
             CALL       PGM(CB0150) PARM('IRC1950' &CSEQ &STAT)
             ENDDO
 
/* Set up the Parameters for the Reports:                         */
/* If all Branches are selected, RCF passes 'ALL' as the entity.  */
 
               IF (&ENT = 'ALL') THEN(CHGVAR (&ENT) VALUE('   '))
 
               IF COND(&CAS006 *EQ 'Y') THEN(DO)                                          /*CAS006*/
                                                                                          /*CAS006*/
                    CHGVAR (&CCY)  VALUE(%SST(&RPARM 1 3))                                /*CAS006*/
                    IF (&CCY = '***') THEN(CHGVAR (&CCY) VALUE('   '))                    /*CAS006*/
                                                                                          /*CAS006*/
                    CHGVAR (&BOOK) VALUE(%SST(&RPARM 4 2))                                /*CAS006*/
                    IF (&BOOK = '**') THEN(CHGVAR (&BOOK) VALUE('  '))                    /*CAS006*/
                                                                                          /*CAS006*/
/* Call the FRA Revaluation Report. */                                                    /*CAS006*/
                                                                                          /*CAS006*/
                    IF (&MODE *EQ 'F') THEN(DO)                                           /*CAS006*/
                         SNDMSG ('IRC1950 - FRA Revaluation Report') +
                            TOMSGQ(MRUNQ)                                                 /*CAS006*/
                         CALL (IR1950) PARM(&TYPE &ENT &CCY &BOOK &SEQ)                   /*CAS006*/
                                                                                          /*CAS006*/
/* Check for Database Error. */                                                           /*CAS006*/
                                                                                          /*CAS006*/
                         IF (%SWITCH(XXXXXX11)) THEN(DO)                                  /*CAS006*/
                              RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)                       /*CAS006*/
                              SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)                           /*CAS006*/
                              GOTO (ABNOR)                                                /*CAS006*/
                         ENDDO                                                            /*CAS006*/
                    ENDDO                                                                 /*CAS006*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CAS006*/
             IF (&MODE *EQ 'S') THEN(DO)
               SNDMSG ('IRC1950 - IRS (Single Currency) Revaluation +
                       Report') TOMSGQ(MRUNQ)
 
/* Revaluation Report */
 
               IF (%SWITCH(XXXXXX00)) THEN(DO)
               CALL (IR1956) PARM(&MODE &TYPE &SEQ)
               ENDDO
 
/* Check for Database Error */
 
               IF (%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                 GOTO (ABNOR)
               ENDDO
             ENDDO
 
/* Call IRS (Cross Currency) Revaluation Report */
 
             IF (&MODE *EQ 'X') THEN(DO)
               SNDMSG ('IRC1950 - IRS (Cross Currency) Revaluation +
                       Report') TOMSGQ(MRUNQ)
 
/* Revaluation Report */
 
               IF (%SWITCH(XXXXXX00)) THEN(DO)
               CALL (IR1956) PARM(&MODE &TYPE &SEQ)
               ENDDO
 
/* Check for Database Error */
 
               IF (%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                 GOTO (ABNOR)
               ENDDO
             ENDDO
 
/* If no error occured in the program */
 
             IF         COND(&TYPE *NE 'I') THEN(DO)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Call CB0150 to update restart indicator */
 
                  CHGVAR     VAR(&STAT) VALUE('N')
                  CALL       PGM(CB0150) PARM('IRC1950' &CSEQ &STAT)
                  DLTF       FILE(XIRNPVBPD)
                  MONMSG     MSGID(CPF2105)
                  DLTF       FILE(XRXNPVBPD)
                  MONMSG     MSGID(CPF2105)
                                                                                          /*CAS006*/
                  IF         COND(&CAS006 *EQ 'Y') THEN(DO)                               /*CAS006*/
                       DLTF       FILE(XFRNPVLPD)                                         /*CAS006*/
                       MONMSG     MSGID(CPF2105)                                          /*CAS006*/
                  ENDDO                                                                   /*CAS006*/
                                                                                          /*CAS006*/
             ENDDO
             ENDDO
 
             GOTO (END)
 
/* Abnormal termination - batch job */
 
 ABNOR:      SNDMSG ('IRS-RS Revaluation Report has +
                     terminated abnormally.') TOMSGQ(MOPERQ MRUNQ)
 
             CPYF       FROMFILE(&DPLIB/XIRNPVBPD) TOFILE(IRNPVBPD) +
                        MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(&DPLIB/XRXNPVBPD) TOFILE(RXNPVBPD) +
                        MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                                                                                          /*CAS006*/
             IF         COND(&CAS006 *EQ 'Y') THEN(DO)                                    /*CAS006*/
                  CPYF       FROMFILE(&DPLIB/XFRNPVLPD) +
                  TOFILE(FRNPVLPD) MBROPT(*REPLACE)                                       /*CAS006*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                               /*CAS006*/
             ENDDO                                                                        /*CAS006*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
