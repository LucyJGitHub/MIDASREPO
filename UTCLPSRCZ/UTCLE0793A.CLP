/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to Update PF/FACHISA sequence')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0793A - To correct sequence of records in PF/FACHISA   */
/*                                                                   */
/*       (c) Finastra International Limited 2016                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD022057 *CREATE   Date 08Nov16              */
/*                      Xxxxxxxx           Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD022057- To resequence the records in FACHISA.             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2016')
/**/
/* Global monitor message                                            */
/**/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Get system prefix                                                 */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/* Start of program                                                  */
/**/
             SNDPGMMSG  MSG('UTCLE0793A - (Start) To update +
                          PF/FACHISA') TOMSGQ(MRUNQ MOPERQ)
/**/
/* Passed parameter is invalid                                       */
/**/
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
 
             SNDPGMMSG  MSG('UTCLE0793A - Invalid parameter passed') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('UTCLE0793A Invalid parameter +
                          passed. Should be ''U'' or ''A''') +
                          MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
             CLRPFM     FILE(&DPLIB/UTLE793APA)
             CLRPFM     FILE(&DPLIB/UTLE793APB)
/**/
/* Create backup in xxDPLIB if in update mode                        */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
             DLTF       FILE(&DPLIB/PPFACHISA)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/FACHISA) +
                        TOFILE(&DPLIB/PPFACHISA) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(CONTIN1)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/FACHISA to PF/PPFACHISA. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACHISA +
                          created') TOMSGQ(MOPERQ MRUNQ)
 
CONTIN1:
             DLTF       FILE(&DPLIB/PPFACHISH)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/FACHISH) +
                        TOFILE(&DPLIB/PPFACHISH) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(CONTIN2)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/FACHISH to PF/PPFACHISH. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACHISH +
                          created') TOMSGQ(MOPERQ MRUNQ)
 
CONTIN2:
             DLTF       FILE(&DPLIB/PPFACACT)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/FACACT) +
                        TOFILE(&DPLIB/PPFACACT) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(CONT1)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/FACACT to PF/PPFACACT. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACACT +
                          created') TOMSGQ(MOPERQ MRUNQ)
 
             ENDDO
 CONT1:
/**/
/* Create LDA if it doesn't exist                                    */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/**/
/* Call the main program                                             */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
/**/
/**/
             CPYF       FROMFILE(&DMLIB/FACHISA) +
                        TOFILE(&DPLIB/UTLE793APB) MBROPT(*REPLACE) +
                        CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(CONT6)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/FACHISA to PF/UTLE793APB. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Copied file FACHISA to +
                        UTLNNNPB') TOMSGQ(MOPERQ MRUNQ)
CONT6:
/**/
/* Call program that will correct sequence no. in FACHISA            */
/**/
             CALL       PGM(UTLE0793A) PARM(&MODE)
/**/
/* Error occured in main program                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             RGZPFM     FILE(&DPLIB/UTLE793APB)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
             CPYF       FROMFILE(&DPLIB/UTLE793APB) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*REPLACE) +
                        CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(CONTIN6)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/UTLE793APB to PF/FACHISA. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Copied file UTLE793APB to +
                        FACHISA') TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/* Delete backup-up file if the program completed normally           */
/**/
CONTIN6:
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             DLTF       FILE(&DPLIB/PPFACHISA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/PPFACHISH)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/PPFACACT)
             MONMSG     MSGID(CPF0000)
             ENDDO
/**/
             SNDPGMMSG  MSG('UTCLE0793A completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or                            */
/* Restore backup if an error occured in update mode                 */
/**/
 ABNOR:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
             IF         COND(&RUNP *EQ 'YES') THEN(DO)
             CPYF       FROMFILE(&DPLIB/PPFACHISA) +
                        TOFILE(FACHISA) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/PPFACHISA to PF/FACHISA. Please copy file +
                          manually. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACHISA has +
                          been restored to FACHISA') TOMSGQ(MOPERQ +
                          MRUNQ)
/**/
             CPYF       FROMFILE(&DPLIB/PPFACHISH) +
                        TOFILE(&DMLIB/FACHISH) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/PPFACHISH to PF/FACHISH. Please copy file +
                          manually. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACHISH has +
                          been restored to FACHISH') TOMSGQ(MOPERQ +
                          MRUNQ)
/**/
             CPYF       FROMFILE(&DPLIB/PPFACACT) +
                        TOFILE(&DMLIB/FACACT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0793A - Error occured in copying +
                          PF/PPFACACT to PF/FACACT. Please copy file +
                          manually. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             SNDPGMMSG  MSG('UTCLE0793A - Back-up file PPFACHISH has +
                          been restored to FACHISH') TOMSGQ(MOPERQ +
                          MRUNQ)
             ENDDO
 
             ENDDO
 
 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCLE0793A program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2016')
             SNDPGMMSG  MSG('End of UTCLE0793A') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
