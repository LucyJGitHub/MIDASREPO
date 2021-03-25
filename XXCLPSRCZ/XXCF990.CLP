/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX Management Accounts Automatic Balance Upd')  */
/*********************************************************************/
/*                                                                   */
/*       Midas     Management Accounts Module                        */
/*                                                                   */
/*       XXCF990 - Management Accounts Automatic Balance Update      */
/*                                                                   */
/*       (C) Copyright Finastra Systems Technology Inc, 2020         */
/*                                                                   */
/*       Last Amend No. EML108             Date 14Jan20              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       EML108 - Upgrade FMD003 and fixes to FBM2.1SP21             */
/*       JGFIX1 - Add Monitor messages to prevent crashing           */
/*                if copying empty files.                            */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19            */
/*       231735 - Separate GE-XB postings update to Opening and      */
/*                Closing Balances and Average Balance Calculation.  */
/*       FMD003 - Automatic Management Accounts Balance Update       */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) /* Return code */
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

             DLTOVR     FILE(*ALL) LVL(*JOB)
             RMVM       FILE(XGLHIBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV4) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

/* Copy files to security copy files                                 */

             CPYF       FROMFILE(GLHIBLPD) TOFILE(XGLHIBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE)
             CPYF       FROMFILE(GLAVBLPD) TOFILE(XGLAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE)
             CPYF       FROMFILE(GLHBCGPD) TOFILE(XGLHBCGX0) +
                          FROMMBR(*ALL) MBROPT(*REPLACE)
             CPYF       FROMFILE(MCAVBLX0) TOFILE(XMCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)

             OVRDBF     FILE(GLHBCGPD) TOFILE(XGLHBCGX0)
             OVRDBF     FILE(GLHBCGL1) TOFILE(XGLHBCGV1)
             OVRDBF     FILE(GLHBCGL0) TOFILE(XGLHBCGV0) SHARE(*NO)

 READNXT:    RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
             IF         COND(&HCTYLC *NE 'D') THEN(DO)
             ADDLFM     FILE(XGLHIBLV0) MBR(&HCCGCD) DTAMBRS((XGLHIBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLHIBLV1) MBR(&HCCGCD) DTAMBRS((XGLHIBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLHIBLV2) MBR(&HCCGCD) DTAMBRS((XGLHIBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLHIBLV3) MBR(&HCCGCD) DTAMBRS((XGLHIBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLHIBLV4) MBR(&HCCGCD) DTAMBRS((XGLHIBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLAVBLV0) MBR(&HCCGCD) DTAMBRS((XGLAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLAVBLV1) MBR(&HCCGCD) DTAMBRS((XGLAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLAVBLV2) MBR(&HCCGCD) DTAMBRS((XGLAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XGLAVBLV3) MBR(&HCCGCD) DTAMBRS((XGLAVBLX0 +
                          (&HCCGCD)))
             ADDLFM     FILE(XMCAVBLV0) MBR(&HCCGCD) DTAMBRS((XMCAVBLX0 +
                          (&HCCGCD)))

/* Override to security copies                                       */

             OVRDBF     FILE(GLHIBLPD) TOFILE(XGLHIBLX0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL0) TOFILE(XGLHIBLV0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL1) TOFILE(XGLHIBLV1) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL2) TOFILE(XGLHIBLV2) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL3) TOFILE(XGLHIBLV3) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL4) TOFILE(XGLHIBLV4) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLPD) TOFILE(XGLAVBLX0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL0) TOFILE(XGLAVBLV0) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL1) TOFILE(XGLAVBLV1) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL2) TOFILE(XGLAVBLV2) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL3) TOFILE(XGLAVBLV3) MBR(&HCCGCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MCAVBLV0) TOFILE(XMCAVBLV0) MBR(&HCCGCD) +
                          LVLCHK(*NO)

             CALL       PGM(XXF993) PARM(&HCPSTC &HCCPNB &RTCD)
             IF         COND(&RTCD *EQ 'C' *OR &RTCD *EQ 'Y') +
                          THEN(GOTO CMDLBL(ABNOR))

             CALL       PGM(XXF990) PARM(&HCCGCD &RTCD)
             DLTOVR     FILE(*ALL) LVL(*JOB)
             IF         COND(&RTCD *EQ 'C' *OR &RTCD *EQ 'Y') +
                          THEN(GOTO CMDLBL(ABNOR))
             ENDDO
             GOTO       CMDLBL(READNXT)

/* If recreate took place and completed normally, update files       */

 FINISH:     DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(XGLHIBLX0) TOFILE(GLHIBLPD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             RMVM       FILE(XGLHIBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLV4) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             CPYF       FROMFILE(XGLAVBLX0) TOFILE(GLAVBLPD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             RMVM       FILE(XGLAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLV3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             CPYF       FROMFILE(XGLHBCGX0) TOFILE(GLHBCGPD) +
                          MBROPT(*REPLACE)

             CPYF       FROMFILE(XMCAVBLX0) TOFILE(MCAVBLX0) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2870 CPF2817)
             RMVM       FILE(XMCAVBLV0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XMCAVBLX0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)

             GOTO       CMDLBL(END)

 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(*ALL) LVL(*JOB)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDMSG     MSG('PROGRAM XXCF990 TERMINATED +
                          ABNORMALLY.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        ENDPGM
