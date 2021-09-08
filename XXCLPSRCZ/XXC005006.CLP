000100210908/*********************************************************************/
000101210908/*STD    CLPBASE                                                     */
000102210908/*EXI    TEXT('Midas XX ETL Extract Requirements - SDBANK')          */
000103210908/*********************************************************************/
000104210908/*                                                                   */
000105210908/*       Midas - Standing Data Module                                */
000106210908/*                                                                   */
000107210908/*       XXC005006 - Midas XX ETL Extract Requirements - SDBANK      */
000108210908/*                                                                   */
000109210908/*       (c) Finastra International Limited 2021                     */
000110210908/*                                                                   */
000111210908/*       Last Amend No. DRI007  *CREATE    Date 16Aug21              */
000112210908/*                                                                   */
000113210908/*********************************************************************/
000114210908/*                                                                   */
000115210908/*       DRI007 - ETL Extract Requirements                           */
000116210908/*                                                                   */
000117210908/*********************************************************************/
000118210908             PGM        PARM(&BJRDNB &BJLCCY &BJSLCD &BJBVPD &BJDFIN)
000119210908
000120210908             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
000121210908                          Limited 2021')
000122210908             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
000123210908             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
000124210908
000125210908             DCLF       FILE(SDBANKPD)
000126210908/**/
000127210908/*    Global monitor message                                         */
000128210908/**/
000129210908             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
000131210908
000132210908             SNDPGMMSG  MSG('XXC005005 - Midas XX ETL Extract Requirements') TOMSGQ(MRUNQ)
000134210908
000135210908/**/
000136210908             CHGJOB     SWS(00000000)
000137210908
000138210908/* Determine the backup data library name                                          */
000139210908
000140210908             RCVF
000141210908
000142210908             GOTO       CMDLBL(ENDPGM)
000143210908
000144210908 ABNOR:
000145210908             CHGJOB     SWS(XXXXXX11)
000146210908
000147210908/* Abnormal termination */
000148210908
000149210908             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC005006 ended +
000150210908                          abnormally - see job log') TOMSGQ(MOPERQ)
000151210908             MONMSG     MSGID(CPF0000 MCH0000)
000152210908
000153210908 ENDPGM:
000154210908             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited 2021')
000156210908             ENDPGM
