/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AO CL to check for record locking')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Access Objects Module                               */
/*                                                                   */
/*       AOC8000 - CHECK FOR RECORD LOCKING                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6931            Date 04May05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      188755            Date 19Jul01               */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CFT003            Date 20NOV98               */
/*                      S01408            DATE 04MAY95               */
/*                      051131            DATE 22FEB93               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6931 - Incorrect use of error code 600.                  */
/*       CPK015 - 4.01 packaging.  Use DPLIB and not DILIB.          */
/*       188755 - Don't dump if data area not present                */
/*       CFT003 - FT Batch Authorisation                             */
/*       S01408 - Addition Of Core Hook AOC8000MP1                   */
/*                Addition Of Core Hook AOC8000MP2                   */
/*       051131 - Correct analysis of OP type, add RP type and       */
/*                add DMPCLPGM for error processing.                 */
/*                                                                   */
/*       CREATED FOR E42167 - CL PROGRAM FOR RECORD LOCKING          */
/*       XXXXXX - DESCRIPTION                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&RTNCDE &MODULE &TRNREF &RINFOR)
/**/
/*           Copyright statement definition                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)
             DCL        VAR(&RDATA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DQUEUE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(30)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&DTANAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,AOH00018                                            */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/*       Retrieve the job number      */
/* */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNUM)
/* */
/*       Check that data queue exists                                */
/* */
             CHGVAR     VAR(&DQUEUE) VALUE('Q' *CAT &JOBNUM)
 
             CHKOBJ     OBJ(QTEMP/&DQUEUE) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAQ    DTAQ(QTEMP/&DQUEUE) MAXLEN(256) TEXT('Data +
                          queue for Transaction Allocation')
             ENDDO
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DPLIB')                         /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AOC8000MP1                                          */
                                                                      /*S01408*/
/* */
/*       Read dataqueue until empty                                  */
/* */
 READ:       CALL       PGM(QRCVDTAQ) PARM(&DQUEUE 'QTEMP' &FLDLEN +
                          &DATA &WAIT)
/* */
             IF         COND(&FLDLEN *GT 0) THEN(DO)
/* */
/* Deallocate dataareas */
/* */
             CHGVAR     VAR(&DTANAME) VALUE(%SST(&DATA 1 10))
             CHGVAR     VAR(&DTALIB) VALUE(%SST(&DATA 11 10))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AOC8000MP2                                          */
                                                                      /*S01408*/
             DLCOBJ     OBJ((&DTALIB/&DTANAME *DTAARA *SHRRD))
             DLCOBJ     OBJ((&DTALIB/&DTANAME *DTAARA *EXCL))
             GOTO       CMDLBL(READ)
             ENDDO
/* */
/*       Check that transaction reference is n't blank               */
/* */
             IF         COND(&TRNREF *EQ '               ') +
                          THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&RTNCDE) VALUE('*IN USE')
 /* */
/*       Format name of dataarea funds transfer                      */
/* */
/*/COPY WNCPYSRC,AOH00019                                            */
             IF         COND(&MODULE *EQ 'FT') THEN(DO)
/*           IF         COND(%SST(&TRNREF 12 2) *EQ 'OT') THEN(DO)     *051131*/
             IF         COND(%SST(&TRNREF 12 2) *EQ 'OP') THEN(DO)
/*/COPY WNCPYSRC,AOH00020                                            */
             CHGVAR     VAR(&DTANAME) VALUE('O' *CAT %SST(&TRNREF 3 9))
/*/COPY WNCPYSRC,AOH00021                                            */
             ENDDO
                                                                      /*051131*/
             IF         COND(%SST(&TRNREF 12 2) *EQ 'RP') THEN(DO)    /*051131*/
             CHGVAR   VAR(&DTANAME) VALUE('R' *CAT %SST(&TRNREF 3 9)) /*051131*/
             ENDDO                                                    /*051131*/
             IF         COND(%SST(&TRNREF 12 2) *EQ 'IN') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('I' *CAT %SST(&TRNREF 3 9))
             ENDDO
             IF         COND(%SST(&TRNREF 12 2) *EQ 'CP') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('P' *CAT %SST(&TRNREF 3 9))
             ENDDO
             IF         COND(%SST(&TRNREF 12 2) *EQ 'CC') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('C' *CAT %SST(&TRNREF 3 9))
             ENDDO
             IF         COND(%SST(&TRNREF 12 2) *EQ 'NT') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('T' *CAT %SST(&TRNREF 3 9))
             ENDDO
             ENDDO
