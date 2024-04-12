/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Client Input Cycle Initiation DB save (SAVF)')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC5150    -  INPUT CYCLE INITIATION DB SAVE (SAVF)         */
/*                                                                   */
/*       (c) Finastra International Limited 2024                     */
/*                                                                   */
/*       Last Amend No. MD056670 *CREATE   Date 01Mar24              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD056670 - Use of BRMS versus core feature CSC032           */
/*                                                                   */
/*********************************************************************/
             PGM

/*   Initial Processing                                             */

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2024')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

/* ********** INSERT ANY PROCESSING HERE ******************************* */

             GOTO       CMDLBL(END)
ABNOR:

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination - batch job */

             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC5150 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)

             ENDDO
END:
             ENDPGM
