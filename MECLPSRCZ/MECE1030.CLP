/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1030 - Import Incoming Messages                         */
/*                                                                   */
/*       (C) COPYRIGHT Misys ibs Ltd 2001                            */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. ST2701             Date 19Sep2006            */
/*       Prev Amend No. ST2701             Date 27Jan2005            */
/*                      ESL038             Date 01Oct2004            */
/*                      E10004             Date 30Jan2004            */
/*                      ERN054             Date 11Jun2003            */
/*                      PL0001 *Create     Date 11Oct2001            */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       STPIII - NordLB STP III Changes. Add conversion table.      */
/*       ST2701 - Folder with System Prefix should go first in path. */
/*       ESL038 - ING STP Development                                */
/*       E10004 - Prevent multiple use at the same time              */
/*       ERN054 - Add IFS route for file location                    */
/*       PL0001 - Incoming Messages from PC File                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FOLDER &DOCUMENT)                                           **ERN054*/
             PGM        PARM(&FOLDER &DOCUMENT &ROUTE &CODEPAGE)
/* */
             DCL        VAR(&MISYS) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT Misys ibs Ltd 2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) +
                          VALUE('xxusrmsg')
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DOCUMENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ROUTE) TYPE(*CHAR) LEN(40)                                   /*ERN054*/
             DCL        VAR(&CODEPAGE) TYPE(*CHAR) LEN(10) /*ERN054*/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(50)                                /*ERN054*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*ERN054*/
             DCL        VAR(&TOMBR) TYPE(*CHAR) LEN(60)                                   /*ERN054*/
             DCL        VAR(&FOLDER1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DOCUMENT1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOCUMENT2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)                                     /*E10004*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
/* */                                                                                     /*E10004*/
/* Make sure no one else running */                                                       /*E10004*/
/* */                                                                                     /*E10004*/
             RTVJOBA    TYPE(&TYPE)                                                       /*E10004*/
             ALCOBJ     OBJ((MEIMSGP0 *FILE *EXCL)) WAIT(10)                              /*E10004*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                                           /*E10004*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0016')                                      /*E10004*/
             CHGVAR     VAR(&MSGDTA) VALUE('Another user is using this function')         /*E10004*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*E10004*/
             ENDDO                                                                        /*E10004*/
                                                                                          /*E10004*/
/* */
/* Get data for document */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DB)
             CHGVAR     VAR(&FOLDER1) VALUE(&FOLDER *TCAT &DB)
             CHGVAR     VAR(&DOCUMENT1) VALUE(&DOCUMENT *TCAT '.TXT')
             IF         COND(&ROUTE *EQ '*NONE') THEN(DO)                                 /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0010')
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *CAT &DOCUMENT1)
             CHKDLO     DLO(&DOCUMENT1) FLR(&FOLDER1) AUT(*USE)
             CHGVAR     VAR(&DOCUMENT2) VALUE(&DOCUMENT *TCAT +
                          'IMP.TXT')
             CHGVAR     VAR(&MSGID) VALUE('PLN0011')
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *CAT &DOCUMENT2)
             CHKDLO     DLO(&DOCUMENT2) FLR(&FOLDER1) AUT(*USE)
             MONMSG     MSGID(CPF8A82) EXEC(DO)
             GOTO       CMDLBL(IMPNF)
             ENDDO
             GOTO       CMDLBL(ABNORMAL)
/* */
 IMPNF:
             CHGVAR     VAR(&MSGID) VALUE('PLN0012')
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *CAT &DOCUMENT1)
             CPYFRMPCD  FROMFLR(&FOLDER1) TOFILE(MEIMSGP0) +
                          FROMDOC(&DOCUMENT1) TRNTBL(ELXTBLIN)                            /*STPIII*/
             ENDDO                                                                        /*ERN054*/
             ELSE       CMD(DO)                                                           /*ERN054*/
