/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Cityd LE, FT, RE & NT Extr File Upd Ctl')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0008 - Citydealer LE, FT, RE & NT Extract File           */
/*                 Update Control                                    */
/*                                                                   */
/*       Function: This program will be called during Next Day       */
/*                 Setup.  It may only run after journalling has     */
/*                 re-started and the journal receivers have been    */
/*                 changed (SCC0408) and must complete before the    */
/*                 beginning of business database save can be taken  */
/*                 (SCC0410).                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      099850             Date 21Feb96              */
/*                      CCM002 *CREATE     DATE 04SEP95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging.  Move data queues from XLIB   */
/*                to DPLIB.                                          */
/*       099850 - Citydealer Dataqueue must be deleted and recreated */
/*                daily in order to reclaim used storage.            */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI)       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6) VALUE('  XLIB') /*099850*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NXTJRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,DLC0008001                                          */
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,DLC0008002                                          */
/**/
             SNDPGMMSG  MSG('DLC0008 - Citydealer LE, FT, RE & NT +
                          Extract File Update') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*    Setup system prefix variable from SDSTAT data area.            */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&XLIB 1 2)) VALUE(&SYSID)      /*099850*/
/**/
/*    Call program CB0160 to get value of restart indicator.         */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/                                                                  /*099850*/
/*****Delete*and*Recreate*the*Citydealer*Dataqueue                */           /*099850*/ /*CPK014*/
/************                                                                  /*099850*/ /*CPK014*/
/************DLTDTAQ    DTAQ(&XLIB/DLCDDTAQ)                                   /*099850*/ /*CPK014*/
/************MONMSG     MSGID(CPF0000)                                         /*099850*/ /*CPK014*/
/************                                                                  /*099850*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&XLIB/DLCDDTAQ) MAXLEN(32) TEXT('Midas +                     /*CPK014*/
/************             DL Citydealer Interface Dataqueue')                  /*099850*/ /*CPK014*/
 
/* Clear Citydealer data queue. */                                                        /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('DLCDDTAQ' '*LIBL ')                           /*CPK014*/
 
/**/
/*    If it is NOT a restart.                                        */
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
               DLTF       FILE(XDLCDCRPD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDLCDJNPD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XSDDEALPD)
               MONMSG     MSGID(CPF2105)
/**/
               CPYF       FROMFILE(DLCDCRPD) TOFILE(&DPLIB/XDLCDCRPD) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
               CPYF       FROMFILE(DLCDJNPD) TOFILE(&DPLIB/XDLCDJNPD) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
               CPYF       FROMFILE(SDDEALPD) TOFILE(&DPLIB/XSDDEALPD) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
/**/
/*    If it is a restart .                                           */
/**/
             IF         COND(&STAT *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XDLCDCRPD) TOFILE(DLCDCRPD) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DLCDCRPD))
               CPYF       FROMFILE(XDLCDJNPD) TOFILE(DLCDJNPD) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DLCDJNPD))
               CPYF       FROMFILE(XSDDEALPD) TOFILE(SDDEALPD) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(SDDEALPD))
             ENDDO
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
/**/
/** Call CB0150 to update restart indicator                          */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
/** Retrieve Journal Entry.                                          */
/**/
/*/COPY WNCPYSRC,DLC0008003                                          */
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*LAST) +
                          SEARCH(*DESCEND) RTNSEQNBR(&JSEQNO) +
                          RTNRCV(&NXTJRC)
/*/COPY WNCPYSRC,DLC0008004                                          */
/**/
/*    Call LE, FT, RE & NT Extract File Update program.              */
/**/
             CALL       PGM(DL0008) PARM(&NXTJRC &JSEQNO)
/**/
/*    If no error occured in the program                             */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/** Call CB0150 to update restart indicator */
/**/
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XDLCDCRPD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDLCDJNPD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XSDDEALPD)
               MONMSG     MSGID(CPF2105)
             ENDDO
/**/
/*    Database error processing                                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*/COPY WNCPYSRC,DLC0008005                                          */
             GOTO       CMDLBL(END)
/**/
/*   Abnormal termination - batch job                                */
/**/
 ABNOR:
/*/COPY WNCPYSRC,DLC0008006                                          */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer LE, FT, RE & NT Extract File +
                          Update ENDED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,DLC0008007                                          */
             ENDPGM
