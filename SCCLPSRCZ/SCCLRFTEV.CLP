/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear Last Night FT Events File')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCLRFTEV - Clear FT events files                           */
/*                                                                   */
/*       (c) Finastra International Limited 2016                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1038892 *CREATE  Date 14Nov16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1038892 - CoB performance problems                        */
/*                   Bring the clear of the events files forward as  */
/*                   they are large files and can take minutes to    */
/*                   clear. (Child:AR1038893)                        */
/*                   Apply fix for MD042369                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2016')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             RTVJOBA    TYPE(&JOBTYPE)
 
             SNDPGMMSG  MSG('Clear Previous Night''s FT Events files') +
                          TOMSGQ(MRUNQ)
 
             CLRPFM     FILE(FPVNTDD)
             CLRPFM     FILE(FPVNTZZ)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCLRFTEV ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
