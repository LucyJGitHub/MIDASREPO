/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Initialise Branch Status')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4480  - Initialise Branch Status                         */
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
/*       Prev Amend No. 118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22Jul96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
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
                CALL       PGM(RE4480)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal Processing */
 
 ABNOR:      SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program REC4480A +
                          ended abnormally')
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  TOMSGQ(QSYSOPR) MSG('Program REC4480A +
                          ended abnormally')                          /*118134*/
             ENDDO                                                    /*118134*/
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
