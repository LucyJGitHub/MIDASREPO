/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Interim Trade Number Gaps Report')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*         SEC0303 - INTERIM TRADE NUMBER GAPS REPORT               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*         LAST AMEND NO.  S01117            DATE  10DEC90          */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         S01117 - MULTI-BRANCHING                                 *  *S01117*/
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/************DCL VAR(&MEM) TYPE(*CHAR) LEN(44)                     */ /*S01117*/
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
/**/
/*           DCLDTAARA DTAARA(LDA)                                  *  *S01179*/
             DCL       VAR(&LDA)      TYPE(*CHAR)  LEN(256)           /*S01179*/
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             SNDPGMMSG  MSG('Trade Number Ranges Interim Report') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00100000)
/**/
/*           CALL       PGM(SE0630)                                */ /*S01117*/
             CALL       PGM(SE0630) PARM(&RSEQ)                       /*S01117*/
/**/
/*  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RCVDTAARA  DTAARA(LDA)                                */ /*S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01117*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01117*/
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             SNDPGMMSG  MSG('File Controls out of Balance') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
            ENDPGM
