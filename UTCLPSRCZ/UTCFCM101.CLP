000100200430/*********************************************************************/
000101200430/*STD    CLPBASE                                                     */
000102200430/*EXI    TEXT('Midas UT FCM101 Take-on Utility Control')             */
000103200430/*********************************************************************/
000104200430/*                                                                   */
000105200430/*       Midas - General Ledger Module                               */
000106200430/*                                                                   */
000107200430/*       UTCFCM101 - Midas UT FCM101 Take-on Utility Control         */
000108200430/*                                                                   */
000109200430/*       (c) Finastra International Limited 2019                     */
000110200430/*                                                                   */
000111200430/*       Last Amend No. FCM101             Date 14Mar19              */
000112200430/*                                                                   */
000113200430/*********************************************************************/
000114200430/*                                                                   */
000115200430/*       FCM101 - Floor Rates                                        */
000116200430/*                                                                   */
000117200430/*********************************************************************/
000118200430             PGM        PARM(&FLR &DOC)
000119200430
000120200430             DCL        VAR(&FLR) TYPE(*CHAR) LEN(10)
000121200430             DCL        VAR(&DOC) TYPE(*CHAR) LEN(10)
000122200430             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
000123200430             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra International +
000124200430                          Limited 2018') /*JMI108*/
000125200430
000126200430/* Global monitor message */
000127200430
000128200430             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
000130200430/* Copy details from PCFOLDER */
000131200430             CPYFRMPCD  FROMFLR(&FLR) TOFILE(UTFLRPD) FROMDOC(&DOC)
000132200430             CALL       PGM(UTFCM101A)
000133200430             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
000134200430                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
000136200430                GOTO       CMDLBL(ABNOR)
000137200430             ENDDO
000138200430
000139200430             CALL       PGM(UTFCM101B)
000140200430             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
000141200430                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
000143200430                GOTO       CMDLBL(ABNOR)
000144200430             ENDDO
000145200430
000146200430             GOTO       CMDLBL(END)
000147200430
000148200430 ABNOR:
000149200430
000150200430             CHGJOB     SWS(XXXXXX11)
000151200430
000152200430             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program UTCFCM101 ended +
000153200430                          abnormally - see job log') TOMSGQ(MOPERQ)
000155200430             MONMSG     MSGID(CPF0000 MCH0000)
000156200430
000157200430 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited 2019')
000159200430
000160200430             ENDPGM