/* */
/*       Format name of dataarea for dealing                         */
/* */
             IF         COND(&MODULE *EQ 'DL') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('D' *CAT %SST(&TRNREF 1 6))
             ENDDO
/* */
/*       Format name of dataarea for lending                         */
/* */
             IF         COND(&MODULE *EQ 'LE') THEN(DO)
             CHGVAR     VAR(&DTANAME) VALUE('L' *CAT %SST(&TRNREF 1 6))
             ENDDO
/* */
/*       Check that data area exists                                 */
/* */
             CHKOBJ     OBJ(&DILIB/&DTANAME) OBJTYPE(*DTAARA)
/**********  MONMSG     MSGID(CPF0001) EXEC(GOTO END) */                      /*188755*/ /*BUG6931*/
             MONMSG     MSGID(CPF0001) EXEC(DO)                                          /*BUG6931*/
               CHGVAR      VAR(&RTNCDE) VALUE('       ')                                 /*BUG6931*/
               GOTO        CMDLBL(END)                                                   /*BUG6931*/
             ENDDO                                                                       /*BUG6931*/
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(&DILIB/&DTANAME) TYPE(*CHAR) LEN(512) +
                          VALUE(&TRNREF) TEXT('Allocation +
                          dataarea') AUT(*ALL)
             ENDDO
/* */
/*       Allocate dataarea                                           */
/* */
             ALCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)
             RTVDTAARA  DTAARA(&DILIB/&DTANAME (1 80)) RTNVAR(&RDATA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&RDATA) VALUE(' ')
             ENDDO
             CHGVAR     VAR(&RINFOR) VALUE(%SST(&RDATA 20 10) *TCAT +
                          '/' *TCAT %SST(&RDATA 30 10) *TCAT '/' +
                          *TCAT %SST(&RDATA 40 6))
             CHGVAR     VAR(&RTNCDE) VALUE('*IN USE')
             GOTO       CMDLBL(END)
             ENDDO
                                                                                          /*CFT003*/
/*       Check not reserved by Batch Authorisation                   */                   /*CFT003*/
                                                                                          /*CFT003*/
             CALL       PGM(FT0810) PARM(&TRNREF &RTNCDE &RDATA)                          /*CFT003*/
                                                                                          /*CFT003*/
             IF         COND(&RTNCDE *NE '       ') THEN(DO)                              /*CFT003*/
                CHGVAR     VAR(&RINFOR) VALUE(&RDATA)                                     /*CFT003*/
                GOTO       CMDLBL(END)                                                    /*CFT003*/
             ENDDO                                                                        /*CFT003*/
                                                                                          /*CFT003*/
/* */
/*       Send data queue entry                                       */
/* */
             CHGVAR     VAR(&DATA) VALUE(&DTANAME *CAT &DILIB)
             CHGVAR     VAR(&FLDLEN) VALUE(30)
             CALL       PGM(QSNDDTAQ) PARM(&DQUEUE 'QTEMP' &FLDLEN +
                          &DATA)
/* */
/*       Place job information in dataarea                           */
/* */
             CHGDTAARA  DTAARA(&DILIB/&DTANAME (20 26)) VALUE(&JOB +
                          *CAT &USER *CAT &JOBNUM)
/* */
/*       Allocate to *SHRRD state                                    */
/* */
             ALCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *SHRRD)) WAIT(5)
             DLCOBJ     OBJ((&DILIB/&DTANAME *DTAARA *EXCL))
/* */
/*       Blank return code and exit                                  */
/* */
             CHGVAR     VAR(&RTNCDE) VALUE('       ')
             GOTO       CMDLBL(END)
/* */
 ABNOR:      SNDPGMMSG  MSG('AOC8000 - Ended Abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR*')
             DMPCLPGM                                                 /*051131*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*051131*/
/* */
 END:
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
