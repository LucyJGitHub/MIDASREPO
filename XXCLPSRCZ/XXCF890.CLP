/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX Management Accounts Average Balance Upd')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     Management Accounts Module                        */
/*                                                                   */
/*       XXCF890 - Management Accounts Average Balance Update        */
/*                                                                   */
/*       (C) Copyright Finastra Systems Technology, Inc. 2020        */
/*                                                                   */
/*       Last Amend No. EML108             Date 14Jan20              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       EML108 - Upgrade FMD003 and fixes to FBM2.1SP21             */
/*       JGFIX1 - Add Monitor messages to prevent crashing           */
/*                if copying empty files.                            */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19            */
/*       231735 - Separate Average Balance calculation from          */
/*                XXCF990.                                           */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra Systems Technology, +
                          Inc, 2020')

             DCLF       FILE(GLHBCGL1)

/* Global Monitor Message                                            */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up copyright                                                  */
             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          Systems Technology, Inc. 2020')

             RMVM       FILE(XMCAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCWORKX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(UPWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

/* Copy files to security copy files                                 */

             CPYF       FROMFILE(MCAVBLX0) TOFILE(XMCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)
             CPYF       FROMFILE(MCWORKX0) TOFILE(XMCWORKX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)

 READNXT:    RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))

             IF         COND((&HCTYLC *NE 'D') *AND (&HCADCB *NE +
                          'N')) THEN(DO)
             ADDLFM     FILE(XMCAVBLV0) MBR(&HCCGCD) DTAMBRS((XMCAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XMCWORKV0) MBR(&HCCGCD) DTAMBRS((XMCWORKX0 +
                          (&HCCGCD)))
             RMVM       FILE(UPWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             ADDLFM     FILE(UPWORKV0) MBR(&HCCGCD) +
                          DTAMBRS((UPWORKX0 (&HCCGCD)))
             CHKOBJ     OBJ(MCWORKX0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(MCWORKX0) +
                          MBR(&HCCGCD))
             CHKOBJ     OBJ(MCWORKV0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCWORKV0) +
                          MBR(&HCCGCD) DTAMBRS((MCWORKX0 (&HCCGCD))))
             CHKOBJ     OBJ(MCWORKV2) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCWORKV2) +
                          MBR(&HCCGCD) DTAMBRS((MCWORKX2 (&HCCGCD))))
             CHKOBJ     OBJ(MCAVBLX0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(MCAVBLX0) +
                          MBR(&HCCGCD))
             CHKOBJ     OBJ(MCAVBLV0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(MCAVBLV0) +
                          MBR(&HCCGCD) DTAMBRS((MCAVBLX0 (&HCCGCD))))

/* Override to security copies                                       */

             OVRDBF     FILE(MCAVBLV0) TOFILE(XMCAVBLV0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MCWORKV0) TOFILE(XMCWORKV0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MCWORKX0) TOFILE(XMCWORKX0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MCWORKV2) MBR(&HCCGCD)
             OVRDBF     FILE(UPWORKX0) MBR(&HCCGCD)
             OVRDBF     FILE(UPWORKV0) MBR(&HCCGCD)
             CALL       PGM(XXF991) PARM(&HCCGCD &RTCD)
             DLTOVR     FILE(*ALL) LVL(*JOB)
             IF         COND(&RTCD *EQ 'C' *OR &RTCD *EQ 'Y') +
                          THEN(GOTO CMDLBL(ABNOR))
             ENDDO

             GOTO       CMDLBL(READNXT)

/* If recreate took place and completed normally, update files       */

 FINISH:     DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(XMCAVBLX0) TOFILE(MCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)
             RMVM       FILE(XMCAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             CPYF       FROMFILE(XMCWORKX0) TOFILE(MCWORKX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             RMVM       FILE(XMCWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCWORKX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             RMVM       FILE(UPWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             GOTO       CMDLBL(END)

 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL) LVL(*JOB)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDMSG     MSG('PROGRAM XXCF890 TERMINATED +
                          ABNORMALLY.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM
