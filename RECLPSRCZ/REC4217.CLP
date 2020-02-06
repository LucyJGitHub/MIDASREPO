/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Presented Cheques Maintenance')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4217 - Presented Cheques Maintenance                     */
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
/*       Prev Amend No. 096490             Date 28Nov95              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**  Send program Message */
 
             SNDPGMMSG  MSG('PRESENTED CHEQUES MAINTENANCE') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
 
/**  Clear switches */
 
             CHGJOB    SWS(00000000)
 
 
/**  Call the program */
 
             CALL          PGM(RE4217)
 
 
 
/**  For database errors, recover data from LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4217 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**  End of program */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
/**/
