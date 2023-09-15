/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('BA6048 - Initialization program - SPI4')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Feature activation - Special Instructions in LE     */
/*                                                                   */
/*       A6C000095 - Initialization Program to run after installat.  */
/*                                                                   */
/*       (c)  Copyright Finastra International Limited 2023          */
/*                                                                   */
/*       Last Amend No. BA6048  *CREATE    Date 01Mar23              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BA6048 - New Special Instructions for LE Loans              */
/*                                                                   */
/*********************************************************************/

/***  Start Program.  ***/

 START:      PGM        PARM(&RETURN &MODE)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2023')

/***  Declare parameter.  ***/

             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFZONE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&COMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxCOMLIB')

 /***  Monitor for Error Messages from System.  ***/

             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))

 /***  Reset Error values - switches  ***/

             CHGJOB     SWS(XXXXXX00)

 /***  Modes ***/

             IF         COND(&MODE *EQ '1') THEN(DO)
                  CHGVAR     VAR(&PGM) VALUE('A6000095  ')
                  CALL       PGM(&PGM) PARM(&RETURN &MODE)
             IF         COND(&RETURN *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO

             IF         COND(&MODE *EQ '2') THEN(DO)
                  CHGVAR     VAR(&PGM) VALUE('A6000095  ')
                  CALL       PGM(&PGM) PARM(&RETURN &MODE)
             IF         COND(&RETURN *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO

             GOTO       CMDLBL(ENDPGM)

 /***  Send Message to User alerting failure.  ***/

 ABNOR:      SNDPGMMSG  MSG('Error During ' *CAT &PGM *CAT ' +
                          Initiation') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&RETURN) VALUE('*ERROR ')
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)

/***  End Program.  ***/

 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra +
                          International Ltd.')
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)

             ENDPGM
