/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*       Midas - Funds Transfer Module.                              */
/*                                                                   */
/*       FTCE060 - Midas FT BIC Load Interface File.                 */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2006                         */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. MKCAR9  *Create    Date 25Nov04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       MKCAR9 - BIC Load.                                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2006')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

/* Global message monitor : */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
/**/
/**/
             ALCOBJ     OBJ((FTCE060 *DTAARA *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('FTCE060 - Procedure already Active') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDB)
             ENDDO
/**/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*    CREATE LDA IF NOT IN LIBRARY LIST - EG SUBMITTED JOB */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL DATA AREA +
                          EQUIVALENT') AUT(*USE))
/**/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T E 0 6 0  - - -      **/
/*                    - - - - - - - - - - - -        */
             CHGJOB     SWS(XXXXXX00)
/**/
/**  Check for Database Errors Trapped by Program   **/
/**/
/*                    - - - - - - - - - - - -        */
/**  Call Program    - - -  F T 0 6 6 0  - - -      **/
/*                    - - - - - - - - - - - -        */

             CALL       PGM(FTE060) PARM(&JOB &USER &NBR)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             ROLLBACK
             SNDPGMMSG  MSG('Process Failed. Press Enter to +
                          Continue.') TOPGMQ(*EXT)
             CHGJOB     SWS(XXXXXXX1)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             CLRPFM     FILE(FTBICLPD)
             SNDPGMMSG  MSG('BIC Load run completed successfully.') +
                          TOMSGQ(MRUNQ)
             GOTO       CMDLBL(END)
/**/
/*  Abnormal termination processing  */
/**/
ABNOR:

             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Request has terminated abnormally. +
                          Please contact your system supervisor') +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Request has terminated abnormally. +
                          Please contact your system supervisor') +
                          TOPGMQ(*EXT)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 END:        DLCOBJ     OBJ((FTCE060 *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 ENDB:       CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys Banking +
                          Systems Ltd.')
             ENDPGM
