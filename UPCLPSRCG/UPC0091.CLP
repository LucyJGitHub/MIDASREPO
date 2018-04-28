/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP CRTDLVLST validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UTC0091 - CRTDLVLST Validity Checker                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK020             Date 28Jul04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     Date 29Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK020 - Handle deliverable data.                           */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRC &DLVLIB &DFTLIB &CRTOPT &PROJECT)
 
/* Command parameters */
             DCL        VAR(&SRC) TYPE(*CHAR) LEN(202)
             DCL        VAR(&DLVLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&DFTLIB) TYPE(*CHAR) LEN(8)                                */ /*CPK020*/
             DCL        VAR(&DFTLIB) TYPE(*CHAR) LEN(10)                                  /*CPK020*/
             DCL        VAR(&CRTOPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PROJECT) TYPE(*CHAR) LEN(10)
 
/* Work variables */
             DCL        VAR(&COUNT1) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(508)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&NBRSRC) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&NBRSRCB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OBJENT) TYPE(*CHAR) LEN(108)
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SRC1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&START1) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&START2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
 
/* Work variables - generic user space variables */
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                          VALUE('DLVLSTVC  QTEMP     ')
             DCL        VAR(&ATTRIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(10) VALUE('*ALL')
             DCL        VAR(&GENHDR) TYPE(*CHAR) LEN(140)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ENTCNT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&ENTCNTB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ENTLENB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OFFSETB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&STRPOSB) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERRCDE) TYPE(*DEC) LEN(4 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* If *NONE is specified then skip source file processing */
             CHGVAR     VAR(&SRC1) VALUE(%SST(&SRC 3 10))
             IF         COND(&SRC1 *EQ '*NONE') THEN(GOTO +
                          CMDLBL(DLVLIB))
 
/* Retrieve number of source files from list variable */
             CHGVAR     VAR(&NBRSRCB) VALUE(%SST(&SRC 1 2))
             CHGVAR     VAR(&NBRSRC) VALUE(%BIN(&NBRSRCB))
             CHGVAR     VAR(&START1) VALUE(3)
 
SRCLOOP:
             CHGVAR     VAR(&COUNT1) VALUE(&COUNT1 + 1)
             IF         COND(&COUNT1 *LE &NBRSRC) THEN(DO)
               CHGVAR     VAR(&START2) VALUE(&START1 + 10)
               CHGVAR     VAR(&SRCF) VALUE(%SST(&SRC &START1 10))
               CHGVAR     VAR(&SRCLIB) VALUE(%SST(&SRC &START2 10))
               CHGVAR     VAR(&SRCFLIB) VALUE(&SRCF *CAT &SRCLIB)
 
/* Scan SRCF for '*' in case of generic*  or *ALL */
               CALL       PGM(QCLSCAN) PARM(&SRCF &STRLEN &STRPOS +
                            '*' &PATLEN '0' '0' '' &RESULT)
 
/* Create user space to contain list of source files */
             IF         COND(&RESULT *GT 0) THEN(DO)
               CALL QUSCRTUS                                      +
                    (&USRSPC                                      +
                     &ATTRIB                                      +
                     X'00000400'                                  +
                     ' '                                          +
                     &AUTH                                        +
                     'Source File List User Space')
             MONMSG     MSGID(CPF9870) EXEC(RCVMSG MSGTYPE(*LAST))
 
/* Generate source file list */
               CALL QUSLOBJ                                       +
                    (&USRSPC                                      +
                     'OBJL0200'                                   +
                     &SRCFLIB                                     +
                     '*FILE'                                      +
                     &ERRCDE)
               MONMSG     MSGID(CPF0000)
 
/* Read generic header from user space */
             CALL       PGM(QUSRTVUS) PARM(&USRSPC X'00000001' +
                          X'0000008C' &GENHDR)
             MONMSG     MSGID(CPF0000)
 
/* Retrieve number of list entries        */
/* Retrieve list entry length and offset. */
/* Calculate starting position.           */
             CHGVAR     VAR(&ENTCNTB) VALUE(%SST(&GENHDR 133 4))
             CHGVAR     VAR(&ENTCNT) VALUE(%BIN(&ENTCNTB))
             CHGVAR     VAR(&ENTLENB) VALUE(%SST(&GENHDR 137 4))
             CHGVAR     VAR(&OFFSETB) VALUE(%SST(&GENHDR 125 4))
             CHGVAR     VAR(%BIN(&STRPOSB)) VALUE(%BIN(&OFFSETB) + 1)
 
/* Read through list */
 LISTLOOP:
             CHGVAR     &COUNT (&COUNT + 1)
             IF         (&COUNT *LE &ENTCNT) DO
               CALL       PGM(QUSRTVUS) PARM(&USRSPC &STRPOSB +
                            &ENTLENB &OBJENT)
               CHGVAR     VAR(&SRCF) VALUE(%SST(&OBJENT 1 10))
               CHGVAR     VAR(&SRCLIB) VALUE(%SST(&OBJENT 11 10))
               CHGVAR     VAR(&OBJATR) VALUE(%SST(&OBJENT 32 10))
 
               IF         COND(&OBJATR *EQ 'PF') THEN(DO)
                 CHKOBJ     OBJ(&SRCLIB/&SRCF) OBJTYPE(*FILE) +
                              AUT(*USE)
                 MONMSG     MSGID(CPF0000) EXEC(DO)
                   RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
                      CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                   MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                      CHGVAR     VAR(&ERROR) VALUE('Y')
                 ENDDO
               ENDDO
 
/* Read next entry from user space */
               CHGVAR     VAR(%BIN(&STRPOSB)) +
                            VALUE(%BIN(&STRPOSB) + %BIN(&ENTLENB))
               GOTO       CMDLBL(LISTLOOP)
             ENDDO
             ENDDO
 
/* Check for individual source files */
             ELSE       CMD(DO)
               CHKOBJ     OBJ(&SRCLIB/&SRCF) OBJTYPE(*FILE) +
                            AUT(*USE)
               MONMSG     MSGID(CPF0000) EXEC(DO)
                 RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
                    CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)
                    SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                 MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                    CHGVAR     VAR(&ERROR) VALUE('Y')
               ENDDO
             ENDDO
 
               CHGVAR     VAR(&START1) VALUE(&START1 + 20)
               GOTO       CMDLBL(SRCLOOP)
             ENDDO
 
/* Check for delivery library */
DLVLIB:
             CHKOBJ     OBJ(&DLVLIB) OBJTYPE(*LIB) AUT(*CHANGE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
                CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
 
/* Check for deliverable data library. */                                                 /*CPK020*/
DLVDTA:                                                                                   /*CPK020*/
             IF         COND(&DFTLIB *NE '*NONE') THEN(DO)                                /*CPK020*/
                CHKOBJ     OBJ(&DFTLIB) OBJTYPE(*LIB) AUT(*USE)                           /*CPK020*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                        /*CPK020*/
                   RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)                           /*CPK020*/
                   CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)                        /*CPK020*/
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA(&MSGDTA) MSGTYPE(*DIAG)                            /*CPK020*/
                   CHGVAR     VAR(&ERROR) VALUE('Y')                                      /*CPK020*/
                ENDDO                                                                     /*CPK020*/
             ENDDO                                                                        /*CPK020*/
 
/* Send message to pass earlier messages back */
ERRORS:
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
/* Normal end of program */
             RETURN
 
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
