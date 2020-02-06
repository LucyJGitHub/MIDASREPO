/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Initialisation Program for CSW210')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities and Trading Module                       */
/*                                                                   */
/*       CLP/SEC000200 - Midas Initialisation Program for CSW210     */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSW210  *CREATE    Date 04May10              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW210 - Swift 2010 Changes                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCODE &RESMODE)
 
/* Declare Variables */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RESMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2010')
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRCOD) TYPE(*DEC ) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas Initialisation Program for CSW210') +
                            TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
/* Start commitment control for batch jobs with file updates */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
                MONMSG     MSGID(CPF8351)
             ENDDO
 
/* Start commitment control for inter-active jobs */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF8351)
             ENDDO
 
/*  Check that ZMUSER dataarea has been set up in QTEMP, if not   */
/*  create it here.                                               */
 
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
 
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CALL       PGM(ZMUSER) PARM(&ERRCOD &ZMUSER)
               IF         COND(&ERRCOD *NE 0) THEN(DO)
                 SNDPGMMSG MSG('Default Branch or Department not valid') +
                       TOPGMQ(*EXT) MSGTYPE(*INFO)
               ENDDO
             ENDDO
 
/* Call Initialisation Program for CSW210 */
 
             CALL       PGM(SE000200) PARM(&RETCODE &RESMODE)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
/* Abnormal termination - Batch job */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC000200 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2010')
 
             ENDPGM
 
