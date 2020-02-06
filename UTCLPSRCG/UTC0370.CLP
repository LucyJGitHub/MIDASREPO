/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for MOVMBR utility')                     */
/*XBI    OVRDBF FILE(MOVMBR) TOFILE(QAFDMBRL)                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0370 - CPP for MOVMBR utility                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 11Oct01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP014 *CREATE     Date 12Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - 4.01 packaging.  Only delete empty source files if */
/*                they have been processed.                          */
/*       CPK014 - Release 4 packaging.  Error when moving member     */
/*                that has no records.                               */
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
             DCL        VAR(&PREVFILE) TYPE(*CHAR) LEN(10)                                /*CPK015*/
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YEAR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SPECMBR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SPECMBRTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NOCREATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVFILENAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STARTED) TYPE(*CHAR) LEN(1) VALUE('N')                       /*CPK015*/
 
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3) VALUE(10)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(10) +
                        VALUE('*')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
             DCL        VAR(&TRIM) TYPE(*DEC) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(MOVMBR)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)                                                     /*CPK015*/
 
/* Create message queue for members that aren't moved.                        */
             DLTMSGQ    MSGQ(QTEMP/MOVMBR)
             MONMSG     MSGID(CPF2105)
             CRTMSGQ    MSGQ(QTEMP/MOVMBR) TEXT('Temporary message +
                          queue for MOVMBR utility')
 
/* Break down file and library and date fields. */
             CHGVAR     VAR(&FROMFILE) VALUE(%SST(&FROMFILEQ 1 10))
             CHGVAR     VAR(&FROMLIB) VALUE(%SST(&FROMFILEQ 11 10))
             IF         COND(&DATE *NE '*ALL') THEN(DO)
                CHGVAR     VAR(&DAY) VALUE(%SST(&DATE 1 2))
                CHGVAR     VAR(&MONTH) VALUE(%SST(&DATE 3 2))
                CHGVAR     VAR(&YEAR) VALUE(%SST(&DATE 5 2))
             ENDDO
 
/* Create outfile of file members (physical files only) direct from parameters. */
             DSPFD      FILE(&FROMLIB/&FROMFILE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/MOVMBR)
 
/* Check if member is generic or specific. */
             IF         COND(&FROMMBR *NE '*ALL') THEN(DO)
/* Call QCLSCAN to look for "*"; if it is not found (&RESULT = 0) then a      */
/*  specific member has been requested.  If "*" is found then a generic       */
/*  member name has been requested.                                           */
                CALL       PGM(QCLSCAN) PARM(&FROMMBR &STRLEN &STRPOS +
                             &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                             &RESULT)
                IF         COND(&RESULT *EQ 0) THEN(DO)
                   CHGVAR     VAR(&CPYMBR) VALUE(&FROMMBR)
/* Note: if specific member specified then flag because the following CPYF    */
/*  only works like a wildcard.                                               */
                   CHGVAR     VAR(&SPECMBR) VALUE('Y')
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&CPYMBR) VALUE('          ')
                   CHGVAR     VAR(&RESULT) VALUE(&RESULT - 1)
                   CHGVAR     VAR(&CPYMBR) VALUE(%SST(&FROMMBR 1 &RESULT))
                ENDDO
/* Once the contents of &FROMMBR have been worked out then copy out records   */
/*  that match ...                                                            */
                CPYF       FROMFILE(QTEMP/MOVMBR) +
                             TOFILE(QTEMP/MOVMBR_QT) MBROPT(*REPLACE) +
                             CRTFILE(*YES) INCCHAR(MLNAME 1 *EQ &CPYMBR)
