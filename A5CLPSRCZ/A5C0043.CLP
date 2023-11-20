/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Extra Statements for set of accounts')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       A5C0043 - Midas GL Extra Statements for set of accounts     */
/*                                                                   */
/*       (c)  Copyright Finastra International Limited 2023          */
/*                                                                   */
/*       Last Amend No. BA5009             Date 06Sep23              */
/*       Prev Amend No. BA5008 *CREATE     Date 06Sep23              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BA5009 - Extra Statement of Accounts for A/c codes          */
/*                "0000002362" to "0000002369" (Non Month End)       */
/*       BA5008 - Extra Statement of Accounts for A/c codes          */
/*                "0000002362" to "0000002369" (Month End)           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2023')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&BA5008) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&BA5009) TYPE(*CHAR) LEN(1) VALUE('N')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                             EXEC(GOTO ABNOR)

/* Send message to MRUNQ */
             SNDPGMMSG  MSG('A5C0043 - Midas GL Extra Statements for +
                          set of accounts') TOMSGQ(MRUNQ)
/**/
/** Access SAR file to determine if switchable feature BA5008 is switched ON.          */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('BA5008')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BA5008) VALUE('Y'))

/**/
/** Access SAR file to determine if switchable feature BA5009 is switched ON.          */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('BA5009')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BA5009) VALUE('Y'))

/**/
/* Call SD2000 to determine whether End of Month */
/**/
             CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                  CHGVAR     VAR(&PGM) VALUE('SD2000')
                  GOTO       CMDLBL(ABNOR)
             ENDDO

             OVRDBF     FILE(GLAPSGL0) TOFILE(GLAPSGAL0)

             IF         COND(&EOM *EQ 'Y' *AND &BA5008 *EQ 'Y') THEN(DO)
                  CALL       PGM(A50420)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                    CHGVAR     VAR(&PGM) VALUE('A50420')
                    GOTO       CMDLBL(ABNOR)
                  ENDDO
                  ENDDO

             IF         COND(&EOM *NE 'Y' *AND &BA5009 *EQ 'Y') THEN(DO)
                  CALL       PGM(A50421)
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                    CHGVAR     VAR(&PGM) VALUE('A50421')
                    GOTO       CMDLBL(ABNOR)
                  ENDDO
                  ENDDO

             GOTO       CMDLBL(ENDPGM)

/** Abnormal error processing */

ABNOR:       CHGVAR     VAR(&MSG) VALUE('Program A5C0043 - ' *CAT +
                          &PGM *BCAT 'ended abnormally')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2023')
ENDPGM:      ENDPGM

