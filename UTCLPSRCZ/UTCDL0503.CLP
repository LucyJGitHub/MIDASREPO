/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Interest History Purge Utility')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       UTCDL0503 - Interest History Purge Utility                  */
/*                                                                   */
/*       (c) Finastra International Limited 2018                     */
/*                                                                   */
/*       Last Amend No. MD051650  *CREATE  Date 12Sep18              */
/*       Prev Amend No. Xxxxxxxx           Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD051650 - Calls UTDL0503 utility program.                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018')
/**/
/* Global monitor message */
/**/

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCDL0503 - Utility to update Interest History File - +
                          HISTSAA') TOMSGQ(MRUNQ MOPERQ)
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
             SNDPGMMSG  MSG('UTCDL0503 - Invalid parameter passed') +
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
/*  Check if BKHISTSAA already exists */
/**/
             CHKOBJ     OBJ(&DPLIB/BKHISTSAA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(BKHISTSAA)
/**/
/* Create backup of PF/HISTSAA */
/**/

BACKUP:      CPYF       FROMFILE(&DMLIB/HISTSAA) +
                        TOFILE(&DPLIB/BKHISTSAA) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(BKHISTSAA)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCDL0503 - Error occured in copying +
                          PF/HISTSAA to PF/BKHISTSAA. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

             CHGJOB     SWS(XXXXXX00)

/**/
/* Call program that will delete records in HISTSAA */
/**/
             CALL       PGM(UTDL0503) PARM(&MODE)
/**/
/* Error occurred in the program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCDL0503 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             DLTF       FILE(&DPLIB/BKHISTSAA)
             MONMSG     MSGID(CPF0000)
             ENDDO

             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/

ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)

             CPYF       FROMFILE(&DPLIB/BKHISTSAA) +
                        TOFILE(&DMLIB/HISTSAA) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/HISTSAA +
                          from PF/BKHISTSAA. Process terminated.  +
                          Please restore manually PF/HISTSAA from +
                          PF/BKHISTSAA.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO

 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCDL0503 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2018')
             SNDPGMMSG  MSG('End of UTCDL0503') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