/* */                                                                                     /*ERN054*/
/* Test for data to be extracted is in location */                                        /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0020')                                      /*ERN054*/
/********    CHGVAR     VAR(&MSGDTA) VALUE(&ROUTE *TCAT '/' *CAT +   */                   /*ST2701*/
/********                 &FOLDER1 *TCAT '/' *CAT &DOCUMENT1)        */                   /*ST2701*/
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *TCAT '/' *CAT +
                          &ROUTE *TCAT '/' *CAT &DOCUMENT1)                               /*ST2701*/
             CHGVAR     VAR(&LOCATION) VALUE(&MSGDTA)                                     /*ERN054*/
             CHKOUT     OBJ(&LOCATION)                                                    /*ERN054*/
             CHKIN    OBJ(&LOCATION)                                                      /*ERN054*/
/* */                                                                                     /*ERN054*/
/* Test for data to be extracted in prior run */                                          /*ERN054*/
             CHGVAR     VAR(&DOCUMENT2) VALUE(&DOCUMENT *TCAT +
                          'IMP.TXT')                                                      /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0021')                                      /*ERN054*/
/*********   CHGVAR     VAR(&MSGDTA) VALUE(&ROUTE *TCAT '/' *CAT +    ***/                /*ST2701*/
/*********                &FOLDER1 *TCAT '/' *CAT &DOCUMENT2)         ***/                /*ST2701*/
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *TCAT '/' *CAT +
                          &ROUTE *TCAT '/' *CAT &DOCUMENT2)                               /*ST2701*/
             CHGVAR     VAR(&LOCATION) VALUE(&MSGDTA)                                     /*ERN054*/
             CHKOUT     OBJ(&LOCATION)                                                    /*ERN054*/
             MONMSG     MSGID(CPFA0A9) EXEC(DO)                                           /*ERN054*/
             GOTO       CMDLBL(IMPNF2)                                                    /*ERN054*/
             ENDDO                                                                        /*ERN054*/
             CHKIN    OBJ(&LOCATION)                                                      /*ERN054*/
             MONMSG     MSGID(CPF0000)                                                    /*ERN054*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*ERN054*/
/* */                                                                                     /*ERN054*/
 IMPNF2:                                                                                  /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0022')                                      /*ERN054*/
/*********   CHGVAR     VAR(&MSGDTA) VALUE(&ROUTE *TCAT '/' *CAT +  ****/                 /*ST2701*/
/*********                &FOLDER1 *TCAT '/' *CAT &DOCUMENT1)       ****/                 /*ST2701*/
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *TCAT '/' *CAT +
                          &ROUTE *TCAT '/' *CAT &DOCUMENT1)                               /*ST2701*/
             CHGVAR     VAR(&LOCATION) VALUE(&MSGDTA)                                     /*ERN054*/
             CHKOUT     OBJ(&LOCATION)                                                    /*ERN054*/
/* */                                                                                     /*ERN054*/
/* Create temporary file for copy of message data                                         /*ERN054*/
                                                                                          /*ERN054*/
             CHGVAR     VAR(&DPLIB) VALUE(&DB *CAT 'DPLIB')                               /*ERN054*/
             CHKOBJ     OBJ(&DPLIB/IMPINCMSG) OBJTYPE(*FILE)                              /*ERN054*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*ERN054*/
             CRTPF      FILE(&DPLIB/IMPINCMSG) RCDLEN(122) +
                          TEXT('Import Message Data') SIZE(*NOMAX)                        /*ERN054*/
             ENDDO                                                                        /*ERN054*/
/* */                                                                                     /*ERN054*/
/* Clear file and copy                                                                    /*ERN054*/
             CLRPFM     FILE(&DPLIB/IMPINCMSG)                                            /*ERN054*/
             CHGVAR     VAR(&TOMBR) VALUE('/QSYS.LIB/' *CAT &DPLIB +
                          *TCAT '.LIB/IMPINCMSG.FILE/IMPINCMSG.MBR')                      /*ERN054*/
             CPYFRMSTMF FROMSTMF(&LOCATION) TOMBR(&TOMBR) +
                          MBROPT(*REPLACE) STMFCODPAG(&CODEPAGE)
             CHKIN    OBJ(&LOCATION)
             CPYF       FROMFILE(&DPLIB/IMPINCMSG) TOFILE(MEIMSGP0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             ENDDO
/* */
/* Start commitment control */
/* */
             STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF8351)
