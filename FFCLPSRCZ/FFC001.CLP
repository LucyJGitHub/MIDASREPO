/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Initialisation program for switch')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FUTURES AND OPTIONS MODULE                      */
/*                                                                   */
/*       FFC001  - Initialisation program for switchable             */
/*                 feature S01456                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 215890             Date 23Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01456             Date 02Feb94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       215890 - Create data area LDA if it does not exist.         */
/*       S01456 - Monthly P & L Enhancements                         */
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
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')                                                      /*215890*/
             MONMSG     MSGID(CPF0000)                                                    /*215890*/
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
/**/
                   CLRPFM     CMPRND
/**/
                CALL       PGM(FF0051)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO  CMDLBL(END)
                ENDDO
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
/**/
                   CLRPFM     CMPRND
/**/
                CALL       PGM(FF0051)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO  CMDLBL(END)
/**/
                ENDDO
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
/**/
                   CLRPFM     CMPRND
                CALL       PGM(FF0053)
                    GOTO  CMDLBL(END)
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
             SNDPGMMSG  MSG('Program FFC001 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
