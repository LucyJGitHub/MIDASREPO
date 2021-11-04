/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME MT101 & MT102 Totals Utility')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       UTCME0504 - FT Message Management 101 & 102 Totals Utility  */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. MD057504  *CREATE  Date 22Jan21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057504 - Calls UTME0504 utility program.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2021')
/**/
/* Global monitor message */
/**/

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCME0504 - Utility to update MT101 & MT102 +
                          Totals File - MEIRFTPD') TOMSGQ(MRUNQ MOPERQ)
/**/
/* Create LDA if it doesn't exist */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/**/
/* Passed parameter is invalid */
/**/
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
             SNDPGMMSG  MSG('UTCME0504 - Invalid parameter passed') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter. It should either be ''U'' or +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* Get system prefix */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
/**/
/*  Check if BKMEIRFTPD already exists */
/**/
             CHKOBJ     OBJ(&DPLIB/BKMEIRFTPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(BKMEIRFTPD)
/**/
/* Create backup of PF/MEIRFTPD */
/**/

BACKUP:      CPYF       FROMFILE(&DMLIB/MEIRFTPD) +
                        TOFILE(&DPLIB/BKMEIRFTPD) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(BKMEIRFTPD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCME0504 - Error occured in copying +
                          PF/MEIRFTPD to PF/BKMEIRFTPD. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

             CHGJOB     SWS(XXXXXX00)

/**/
/* Call program that will update records in MEIRFTPD */
/**/
             CALL       PGM(UTME0504) PARM(&MODE)
/**/
/* Error occurred in the program */
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             DLTF       FILE(&DPLIB/BKMEIRFTPD)
             MONMSG     MSGID(CPF0000)
             ENDDO
             SNDPGMMSG  MSG('UTCME0504 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/

ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)

             CPYF       FROMFILE(&DPLIB/BKMEIRFTPD) +
                        TOFILE(&DMLIB/MEIRFTPD) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/MEIRFTPD +
                          from PF/BKMEIRFTPD. Process terminated.  +
                          Please restore manually PF/MEIRFTPD from +
                          PF/BKMEIRFTPD.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO


 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCME0504 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2021')
             SNDPGMMSG  MSG('End of UTCME0504') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
