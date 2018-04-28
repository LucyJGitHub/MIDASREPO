/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OUTSTANDING DELIVERY INSTRUCTIONS')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0811 - OUTSTANDING DELIVERY INSTRUCTIONS                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E27942                  DATE  03SEP91       */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*                                                                  */
/********************************************************************/
/**/
             PGM PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B) */
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch*/
/*                                                                  */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
 
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/*/COPY WNCPYSRC,DLC0811001                                          */
/*  NO DL0670 FOR COMPANY REPORTS  */
                   IF      COND(&RLEV *NE 'C') THEN(DO)
/**/
/*  FOR SYSTEM REQUESTS TREAT AS BRANCH  */
/*********************IF      COND(&RLEV *EQ 'S') THEN(DO)           * *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E27942*/
                           CHGVAR     VAR(&RENT) VALUE('ALL')
                      ENDDO
/*/COPY WNCPYSRC,DLC0811002                                          */
/**/
                   SNDMSG    MSG('OUTSTANDING DELIVERY INSTRUCTIONS +
                                 REPORT') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC0811003                                          */
                   CALL      PGM(DL0670) PARM(&RSEQ &RENT)
/*/COPY WNCPYSRC,DLC0811004                                          */
                   RTVJOBA   SWS(&SWS)
/*/COPY WNCPYSRC,DLC0811005                                          */
/**/
                   ENDDO
/*/COPY WNCPYSRC,DLC0811006                                          */
/**/
ERRCHK:
/*   ERROR MESSAGES                                           */
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
