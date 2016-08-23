/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Send 'release' msg to TI/CSCS after maint')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0041 - Send 'Release' msg to TI/CSCS after maintenance   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI001  *CREATE    Date 01AUG97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('TIC0041 - Send "Release" msg to +
                          TI/CSCS after maintenance') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Call the TI program KAPEQEN                                      */
             CHGVAR     VAR(&LENGTH) VALUE(17)
             CHGVAR     VAR(&SEND) VALUE('*MODE     RELEASE')
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* Call the TI program KAPENEQ                                      */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
             IF         COND(&LENGTH *EQ 0) THEN(DO)
             SNDPGMMSG  MSG('TI failed to respond') TOMSGQ(MRUNQ +
                          MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
/* Abnormal termination  */
             CHGVAR     VAR(&MSG) VALUE('TIC0041 - Send "Release" +
                          msg to TI/CSCS after maintenance +
                          terminated abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
