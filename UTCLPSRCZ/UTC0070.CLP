/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Update Data Area')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0070 - Update data area                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CREATE             Date 05MAR96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CREATE - Rewrite of AMDDTAARA                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DTAARALIB &ACTION)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DTAARALIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/* */
/* Set switches */
/* */
             CHGJOB     DATFMT(*YMD) SWS(XXXXX000)
/* */
/* Get DTAARA information */
/* */
             CHGVAR     VAR(&DTAARA) VALUE(%SST(&DTAARALIB 1 10))
             CHGVAR     VAR(&LIBRARY) VALUE(%SST(&DTAARALIB 11 10))
/* */
/* Check that data area exists */
/* */
             IF         COND(&DTAARA *EQ '*LDA') THEN(DO)
             CHGVAR     VAR(%SST(&DTAARALIB 11 10)) VALUE('          ')
             ENDDO
             ELSE       CMD(DO)
             IF         COND(&DTAARA *EQ '*GDA') THEN(DO)
             CHGVAR     VAR(%SST(&DTAARALIB 11 10)) VALUE('          ')
             ENDDO
             ELSE       CMD(DO)
             CHKOBJ     OBJ(&LIBRARY/&DTAARA) OBJTYPE(*DTAARA)
/* */
/* Check authorisation rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&DTAARA) OBJTYPE(*DTAARA) +
                          AUT(*USE)
/* */
/* Check Update rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&DTAARA) OBJTYPE(*DTAARA) +
                          AUT(*UPD)
             MONMSG     MSGID(CPF9802) EXEC(DO)
             CHGVAR     VAR(&ACTION) VALUE('*ENQUIRE')
             ENDDO
/* */
             ENDDO
             ENDDO
/* */
/* Call program */
/* */
             CALL       PGM(UT0072) PARM(&RETURNCODE &ACTION +
                          &DTAARALIB)
/* */
             GOTO       CMDLBL(END)
/* */
/* Abnormal processing */
/* */
 ABNORMAL:
 MSGREAD:    RCVMSG     MSGQ(*PGMQ) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
/* */
/* If message read send to use */
/* */
             IF         COND(&MSGID *NE '       ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(MSGREAD)
             ENDDO
/* */
/* Reclaim resources */
/* */
             RCLRSC
             MONMSG     MSGID(CPF0000)
/* */
/* Send escape message to terminate processing */
/* */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          in command UPDDTAARA') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
/* */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Reclaim resources */
/* */
             RCLRSC
             MONMSG     MSGID(CPF0000)
             ENDPGM
