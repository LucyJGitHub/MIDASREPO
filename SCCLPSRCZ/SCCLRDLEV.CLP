/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear Last Night DL Events File')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCLRDLEV - Clear DL events files                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. AR1038892 *Create  Date 14Nov16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1038892 - CoB performance problems                        */
/*                   Bring the clear of the events files forward as  */
/*                   they are large files and can take minutes to    */
/*                   clear. (Child:AR1038893)                        */
/*                   Apply fix for MD042369                          */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2016')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)


/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)
             RTVJOBA    TYPE(&JOBTYPE)
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)

             SNDPGMMSG  MSG('Clear Previous Night''s DL Events files') +
                          TOMSGQ(MRUNQ)

             CLRPFM     FILE(EVNTXEC)
             CLRPFM     FILE(EVNTXED)
             CLRPFM     FILE(EVNTXZZ)
             IF         COND(%SST(&MMOD 7 1)='Y') THEN(DO)
                 CLRPFM     FILE(EMXT2H1)
                 CLRPFM     FILE(EMXT2D2)
                 CLRPFM     FILE(EMXT2T1)
                 CLRPFM     FILE(EMTE2H1)
                 CLRPFM     FILE(EMTE2E2)
                 CLRPFM     FILE(EMTE2T1)
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCLRDLEV ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

             ENDPGM
