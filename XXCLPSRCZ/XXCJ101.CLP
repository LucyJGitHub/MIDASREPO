/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Pooling Accounts Maintenance')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/********SDCJ101*-*Midas*SD Pooling Accounts Maintenance**************/         /*JMI108*/
/*       XXCJ101 - Midas SD Pooling Accounts Maintenance             */         /*JMI108*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/         /*JMI108*/
/*       (c) Finastra International Limited 2018                     */         /*JMI108*/
/*                                                                   */
/*       Last Amend No. JMI108             Date 31May18              */
/*       Prev Amend No. TFJ011  *CREATE    Date 22Jan07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI108 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ011 - Account Balance Pooling                            */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&RETURN &MODE)

             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI108*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI108*/

/* Global monitor message */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)

             CHGJOB     SWS(XXXXXX00)

/* Main processing */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB')

             IF         (&MODE = 'M') THEN(DO)

/* Move QTEMP at the top of the library list */
             RMVLIBLE   QTEMP
             MONMSG     MSGID(CPF2104)
             ADDLIBLE   QTEMP
             MONMSG     MSGID(CPF2103)

/*           CLRPFM     FILE(SDJ101PP) */ /*JMI108*/
             CLRPFM     FILE(XXJ101PP) /*JMI108*/
             MONMSG     MSGID(CPF0000)

/*           CPYF       FROMFILE(&DPLIB/SDJ101PP) TOFILE(QTEMP/SDJ101PP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) */ /*JMI108*/
             CPYF       FROMFILE(&DPLIB/XXJ101PP) TOFILE(QTEMP/XXJ101PP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) /*JMI108*/
             ENDDO
/* Call the Midas SD Pooling Accounts Maintenance */
/*           CALL       PGM(SDJ101D) PARM(&RETURN &MODE) */ /*JMI108*/
             CALL       PGM(XXJ101D) PARM(&RETURN &MODE) /*JMI108*/

/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(&RETURN *EQ 'PSSR   ') THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call the Midas SD Pooling Accounts Maintenance Audit */
             IF         (&MODE = 'M') THEN(DO)
             RTVJOBA    JOB(&JOB) USER(&USER)
/*           CALL       PGM(SDJ105) PARM(&RETURN &MODE &SEQ &LVL &ENT &JOB &USER) */ /*JMI108*/
             CALL       PGM(XXJ105) PARM(&RETURN &MODE &SEQ &LVL &ENT &JOB &USER) +
                          /*JMI108*/

/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(&RETURN *EQ 'PSSR   ') THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO

/*           DLTF       FILE(QTEMP/SDJ101PP) */ /*JMI108*/
             DLTF       FILE(QTEMP/XXJ101PP) /*JMI108*/
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   QTEMP
             MONMSG     MSGID(CPF2104)
             ADDLIBLE   LIB(QTEMP) POSITION(*LAST)
             MONMSG     MSGID(CPF2103)

             ENDDO

             GOTO       CMDLBL(END)

ABNOR:

             CHGJOB     SWS(XXXXXX11)

             SNDMSG     MSG('Midas SD Pooling Accounts Maintenance +
                          has terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*JMI108*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*JMI108*/

             ENDPGM
