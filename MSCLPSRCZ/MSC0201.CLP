/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS BSC/2780 Msg. compression/transmission')     */
/********************************************************************/
/*                                                                  */
/*     Midas Midas/S.W.I.F.T. DIRECT LINK                           */
/*                                                                  */
/*     MSC0201 - COMMUNICATIONS/COMPRESSION PROGRAM                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CSW101             Date 06Feb23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      120202             Date 11Jun97              */
/*                      CSW001             Date 20Mar95              */
/*                   S01310            DATE 20SEP91                 */
/*                   S01259            DATE 13/12/90                */
/*                   S01117            DATE 25JAN90                 */
/*                   S01192            DATE 30/01/89                */
/*                                                                  */
/********************************************************************/
/*       CSW101 - PAYPlus Interface                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     120202 - AOMGMER0 parameters have changed                     */
/*     CSW001 - SWIFT ALLIANCE Batch Transmission                    */
/*              execute program MSC3001 (if TCPF) and go to          */
/*              end of this program.                                 */
/*     S01310 - SWIFT RATIONALISATION                               */
/*     S01259 - If SWIFT II on call MS0206 else call MS0201         */
/*     S01117 - MULTIBRANCHING CHANGES                              */
/*     S01192 - NEW PROGRAM FOR 2780 LINK                           */
/********************************************************************/
/*/COPY WNCPYSRC,MSC0201001                                          */
             PGM
/*/COPY WNCPYSRC,MSC0201002                                          */

/* ** Programmer note **                                              /*CSW001*/
/*    Any changes to this program may also need to applied to MSC3001 /*CSW001*/

/* Declare variables :                                          */

/************DCL        VAR(&MEM)    TYPE(*CHAR) LEN(44)              /*S01117*/
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)              /*S01117*/
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACCOPT) TYPE(*CHAR) LEN(7)
/************DCL        VAR(&MSDLICD) TYPE(*CHAR) LEN(26)      */     /*S01310*/
/************DCL        VAR(&MSMGME) TYPE(*CHAR) LEN(26)   /*S01310*/ /*120202*/
             DCL        VAR(&MSMGME) TYPE(*CHAR) LEN(800)             /*120202*/
             DCL        VAR(&PROTOCOL) TYPE(*CHAR) LEN(4)
/************DCL        VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7) VALUE('       ') /*CSW001*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CSW001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSW001*/
             DCL        VAR(&CSW001) TYPE(*CHAR) LEN(1)               /*CSW001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CSW001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MSC0201015                                          */
                                                                                          /*CSW101*/
             DCL        VAR(&SBS)    TYPE(*CHAR) LEN(2)                                   /*CSW101*/
             DCL        VAR(&COMLIB) TYPE(*CHAR) LEN(10)                                  /*CSW101*/
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)                                  /*CSW101*/
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(7)                                   /*CSW101*/
             DCL        VAR(&SEQD)   TYPE(*CHAR) LEN(2)                                   /*CSW101*/
             DCL        VAR(&SEQ)    TYPE(*DEC)  LEN(2 0)                                 /*CSW101*/
             DCL        VAR(&MIDA)   TYPE(*CHAR) LEN(8)                                   /*CSW101*/
             DCL        VAR(&MIDSAV) TYPE(*CHAR) LEN(10)                                  /*CSW101*/
             DCL        VAR(&FMT)    TYPE(*CHAR) LEN(118)                                 /*CSW101*/
             DCL        VAR(&CSW101) TYPE(*CHAR) LEN(1)                                   /*CSW101*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSW101*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CSW101*/
                                                                                          /*CSW101*/
             DCLF       FILE(MS2780DF)
/*/COPY WNCPYSRC,MSC0201012                                          */

/* Global message monitor :                                     */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABEND))

/* Set off all Job switches :                                   */

             CHGJOB     SWS(00000000)

/**Determine*if*S.W.I.F.T. II is on                             /*S01259S01310*/
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/

/* Call access object for swift direct link ICD to check protocol */

             CHGVAR     VAR(&RTNCODE) VALUE('*MSG   ')
             CHGVAR     VAR(&ACCOPT) VALUE('*FIRST ')

