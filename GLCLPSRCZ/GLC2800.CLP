/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis account details maintenance')         */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2800    Fontis Accounts Details Maintenance                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CGL004 *C *CREATE  Date 22Jan96              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&RTCD &ACNT &ACTN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
/**********  DCL        VAR(&ACNT) TYPE(*CHAR) LEN(18) */                                 /*CGL029*/
             DCL        VAR(&ACNT) TYPE(*CHAR) LEN(24)                                    /*CGL029*/
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YORN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Call Program GL2801                                               */
/**/
             CALL       PGM(GL2801) PARM(&RTCD &YORN)
/**/
/* If database error occurs, standard abnormal termination          */
/* processing performed.                                            */
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* If F3 or F12 is pressed, then end program                        */
/**/
             IF         COND((&RTCD = 'Y2U9999') *OR (&RTCD = +
                          'USR0790')) THEN(GOTO CMDLBL(END))
/**/
/* If return code is not blank, (error has occurred), then perform  */
/* standard abnormal termination processing.                        */
/**/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/* If no error occurred, then call GL2800.                          */
/**/
             IF         COND((&RTCD *EQ '       ') *AND (&YORN *EQ +
                          'Y')) THEN(CALL PGM(GL2800) PARM(&RTCD +
                          &ACNT &ACTN))
/**/
/* If database error occurs, perform standard abnormal termination  */
/* processing.                                                      */
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                           ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
