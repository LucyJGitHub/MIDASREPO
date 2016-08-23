/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE MONTHLY PROCESSING')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC10 - MONTHLY PROCESSING REPORTING                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 098552          DATE  24MAR97               */
/*       PREV AMEND NO. S01117          DATE  07FEB90               */
/*                      S01194          DATE  11DEC89               */
/*                      S01179          DATE  14/09/88              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       098552 - Allow reports to be produced at non-EOM run.      */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                  * *S01117*/
             PGM PARM(&PARM &RSEQ &RLEV &RENT)                        /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*********** DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*********** DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/**/
             CHGJOB     SWS(00000000)
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)             */ /*098552*/
/************IF         COND(%SUBSTRING(&LESTAT 13 1) *NE 'Y') +
                        THEN(GOTO CMDLBL(ENDPGM))                  */ /*098552*/
/***************CALL       PGM(&PARM)                      */         /*S01117*/
                CALL       PGM(&PARM) PARM(&RSEQ &RLEV &RENT)         /*S01117*/
/**/
/*   ERROR MESSAGES                                             */
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*****CHGVAR ****VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))          */ /*S01194*/
      CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))             /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                                               BALANCE')
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***ENDPGM:*****ENDPGM                                             */ /*098552*/
                ENDPGM                                                /*098552*/
