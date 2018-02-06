/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AP Submit *_DBU jobs from a batch job')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - API Module                                          */
/*                                                                   */
/*       APC0410 - Submit *_DBU Jobs from a Batch Job                */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK016             Date 09Jul03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015  *CREATE    Date 10MAY02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK016 - End successful run with *NOLIST.                   */
/*       CPK015 - New program to sped up user signon.                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
/*/COPY WNCPYSRC,APC0410INT                                          */
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ABNORFLAG) TYPE(*CHAR) LEN(1)                                /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,APC0410MPS                                          */
 
             CALL       PGM(APCSTRBKJB)
 
/*/COPY WNCPYSRC,APC0410MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,APC0410ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&ABNORFLAG) VALUE('Y')                                        /*CPK016*/
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          APC0410 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             IF         COND(&ABNORFLAG *EQ ' ') THEN(DO)                                 /*CPK016*/
                CHGJOB     LOG(*SAME *SAME *NOLIST)                                       /*CPK016*/
             ENDDO                                                                        /*CPK016*/
                                                                                          /*CPK016*/
/*/COPY WNCPYSRC,APC0410END                                          */
 
             ENDPGM
