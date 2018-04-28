/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MM Initialization Program for CER034')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Module                                 */
/*                                                                   */
/*       SDC000099 - Midas SD Initialisation program for CER034      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG22611A          Date 10Feb09              */
/*                      BUG22611           Date 09Feb09              */
/*                      CER034  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22611A - CER048 init pgm error                           */
/*       BUG22611 - German Features initialization pgm error         */
/*       CER034 - German Features - New Fields and Enquiries         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRTCD &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
 
/** Create LDA */                                                                      /*BUG22611A*/
                                                                                       /*BUG22611A*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                         /*BUG22611A*/
             MONMSG     MSGID(CPF1023)                                                 /*BUG22611A*/
                                                                                       /*BUG22611A*/
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *CAT 'DMLIB')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 /** Call the take-on rpg */
 
             IF         COND(&PMODE *NE '3') THEN(DO)
             CALL       PGM(SD000099)
             ENDDO
 
 /** If error occur */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/**********  ROLLBACK   */                                                              /*BUG22611*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**********  ELSE       CMD(DO)   */                                                    /*BUG22611*/
/**********  COMMIT               */                                                    /*BUG22611*/
/**********  ENDDO                */                                                    /*BUG22611*/
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGVAR     VAR(&PRTCD) VALUE('*ERROR')
 
 /** Send error message */
 
             SNDPGMMSG  MSG('Program SDC000099 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:
             MONMSG     MSGID(CPF2105)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd')
             ENDPGM
