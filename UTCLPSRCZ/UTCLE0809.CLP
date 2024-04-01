/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT Patch for Facilities Interest Calc. Basis')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       UTCLE0809 - CL program to call datapatch ILE/UTLE0809       */

/*                                                                   */
/*       (c) Finastra International Limited 2018                     */
/*                                                                   */
/*       Last Amend No. MD042752  *CREATE  Date 15Jan18              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD042752 - Facility currency being picked up to calculate   */
/*             interest rather than loan currency                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2018')

/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))

/**Start of program */

             SNDPGMMSG  MSG('UTCLE0809 - Data Patch for Facilities Default Interest +
                        Calculation Basis') TOMSGQ(MRUNQ MOPERQ)

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO

/** Passed parameter is invalid */

             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
                          'a') *AND (&MODE *NE 'U')  +
                          *AND (&MODE *NE 'u')) THEN(DO)

             SNDPGMMSG  MSG('Invalid parameter passed to UTCLE0809') +
                          TOMSGQ(MOPERQ MRUNQ)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. Mode parameter should either be ''U'' +
                          or ''u'' for Update and ''A'' or ''a'' for +
                          Audit') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)

/** Get system prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')

             CHKOBJ     OBJ(&DPLIB/YYFCLTYFM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYFCLTYFM)

BACKUP:
             CPYF       FROMFILE(&DMLIB/FCLTYFM) +
                          TOFILE(&DPLIB/YYFCLTYFM) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(YYFCLTYFM)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/FCLTYFM to +
                          PF/YYFCLTYFM. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO

/* Call ILE/UTLE0809 */

             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTLE0809) PARM(&MODE)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                        CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCLE0809 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)

 ABNOR:
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&DPLIB/YYFCLTYFM) +
                        TOFILE(&DMLIB/FCLTYFM) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FCLTYFM +
                          from PF/YYFCLTYFM. Process terminated.  +
                          Please restore PF/FCLTYFM manually from +
                          PF/YYFCLTYFM.') +
                          MSGTYPE(*INFO)
             ENDDO
             ENDDO
             ENDDO

ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCLE0809 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018')
             SNDPGMMSG  MSG('End of UTCLE0809') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
