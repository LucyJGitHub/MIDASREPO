/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Daily Management Accounts Balances Update')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0600 - Daily Management Accounts Balances Update         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. LLE030  *CREATE    Date 26Feb20              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LLE030  -  Run the management accounts balances update      */
/*                  every day for all control groups. This component */
/*                  is based on MCC0265, which is an on-request      */
/*                  component.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&GROUPCODE) TYPE(*CHAR) LEN(2)          /*Group Code*/
             DCL        VAR(&PERIODSET) TYPE(*CHAR) LEN(1)          /*Period Set*/
             DCL        VAR(&POSTINGBAS) TYPE(*CHAR) LEN(1)         /*Posting Basis*/
             DCL        VAR(&STARTDATE) TYPE(*CHAR) LEN(5)          /*Start Date*/
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(8)           /*Sections*/
             DCL        VAR(&ANALYSIS) TYPE(*CHAR) LEN(10)          /*Analysis*/
             DCL        VAR(&STARTTIME) TYPE(*CHAR) LEN(6)          /*Start Time*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(1)         /*Return Code*/
             DCL        VAR(&CMC001) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')

/* Global error message                                              */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))

/* Create LDA */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000)

/* Retrieve recovery flag */

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DILIB) VALUE(&SYSID *TCAT 'DILIB')
             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *TCAT 'DMLIB')

/* If restart, Restore for Security Copies  */

             IF         COND(&BUSY = 'Y') THEN(DO)
             RSTOBJ     OBJ(GLHIBLPD GLAVBLPD) SAVLIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/MCC0265A)
             ENDDO

             ELSE       CMD(DO)

/* Take security copy of files  */

             CHKOBJ     OBJ(&DILIB/MCC0265A) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTSAVF    FILE(&DILIB/MCC0265A) TEXT('Save of +
                          Management Accounts file during COB')
             ENDDO
             CLRSAVF    FILE(&DILIB/MCC0265A)
             SAVOBJ     OBJ(GLHIBLPD GLAVBLPD) LIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/MCC0265A)

             ENDDO

/*  Check if Management Accounts Enhancement is installed. */

             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)

/*  If Management Accounts Enhancement is installed, exclusively  */
/*  allocate DTAARA/MC0220 to indicate that mgmt a/cs are in use  */

             IF         COND(&RTCD *EQ ' ') THEN(DO)
                CHGVAR     VAR(&CMC001) VALUE('Y')
                ALCOBJ     OBJ((MC0220 *DTAARA *EXCLRD)) WAIT(0)
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   SNDPGMMSG  MSG('Management accounts files cannot +
                                allocated at this time.') +
                                TOMSGQ(MRUNQ MOPERQ)
                   MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                   GOTO       CMDLBL(ERROR)
                ENDDO
             ENDDO

/* Set busy flag */

             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)

/* Work through all defined Group Codes */
TAG01:

/* Call the Update All Control Groups program */
             CALL       PGM(MC0265) PARM(&GROUPCODE &PERIODSET +
                          &POSTINGBAS &STARTDATE &SECTIONS +
                          &ANALYSIS &STARTTIME)

/* If Group Code is not returned from MCC0265, skip out of loop */
             IF         COND(&GROUPCODE *EQ '  ') THEN(GOTO +
                          CMDLBL(TAG02))

/** If the required members do not exist, create them.            */
/** This will be required where a database is restored containing */
/** control groups for which the pf/lf members do not exist.      */

             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLHIBLPD) +
                        MBR(&GROUPCODE))

             CHKOBJ     OBJ(GLHIBLL0) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL0) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLHIBLL1) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL1) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLHIBLL3) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL3) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLHIBLL4) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL4) +
                        MBR(&GROUPCODE) DTAMBRS((GLHIBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLAVBLPD) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLAVBLPD) +
                        MBR(&GROUPCODE))

             CHKOBJ     OBJ(GLAVBLL0) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL0) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLAVBLL1) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL1) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))

             CHKOBJ     OBJ(GLAVBLL3) OBJTYPE(*FILE) MBR(&GROUPCODE)
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL3) +
                        MBR(&GROUPCODE) DTAMBRS((GLAVBLPD +
                        (&GROUPCODE))))

/* Override to member for the Group Code */
             OVRDBF     FILE(GLHIBLPD) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL0) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL1) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL3) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL4) TOFILE(*FILE) MBR(&GROUPCODE)

             OVRDBF     FILE(GLAVBLPD) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL0) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL1) TOFILE(*FILE) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL3) TOFILE(*FILE) MBR(&GROUPCODE)

/* Call Select Postings using OPNQRYF program */
/* These parameters are output by MC0265      */
             CALL       PGM(MCC0299) PARM(&PERIODSET &POSTINGBAS +
                          &STARTDATE &SECTIONS &ANALYSIS 'N' +
                          &STARTTIME)

/* Call Update Management Accounts to Current End of Period program  */
             CALL       PGM(MC0230) PARM(&GROUPCODE &RETURNCODE)

/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* Call Update Management Accounts with Movements program */
/*      Override UPDBALPD to OPNQRYF generated by MCC0299 */
             OVRDBF     FILE(UPDBALPD) TOFILE(GLPERDPD) SHARE(*YES)
             CALL       PGM(MC0235) PARM(&GROUPCODE &RETURNCODE)
             DLTOVR     FILE(UPDBALPD)

/* Check for database error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* Call Rework DR/CR Average Balances program */
             CALL       PGM(MCC0240) PARM(&GROUPCODE &RETURNCODE)

/* Check for database error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))

/* Delete all file overrides */
             DLTOVR     FILE(*ALL)

/* End of processing run if MC0265 returns a Group Code */
/* Process the next Group Code                          */
             GOTO       CMDLBL(TAG01)

/* Reset busy flag as run successful */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
             CLRSAVF    FILE(&DILIB/MCC0265A)

 TAG02:
             IF         COND(&CMC001 *EQ 'Y') THEN(DO)
                DLCOBJ     OBJ((MC0220 *DTAARA *EXCLRD))
             ENDDO
             GOTO       CMDLBL(ENDP)

 ERROR:      SNDPGMMSG  MSG('Daily Management Accounts Balances +
                          Update ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2002')
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
