/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Prompt for status of link during maint.')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0040 - Prompt for Status of Midas/TI Link during         */
/*                 Maintenance                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend     CTI001  *CREATE    Date 06AUG97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SYSNM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
 
             DCLF       FILE(TIC0040DF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&MSG) VALUE('TIC0040 - Prompt for Status +
                          of Midas/TI Link during Maintenance')
 
/* Display System and User Name */
             RTVNETA    SYSNAME(&SYSNM)
             RTVJOBA    USER(&USERID)
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
 
/* Display and read the prompt */
SNDRCVF:     SNDRCVF
 
/* Process the reply */
             IF         COND(&REPLY *EQ 'Y') THEN(DO)
 
/* Call the TI program KAPEQEN  */
             CHGVAR     VAR(&LENGTH) VALUE(17)
             CHGVAR     VAR(&SEND) VALUE('*MODE     SUSPEND')
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* Call the TI program KAPENEQ  */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
             IF         COND(&LENGTH *EQ 0) THEN(DO)
             SNDPGMMSG  MSG('TI failed to respond') TOMSGQ(MRUNQ +
                          MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&REPLY *EQ 'N') THEN(DO)
 
/* Call the TI program KAPEQEN  */
             CHGVAR     VAR(&LENGTH) VALUE(17)
             CHGVAR     VAR(&SEND) VALUE('*MODE     OFFLINE')
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* Call the TI program KAPENEQ  */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
             IF         COND(&LENGTH *EQ 0) THEN(DO)
             SNDPGMMSG  MSG('TI failed to respond') TOMSGQ(MRUNQ +
                          MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(SNDRCVF)
 
/* Abnormal termination  */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&MSG) VALUE('TIC0040 - Prompt for Status +
                          of Midas/TI Link during Maintenance +
                          terminated abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
