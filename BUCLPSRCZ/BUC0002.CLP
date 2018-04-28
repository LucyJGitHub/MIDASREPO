/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas BU Call Leo program CCIU10')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     Background Update                                 */
/*                                                                   */
/*       BUC0002 - Call LEO program CCIU10                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01467             DATE 27MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01467  -  Midas-Leo Integration - New program              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN &PAR1 &PAR2)
 
/** Declare the parameters and variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PAR1) TYPE(*CHAR) LEN(800)
             DCL        VAR(&PAR2) TYPE(*CHAR) LEN(800)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
/** Global monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Change the switches U7 & U8 off */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Retrieve the Library name for the LEO program CCIU10 */
 
             RTVDTAARA  DTAARA(*LDA (51 10)) RTNVAR(&LIB)
 
/** Call the LEO update program CCIU10 */
 
             CALL       PGM(&LIB/CCIU10) PARM(&RTN &PAR1 &PAR2)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal error processing */
 
 ABNOR:      SNDPGMMSG  MSG('Program BUC0002 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