/************CALL    PGM(AOMSDLR0) PARM(&RTNCODE &ACCOPT &MSDLICD)*/ /*S01310*/
             CALL    PGM(AOMGMER0) PARM(&RTNCODE &ACCOPT &MSMGME)    /*S01310*/

/* This option only valid for 2780 link                         */

/************CHGVAR     VAR(&PROTOCOL) VALUE(%SST(&MSDLICD 23 4)) */ /*S01310*/
             CHGVAR     VAR(&PROTOCOL) VALUE(%SST(&MSMGME 17 4))     /*S01310*/
/* CSW001    IF         COND(&PROTOCOL *NE '2780') THEN(DO)           /*CSW001*/
/* *****        SNDPGMMSG  MSG('This Option only valid with the 2780 +/*CSW001*/
/* *****                  Communications Protocol') TOPGMQ(*EXT) +    /*CSW001*/
/* *****                  TOMSGQ(MOPERQ)                              /*CSW001*/
/* *****          GOTO       CMDLBL(END)                              /*CSW001*/
/* *****     ENDDO                                                    /*CSW001*/
                                                                      /*CSW001*/
/* If SWIFT Alliance Batch Interface in system, chk for TCPF protocol /*CSW001*/
             CHGVAR     VAR(&SARD) VALUE('CSW001')                    /*CSW001*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CSW001*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CSW001*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CSW001*/
                  CHGVAR     VAR(&CSW001) VALUE('Y')                  /*CSW001*/
                                                                      /*CSW001*/
/* If TCPF protocol then call MSC3001 and go to end                   /*CSW001*/
             IF         COND(&PROTOCOL *EQ 'TCPF') THEN(DO)           /*CSW001*/
/*/COPY WNCPYSRC,MSC0201003                                          */
             CALL       PGM(MSC3001)                                  /*CSW001*/
/*/COPY WNCPYSRC,MSC0201004                                          */
             GOTO       END2                                          /*CSW001*/
             ENDDO                                                    /*CSW001*/
             ENDDO                                                    /*CSW001*/
/*/COPY WNCPYSRC,MSC0201013                                          */
                                                                      /*CSW001*/
