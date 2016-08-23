/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX Control revalue daily positions')            */
/*********************************************************************/
/*                                                                   */
/*     Midas - FX Dealer Module                                      */
/*                                                                   */
/*     FXC0590   - REVALUE DAILY POSITIONS                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. XXXXX               DATE XX/XX/XX              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&@MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global MONMSG to trap any unexpected errors */
             MONMSG     MSGID(CPF0000)
/**/
/* set the switches 7 and 8 off */
             CHGJOB     SWS(00000000)
/**/
/* call FX0590 revalue daily positions */
             CALL       PGM(FX0590)
/**/
/* if U7 or U8 are set on then it is a data base error, so */
/* send a data base error message to message queue MOPERQ  */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&@MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&@MSG) +
                             TOMSGQ(MOPERQ)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDTAG:     ENDPGM
