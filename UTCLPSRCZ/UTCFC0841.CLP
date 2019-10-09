/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to call UTFC0841')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       UTCFC0841 - CL program to call datapatch PGM/UTFC0841       */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD054408  *CREATE  Date 05Oct19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054408 - TAIC013 - Periodic Report starts generating Daily*/
/*                  if previous month does not have 31 days          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LSTD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2019')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCFC0841 - MD-54408 Data Patch Program') +
                          TOMSGQ(MRUNQ MOPERQ)
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
                SNDPGMMSG  MSG('Invalid parameter passed to UTCFC0841') +
                             TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. Mode parameter should either be ''U'' +
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
                        CHGVAR     VAR(&DTALIB) VALUE(&PREF *TCAT 'DTALIB')
/**/

FLECHK:
/* Check if YYXXXXXXXX exists */
/**/
                        CHKOBJ     OBJ(&DMLIB/YYFCPREQPD) OBJTYPE(*FILE)
                        MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
                        DLTF       FILE(YYFCPREQPD)

/**/
/* Create backup */
/**/
BACKUP:
                        CPYF       FROMFILE(&DMLIB/FCPREQPD) TOFILE(&DPLIB/YYFCPREQPD) +
                                   MBROPT(*REPLACE) CRTFILE(*YES)
                        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                        CLRPFM     FILE(YYFCPREQPD)
                        ENDDO
                        MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                        SNDUSRMSG  MSG('Error occurred in copying PF/FCPREQPD to +
                             PF/YYFCPREQPD. Process terminated.') MSGTYPE(*INFO)
                        GOTO       CMDLBL(END)
                        ENDDO

             ENDDO
/**/
/* Call ILE/UTFC0841 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTFC0841) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCFC0841 completed normally.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)

/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
                        IF         COND(&RUNP *EQ 'YES') THEN(DO)

                                   CPYF       FROMFILE(&DPLIB/YYFCPREQPD) TOFILE(&DMLIB/FCPREQPD) +
                                              MBROPT(*REPLACE) FMTOPT(*NONE)
                                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                                   SNDUSRMSG  MSG('Error occurred in restoring PF/FCPREQPD from +
                                              PF/FCPREQPD. Process terminated.  Please restore +
                                              PF/FCPREQPD manually from PF/YYFCPREQPD.') +
                                              MSGTYPE(*INFO)
                                   ENDDO
                        ENDDO
             ENDDO

 ABNOR1:     SNDPGMMSG  MSG('Error occurred in UTCFC0841 program') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2019')
             SNDPGMMSG  MSG('End of UTCFC0841') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