/* If not TCPF or 2780 protocol snd usr msg                           /*CSW001*/
             IF         COND(&PROTOCOL *EQ '2780') THEN(GOTO EXEC)    /*CSW001*/

             SNDPGMMSG  MSG('This Option only valid with the 2780 or +
                          TCP/IP FTP Communications Protocol') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CSW001*/
             GOTO       CMDLBL(END)                                   /*CSW001*/

/* Send notification of Compression startup :                   */
EXEC:                                                                 /*CSW001*/
             SNDPGMMSG  MSG('SWIFT Compression program starting') +
                          TOMSGQ(MRUNQ)

/* Allocate Dataarea to limit calls to ST200                    */

             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                  SNDPGMMSG  MSG('SWIFT Send/Receive program already +
                          active') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(END)
             ENDDO

/* Display screen message for transmission active               */

             CHGVAR     VAR(&TEXT) VALUE('Midas/S.W.I.F.T. Message +
                          Output is in Progress')
/*           SNDRCVF    WAIT(*NO)                                     /*CSW001*/
             SNDRCVF    RCDFMT(MS2780S) WAIT(*NO)                     /*CSW001*/
/*/COPY WNCPYSRC,MSC0201014                                          */

/* Call S.W.I.F.T. Message Compression program :                */

             CLRPFM     FILE(MS2780O)

/****If*SWIFT*II*on*call MS0206                                 /*S01259S01310*/
/************IF*COND(&SWII *EQ 'Y') THEN(DO)                    /*S01259S01310*/
/************CALL*******PGM(MS0206)                             /*S01259S01310*/
/************ENDDO******                                        /*S01259S01310*/
/***********************                                        /*S01259S01310*/
/****If*SWIFT*II*not*on*call MS0201                             /*S01259S01310*/
/************IF*COND(&SWII *NE 'Y') THEN(DO)                    /*S01259S01310*/
/************CALL*******PGM(MS0201)                                   /*S01310*/
/************ENDDO******                                        /*S01259S01310*/
                                                                      /*S01310*/
/*/COPY WNCPYSRC,MSC0201005                                          */
                                                                                          /*CSW101*/
             CHGVAR     VAR(&RTN)  VALUE('       ')                                       /*CSW101*/
             CHGVAR     VAR(&OPN)  VALUE('*VERIFY')                                       /*CSW101*/
             CHGVAR     VAR(&SARD) VALUE('CSW101')                                        /*CSW101*/
                                                                                          /*CSW101*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CSW101*/
                                                                                          /*CSW101*/
             IF         COND(&RTN  *EQ '       ') THEN(DO)                                /*CSW101*/

/* Access SDBANKPD to get run date for Outgoing copy file       */                        /*CSW101*/
                                                                                          /*CSW101*/
             CHGVAR     VAR(&RTN)  VALUE('       ')                                       /*CSW101*/
             CHGVAR     VAR(&OPN)  VALUE('*VERIFY')                                       /*CSW101*/
                                                                                          /*CSW101*/
             CALL       PGM(AOBANKR0) PARM(&RTN  &OPN  &FMT)                              /*CSW101*/
                                                                                          /*CSW101*/
             IF         COND(&RTN  *EQ '       ') THEN(CHGVAR +
                          VAR(&DATE) VALUE(%SST(&FMT 43 7)))                              /*CSW101*/
                                                                                          /*CSW101*/
/* Setup and Check for external communication library if exists */                        /*CSW101*/
                                                                                          /*CSW101*/
             RTVDTAARA  DTAARA(MSSTAT (255 2)) RTNVAR(&SBS)                               /*CSW101*/
             CHGVAR     VAR(&COMLIB) VALUE(&SBS *CAT 'COMLIB')                            /*CSW101*/
             CHGVAR     VAR(&DMLIB)  VALUE(&SBS *CAT 'DMLIB')                             /*CSW101*/
                                                                                          /*CSW101*/
             CHKOBJ     OBJ(QSYS/&COMLIB) OBJTYPE(*LIB)                                   /*CSW101*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CSW101*/
             CHGVAR     VAR(&TEXT) VALUE('The Communication +
                          library ' *CAT &COMLIB *CAT ' does not +
                          exist')                                                         /*CSW101*/
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)                                        /*CSW101*/
             SNDPGMMSG  MSG('The Communication library ' *CAT +
                          &COMLIB  *CAT ' Does not exist') +
                        TOMSGQ(MOPERQ)                                                    /*CSW101*/
             GOTO ABEND                                                                   /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
/* Check previous file has been picked up by Merva otherwise */                           /*CSW101*/
/* end up with connection.                                   */                           /*CSW101*/
                                                                                          /*CSW101*/
             CHKOBJ     OBJ(&COMLIB/MIDO) OBJTYPE(*FILE)                                  /*CSW101*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO PROCESS)                                 /*CSW101*/
                                                                                          /*CSW101*/
             CHGVAR     VAR(&TEXT) VALUE('MIDO file already exists, +
                          contact PAYplus operator')                                      /*CSW101*/
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)                                        /*CSW101*/
             SNDPGMMSG  MSG('The MIDO File has not been picked up +
                          by PAYPlus. Check with PAYplus operator +
                          before to continue') TOMSGQ(MOPERQ)                             /*CSW101*/
                                                                                          /*CSW101*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                                       /*CSW101*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSW101*/
             GOTO END2                                                                    /*CSW101*/
                                                                                          /*CSW101*/
/* Prepare Midas outgoing SWIFT file in appropriate format      */                        /*CSW101*/
                                                                                          /*CSW101*/
PROCESS:                                                                                  /*CSW101*/
/* Clear output file                                            */                        /*CSW101*/
             CLRPFM     MS2780PD                                                          /*CSW101*/
                                                                                          /*CSW101*/
/* Call the compression program                                 */                        /*CSW101*/
             CHGJOB     SWS(00000000)                                                     /*CSW101*/
             CALL       PGM(MS100001)                                                     /*CSW101*/
                                                                                          /*CSW101*/
/* Check program terminated normally                            */                        /*CSW101*/
                                                                                          /*CSW101*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CSW101*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                            /*CSW101*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CSW101*/
                  ROLLBACK                                                                /*CSW101*/
                  GOTO ABEND                                                              /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
/* Inform user if there is no Outgoing Messages to transmit     */                        /*CSW101*/
                                                                                          /*CSW101*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)                                  /*CSW101*/
             CHGVAR     VAR(&TEXT) VALUE('There is no Outgoing +
                          Message for Transmission')                                      /*CSW101*/
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)                                        /*CSW101*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                                       /*CSW101*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSW101*/
             GOTO END2                                                                    /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
/* Copy Outgoing message file into the communication library    */                        /*CSW101*/
/* Check for the last sequence Nr. for the copy file            */                        /*CSW101*/
                                                                                          /*CSW101*/
             RTVDTAARA  DTAARA(MSSTAT (253 2)) RTNVAR(&SEQD)                              /*CSW101*/
             CHGVAR     VAR(&SEQ) VALUE(&SEQD)                                            /*CSW101*/
             CHGVAR     VAR(&SEQ) VALUE(&SEQ+1)                                           /*CSW101*/
                                                                                          /*CSW101*/
             IF COND(%SST(&DATE 1 1) *EQ ' ')  THEN(DO)                                   /*CSW101*/
             CHGVAR     VAR(%SST(&DATE 1 1)) VALUE('0')                                   /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
             CHGVAR     VAR(&MIDA) VALUE('#' *CAT &DATE)                                  /*CSW101*/
             CHGVAR     VAR(&SEQD) VALUE(&SEQ)                                            /*CSW101*/
             CHGVAR     VAR(&MIDSAV) VALUE(&MIDA *CAT &SEQD)                              /*CSW101*/
                                                                                          /*CSW101*/
             CPYF       FROMFILE(MS2780PD) TOFILE(MIDO) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CSW101*/
             CRTDUPOBJ  OBJ(MIDO) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&COMLIB) DATA(*YES)                                       /*CSW101*/
             CPYF       FROMFILE(&COMLIB/MIDO) +
                          TOFILE(&COMLIB/&MIDSAV) MBROPT(*ADD) +
                          CRTFILE(*YES)                                                   /*CSW101*/
                                                                                          /*CSW101*/
             CHGVAR     VAR(&TEXT) VALUE('Midas Outgoing Message is +
                          ready, contact PAYplus')                                        /*CSW101*/
                                                                                          /*CSW101*/
             SNDRCVF    RCDFMT(MS2780S) WAIT(*YES)                                        /*CSW101*/
             SNDPGMMSG  MSG('The MIDO File is now ready for +
                          transmission to PAYplus. Please inform +
                          relevant site.') TOMSGQ(MOPERQ)                                 /*CSW101*/
                                                                                          /*CSW101*/
/* Update message index to transmitted and terminate            */                        /*CSW101*/
                                                                                          /*CSW101*/
             CALL       PGM(MS0203) PARM('T')                                             /*CSW101*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                                       /*CSW101*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSW101*/
             CHGDTAARA  DTAARA(MSSTAT (253 2)) VALUE(&SEQD)                               /*CSW101*/
             ENDRCV                                                                       /*CSW101*/
             MONMSG CPF0000                                                               /*CSW101*/
                                                                                          /*CSW101*/
/*  PRANG process */                                                                      /*CSW101*/
                             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                                'PAYPlusCommand' &SVAL1 '' '' '' '' +
                          '' '' '' '' '' '' '' '' '' '' '' '' '' +
                          '')                                                             /*CSW101*/
                IF         COND(&RTNCDE *NE '       ') THEN(GOTO +
                                CMDLBL(ABEND))                                            /*CSW101*/
                                                                                          /*CSW101*/
                IF         COND(&SVAL1 *NE '       ') THEN(DO)                            /*CSW101*/
                CALL       PGM(QCMDEXC) PARM(&SVAL1 200)                                  /*CSW101*/
                ENDDO                                                                     /*CSW101*/
                                                                                          /*CSW101*/
             GOTO       END2                                                              /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
             CALL MS0208                                              /*S01310*/
/*/COPY WNCPYSRC,MSC0201006                                          */

/* Notify Database errors to MOPERQ :                           */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)        /*S01117*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)        /*S01117*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  ROLLBACK
                  GOTO       CMDLBL(ABEND)
             ENDDO

/* Notify no data to sent to MOPERQ :                           */

             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                  SNDPGMMSG  MSG('No messages are ready for transmission') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(END)
             ENDDO

/*/COPY WNCPYSRC,MSC0201007                                          */
/* Send notification of Communications startup :                */

             SNDPGMMSG  MSG('SWIFT Communications program starting') +
                          TOMSGQ(MRUNQ)

/* Check the Message Switch line :                              */

             CHKOBJ     OBJ(MS2780LIND) OBJTYPE(*LIND)

/* Line does not exist - message and exit :                     */

             MONMSG     MSGID(CPF9800) EXEC(GOTO CMDLBL(ABEND))

/* Line exists - vary devices and transmit data :               */

 LOOP1:      VRYCFG     CFGOBJ(MS2780DEV) CFGTYPE(*DEV) STATUS(*OFF) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)
             VRYCFG     CFGOBJ(MS2780CUD) CFGTYPE(*CTL) STATUS(*OFF) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)
             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*OFF) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640)

             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*ON) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))
             VRYCFG     CFGOBJ(MS2780CUD) CFGTYPE(*CTL) STATUS(*ON) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))
             VRYCFG     CFGOBJ(MS2780DEV) CFGTYPE(*DEV) STATUS(*ON) +
                          RANGE(*OBJ)
             MONMSG     MSGID(CPF2640) EXEC(GOTO CMDLBL(RETRY))

             CHGJOB     SWS(XXXXX000)


             CALL       PGM(MS0202)

