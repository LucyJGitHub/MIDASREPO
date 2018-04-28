/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Fetch source from sign off libraries')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0013 - Fetch latest source from sign off libraries       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      077419             Date 14Oct94              */
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes                          */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       077419 - Not all DDS source files being searched            */
/*       S01516 - Incorporation of enhanced FETCH into core          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MBR &MOD &TYPE &WRKMBR &DEVSUPP +
                          &QTOSRCF &TOMBR &OVERWRITE)
/**/
/*  PARAMETERS */
/**/
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WRKMBR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DEVSUPP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTOSRCF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OVERWRITE) TYPE(*CHAR) LEN(4)
/**/
/*  WORK FIELDS */
/**/
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOSRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOSRCFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFDDS) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&TOSRCFDDS) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&FTCHSL) TYPE(*CHAR) LEN(250)
             DCL        VAR(&FETCHLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTR1) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&PTR2) TYPE(*DEC) LEN(3) VALUE(1)
             DCL        VAR(&DDSTYPE) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&DDSTYPES) TYPE(*CHAR) LEN(20) VALUE('DA +
/************             DF DL DM DP DV PR')                         /*077419*/
             DCL        VAR(&DDSTYPES) TYPE(*CHAR) LEN(20) VALUE('DA +
                          DF DT DM DP DV PR')                         /*077419*/
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FETCH) TYPE(*CHAR) LEN(500)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/*  RETRIEVE LIBRARY SEARCH LIST DATA AREA */
/**/
             RTVDTAARA  DTAARA(FETCH) RTNVAR(&FETCH)
/**/
/*  SPLIT UP QUALIFIED NAMES INTO FILE AND LIBRARY */
/**/
             CHGVAR     VAR(&TOSRCF) VALUE(%SST(&QTOSRCF 1 10))
             CHGVAR     VAR(&TOSRCFLIB) VALUE(%SST(&QTOSRCF 11 10))
 
/**/
/*  DETERMINE SOURCE FILE NAME USING */
/*  STANDARD MIDAS NAMING CONVENTIONS */
/**/
             IF         COND(&MOD *EQ ' ') THEN(CHGVAR VAR(&MOD) +
                          VALUE(%SST(&MBR 1 2)))
 
             IF         COND(&TYPE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&TYPE) VALUE(DDS)
             IF         COND(%SST(&MBR 3 1) *EQ 'C' *AND %SST(&MBR 4 +
                          1) *GE '0' *AND %SST(&MBR 4 1) *LE '9') +
                          THEN(CHGVAR VAR(&TYPE) VALUE(CL))
             IF         COND(%SST(&MBR 3 1) *GE '0' *AND %SST(&MBR 3 +
                          1) *LE '9' *AND %SST(&MBR 8 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&TYPE) VALUE(RPG))
             ENDDO
 
/**/
/*      CHANGE '*MBR' TO DERIVED NAME */
/**/
             IF         COND(&TYPE *NE DDS) THEN(DO)
             CHGVAR     VAR(&SRCF) VALUE(&MOD *TCAT &TYPE *TCAT 'SRC')
             IF         COND(&TOSRCF *EQ '*MBR') THEN(CHGVAR +
                          VAR(&TOSRCF) VALUE(&MOD *TCAT &TYPE *TCAT +
                          'SRC'))
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&SRCFDDS) VALUE(Y)
             IF         COND(&TOSRCF *EQ '*MBR') THEN(CHGVAR +
                          VAR(&TOSRCFDDS) VALUE(Y))
             ENDDO
 
/**/
/*  IF TOMBR IS '*MBR' CHANGE IT TO THE VALUE OF THE SOURCE MEMBER */
/**/
             IF         COND(&TOMBR *EQ *MBR) THEN(CHGVAR +
                          VAR(&TOMBR) VALUE(&MBR))
 
/**/
/*     SET UP LIBRARY SEARCH LIST                                    */
/**/
             IF         COND(&DEVSUPP *EQ 'S') THEN(CHGVAR +
                          VAR(&FTCHSL) VALUE(%SST(&FETCH 1 250)))
             IF         COND(&DEVSUPP *EQ 'D') THEN(DO)
             CHGVAR     VAR(&FTCHSL) VALUE(%SST(&FETCH 251 250))
             CHGVAR     VAR(&SRCFLIB) VALUE(%SST(&FETCH 1 10))
             CHKOBJ     OBJ(&SRCFLIB/&SRCF) OBJTYPE(*FILE) MBR(&MBR)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LAB10))
/************SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MBR****+         */ /*BG18886*/
/************             'also exists in'****&SRCF****'in'****+              */ /*BG18886*/
/************             &SRCFLIB) TOPGMQ(*EXT) MSGTYPE(*DIAG)               */ /*BG18886*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MBR *BCAT +
                          'also exists in' *BCAT &SRCF *BCAT 'in' *BCAT +
                          &SRCFLIB) TOPGMQ(*EXT) MSGTYPE(*DIAG)                  /*BG18886*/
             SNDUSRMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Do you +
                          want to use this source instead? Answer Y +
                          or N') MSGTYPE(*INQ) MSGRPY(&REPLY)
