/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation Programs for EU Tax')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000782 - Initialisation Programs for EU Tax              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL032  *CREATE    Date 01Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL032 - Automatic Exchange of Information                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNC &MODE)
 
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(SE008090)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(EUTAXTKON) PARM('1')
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(EUTAXTKON) PARM('2')
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(EUTAXTKON) PARM('3')
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
 
ABNOR:
 
 /* Send the error message */
 
             ROLLBACK
             SNDPGMMSG  MSG('Program SDC000782 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
