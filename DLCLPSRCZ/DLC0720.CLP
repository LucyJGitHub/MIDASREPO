/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas DL Deals Due For Automatic Rollover Today')     */
/********************************************************************/
/*                                                                  */
/*       Midas - Dealing Module                                     */
/*                                                                  */
/*       DLC0720 - Deals due for Automatic Rollover Today           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2004          */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL016 *Create    Date  03Feb04             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CDL016 - Autumatic Rollover of Fixed Term Loan/Dep         */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&RSEQ &RLVL &RENT &PARMS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARMS) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
 
/***  Monitor for any errors and send appropriate message to MOPERQ */
 
             MONMSG (RPG0000 CPF0000 MCH0000) EXEC(GOTO (ERROR))
 
/***  Initialise Switches and LDA  */
 
             CHGJOB SWS(00000000)
             CHGDTAARA (LDA) VALUE(' ')
 
 
/***  Report                                                         */
               CALL (DL0720) PARM(&RSEQ &RENT &PARMS)
 
/***  Check for Database Error  */
 
               IF (%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA (LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                 GOTO (ERROR)
               ENDDO
 
             GOTO (END)
 
 ERROR:
             SNDMSG ('MM Deals due for Automatic Rollover Today +
                  terminated abnormally.') TOMSGQ(MOPERQ MRUNQ)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 END:        ENDPGM
