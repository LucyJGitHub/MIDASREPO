/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Ouput File Field Description in RPMSGFPD.')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1313 - Ouput File Field Description in RPMSGFPD.         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 198320             Date 24Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       198320 - Allocate appropriate member with *EXCL lock state. */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&Interface &File &replace)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Interface) TYPE(*CHAR) LEN(10)
             DCL        VAR(&File)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&Replace)   TYPE(*CHAR) LEN(4)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&RepSbsLib) TYPE(*CHAR) LEN(10)
             DCL        VAR(&Command)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&Length)    TYPE(*DEC)  LEN(15 5) VALUE(256)
             DCL        VAR(&Msgid)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MsgfLib)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(132)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Get Replication Subsystem library.                               */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(KMDSBS) RTNVAR(&RepSbsLib)
 
/*-------------------------------------------------------------------*/
/*  Allocate RPMSGFPD member.                                        */
/*-------------------------------------------------------------------*/
 
             ALCOBJ     OBJ((RPMSGFPD *FILE *EXCLRD +
                          &Interface)) WAIT(0)
 
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*198320*/
                   RCVMSG     MSGTYPE(*LAST) MSG(&Msgdta)             /*198320*/
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA('0000' *CAT &Msgdta) +
                                MSGTYPE(*DIAG)                        /*198320*/
                   GOTO       CMDLBL(ENDPGM)                          /*198320*/
             ENDDO                                                    /*198320*/
 
/*-------------------------------------------------------------------*/
/*  Copy RPMSGFPD member to same file in library QTEMP, only if      */
/*  file description replacement was required.                       */
/*-------------------------------------------------------------------*/
 
             IF         COND(&Replace = '*YES') THEN(DO)
                   CHGVAR VAR(&Command) +
                            VALUE('CPYF FROMFILE(RPMSGFPD) +
                                        TOFILE(QTEMP/RPMSGFPD) +
                                        FROMMBR(' *CAT &Interface *CAT ') TOMBR(*FROMMBR) +
                                        MBROPT(*REPLACE) CRTFILE(*YES) +
                                        INCCHAR(WHFILE 1 *NE' *BCAT &File *TCAT ')')
                   CALL       PGM(QCMDEXC) PARM(&Command &Length)
                   MONMSG     MSGID(CPF2817 CPF2869)
 
/*-------------------------------------------------------------------*/
/*  Copy RPMSGFPD first member from QTEMP back, only if file         */
/*  description replacement was required.                            */
/*-------------------------------------------------------------------*/
 
/**********        CPYF       FROMFILE(QTEMP/RPMSGFPD) +           */ /*198320*/
/**********                     TOFILE(RPMSGFPD) FROMMBR(*FIRST) + */ /*198320*/
/**********                     TOMBR(*FROMMBR) MBROPT(*REPLACE)   */ /*198320*/
                   CPYF       FROMFILE(QTEMP/RPMSGFPD) +
                                TOFILE(RPMSGFPD) FROMMBR(&Interface) +
                                TOMBR(*FROMMBR) MBROPT(*REPLACE)      /*198320*/
                   MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                                FILE(&RepSbsLib/RPMSGFPD) MBR(&Interface))
 
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Output new description of file.                                  */
/*-------------------------------------------------------------------*/
 
             DSPFFD     FILE(&File) OUTPUT(*OUTFILE) +
                          OUTFILE(RPMSGFPD) OUTMBR(&Interface *ADD)
             RCVMSG     MSGTYPE(*LAST) MSGDTA(&Msgdta) MSGID(&Msgid) +
                          MSGF(&Msgf) MSGFLIB(&MsgfLib)
             SNDPGMMSG  MSGID(&Msgid) MSGF(&MsgfLib/&Msgf) +
                          MSGDTA(&Msgdta) TOPGMQ(*PRV)
 
/*-------------------------------------------------------------------*/
/*  Deallocate RPMSGFPD member.                                      */
/*-------------------------------------------------------------------*/
 
/**********  DLCOBJ     OBJ((RPMSGFPD *FILE *EXCLRD &Interface))      /*198320*/
/**********  MONMSG     MSGID(CPF0000)                                /*198320*/
 
             GOTO ENDPGM
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1313 - Ouput File Field Description +
                                 in RPMSGFPD - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
                                                                      /*198320*/
/*-----------------------------------------------------------------*/ /*198320*/
/*  Deallocate RPMSGFPD member.                                       /*198320*/
/*-----------------------------------------------------------------*/ /*198320*/
                                                                      /*198320*/
             DLCOBJ     OBJ((RPMSGFPD *FILE *EXCL &Interface))        /*198320*/
             MONMSG     MSGID(CPF0000)                                /*198320*/
                                                                      /*198320*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
