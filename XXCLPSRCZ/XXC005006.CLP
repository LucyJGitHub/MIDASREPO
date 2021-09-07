000100210907                      /*********************************************************************/
000101210907/*STD    CLPBASE                                                     */
000102210907/*EXI    TEXT('Midas XX ETL Extract Requirements - SDBANK')          */
000103210907/*********************************************************************/
000104210907/*                                                                   */
000105210907/*       Midas - Standing Data Module                                */
000106210907/*                                                                   */
000107210907/*       XXC005006 - Midas XX ETL Extract Requirements - SDBANK      */
000108210907/*                                                                   */
000109210907/*       (c) Finastra International Limited 2021                     */
000110210907/*                                                                   */
000111210907/*       Last Amend No. DRI007  *CREATE    Date 16Aug21              */
000112210907/*                                                                   */
000113210907/*********************************************************************/
000114210907/*                                                                   */
000115210907/*       DRI007 - ETL Extract Requirements                           */
000116210907/*                                                                   */
000117210907/*********************************************************************/
000118210907             PGM        PARM(&BJRDNB &BJLCCY &BJSLCD &BJBVPD &BJDFIN)
000119210907
000120210907             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
000121210907                          Limited 2021')
000122210907             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
000123210907             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
000124210907
000125210907             DCLF       FILE(SDBANKPD)
000126210907/**/
000127210907/*    Global monitor message                                         */
000128210907/**/
000129210907             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
000131210907
000132210907             SNDPGMMSG  MSG('XXC005005 - Midas XX ETL Extract Requirements') TOMSGQ(MRUNQ)
000134210907
000135210907/**/
000136210907             CHGJOB     SWS(00000000)
000137210907
000138210907/* Determine the backup data library name                                          */
000139210907
000140210907             RCVF
000141210907
000142210907             GOTO       CMDLBL(ENDPGM)
000143210907
000144210907 ABNOR:
000145210907             CHGJOB     SWS(XXXXXX11)
000146210907
000147210907/* Abnormal termination */
000148210907
000149210907             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC005006 ended +
000150210907                          abnormally - see job log') TOMSGQ(MOPERQ)
000151210907             MONMSG     MSGID(CPF0000 MCH0000)
000152210907
000153210907 ENDPGM:
000154210907             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited 2021')
000156210907             ENDPGM
