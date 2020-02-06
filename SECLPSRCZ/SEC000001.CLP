/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Initialisation program for CSE071')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SEC000001 - Initialisation program for CSE071               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE071  *CREATE    Date 26May05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE071 - Multiple Holidays Re Securities                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
             CALL       PGM(SE000001) PARM('Y')
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
             CALL       PGM(SE000001) PARM('Y')
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             CALL       PGM(SE000001) PARM('N')
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
/* Send the error message */
 
             SNDPGMMSG  MSG('Program SEC000001 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* End program */
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
