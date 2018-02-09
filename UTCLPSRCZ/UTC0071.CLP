/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Update Data Area')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0071 - Update data area                                  */
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
/*       Prev Amend No. CREATE             Date 05Mar96              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CREATE - Rewrite of AMDDTAARA                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DATA_LIB &LENGTH &TYPE &NUMERIC &DATA)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA_LIB) TYPE(*CHAR)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(3000)
             DCL        VAR(&NUMERIC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&COMMAND) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LENGTHA) TYPE(*DEC) LEN(5)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             CHGJOB     SWS(XXXXX000)
/* */
/* Set up paramters for CHGDTAARA command */
/* */
             CHGVAR     VAR(&NAME) VALUE(%SST(&DATA_LIB 1 10))
             CHGVAR     VAR(&LIBRARY) VALUE(%SST(&DATA_LIB 11 10))
             CHGVAR     VAR(&LENGTHA) VALUE(&LENGTH)
/* */
/* Update data area, if numeric concatenate string */
/* */
             IF         COND(&TYPE *NE '*DEC') THEN(DO)
             CHGDTAARA  DTAARA(&LIBRARY/&NAME *ALL) VALUE(%SST(&DATA +
                          1 &LENGTH))
             ENDDO
             IF         COND(&TYPE *EQ '*DEC') THEN(DO)
             CHGVAR     VAR(&COMMAND) VALUE('CHGDTAARA  DTAARA(' +
                          *TCAT &LIBRARY *TCAT '/' *TCAT &NAME +
                          *BCAT ' *ALL) VALUE(' *CAT &NUMERIC *CAT ')')
             CALL       PGM(QCMDEXC) PARM(&COMMAND 100)
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Abnormal termination processing                       */
/* */
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program UTC0070 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTC0070 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
             ENDPGM
