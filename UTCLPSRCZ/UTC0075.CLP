/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT View Physical File Records')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0075 - Update physical file member                       */
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
/*       CREATE - Rewrite of UPDPF                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILELIB &MEMBER)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&FILELIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTIONS) TYPE(*CHAR) LEN(10) VALUE(A23456)
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
/* Get file information */
/* */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIBRARY) VALUE(%SST(&FILELIB 11 10))
/* */
/* Check that file exists */
/* */
             CHKOBJ     OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) MBR(&MEMBER)
/* */
/* Check authorisation rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) +
                          MBR(&MEMBER) AUT(*USE)
/* */
/* Check that file is a physical */
/* */
             RTVOBJD    OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) +
                          OBJATR(&OBJATR)
             IF         COND((&OBJATR *EQ 'PF') *OR +
                             (&OBJATR *EQ 'PF-SRC')) THEN(DO)
             ENDDO
             ELSE       CMD(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('File ' +
                          *CAT &LIBRARY *TCAT '/' *CAT &FILE *BCAT +
                          'not a physical file') MSGTYPE(*ESCAPE)
             ENDDO
/* */
/* Check Update rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) +
                          MBR(&MEMBER) AUT(*UPD)
             MONMSG     MSGID(CPF9802) EXEC(DO)
             CHGVAR     VAR(%SST(&ACTIONS 2 1)) VALUE(' ')
             ENDDO
/* */
/* Check Add rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) +
                          MBR(&MEMBER) AUT(*ADD)
             MONMSG     MSGID(CPF9802) EXEC(DO)
             CHGVAR     VAR(%SST(&ACTIONS 1 1)) VALUE(' ')
             CHGVAR     VAR(%SST(&ACTIONS 3 1)) VALUE(' ')
             ENDDO
/* */
/* Check Delete rights */
/* */
             CHKOBJ     OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE) +
                          MBR(&MEMBER) AUT(*DLT)
             MONMSG     MSGID(CPF9802) EXEC(DO)
             CHGVAR     VAR(%SST(&ACTIONS 4 1)) VALUE(' ')
             ENDDO
/* */
/* Override database files */
/* */
             OVRDBF     FILE(CSCFILE) TOFILE(&LIBRARY/&FILE) +
                          MBR(&MEMBER) SECURE(*YES) SHARE(*NO)
             OVRDBF     FILE(CSCFILU) TOFILE(&LIBRARY/&FILE) +
                          MBR(&MEMBER) SECURE(*YES) SHARE(*NO)
/* */
/* Call program */
/* */
             CALL       PGM(UT0076) PARM(&RETURNCODE &ACTIONS)
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
                          in command UPDPFM') MSGTYPE(*ESCAPE)
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