/* ... and then copy them back in. */
                CPYF       FROMFILE(QTEMP/MOVMBR_QT) +
                             TOFILE(QTEMP/MOVMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   SNDMSG     MSG('No members have been moved as none meet +
                                the selection criteria.') TOMSGQ(QTEMP/MOVMBR)
                   CHGVAR     VAR(&MSG) VALUE('Y')
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* If a specific member type has been requested then copy them out ...        */
             IF         COND(&MBRTYPE *NE '*ALL') THEN(DO)
                CPYF       FROMFILE(QTEMP/MOVMBR) +
                             TOFILE(QTEMP/MOVMBR_QT) MBROPT(*REPLACE) +
                             CRTFILE(*YES) INCCHAR(MLSEU2 1 *EQ &MBRTYPE)
/* ... and then copy them back in. */
                CPYF       FROMFILE(QTEMP/MOVMBR_QT) +
                             TOFILE(QTEMP/MOVMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   SNDMSG     MSG('No members have been moved as none meet +
                                the selection criteria.') TOMSGQ(QTEMP/MOVMBR)
                   CHGVAR     VAR(&MSG) VALUE('Y')
                   GOTO       CMDLBL(END)
                ENDDO
/* Note: if specific member type specified then flag because the preceding    */
/*  CPYF only works like a wildcard.                                          */
                CHGVAR     VAR(&SPECMBRTYP) VALUE('Y')
             ENDDO
 
/* If a specific date has been requested then arrange date to compare ....    */
             IF         COND(&DATE *NE '*ALL') THEN(DO)
                CHGVAR     VAR(%SST(&CPYDATE 1 2)) VALUE(&YEAR)
                CHGVAR     VAR(%SST(&CPYDATE 3 2)) VALUE(&MONTH)
                CHGVAR     VAR(%SST(&CPYDATE 5 2)) VALUE(&DAY)
/* ... copy records out ...                                                  */
                CPYF       FROMFILE(QTEMP/MOVMBR) +
                             TOFILE(QTEMP/MOVMBR_QT) MBROPT(*REPLACE) +
                             CRTFILE(*YES) INCCHAR(MLCHGD 1 &DATESEL +
                             &CPYDATE)
/* ... and then copy them back in. */
                CPYF       FROMFILE(QTEMP/MOVMBR_QT) +
                             TOFILE(QTEMP/MOVMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   SNDMSG     MSG('No members have been moved as none meet +
                                the selection criteria.') TOMSGQ(QTEMP/MOVMBR)
                   CHGVAR     VAR(&MSG) VALUE('Y')
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* File MOVMBR should now only consist of records that are required to be     */
/*  moved.                                                                    */
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(DLTF)
             ENDDO
 
             IF         COND(&STARTED *EQ 'N') THEN(DO)                                   /*CPK015*/
                CHGVAR     VAR(&PREVFILE) VALUE(&MLFILE)                                  /*CPK015*/
                CHGVAR     VAR(&STARTED) VALUE('Y')                                       /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
/* Check if the source file matches the previous source file.  If it does not */          /*CPK015*/
/*  then call program to delete previous source file if it has no members     */          /*CPK015*/
/*  left.                                                                     */          /*CPK015*/
             IF         COND(&PREVFILE *NE &MLFILE *AND &LEAVE *EQ +
                          '*NO') THEN(DO)                                                 /*CPK015*/
                CALL       PGM(UTC0371) PARM(&FROMLIB &PREVFILE)                          /*CPK015*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CPK015*/
                   GOTO       CMDLBL(ABNOR)                                               /*CPK015*/
                ENDDO                                                                     /*CPK015*/
                CHGVAR     VAR(&PREVFILE) VALUE(&MLFILE)                                  /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
/* First check that member meets specific selection criteria.                 */
             IF         COND(&SPECMBR *EQ 'Y') THEN(DO)
                IF         COND(&FROMMBR *NE &MLNAME) THEN(DO)
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
             IF         COND(&SPECMBRTYP *EQ 'Y') THEN(DO)
                IF         COND(&MBRTYPE *NE &MLSEU2) THEN(DO)
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
 
/* If a file with no members has been processed then ignore.                  */
             IF         COND(&MLNOMB *EQ 0) THEN(DO)
                GOTO       CMDLBL(READNEXT)
             ENDDO
 
CREATEFILE:
/* Check if file exists only ...it has not been flagged as not existing and   */
/* ... is this the same file as the last read ?                               */
             IF         COND(&MLFILE *EQ &SAVFILENAM) THEN(DO)
/* ... has it already been flagged as not be created?                         */
                IF         COND(&NOCREATE *EQ 'Y') THEN(DO)
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&NOCREATE) VALUE('N')
                CHGVAR     VAR(&SAVFILENAM) VALUE(&MLFILE)
             ENDDO
 
             CHKOBJ     OBJ(&TOLIB/&MLFILE) OBJTYPE(*FILE)
/* If it doesn't and the option to create the file = '*YES' then simply       */
/*  perform copy of member ...                                                */
             MONMSG     MSGID(CPF9801) EXEC(DO)
                IF         COND(&CREATE *EQ '*YES') THEN(DO)
                   CPYF       FROMFILE(&FROMLIB/&MLFILE) +
                                TOFILE(&TOLIB/&MLFILE) FROMMBR(&MLNAME) +
                                TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                CRTFILE(*YES)
                   GOTO       CMDLBL(LEAVE)
                ENDDO
/* ... else flag that file is to be ignored for all of its members.           */
                ELSE       CMD(DO)
                   SNDMSG     MSG('No members for file' *BCAT &MLFILE +
                                *BCAT 'have been moved') TOMSGQ(QTEMP/MOVMBR)
                   CHGVAR     VAR(&NOCREATE) VALUE('Y')
                   CHGVAR     VAR(&MSG) VALUE('Y')
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
 
/* If file did exist then check if member exists.                             */
             CHKOBJ     OBJ(&TOLIB/&MLFILE) OBJTYPE(*FILE) MBR(&MLNAME)
/* If it doesn't and then simply copy member.                                 */
             MONMSG     MSGID(CPF9815) EXEC(DO)
                CPYF       FROMFILE(&FROMLIB/&MLFILE) +
                             TOFILE(&TOLIB/&MLFILE) FROMMBR(&MLNAME) +
                             TOMBR(*FROMMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*CPK014*/
                GOTO       CMDLBL(LEAVE)
             ENDDO
/* If member did exist then check whether member can be replaced.             */
             IF         COND(&REPLACE *EQ '*YES') THEN(DO)
                RMVM       FILE(&TOLIB/&MLFILE) MBR(&MLNAME)
                CPYF       FROMFILE(&FROMLIB/&MLFILE) +
                             TOFILE(&TOLIB/&MLFILE) FROMMBR(&MLNAME) +
                             TOMBR(*FROMMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                 /*CPK014*/
                GOTO       CMDLBL(LEAVE)
             ENDDO
/* If it can not be replaced send message that member was not moved.          */
             ELSE       CMD(DO)
                SNDMSG     MSG('Member' *BCAT &MLNAME *BCAT 'from file' +
                             *BCAT &MLFILE *BCAT 'has not been moved') +
                             TOMSGQ(QTEMP/MOVMBR)
                CHGVAR     VAR(&MSG) VALUE('Y')
                GOTO       CMDLBL(READNEXT)
             ENDDO
 
LEAVE:
/* If from member is not be left then remove it.                              */
             IF         COND(&LEAVE *EQ '*NO') THEN(DO)
                RMVM       FILE(&FROMLIB/&MLFILE) MBR(&MLNAME)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
DLTF:
/* Delete files from 'from' library if they are empty. */
             IF         COND(&LEAVE *EQ '*NO') THEN(DO)
/************   CALL       PGM(UTC0371) PARM(&FROMLIB)                                 */ /*CPK015*/
                CALL       PGM(UTC0371) PARM(&FROMLIB &PREVFILE)                          /*CPK015*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          occurred in MOVMBR.  Check joblog for +
                          details.') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
 
 END:
 /* If any messages have been sent then display them to print.                */
             IF         COND(&MSG *EQ 'Y') THEN(DO)
                DSPMSG     MSGQ(QTEMP/MOVMBR) OUTPUT(*PRINT)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
