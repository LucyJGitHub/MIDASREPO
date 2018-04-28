/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FX Unauthorised FX deals control program')      */
/*********************************************************************/
/*                                                                   */
/*    Midas  -  FX Dealer Module                                     */
/*                                                                   */
/*    FXC0840  -  Unauthorised FX Deals control program              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*    LAST AMEND NO. 087340 *CREATE        DATE 04MAY85              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*    087340 - New control pgm for FX0840                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        /* No parameters */
 
             DCL        VAR(&MGDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Monitor for fatal errors and exit program :                  */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set Job switches and LDA :                                   */
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
 
/* Call Unauthorised FX Deals Enquiry                           */
 
             CALL       PGM(FX0840)
 
 
/* Check Job switches for DB/Pgm. error :                      */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MGDA)
                 SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MGDA) +
                            TOMSGQ(*LIBL/MOPERQ)
 
                 SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.+
                            Press ENTER to Continue.') TOPGMQ(*EXT)
             ENDDO
 
 /* No errors - exit program normally :                         */
 
             GOTO       CMDLBL(PGMEND)
 
 /* Database or Program error - inform User and calling pgm.:   */
 
 ABNOR:      SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.    +
                        Press ENTER to Continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
/* Program end (Normal or Abnormal) :                           */
 
 PGMEND:
 
/* Reclaim resources :                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
