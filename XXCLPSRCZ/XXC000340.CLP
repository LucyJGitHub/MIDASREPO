/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Check if OPICS download is finished')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-Opics Interface                               */
/*                                                                   */
/********SDC9700*-*Check*if*OPICS*download*is*completed***************/                 /* JMI111 */
/*       XXC000340 - Check if OPICS download is completed            */                 /* JMI111 */
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                 /* JMI111 */
/*       (c) Finastra International Limited 2018                     */                 /* JMI111 */
/*                                                                   */
/*       Last Amend No. JMI111               Date 16May18            */
/*       Prev Amend No. CGL019  *CREATE      Date 20Apr07            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI111 - Midas/OPICS Interface. Upgrade to FBM 2.1          */
/*       CGL019 - Midas/OPICS Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM

/************DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')                                              */        /* JMI111 */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2018')                         /* JMI111 */

             DCL        VAR(&DQNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('DOWNLOAD')
             DCL        VAR(&MSGLEN) TYPE(*DEC) LEN(5 0) VALUE(2)
             DCL        VAR(&WAITTM) TYPE(*DEC) LEN(5 0) VALUE(100)
             DCL        VAR(&DTQVAL) TYPE(*CHAR) LEN(2)

/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))

/* Send message to MRUNQ */
/************SNDPGMMSG  MSG('SDC9700 - Check if OPICS download is completed') + */      /* JMI111 */
             SNDPGMMSG  MSG('XXC000340 - Check if OPICS download is +
                          completed') TOMSGQ(MRUNQ)                                     /* JMI111 */

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)

             CALL       PGM(QRCVDTAQ) PARM(&DQNAME '*LIBL' &MSGLEN +
                          &DTQVAL &WAITTM)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&DTQVAL) +
                          VALUE('  '))

/* If returned value is blank, CoB cannot continue */

             IF         COND(&DTQVAL *EQ '  ' *OR &MSGLEN *EQ 0) +
                          THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                SNDMSG     MSG('OPICS download processing is still running') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)

 ABNOR:        CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
/**************SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                          ('Program SDC9700 ended abnormally - +
                          see job log') TOMSGQ(MOPERQ MRUNQ)                  */        /* JMI111 */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          XXC000340 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ MRUNQ)                                    /* JMI111 */
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO

 ENDPGM:
/************CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')          */        /* JMI111 */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2018')                         /* JMI111 */

             ENDPGM
