/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT MOVMBR validity checker')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0370_VC - Validity checker for MOVMBR                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 08Feb02              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP014 *C *CREATE  Date 12Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Date checking improved.                            */
/*       CUP014 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FROMFILEQ &FROMMBR &TOLIB &MBRTYPE +
                          &LEAVE &CREATE &REPLACE &DATE &DATESEL)
 
             DCL        VAR(&FROMFILEQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FROMMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATESEL) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LEAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CREATE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REPLACE) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&FROMFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YEAR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YEARN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&DIVYEAR) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DIVYEARN) TYPE(*DEC) LEN(5 2)
             DCL        VAR(&FILEGEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBRGEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REM) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Break down file and library and date fields. */
             CHGVAR     VAR(&FROMFILE) VALUE(%SST(&FROMFILEQ 1 10))
             CHGVAR     VAR(&FROMLIB) VALUE(%SST(&FROMFILEQ 11 10))
             IF         COND(&DATE *NE '*ALL') THEN(DO)
                CHGVAR     VAR(&DAY) VALUE(%SST(&DATE 1 2))
                CHGVAR     VAR(&MONTH) VALUE(%SST(&DATE 3 2))
                CHGVAR     VAR(&YEAR) VALUE(%SST(&DATE 5 2))
             ENDDO
 
/* Check if file contains '*ALL' or is generic. */
             IF         COND(%SST(&FROMFILE 1 1) *EQ '*' *OR +
                          %SST(&FROMFILE 2 1) *EQ '*' *OR +
                          %SST(&FROMFILE 3 1) *EQ '*' *OR +
                          %SST(&FROMFILE 4 1) *EQ '*' *OR +
                          %SST(&FROMFILE 5 1) *EQ '*' *OR +
                          %SST(&FROMFILE 6 1) *EQ '*' *OR +
                          %SST(&FROMFILE 7 1) *EQ '*' *OR +
                          %SST(&FROMFILE 8 1) *EQ '*' *OR +
                          %SST(&FROMFILE 9 1) *EQ '*' *OR +
                          %SST(&FROMFILE 10 1) *EQ '*') THEN(DO)
                CHGVAR     VAR(&FILEGEN) VALUE('Y')
             ENDDO
 
/* Check if member contains '*ALL' or is generic. */
             IF         COND(%SST(&FROMMBR 1 1) *EQ '*' *OR +
                          %SST(&FROMMBR 2 1) *EQ '*' *OR +
                          %SST(&FROMMBR 3 1) *EQ '*' *OR +
                          %SST(&FROMMBR 4 1) *EQ '*' *OR +
                          %SST(&FROMMBR 5 1) *EQ '*' *OR +
                          %SST(&FROMMBR 6 1) *EQ '*' *OR +
                          %SST(&FROMMBR 7 1) *EQ '*' *OR +
                          %SST(&FROMMBR 8 1) *EQ '*' *OR +
                          %SST(&FROMMBR 9 1) *EQ '*' *OR +
                          %SST(&FROMMBR 10 1) *EQ '*') THEN(DO)
                CHGVAR     VAR(&MBRGEN) VALUE('Y')
             ENDDO
 
/* If file is *ALL or *generic then library can not be *LIBL. */
             IF         COND(&FILEGEN *EQ 'Y' *AND &FROMLIB *EQ '*LIBL') +
                          THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Combination of requested +
                             files and *LIBL is not valid.') +
                             MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If a specific file has been selected then check it exists. */
             IF         COND(&FILEGEN *NE 'Y') THEN(DO)
                CHKOBJ     OBJ(&FROMLIB/&FROMFILE) OBJTYPE(*FILE) +
                             AUT(*CHANGE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000File' *BCAT &FROMFILE *BCAT +
                                'in' *BCAT &FROMLIB *BCAT 'does not +
                                exist.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000You +
                                do not have authority to' *BCAT &FROMFILE +
                                *TCAT '.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* If a specific from library has been selected then check it exists. */
             IF         COND(&FROMLIB *NE '*LIBL') THEN(DO)
                CHKOBJ     OBJ(&FROMLIB) OBJTYPE(*LIB) AUT(*CHANGE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000Library' *BCAT &FROMLIB *BCAT +
                                'does not exist.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                MONMSG     MSGID(CPF9802) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000You do not have authority +
                             to' *BCAT &FROMLIB *TCAT '.') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* If a specific member has been selected then check it exists. */
             IF         COND(&MBRGEN *NE 'Y') THEN(DO)
                CHKOBJ     OBJ(&FROMLIB/&FROMFILE) OBJTYPE(*FILE) +
                          MBR(&FROMMBR) AUT(*CHANGE)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000Member' *BCAT &FROMMBR *BCAT +
                                'in' *BCAT &FROMLIB *TCAT '/' *TCAT +
                                &FROMFILE *BCAT 'does not exist.') +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
/* Check that from and to library are not the same. */
             IF         COND(&FROMLIB *EQ '*LIBL') THEN(DO)
                RTVOBJD    OBJ(&FROMFILE) OBJTYPE(*FILE) RTNLIB(&FROMLIB)
             ENDDO
             IF         COND(&FROMLIB *EQ &TOLIB) THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000From library must not be the +
                          same as the to library.') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* See if TOLIB exists and that suitable authority exists. */
             CHKOBJ     OBJ(*LIBL/&TOLIB) OBJTYPE(*LIB) AUT(*CHANGE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &TOLIB *BCAT +
                          'does not exist.') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             MONMSG     MSGID(CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000You do not have authority +
                          to' *BCAT &TOLIB *TCAT '.') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check that date is valid. */
             IF         COND(&DATE *NE *ALL) THEN(DO)
                IF         COND(&YEAR *LT '00' *OR &YEAR *GT '99') +
                             THEN(DO)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&MONTH *LT '01' *OR &MONTH *GT '12') +
                             THEN(DO)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&DAY *LT '01' *OR &DAY *GT '31') +
                             THEN(DO)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(DATECHK)
                ENDDO
                IF         COND(&MONTH *EQ '02' *OR &MONTH *EQ '04' *OR +
                             &MONTH *EQ '06' *OR &MONTH *EQ '09' *OR +
                             &MONTH *EQ '11') THEN(DO)
                   IF         COND(&DAY *EQ '31') THEN(DO)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(DATECHK)
                   ENDDO
                ENDDO
                IF         COND(&MONTH *EQ '02') THEN(DO)
                   IF         COND(&DAY *EQ '30') THEN(DO)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(DATECHK)
                   ENDDO
                   IF         COND(&DAY *EQ '29' *AND &YEAR *NE '00') +
                             THEN(DO)                                                     /*CPK014*/
                   CHGVAR     VAR(&YEARN) VALUE(&YEAR)
                   CHGVAR     VAR(&DIVYEARN) VALUE(&YEARN / 4)
                   CHGVAR     VAR(&DIVYEAR) VALUE(&DIVYEARN)
                   CHGVAR     VAR(&REM) VALUE(%SST(&DIVYEAR 4 2))
                   IF         COND(&REM *NE '00') THEN(DO)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                      GOTO       CMDLBL(DATECHK)
                   ENDDO
                   ENDDO                                                                  /*CPK014*/
                ENDDO
             ENDDO
 
DATECHK:
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Date is not valid.') +
                             MSGTYPE(*DIAG)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
