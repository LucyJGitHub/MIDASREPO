/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Forward Rate Points setup')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                              */
/*                                                                   */
/*       SDC0542 - Set up forward rate points on FWDRTFE.            */
/*                 For switchable feature S01432                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01432             Date 10Jan94              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01432 - Forward Rates by means of Forward Points           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
                CALL       PGM(DL9901)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO  CMDLBL(END)
                ENDDO
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
                CALL       PGM(DL9901)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO  CMDLBL(END)
                ENDDO
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
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
             SNDPGMMSG  MSG('Program DLC9901 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