/* */
/* Run MEE1030 - Import Messages */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             OVRPRTF    FILE(ME1030AU) TOFILE(MEE1030AU)
             OVRPRTF    FILE(ME1030P1) TOFILE(MEE1030P1)
             OVRPRTF    FILE(ME1030P2) TOFILE(MEE1030P2)
             OVRPRTF    FILE(ME1030P3) TOFILE(MEE1030P3)
             CALL       PGM(MEE1030) PARM(&RTN_CODE &FOLDER &DOCUMENT)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSGID) VALUE('PLN0014')
             CHGVAR     VAR(&MSGDTA) VALUE('MEE1030')
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Rename document */
/* */
             IF         COND(&ROUTE *EQ '*NONE') THEN(DO)                                 /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0015')
             CHGVAR     VAR(&MSGDTA) VALUE(&FOLDER1 *CAT &DOCUMENT1 +
                          *CAT &DOCUMENT2)
             RNMDLO     DLO(&DOCUMENT1) NEWDLO(&DOCUMENT2) +
                          FLR(&FOLDER1)
             ENDDO                                                                        /*ERN054*/
             ELSE       CMD(DO)                                                           /*ERN054*/
             CHGVAR     VAR(&MSGID) VALUE('PLN0025')                                      /*ERN054*/
/**********  CHGVAR     VAR(&MSGDTA) VALUE(&DOCUMENT1 *CAT +    ***/                      /*ST2701*/
/**********               &DOCUMENT2 *CAT &ROUTE *TCAT '/' *CAT + ***/                    /*ST2701*/
/**********               &FOLDER1)                               ***/                    /*ST2701*/
             CHGVAR     VAR(&MSGDTA) VALUE(&DOCUMENT1 *CAT +
                          &DOCUMENT2 *CAT &FOLDER1 *TCAT '/' *CAT +
                          &ROUTE)                                                         /*ST2701*/
/**********  CHGVAR     VAR(&LOCATION) VALUE(&ROUTE *TCAT '/' *CAT +  **/                 /*ST2701*/
/**********               &FOLDER1 *TCAT '/' *CAT &DOCUMENT1)         **/                 /*ST2701*/
             CHGVAR     VAR(&LOCATION) VALUE(&FOLDER1 *TCAT '/' *CAT +
                          &ROUTE *TCAT '/' *CAT &DOCUMENT1)                               /*ST2701*/
             RNM        OBJ(&LOCATION) NEWOBJ(&DOCUMENT2)                                 /*ERN054*/
             DLTF       FILE(&DPLIB/IMPINCMSG)                                            /*ERN054*/
             ENDDO                                                                        /*ERN054*/
/* */
/* Send prompt for extraction process */
/* */
             CHGVAR     VAR(&MSGID) VALUE('PLN0014')
             CHGVAR     VAR(&MSGDTA) VALUE('MECE1024')
             CALL       PGM(MECE1024) PARM(&RTN_CODE)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&TYPE = '1') THEN(DO)                                        /*E10004*/
             CALL       PGM(MEC1027) PARM(&RTN_CODE &MSGID &MSGF +
                          &MSGDTA 'ENTER     ' ' ' 'MECE1030' ' ')                        /*E10004*/
             ENDDO                                                                        /*E10004*/
             ENDDO
/**/
             SNDPGMMSG  MSG('Program MECE1050 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1050 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&MISYS) VALUE('COPYRIGHT Misys ibs Ltd. +
                          2001.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */                                                                                     /*E10004*/
/* Make sure no one else running */                                                       /*E10004*/
/* */                                                                                     /*E10004*/
             DLCOBJ     OBJ((MEIMSGP0 *FILE *EXCL))                                       /*E10004*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*E10004*/
/* */
             ENDPGM