/************IF         COND(&REPLY *EQ 'Y'***&REPLY = 'y') +                 */ /*BG18886*/
             IF         COND(&REPLY *EQ 'Y' *OR &REPLY = 'y') +
                          THEN(CHGVAR VAR(&FTCHSL) +
                          VALUE(%SST(&FETCH 1 250)))                             /*BG18886*/
             ENDDO
LAB10:
             IF         COND(&PTR1 *EQ 251) THEN(GOTO CMDLBL(NOTFOUND))
             CHGVAR     VAR(&FETCHLIB) VALUE(%SST(&FTCHSL &PTR1 10))
             IF         COND(&FETCHLIB *EQ ' ') THEN(GOTO +
                          CMDLBL(NOTFOUND))
             CHGVAR     VAR(&PTR1) VALUE(&PTR1 + 10)
 
             IF         COND(&SRCFDDS *EQ N) THEN(DO)
 
             CHKOBJ     OBJ(&FETCHLIB/&SRCF) OBJTYPE(*FILE) MBR(&MBR)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(GOTO CMDLBL(LAB10))
 
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&SRCF) VALUE(&MOD *TCAT 'DDSSRC')
             CHGVAR     VAR(&PTR2) VALUE(-2)
LAB20:
             CHKOBJ     OBJ(&FETCHLIB/&SRCF) OBJTYPE(*FILE) MBR(&MBR)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CHGVAR     VAR(&PTR2) VALUE(&PTR2 + 3)
             IF         COND(&PTR2 *GT 20) THEN(GOTO CMDLBL(LAB10))
             CHGVAR     VAR(&DDSTYPE) VALUE(%SST(&DDSTYPES &PTR2 2))
             IF         COND(&DDSTYPE *EQ ' ') THEN(GOTO CMDLBL(LAB10))
             CHGVAR     VAR(&SRCF) VALUE(&MOD *TCAT 'DDSSRC' *TCAT +
                          &DDSTYPE)
             GOTO       CMDLBL(LAB20)
             ENDDO
 
             ENDDO
 
             CHGVAR     VAR(&SRCFLIB) VALUE(&FETCHLIB)
 
/**/
/*  IF WORK WITH MEMBER HAS BEEN SPECIFIED */
/**/
             IF         COND(&WRKMBR *EQ *YES) THEN(DO)
 
             IF         COND(&TOSRCFDDS *EQ Y) THEN(CHGVAR +
                          VAR(&TOSRCF) VALUE(&SRCF))
/**/
/*  CHECK SOURCE MEMBER ISN'T ALREADY IN TO-SOURCE FILE */
/**/
             IF         COND(&OVERWRITE *EQ *NO) THEN(DO)
             CHKOBJ     OBJ(&TOSRCFLIB/&TOSRCF) OBJTYPE(*FILE) +
                          MBR(&TOMBR)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LAB50))
             RTVMBRD    FILE(&TOSRCFLIB/&TOSRCF) MBR(&TOMBR) +
                          TEXT(&TEXT)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Copy-to-member' *BCAT &TOMBR +
                          *BCAT 'already exists in' *BCAT +
                          &TOSRCFLIB *TCAT '/' *TCAT &TOSRCF) +
                          MSGTYPE(*ESCAPE)
LAB50:
             ENDDO
/**/
/*  CREATE SOURCE FILE IF IT DOESN'T ALREADY EXIST */
/**/
             CHKOBJ     OBJ(&TOSRCFLIB/&TOSRCF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTSRCPF   FILE(&TOSRCFLIB/&TOSRCF) TEXT('Work source +
                          file')
             ENDDO
/**/
/*  COPY SOURCE MEMBER TO WORK LIBRARY */
/**/
             CPYSRCF    FROMFILE(&SRCFLIB/&SRCF) +
                          TOFILE(&TOSRCFLIB/&TOSRCF) FROMMBR(&MBR) +
                          TOMBR(&TOMBR)
/**/
/*  IF SPECIFIED, WORK WITH MEMBER */
/**/
             WRKMBRPDM  FILE(&TOSRCFLIB/&TOSRCF) MBR(&TOMBR)
             ENDDO
 
/**/
/*  OTHERWISE BROWSE MEMBER */
/**/
             IF         COND(&WRKMBR = *NO) THEN(DO)
             STRSEU     SRCFILE(&SRCFLIB/&SRCF) SRCMBR(&MBR) OPTION(5)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
NOTFOUND:
             IF         COND(&SRCFDDS *EQ Y) THEN(CHGVAR VAR(&SRCF) +
                          VALUE(&MOD *TCAT 'DDSSRC*'))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Member' +
                          *BCAT &MBR *BCAT 'not found in libraries +
                          searched') MSGTYPE(*ESCAPE)
ERROR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
