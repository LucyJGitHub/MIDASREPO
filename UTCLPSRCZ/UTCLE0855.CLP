/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('SD MD-57165 Utility program')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - SCustomer Lending Module                            */
/*                                                                   */
/*       UTCLE0855 - CL program to call datapatch PGM/UTLE0855       */
/*                                                                   */
/*       (c) Finastra International Limited 2020                     */
/*                                                                   */
/*       Last Amend No. MD057165  *CREATE  Date 18Feb20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057165 - SP23 Correspondence manager cob failure after    */
/*                  input of new fee                                 */
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
                          International Limited 2020')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCLE0855 - MD-57165 Data Patch Program') +
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
             SNDPGMMSG  MSG('Invalid parameter passed to UTCLE0855') +
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
             CHKOBJ     OBJ(&DPLIB/YYLEFEEDQD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYLEFEEDQD)

/**/
/* Create backup */
/**/
BACKUP:
             CPYF       FROMFILE(&DMLIB/LEFEEDQD) TOFILE(&DPLIB/YYLEFEEDQD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(YYLEFEEDQD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in copying PF/LEFEEDQD to +
                             PF/YYLEFEEDQD. Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO
/**/
/* Call ILE/UTLE0855 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTLE0855) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCLE0855 completed normally.') TOPGMQ(*EXT) +
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

                CPYF       FROMFILE(&DPLIB/YYLEFEEDQD) TOFILE(&DMLIB/LEFEEDQD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in restoring PF/LEFEEDQD from +
                             PF/LEFEEDQD. Process terminated.  Please restore +
                             PF/LEFEEDQD manually from PF/YYLEFEEDQD.') +
                             MSGTYPE(*INFO)
             ENDDO

             ENDDO

             ENDDO

 ABNOR1:     SNDPGMMSG  MSG('Error occurred in UTCLE0855 program') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2020')
             SNDPGMMSG  MSG('End of UTCLE0855') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
