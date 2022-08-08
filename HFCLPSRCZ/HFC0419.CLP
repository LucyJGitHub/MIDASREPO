/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas HF Update Midas User Info (CGP018)')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module               */
/*                                                                   */
/*       HFC0419  - Midas HF Update Midas User Info (CGP018)         */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. CGP018  *CREATE    Date 15Oct12              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGP018 - Midas User Information                             */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&PGM)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2021')

             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2) VALUE(' ')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100) VALUE(' ')
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10) VALUE('JRNBATCH')
             DCL        VAR(&NBR) TYPE(*DEC) LEN(10 0)

             DCLF       FILE(HFFILEL3)

/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')

/* */
/* Processing when coming from HFC0400 */
/* */
             IF         COND(&PGM = 'HFC0400') THEN(DO)

/* */
/* Read all records on file */
/* */
 LOOP:       RCVF

/* */
/* EOF so end program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

/* */
/* Update only on member JRNBATCH else read next record */
/* */
             CHKOBJ     OBJ(&HFLIB/&FFILE) OBJTYPE(*FILE) MBR(&MBR)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))

/* */
/* Check if record to process */
/* */
             RTVMBRD    FILE(&HFLIB/&FFILE) MBR(&MBR) NBRCURRCD(&NBR)
             IF         COND(&NBR *EQ 0) THEN(GOTO CMDLBL(LOOP))

/* */
/* Update users */
/* */
             OVRDBF     FILE(XX) TOFILE(&HFLIB/&FFILE) MBR(&MBR)
             CALL       PGM(HF0419)
             DLTOVR     FILE(XX)

/* */
/* Read next record */
/* */
             GOTO       CMDLBL(LOOP)
             ENDDO


/* */
/* Processing when coming from HFC0200 */
/* */

             IF         COND(&PGM = 'HFC0200') THEN(DO)

/* */
/* Update only file XX exists */
/* */
             CHKOBJ     OBJ(&HFLIB/XX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('File: XX into ' *CAT &HFLIB +
                          *CAT ' not found')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       CMDLBL(END)
             ENDDO

/* */
/* Check if record to process */
/* */
             RTVMBRD    FILE(&HFLIB/XX) NBRCURRCD(&NBR)
             IF         COND(&NBR *EQ 0) THEN(GOTO CMDLBL(END))

/* */
/* Update users */
/* */
             OVRDBF     FILE(XX) TOFILE(&HFLIB/XX)
             CALL       PGM(HF0419)
             DLTOVR     FILE(XX)

             ENDDO


/* */
/* Processing when coming from HFC0510 */
/* */

             IF         COND(&PGM = 'HFC0510') THEN(DO)

/* */
/* Update only file XX exists */
/* */
             CHKOBJ     OBJ(QTEMP/XX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('File: QTEMP/XX not found')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       CMDLBL(END)
             ENDDO

/* */
/* Check if record to process */
/* */
             RTVMBRD    FILE(QTEMP/XX) NBRCURRCD(&NBR)
             IF         COND(&NBR *EQ 0) THEN(GOTO CMDLBL(END))

/* */
/* Update users */
/* */
             OVRDBF     FILE(XX) TOFILE(QTEMP/XX)
             CALL       PGM(HF0419)
             DLTOVR     FILE(XX)

             ENDDO


/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0419 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')

             ENDPGM
