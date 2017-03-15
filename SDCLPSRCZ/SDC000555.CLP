/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Initialisation program for CGL132')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000555 - Midas SD Initialisation program for CGL132      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. MD039642  *CREATE  Date 27Jul16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD039642 - Switching Off CGL132 feature duplicate FATCA     */
/*                    records                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2016')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/** Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
                CALL       PGM(SD000555)
             ENDDO
 
 
/** Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
/** Send the error message */
 
             SNDPGMMSG  MSG('Program SDC000555 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End program */
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
