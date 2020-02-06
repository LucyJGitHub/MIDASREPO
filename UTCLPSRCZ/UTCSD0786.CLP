/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas  SD MD-39670 Utility program for SDFTCSPD')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       UTCSD0784 - Midas  SD MD-36288 Initialization pgm           */
/*                   (CL program to call ILE/UTSD0786)               */
/*                                                                   */
/*       (c) Finastra International Limited 2016                     */
/*                                                                   */
/*       Last Amend No. MD039670  *CREATE  Date 26Jul16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD039670 - FATCA Housekeeping program                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2016')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCSD0786 - MD-39670 Utility Progra +
                         m for SDFTCSPD') TOMSGQ(MRUNQ MOPERQ)
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
             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
                          'a') *AND (&MODE *NE 'U')  +
                          *AND (&MODE *NE 'u')) THEN(DO)
/**/
             SNDPGMMSG  MSG('Invalid parameter passed to UTCSD0786') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. It should either be ''U'' +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* Get system prefix */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/* Check if YYSDFTCSPD exists */
/**/
             CHKOBJ     OBJ(&DPLIB/YYSDFTCSPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FLECHK))
             DLTF       FILE(YYSDFTCSPD)
/**/
FLECHK:      CHKOBJ     OBJ(&DPLIB/YYSDFTCSPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYSDFTCSPD)
/**/
/* Create backup of PF/SDFTCSPD  */
/**/
BACKUP:      CPYF       FROMFILE(&DMLIB/SDFTCSPD) +
                          TOFILE(&DPLIB/YYSDFTCSPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYSDFTCSPD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/SDFTCSPD to +
                          PF/YYSDFTCSPD. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO
/**/
/* Call ILE/UTSD0786 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTSD0786) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCSD0786 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)

/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&DPLIB/YYSDFTCSPD) +
                        TOFILE(&DMLIB/SDFTCSPD) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/SDFTCSPD +
                          from PF/SDFTCSPD. Process terminated.  +
                          Please restore PF/SDFTCSPD manually from +
                          PF/YYSDFTCSPD.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO
             ENDDO

ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCSD0786 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2016')
             SNDPGMMSG  MSG('End of UTCSD0786') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
