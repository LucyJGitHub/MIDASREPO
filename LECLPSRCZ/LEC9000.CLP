/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE New Settlement fields Set-up (S01518)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC9000   - BLI LE PF/CLOANCL, PF/CLOANCK, PF/MCLONCL,      */
/*                   PF/MCLONCK and PF/LOAMSDK New Settlement        */
/*                   fields Set-up for S01518                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01518 *C *CREATE  Date 03Oct94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       S01518 - BLI Lending Swift Enhancement.                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
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
                CALL       PGM(LE9000) PARM(&PMODE)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO  CMDLBL(END)
                ENDDO
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
                CALL       PGM(LE9000) PARM(&PMODE)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO   CMDLBL(END)
                ENDDO
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                CALL       PGM(LE9000) PARM(&PMODE)
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                    GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
 /**/
 /* Abnormal Processing */
 /**/
 ABNOR:      CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /**/
 /* Send the error message */
 /**/
             SNDPGMMSG  MSG('Program LEC9000 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
