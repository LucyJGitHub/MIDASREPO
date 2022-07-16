/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT Datapatch Utility Calling UTLE0662')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0662 - Datapatch Utility Calling UTLE0662              */
/*                                                                   */
/*       (c) Copyright Finastra International Limited 2022           */
/*                                                                   */
/*       Last Amend No. AR1019909 *CREATE  Date 15Jul22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1019909 - CL program that calls UTLE0662 to records in    */
/*                   PF/CLOANCK or PF/MCLONCK with incorrect YILN,   */
/*                   YPLN and YPLC. (Child: AR1019910)               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2022')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(DSPERR))

/* Start of program */

             SNDPGMMSG  MSG('UTCLE0662 - To call UTLE0662') +
                          TOMSGQ(MOPERQ MRUNQ)

/* Create LDA if it doesn't exist */

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO

/* Get system prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')

/* Invalid parameter */

             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
             SNDPGMMSG  MSG('Invalid parameter passed to UTCLE0662') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. It should either be ''U'' +
                          or ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(DSPERR)
             ENDDO
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)

/* Check if YYCLOANCK and YYMCLONCK already exist */

             CHKOBJ     OBJ(&DPLIB/YYCLOANCK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK1))
             DLTF       FILE(YYCLOANCK)

CHECK1:      CHKOBJ     OBJ(&DPLIB/YYMCLONCK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYMCLONCK)

/* Create backup of PF/CLOANCK and PF/MCLONCK */

BACKUP:      CPYF       FROMFILE(&DMLIB/CLOANCK) +
                          TOFILE(&DPLIB/YYCLOANCK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYCLOANCK)
             GOTO       CMDLBL(BACKUP2)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/CLOANCK to +
                          PF/YYCLOANCK. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

BACKUP2:     CPYF       FROMFILE(&DMLIB/MCLONCK) +
                          TOFILE(&DPLIB/YYMCLONCK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYMCLONCK)
             GOTO       CMDLBL(CONTIN)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/MCLONCK to +
                          PF/YYMCLONCK. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO

/* Call UTLE0662 */

CONTIN:      CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CHGLF      FILE(UTL662L1) MAXMBRS(*NOMAX)
             CHGLF      FILE(UTL662L2) MAXMBRS(*NOMAX)

             CHKOBJ     OBJ(UTL662L1) OBJTYPE(*FILE) MBR(UTL662L1)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(UTL662L1) +
                          MBR(UTL662L1))
             CHKOBJ     OBJ(UTL662L2) OBJTYPE(*FILE) MBR(UTL662L2)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(UTL662L2) +
                          MBR(UTL662L2))

             CALL       PGM(UTLE0662) PARM(&MODE)

/* Error occurred in audit program */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO CMDLBL(ABNOR)
             ENDDO

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             DLTF       FILE(YYCLOANCK)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(YYMCLONCK)
             MONMSG     MSGID(CPF2105)
             GOTO       CMDLBL(NORMAL)
             ENDDO

/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */

ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)

             CPYF       FROMFILE(&DPLIB/YYCLOANCK) +
                        TOFILE(&DMLIB/CLOANCK) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(CLOANCK)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/CLOANCK +
                          from PF/YYCLOANCK. Process terminated.  +
                          Please restore manually PF/CLOANCK from +
                          PF/YYCLOANCK.') +
                          MSGTYPE(*INFO)
             ENDDO

             CPYF       FROMFILE(&DPLIB/YYMCLONCK) +
                        TOFILE(&DMLIB/MCLONCK) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(CLOANCK)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/MCLONCK +
                          from PF/YYMCLONCK. Process terminated.  +
                          Please restore manually PF/MCLONCK from +
                          PF/YYMCLONCK.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO

 DSPERR:     SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCLE0622 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)

 NORMAL:
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             SNDUSRMSG  MSG('UTCLE0662 completed normally') +
                        MSGTYPE(*INFO)
             ENDDO

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Systems 2022')
             SNDPGMMSG  MSG('End of UTCLE0662') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
