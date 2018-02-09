/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for GENPAGNUM command')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities module                                      */
/*                                                                   */
/*       UTC0270 - CPP for GENPAGNUM (Generate page numbers) command */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XNNNNN             Date DDMmmYY              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILELIB &RELEASE &PTF)
 
/***COPY*UTCPYSRC,UTC0270INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0270INT                                          */                   /*CPK024*/
 
/*--- Parameters ----------------------------------------------------*/
             DCL        VAR(&FILELIB) TYPE(*CHAR) LEN(20) /* File +
                          and library */
             DCL        VAR(&RELEASE) TYPE(*CHAR) LEN(4) /* Release */
             DCL        VAR(&PTF) TYPE(*CHAR) LEN(2) /* PTF */
 
/*--- Parameters broken down ----------------------------------------*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) /* File */
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) /* Library */
 
/*--- Parameters for APIs -------------------------------------------*/
             DCL        VAR(&GENHDR) TYPE(*CHAR) LEN(140) /* Generic +
                          header data */
             DCL        VAR(&MBRCNT) TYPE(*DEC) LEN(8 0) /* Number +
                          of members */
             DCL        VAR(&MBRCNTB) TYPE(*CHAR) LEN(4) /* Number +
                          of members in binary (4) format */
             DCL        VAR(&ENTLENB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBRENT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&OFFSETB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&STRPOSB) TYPE(*CHAR) LEN(4)
 
/*--- Others --------------------------------------------------------*/
 
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10) /* Member +
                          name */
             DCL        VAR(&TOTALPAGE) TYPE(*DEC) LEN(8 0) /* Total +
                          number of pages */
             DCL        VAR(&PAGE) TYPE(*DEC) LEN(8 0) /* Page +
                          number */
             DCL        VAR(&TOTALPAGEA) TYPE(*CHAR) LEN(22) /* +
                          Total number of pages, alpha format for +
                          passing to RPG. */
             DCL        VAR(&PAGEA) TYPE(*CHAR) LEN(22) /* Page +
                          number, alpha format for passing to RPG. */
 
/*--- Job type ------------------------------------------------------*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*--- Fields for error handling -------------------------------------*/
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(10) /* Return +
                          code */
             DCL        VAR(&ERRID) TYPE(*CHAR) LEN(7) /* Error +
                          message ID. */
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(2000) /* Error +
                          message data. */
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*UTCPYSRC,UTC0270MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0270MPS                                          */                   /*CPK024*/
 
/*--- Start of main processing --------------------------------------*/
 
/** Separate file and library. */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FILELIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FILELIB 11 10))
 
/** Obtain the number of members in the file; this will equal the +
    total number of pages.  First create a user space, deleting it +
    first if it is there. */
             CRTUSRSPC  USRSPC(QTEMP/GENPAGNUM) DELETE(*YES)
 
/** Next call the member list API to put the member list information +
    into the user space.  The parameters are:                    +
    (1) user space and library                                   +
    (2) format to return                                         +
    (3) file and library to process                              +
    (4) member(s) to process                                     +
    (5) whether or not to process overrides (0=no, 1=yes)        +
*/
             CALL       PGM(QUSLMBR) PARM('GENPAGNUM QTEMP     ' +
                          'MBRL0100' &FILELIB '*ALL      ' '0')
 
/** Next call the retreive user space API to get the generic     +
    header information.                                          +
*/
             CALL       PGM(QUSRTVUS) PARM('GENPAGNUM QTEMP     ' +
                          X'00000001' X'0000008C' &GENHDR)
 
/** The number of list entries is held as a binary value in postions +
    133-136 of the generic header.                                   +
*/
             CHGVAR     VAR(&MBRCNTB) VALUE(%SST(&GENHDR 133 4))
             CHGVAR     VAR(&MBRCNT) VALUE(%BIN(&MBRCNTB))
 
/** Store the number of members as the total number of pages,       +
    and edit it into a 3A format for passing to the RPG.            +
*/
             CHGVAR     VAR(&TOTALPAGE) VALUE(&MBRCNT)
             EDTVAR     CHROUT(&TOTALPAGEA) NUMINP(&TOTALPAGE) +
                          EDTCDE(Z)
 
/** The size of each entry is held as a binary value in postions +
    137-140 of the generic header.                                   +
*/
             CHGVAR     VAR(&ENTLENB) VALUE(%SST(&GENHDR 137 4))
 
/** The 'offset to the list data section' is contained in binary     +
    form in positions 125-128 of the generic header; adding one to   +
    this value gives us the actual start position of the list data   +
    section; ie the list of members.                                 +
*/
             CHGVAR     VAR(&OFFSETB) VALUE(%SST(&GENHDR 125 4))
             CHGVAR     VAR(%BIN(&STRPOSB)) VALUE(%BIN(&OFFSETB) + 1)
 
LOOP:
             IF         COND(&MBRCNT = 0) THEN(GOTO END)
             CALL       PGM(QUSRTVUS) PARM('GENPAGNUM QTEMP     ' +
                          &STRPOSB &ENTLENB &MEMBER)
 
/** Incremement the page number, and edit it into a 3A format       +
    for passing to the RPG.  +
*/
             CHGVAR     VAR(&PAGE) VALUE(&PAGE +1)
             EDTVAR     CHROUT(&PAGEA) NUMINP(&PAGE) +
                          EDTCDE(Z)
 
/** Call the RPG which processes the selected member. */
             OVRDBF     FILE(SPOOLS) TOFILE(&LIB/&FILE) MBR(&MEMBER) +
                          LVLCHK(*NO)
             CALL       PGM(UT0270) PARM(&RETCODE &RELEASE &PTF +
                          &PAGEA &TOTALPAGEA)
 
/** If return code is nonblank, perform error processing. */
             IF         COND(&RETCODE *NE ' ') THEN(GOTO CMDLBL(ABNOR))
 
/** Calculate next starting position in user space and reduce number +
    of entries. */
             CHGVAR     VAR(%BIN(&STRPOSB)) VALUE(%BIN(&STRPOSB) + +
                          %BIN(&ENTLENB))
             CHGVAR     VAR(&MBRCNT) VALUE(&MBRCNT - 1)
             GOTO       CMDLBL(LOOP)
 
/***COPY*UTCPYSRC,UTC0270MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0270MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
/*--- End of main processing ----------------------------------------*/
 
ABNOR:
/***COPY*UTCPYSRC,UTC0270ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0270ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/** Receive all previous diagnostic messages and send them to the   **/
/** caller:                                                         **/
             RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSGDTA(&ERRDTA) +
                          MSGID(&ERRID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             IF         COND(&ERRID *NE ' ') THEN(DO)
                SNDPGMMSG  MSGID(&ERRID) MSGF(QCPFMSG) MSGDTA(&ERRDTA) +
                             MSGTYPE(*DIAG)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** Receive escape message and send it to the caller:               **/
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&ERRDTA) +
                          MSGID(&ERRID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&ERRID) MSGF(QCPFMSG) MSGDTA(&ERRDTA) +
                          MSGTYPE(*DIAG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ESC:         SNDPGMMSG  MSGID(CPF0001) MSGF(QSYS/QCPFMSG) +
                          MSGDTA(GENPAGNUM) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/***COPY*UTCPYSRC,UTC0270END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,UTC0270END                                          */                   /*CPK024*/
 
/* (Add any specific end processing here) */
 
             ENDPGM