/* Notify Database errors to MOPERQ :                           */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)        /*S01117*/
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)        /*S01117*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(ABEND)
             ENDDO

/* No errors in transmission program :                          */

             IF         COND(%SWITCH(XXXXX0XX)) THEN(GOTO +
                          CMDLBL(UPDATE))
/**/

/* Errors in vary-on or transmission program - request retry :  */

 RETRY:      SNDPGMMSG  MSG('TRANSMISSION FAILED - do you wish to +
                          re-try (Y or N)') TOPGMQ(*EXT) MSGTYPE(*INQ)
             RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) RMV(*YES) MSG(&RPY)
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *NE 'N') *AND (&RPY *NE 'n')) +
                          THEN(GOTO CMDLBL(RETRY))

             GOTO       CMDLBL(ABEND)
/*/COPY WNCPYSRC,MSC0201008                                          */
/* UPDATE MESSAGE INDEX TO TRANSMITTED                          */

 UPDATE:     CALL       PGM(MS0203) PARM('T')
/*/COPY WNCPYSRC,MSC0201009                                          */
             GOTO       CMDLBL(END)

/* Abnormal end :                                               */

/*/COPY WNCPYSRC,MSC0201010                                          */
 ABEND:      CALL       PGM(MS0203) PARM('R')
/*/COPY WNCPYSRC,MSC0201011                                          */
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('SWIFT Message Transmission ended +
                          abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)

