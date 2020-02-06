/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cheque book Maintenance')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4212 - Cheque Book File Maintenance                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CSC041             Date 26Nov09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      096490             Date 28Nov95              */
/*                      CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC041 - 4-Eyes Checking Gaps (Applied BUG23918)            */
/*       BUG23918-Dataase error occurs in Cheque Book Maintenance    */
/*                upon pressing F15. Applied GEMS fix 239709A        */
/*       239709A - Session Device Error when subfile records exceed  */
/*                 9999.                                             */
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
 
/**  Send program message */
 
             SNDPGMMSG  MSG('CHEQUE BOOK MAINTENANCE') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/**  Clear switches */
 
             CHGJOB    SWS(00000000)
 
 
/**  Call the program */
 
             CALL          PGM(CRTSDT)                                                   /*239709A*/
             CALL          PGM(RE4212)
             CALL          PGM(DLTSDT)                                                   /*239709A*/
 
 
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
                          REC4212 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**  End of program */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
