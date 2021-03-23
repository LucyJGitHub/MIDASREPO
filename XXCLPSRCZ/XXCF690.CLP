/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX Average Balance Maintenance from SDACRCPD')  */
/*********************************************************************/
/*                                                                   */
/*       Midas     Management Accounts Module                        */
/*                                                                   */
/*       XXCF690 - Average Balance Maintenance from SDACRCPD         */
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
/*       231735 - Add/Delete records from MCAVBLX0 and MCWORKX0      */
/*                based on SDACRCPD.                                 */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&SECS) TYPE(*CHAR) LEN(8) /* Return code */
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Finastra Systems Technology, +
                          Inc. 2020')

             DCLF       FILE(GLHBCGL1)

/* Global Monitor Message                                            */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up copyright                                                  */
             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          Systems Technology, Inc. 2020')

             RMVM       FILE(XMCAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLV1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCWORKV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             CPYF       FROMFILE(MCAVBLX0) TOFILE(XMCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)
             CPYF       FROMFILE(MCWORKX0) TOFILE(XMCWORKX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)

 READNXT:    RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
             IF         COND(&HCTYLC *NE 'D' *AND &HCADCB *NE 'N') +
                          THEN(DO)
             ADDLFM     FILE(XMCAVBLV0) MBR(&HCCGCD) DTAMBRS((XMCAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XMCAVBLV1) MBR(&HCCGCD) DTAMBRS((XMCAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XMCWORKV0) MBR(&HCCGCD) DTAMBRS((XMCWORKX0 +
                          (&HCCGCD)))
             CHGVAR     VAR(&SECS) VALUE(&HCIAAC *CAT &HCILAC *CAT +
                          &HCIIAC *CAT &HCIEAC *CAT &HCICAC *CAT +
                          &HCIMAC *CAT &HCITAC *CAT &HCICTA)

             OVRDBF     FILE(MCAVBLV0) TOFILE(XMCAVBLV0) MBR(&HCCGCD)
             OVRDBF     FILE(MCAVBLV1) TOFILE(XMCAVBLV1) MBR(&HCCGCD)
             OVRDBF     FILE(MCWORKV0) TOFILE(XMCWORKV0) MBR(&HCCGCD)

             CALL       PGM(XXF690) PARM(&HCCGCD &HCPSTB &SECS &RTCD)
             DLTOVR     FILE(*ALL)
             IF         COND(&RTCD *EQ 'C' *OR &RTCD *EQ 'Y') +
                          THEN(GOTO CMDLBL(ABNOR))

             ENDDO
             GOTO       CMDLBL(READNXT)

/* If recreate took place and completed normally, update files       */

 FINISH:     DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF9841)

             CPYF       FROMFILE(XMCAVBLX0) TOFILE(MCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)
             CPYF       FROMFILE(XMCWORKX0) TOFILE(MCWORKX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)

             GOTO       CMDLBL(END)

 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL) LVL(*JOB)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDMSG     MSG('PROGRAM XXCF990 TERMINATED +
                          ABNORMALLY.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:
             ENDPGM