/*/COPY WNCPYSRC,MSC0201016                                          */
                                                                                          /*CSW101*/
/* if CSW101 is active then &RTN  = *blanks - avoid to recheck Feature */                 /*CSW101*/
                                                                                          /*CSW101*/
             IF         COND(&CSW101 *EQ 'Y') THEN(DO)                                    /*CSW101*/
                 DLTF       FILE(&COMLIB/MIDO)                                            /*CSW101*/
                 MONMSG     MSGID(CPF0000)                                                /*CSW101*/
                 DLTF       FILE(&COMLIB/MIDSAV)                                          /*CSW101*/
                 MONMSG     MSGID(CPF0000)                                                /*CSW101*/
             ENDDO                                                                        /*CSW101*/
                                                                                          /*CSW101*/
/* Normal end of program :                                      */

 END:        DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)

/* VARY OFF COMMUNICATIONS LINE/CTLU/DEV                        */

             VRYCFG     CFGOBJ(MS2780LIND) CFGTYPE(*LIN) STATUS(*OFF)
             MONMSG     MSGID(CPF0000)

/* Display screen message for transmission finished             */

             ENDRCV
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&TEXT) VALUE('Processing complete, press +
                          enter to continue')
/*           SNDRCVF                                                  /*CSW001*/
             SNDRCVF    RCDFMT(MS2780S)                               /*CSW001*/
             MONMSG     MSGID(CPF0000)
END2:                                                                 /*CSW001*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
