/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Check ending of ECS line at MKI   AUTOLIB')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       ACC4011 - Check for ending of ECS line                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Note: This program must be recompiled in library            */
/*             AUTOLIB on the office machine.                        */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 101930             Date 08JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       101930 - New program created for Autocall.                  */
/*                Program is called from RPG/AC4010 to end the ECS   */
/*                link by checking content of data area ECSRMTxx.    */
/*                Program should exist in lib. AUTOLIB on office m/c.*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIN)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&LIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ECSRMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ECSRMTXX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&ECSRMT) VALUE('ECSRMT' *TCAT &LIN)
 
/* Loop until dataarea ECSRMTxx is cleared */
 
 LOOP:       DLYJOB     DLY(120)
 
             RTVDTAARA  DTAARA(&ECSRMT (1 10)) RTNVAR(&ECSRMTXX)
             IF         COND(&ECSRMTXX *NE '          ') THEN(GOTO +
                          CMDLBL(LOOP))
             GOTO END
 
/* Abnormal error processing */
 
 ABNOR:      RCLRSC
 
             DLTOVR     FILE(*ALL)
 
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
