/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL program for datapatch UT218328')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       UTC218328 - CL Program of Datapatch program UT218328        */
/*                                                                   */
/*       (C) Copyright Misys Banking Systems, Ltd. 2010              */
/*                                                                   */
/*       Last Amend No. AR218328 *CREATE   Date 24Mar10              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR218328 - Populate DLDTSCPD COHO if date is a holiday.     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Misys Banking Systems, Ltd. +
                          2010')
/**/
/** Global monitor message **/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UT218328 - Utility to populate confirmed +
                        holiday of DLDTSCPD') TOMSGQ(MRUNQ MOPERQ)
/**/
/* Create LDA if it doesn't exist */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/**/
/* Passed parameter is invalid */
/**/
             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
                          'a') *AND (&MODE *NE 'U')  +
                          *AND (&MODE *NE 'u')) THEN(DO)
 
             SNDPGMMSG  MSG('Parameter specified is not A or +
                          U. Specify correct mode then run the +
                          program again.') TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('UT218328 Invalid parameter +
                          passed. Should be ''U'' or ''A''') +
                          MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/** Get system prefix **/
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/* Create a backup of DLDTSCPD for update mode */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
             CPYF       FROMFILE(&DMLIB/DLDTSCPD) +
                          TOFILE(&DPLIB/DLDTSCPDXX) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(DLDTSCPDXX)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
/**/
/* Call PGM/UT218328 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
 
             CALL       PGM(UT218328) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('UT218328 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(FIN)
 
/**/
/* Abnormal Termination of the program or            */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
 
             IF         COND(&RUNP *EQ 'YES') THEN(DO)
             CPYF       FROMFILE(&DPLIB/DLDTSCPDXX) +
                        TOFILE(&DMLIB/DLDTSCPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
             SNDUSRMSG  MSG('UT218328 - Error occurred in copying +
                            the file.  Please restore DLDTSCPD +
                            manually') MSGTYPE(*INFO)
             ENDDO
             ENDDO
 
             SNDPGMMSG  MSG('Error occurred in UT218328 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(END)
 
 FIN:        IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
             DLTF       FILE(&DPLIB/DLDTSCPDXX)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(C) Copyright +
                          Misys Banking Systems, Ltd. 2010')
             SNDPGMMSG  MSG('End of UT218328') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
