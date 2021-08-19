/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX ETL Extract Requirements - SDBANK')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       XXC005006 - Midas XX ETL Extract Requirements - SDBANK      */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. DRI007  *CREATE    Date 16Aug21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       DRI007 - ETL Extract Requirements                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BJRDNB &BJLCCY &BJSLCD &BJBVPD &BJDFIN)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2021')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)

             DCLF       FILE(SDBANKPD)
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('XXC005005 - Midas XX ETL Extract Requirements') +
                          TOMSGQ(MRUNQ)

/**/
             CHGJOB     SWS(00000000)

/* Determine the backup data library name                                          */

             RCVF

             GOTO       CMDLBL(ENDPGM)

 ABNOR:
             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC005006 +
                          ended abnormally - see job log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2021')
             ENDPGM
