/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Processes SCCRTKEY command errors')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3100 - Details of new switchable features entered        */
/*                 through commands SCCRTKEY and SCCRTKEYB are       */
/*                 passed to a validation program SC3100V from here. */
/*                 This program processes any errors generated       */
/*                 by validation program SC3100V.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD055681           Date 31Jul20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CSC005  *CREATE    Date 08May98              */
/*                                                                   */
/*       Called by: SCCRTKEY                                         */
/*                  SCCRTKEYB                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055681 - Deliverable Data Split for SAR                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/

/* These parameters correspond to the fields in SCSARSPD, which      */
/* contains all core switchable features and details about release,  */
/* release status, etc..                                             */
/* Also includes unencrypted password.                               */

             PGM        PARM(&SARN &PASS &NEWD &SARD &PRIM +
                          &CEMI &WRELL &WIREL &CLVL &RSTS +
                          &DFLT &MNTB &CHRG &FLRN &DOCN +
                          &HELP &CORE)

             DCL        VAR(&SARN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PASS) TYPE(*CHAR) LEN(16)
             DCL        VAR(&NEWD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRIM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CEMI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRELL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WIREL) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CLVL) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DFLT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MNTB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CHRG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLRN) TYPE(*CHAR) LEN(35)
             DCL        VAR(&DOCN) TYPE(*CHAR) LEN(11)
             DCL        VAR(&HELP) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* If the non-core are updating their SAR file, do override */
             IF COND(&CORE *EQ 'B') THEN(DO)
/***********    OVRDBF     FILE(SCSARSL1) TOFILE(*LIBL/SCSARZL1) */                     /*MD055681*/
             ENDDO

/* Call validation program */
             CALL       PGM(SC3100V) +
                        PARM(&SARN &PASS &NEWD &SARD &PRIM +
                          &CEMI &WRELL &WIREL &CLVL &RSTS +
                          &DFLT &MNTB &CHRG &FLRN &DOCN +
                          &HELP &CORE &RTNCDE)

/* If the RTNCDE is '*EMPT' one of the fields on the input command */
/* was left blank. */
             IF         COND(&RTNCDE *EQ '*EMPT') THEN(DO)
                 SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          One or more fields contain blanks.') +
                          MSGTYPE(*DIAG)
                 CHGVAR     VAR(&ERROR) VALUE('Y')
                 GOTO       CMDLBL(ABNOR)
             ENDDO

/* If the RTNCDE is '*UPD' an error occurred when updating the */
/* SAR details stored on file. This is because a SAR specified  */
/* as core already exists on the non-core file or vice versa.  */
             IF         COND(&RTNCDE *EQ '*UPD') THEN(DO)

/*  Check necessary file exists */
/*  Start CSC007 */
/***************CHKOBJ  OBJ(*LIBL/UPJRNPD) OBJTYPE(*FILE) AUT(*CHANGE)*/
/***************MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)*/
/*  End   CSC007 */
                  SNDPGMMSG MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          Switchable feature found but user not +
                          authorized to update it.') +
                          MSGTYPE(*DIAG)
                  CHGVAR     VAR(&ERROR) VALUE('Y')
                  GOTO       CMDLBL(ABNOR)
/*  Start CSC007 */
/***************ENDDO */
/*  End   CSC007 */
             ENDDO

/* If the RTNCDE is '*ENCR' an error occurred during encryption. */
/* A character entered in the password was not valid.  */
             IF         COND(&RTNCDE *EQ '*ENCR') THEN(DO)

/*  Check necessary file exists */
/*  Start CSC007 */
/***************CHKOBJ     OBJ(*LIBL/UPJRNPD) OBJTYPE(*FILE) AUT(*USE)*/
/***************MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO) */
/*  End   CSC007 */
                  SNDPGMMSG MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          Password contains characters which are +
                          not alphabetic.') MSGTYPE(*DIAG)
                  CHGVAR     VAR(&ERROR) VALUE('Y')
                  GOTO       CMDLBL(ABNOR)
/*  Start CSC007 */
/***************ENDDO*/
/*  End   CSC007 */
             ENDDO

/* If the RTNCDE is '*NUPD' update mode has been selected but the*/
/* switchable feature is not already on file.  */
             IF         COND(&RTNCDE *EQ '*NUPD') THEN(DO)

/*  Check necessary file exists */
/*  Start CSC007 */
/***************CHKOBJ     OBJ(*LIBL/UPJRNPD) OBJTYPE(*FILE) AUT(*USE)*/
/***************MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)*/
/*  End   CSC007 */
                  SNDPGMMSG MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                          Update option unavailable until all new +
                          details inserted.') MSGTYPE(*DIAG)
                  CHGVAR     VAR(&ERROR) VALUE('Y')
                 GOTO       CMDLBL(ABNOR)
/*  Start CSC007 */
/***************ENDDO*/
/*  End   CSC007 */
             ENDDO

 ABNOR:
/*  Send message to cause CPF to pass earlier messages back         */
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
