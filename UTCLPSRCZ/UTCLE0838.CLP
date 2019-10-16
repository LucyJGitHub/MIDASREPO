/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Trigger Repair of Basel II Fields')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0838 - Trigger Repair of Basel II Fields               */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD053837 *CREATE   Date 30Aug19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD053837 - Inconsistency in Basel II initial date and       */
/*                  classification for fees. Zeroise Basel II fields */
/*                  in LEFEED to trigger repair of incorrect values  */
/*                  in COB.                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2019')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))

/* Start of program */

             SNDPGMMSG  MSG('UTCLE0838 program - Trigger Repair +
                          of Basel II Fields') TOMSGQ(MRUNQ MOPERQ)

/* Create LDA if it does not exist */

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO

/* Check if parameter passed is 'U', 'u', 'A' or 'a' or if invalid */

             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
                          'a') *AND (&MODE *NE 'U')  +
                          *AND (&MODE *NE 'u')) THEN(DO)

             SNDPGMMSG  MSG('Invalid parameter passed to UTCLE0838 +
                          program') TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. It should either be ''U'' +
                          or ''u'' for Update and ''A'' or ''a'' for +
                          Audit') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO

/* Get system prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)

             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)

/* Check if YYLEFEED already exists */

             CHKOBJ     OBJ(&DPLIB/YYLEFEED) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYLEFEED)

/* Create backup of PF/LEFEED */

BACKUP:      CPYF       FROMFILE(&DMLIB/LEFEED) +
                          TOFILE(&DPLIB/YYLEFEED) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYLEFEED)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/LEFEED to +
                          PF/YYLEFEED. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

/* Call PGM/UTLE0838 */

             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTLE0838) PARM(&MODE)

/* Error occurred in program */

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCLE0838 program completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)


/* Abnormal termination of the program or */
/* restore backup if an error occurred in update mode */

ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&DPLIB/YYLEFEED) +
                        TOFILE(&DMLIB/LEFEED) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/LEFEED +
                          from PF/YYLEFEED. Process terminated.  +
                          Please restore manually PF/LEFEED from +
                          PF/YYLEFEED.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO
             ENDDO

ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCLE0838 program.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2019')

             SNDPGMMSG  MSG('End of UTCLE0838 program') TOMSGQ(MRUNQ MOPERQ)

             ENDPGM 