/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE CSE039 initialisation')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Security Trading Module                         */
/*                                                                   */
/*       SEC4310   - CSE039 Initialisation - add trigger to SEMVTSPD */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK020             Date 13Aug04              */
/*                      CSE039 *C *CREATE  Date 10Jul03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK020 - Adding command to SCMNTTRIG.                       */
/*       CSE039 - Automatic Settlement of Trades                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
/**********     CALL       PGM(SCMNTTRIG)   PARM('A' 'SEMVTSPD' 'Y')                   */ /*CPK020*/
                TRIGZONE   ACTION(*ADDTRIG)                                               /*CPK020*/
                CALL       PGM(SE0007)    PARM(&RTCDE &PMODE)
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
/**********     CALL       PGM(SCMNTTRIG)   PARM('A' 'SEMVTSPD' 'Y')                   */ /*CPK020*/
                TRIGZONE   ACTION(*ADDTRIG)                                               /*CPK020*/
                CALL       PGM(SE0007)    PARM(&RTCDE &PMODE)
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
/**********     CALL       PGM(SCMNTTRIG)   PARM('R' 'SEMVTSPD' 'Y')                   */ /*CPK020*/
                TRIGZONE   ACTION(*RMVTRIG)                                               /*CPK020*/
             ENDDO
 
             GOTO       CMDLBL(END)
 
 /**/
/* Abnormal Processing */
 /**/
 ABNOR:      CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /**/
 /* Set off the indicators */
 /**/
             CHGJOB     SWS(XXXXXX00)
 
 /**/
 /* Send the error message */
 /**/
             SNDPGMMSG  MSG('Program SEC4310 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
