/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Standing data download')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0001 - TI Bulk Download                                  */
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
/*       Prev Amend     CTI001  *CREATE    Date 12Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SYSNM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&SRVOK) TYPE(*CHAR) LEN(6)
 
             DCLF       FILE(TIC0001DF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Set program's name */
             CHGVAR     VAR(&##PGM) VALUE('TIC0001')
 
/* Display System and User Name */
             RTVNETA    SYSNAME(&SYSNM)
             RTVJOBA    USER(&USERID)
 
 SNDRCVF:    RMVMSG     PGMQ(*SAME (&##PGM)) MSGQ(*PGMQ) CLEAR(*ALL)
             IF         COND(&MSG *NE ' ') THEN(SNDPGMMSG MSG(&MSG) +
                          TOPGMQ(*SAME))
             SNDF       RCDFMT(MSGCTL)
 
/* Display and read the prompt */
             SNDRCVF    RCDFMT(TIC0001F1)
 
/* F12 is pressed */
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(END))
 
/* The server's name cannot be blank */
             IF         COND(&DEPSRV *EQ '  ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('The server name cannot be +
                          blank')
             CHGVAR     VAR(&IN10) VALUE('1')
             GOTO       CMDLBL(SNDRCVF)
             ENDDO
 
             IF         COND(&IN07 *EQ '1') THEN(DO)
/* Call the TI program KAPEQEN  */
             CHGVAR     VAR(&LENGTH) VALUE(12)
             CHGVAR     VAR(&SEND) VALUE('*STATUS   ' *CAT &DEPSRV)
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* Call the TI program KAPENEQ  */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
             IF         COND(&LENGTH *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('TI failed to respond')
             GOTO       CMDLBL(SNDRCVF)
             ENDDO
 
/* If the server is ready call KCMMVC, else send error msg */
             CHGVAR     VAR(&SRVOK) VALUE(&DEPSRV *CAT 'OK')
             IF         COND(%SST(&SEND 11 4) *EQ &SRVOK) THEN(DO)
             CALL       PGM(KCMMVC) PARM(&DEPSRV)
             GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&MSG) VALUE('The server ' *CAT &DEPSRV +
                          *CAT ' is not ready')
             CHGVAR     VAR(&IN10) VALUE('1')
             GOTO       CMDLBL(SNDRCVF)
             ENDDO
             ENDDO      /* IN07 */
 
/* Enter is pressed */
             CHGVAR     VAR(&MSG) VALUE('Press F7 to continue')
             CHGVAR     VAR(&IN10) VALUE('0')
             GOTO       CMDLBL(SNDRCVF)
 
/* Abnormal termination  */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&MSG) VALUE('TIC0001 - TI Bulk Download +
                          terminated abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
