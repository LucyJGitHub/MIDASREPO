/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL program for datapatch UTLE0633')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0633 - CL program to call datapatch ILE/UTLE0633       */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR806351 *CREATE   Date 05Mar12              */
/*                      XXXXXXXX           Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR806351 - PDCLs with type Y/Z and FAMU = N have records in */
/*                  FACHISA. Delete invalid records in file and tag  */
/*                  facility for recalculation. (Child: AR806352)    */
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
                          Finastra International Limited 2012')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCLE0633 - Trigger Facility History +
                        Recalculation') TOMSGQ(MRUNQ MOPERQ)
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
             SNDPGMMSG  MSG('Invalid parameter passed to UTCLE0633') +
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
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/* Check if YYFACHISA, YYFACHISH and YYFACACT already exist */
/**/
             CHKOBJ     OBJ(&DPLIB/YYFACHISA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK1))
             DLTF       FILE(YYFACHISA)
/**/
CHECK1:      CHKOBJ     OBJ(&DPLIB/YYFACHISH) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK2))
             DLTF       FILE(YYFACHISH)
/**/
CHECK2:      CHKOBJ     OBJ(&DPLIB/YYFACACT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYFACACT)
/**/
/* Create backup of PF/FACHISA, PF/FACHISH and PF/FACACT */
/**/
BACKUP:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
             CPYF       FROMFILE(&DMLIB/FACHISA) +
                          TOFILE(&DPLIB/YYFACHISA) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYFACHISA)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/FACHISA to +
                          PF/YYFACHISA. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/FACHISH) +
                          TOFILE(&DPLIB/YYFACHISH) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYFACHISH)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/FACHISH to +
                          PF/YYFACHISH. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/FACACT) +
                          TOFILE(&DPLIB/YYFACACT) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYFACACT)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/FACACT to +
                          PF/YYFACACT. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO
/**/
/* Copy all LOAN records from FACHISA to a temporary file */
/**/
             CPYF       FROMFILE(&DMLIB/FACHISA) +
                          TOFILE(*LIBL/UTLE0633PD) MBROPT(*REPLACE) +
                          CRTFILE(*NO) INCREL((*IF FALOAN *NE ' ') +
                          (*AND FAREVI *EQ ' ')) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
/**/
/* Call ILE/UTLE0633 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
 
             CALL       PGM(UTLE0633) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('UTCLE0633 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(END)
 
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/YYFACHISA) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISA +
                          from PF/YYFACHISA. Process terminated.  +
                          Please restore manually PF/FACHISA from +
                          PF/YYFACHISA.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/YYFACHISH) +
                        TOFILE(&DMLIB/FACHISH) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISH +
                          from PF/YYFACHISH. Process terminated.  +
                          Please restore manually PF/FACHISH from +
                          PF/YYFACHISH.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/YYFACACT) +
                        TOFILE(&DMLIB/FACACT) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACACT +
                          from PF/YYFACACT. Process terminated.  +
                          Please restore manually PF/FACACT from +
                          PF/YYFACACT.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             ENDDO
             ENDDO
 
ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCLE0633 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Systems 2012')
             SNDPGMMSG  MSG('End of UTCLE0633') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
