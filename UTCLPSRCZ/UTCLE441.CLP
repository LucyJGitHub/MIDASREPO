/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Update %indicator field on LEFEED & LEFHST')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE441  - CL program to call utility UTLE0441             */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. 263582 *CREATE     Date 29Jul22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       263582 - Wrong 'Total Accrued to Date' in Fee Detail Enq.   */
/*                Correct the NoOfDays in computations and update    */
/*                value of %indicator field in LEFEED and LEFHST.    */
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
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('UTCLE441 - Update blank %indicator +
                          field on LEFEED and LEFHST') TOMSGQ(MRUNQ +
                          MOPERQ)
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

             SNDPGMMSG  MSG('UTCLE441 - Invalid parameter passed') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('UTCLE441 Invalid parameter +
                          passed. Should be ''A'' or ''U''') +
                          MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* Get system prefix                                                 */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/* Copy LEFEED to temporary input file */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
             DLTF       FILE(&DPLIB/XXLEFEED)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

             CPYF       FROMFILE(&DMLIB/LEFEED) +
                        TOFILE(&DPLIB/XXLEFEED) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(&DPLIB/XXLEFEED)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* Copy LEFHST to temporary input file */
/**/

             DLTF       FILE(&DPLIB/XXLEFHST)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CPYF       FROMFILE(&DMLIB/LEFHST) +
                        TOFILE(&DPLIB/XXLEFHST) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(&DPLIB/XXLEFHST)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
/** Call PGM/UTLE0441 **/
/**/
             CHGJOB     SWS(XXXXXX00)
             CLRPFM     UTEXTFEE
             CHGVAR     VAR(&RUNP) VALUE('YES')
             CALL       PGM(UTLE0441) PARM(&MODE)
/**/
/* Error occurred in program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

 NORMAL:     SNDPGMMSG  MSG('UTCLE441 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)

/**/
/* Abnormal Termination of the program */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)

             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&DPLIB/XXLEFEED) +
                        TOFILE(&DMLIB/LEFEED) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(LEFEED)
             GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             ENDDO
             SNDUSRMSG  MSG('UTCLE441 - Error occurred in copying +
                            the file.  Please restore LEFEED +
                            manually') MSGTYPE(*INFO)

             CPYF       FROMFILE(&DPLIB/XXLEFHST) +
                        TOFILE(&DMLIB/LEFHST) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(LEFHST)
             GOTO       CMDLBL(END)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             ENDDO

             SNDUSRMSG  MSG('UTCLE441 - Error occurred in copying +
                            the file.  Please restore LEFSHT +
                            manually') MSGTYPE(*INFO)
             ENDDO
             ENDDO

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCLE441 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)

 FIN:        DLTF       FILE(&DPLIB/XXLEFEED)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             DLTF       FILE(&DPLIB/XXLEFHST)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 /**/
 /** End program **/
 /**/
 END:        WRKSPLF
             CHGVAR     VAR(&CPYFLD) VALUE('(C) Finastra International +
                          Limited 2022')
             SNDPGMMSG  MSG('End of UTCLE441') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
