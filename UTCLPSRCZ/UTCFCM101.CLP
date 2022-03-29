/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT FCM101 Take-on Utility Control')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       UTCFCM101 - Midas UT FCM101 Take-on Utility Control         */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. FCM101             Date 14Mar19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       FCM101 - Floor Rates                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FLR &DOC)
 
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* Copy details from PCFOLDER */
             CPYFRMPCD  FROMFLR(&FLR) TOFILE(UTFLRPD) FROMDOC(&DOC)
             CALL       PGM(UTFCM101A)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(UTFCM101B)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
              CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                           UTCFCM101 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:           CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                             2019')
 
              ENDPGM