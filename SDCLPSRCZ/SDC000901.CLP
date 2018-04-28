/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Swift Codes Initialization')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000901 - Midas Swift Codes Initialization                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG22611           Date 09Feb09              */
/*                      BG22257 *CREATE    Date 21Jan09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG22611 - German Features initialization pgm error         */
/*       BG22257 - Midas Swift Codes Initialization                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PRTCD &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('SDC000901 - Midas Swift Codes +
                          Initialization') TOMSGQ(MRUNQ)
 
/****Start*commitment*control**/                                                        /*BUG22611*/
 
             IF         COND(&PMODE *NE '3') THEN(DO)
 
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)  */                                 /*BUG22611*/
/**********  MONMSG     MSGID(CPF8351)               */                                 /*BUG22611*/
 
             CALL       PGM(SD200099) PARM('SWIFT' 'SWIFT' 'Y')
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
 
             SNDPGMMSG  MSG('Program SDC000901 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
