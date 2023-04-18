/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE SECTYDQD File Utility')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       UTCSE0859 - Security Details JMS Enabling Extn File Utility */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. MD058313  *CREATE  Date 17Apr23              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD058313 - Calls UTSE0859 utility program.                  */
/*                  Applied for MD-61078.                            */
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
             SNDPGMMSG  MSG('UTCSE0859 - Utility to update Security Details +
                          JMS Enabling Extn - SECTYDQD') TOMSGQ(MRUNQ MOPERQ)
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
             SNDPGMMSG  MSG('UTCSE0859 - Invalid parameter passed') +
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
/*  Check if BKSECTYDQD already exists */
/**/
             CHKOBJ     OBJ(&DPLIB/BKSECTYDQD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(BKSECTYDQD)
/**/
/* Create backup of PF/SECTYDQD */
/**/

BACKUP:      CPYF       FROMFILE(&DMLIB/SECTYDQD) +
                        TOFILE(&DPLIB/BKSECTYDQD) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(BKSECTYDQD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCSE0859 - Error occured in copying +
                          PF/SECTYDQD to PF/BKSECTYDQD. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

             CHGJOB     SWS(XXXXXX00)

/**/
/* Call program that will update records in SECTYDQD */
/**/
             CALL       PGM(UTSE0859) PARM(&MODE)
/**/
/* Error occurred in the program */
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             DLTF       FILE(&DPLIB/BKSECTYDQD)
             MONMSG     MSGID(CPF0000)
             ENDDO
             SNDPGMMSG  MSG('UTCSE0859 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/

ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)

             CPYF       FROMFILE(&DPLIB/BKSECTYDQD) +
                        TOFILE(&DMLIB/SECTYDQD) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/SECTYDQD +
                          from PF/BKSECTYDQD. Process terminated.  +
                          Please restore manually PF/SECTYDQD from +
                          PF/BKSECTYDQD.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO


 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCSE0859 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2021')
             SNDPGMMSG  MSG('End of UTCSE0859') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
