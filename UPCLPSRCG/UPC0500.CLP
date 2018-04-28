/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Set up environment for compares')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0500  - Set up environment for compares                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005  *MOVED     Date 17Aug05              */
/*       Prev Amend No. CUP024             Date 13Jun03              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CUP008             DATE 17Jul00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     DATE 11Feb98              */
/*                                                                   */
/********************************************************************/
/*                                                                   */
/*       CSM005 - Changes for the Bridge compare for MidasPlus.      */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CSC017 - Change to 250 library list.                        */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP008 - Change at operating system V4R4M0 maeans that the  */
/*                 system level needs to be known.                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/********************************************************************/
/**********  PGM        PARM(&QUALNEW &NEWM &QUALOLD &OLDM &NBR &LEN)                  */ /*CSM005*/
             PGM        PARM(&NEWF &NEWL &NEWM &OLDF &OLDL &OLDM +
                          &NBR &LEN &PTFUPG)                                              /*CSM005*/
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CSM005*/
/**********  DCL        VAR(&QUALNEW) TYPE(*CHAR) LEN(20)                              */ /*CSM005*/
/**********  DCL        VAR(&QUALOLD) TYPE(*CHAR) LEN(20)                              */ /*CSM005*/
             DCL        VAR(&NEWM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CSM005*/
 
             DCL        VAR(&NEWF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUM) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)                                */ /*CSC017*/
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(285)                                 */ /*CSC017*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)                                  /*CSC017*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)                                   /*CSC017*/
             DCL        VAR(&NEWME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)                                   /*CUP008*/
             DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)                                  /*CUP008*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('PRDR0100')                                               /*CUP008*/
             DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +
                          VALUE('*OPSYS *CUR  0000*CODE    ')                             /*CUP008*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             RTVJOBA    USRLIBL(&LIBL)
/************RCVF                                                                      */ /*CUP024*/
/************MONMSG     MSGID(CPF0864)                                                 */ /*CUP024*/
/**COPY UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CSM005*/
/**/
/**********  CHGVAR     VAR(&NEWF) VALUE(%SST(&QUALNEW 1 10))                          */ /*CSM005*/
/**********  CHGVAR     VAR(&OLDF) VALUE(%SST(&QUALOLD 1 10))                          */ /*CSM005*/
/**********  CHGVAR     VAR(&NEWL) VALUE(%SST(&QUALNEW 11 10))                         */ /*CSM005*/
/**********  CHGVAR     VAR(&OLDL) VALUE(%SST(&QUALOLD 11 10))                         */ /*CSM005*/
 
/*CHKLIBLE:*                                                                           */ /*CSM005*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                                        */ /*CSM005*/
/**********  CHKLIBLE   LIBS(QTEMP) RETURN(&RETURN)                                    */ /*CSM005*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                                 */ /*CSM005*/
/**********     EDTLIBL                                                                */ /*CSM005*/
/**********     GOTO CHKLIBLE                                                          */ /*CSM005*/
/**********  ENDDO                                                                     */ /*CSM005*/
 
             RMVLIBLE   LIB(QTEMP)
             MONMSG     MSGID(CPF2104 CPF2110)
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)
             MONMSG     MSGID(CPF2103 CPF2110)
/**/
             CHKOBJ     OBJ(QTEMP/QDDSSRC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTSRCPF   FILE(QTEMP/QDDSSRC) RCDLEN(112)
             ENDDO
/**/
             CHKOBJ     OBJ(QTEMP/UPP01P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(QTEMP/UPP01P) RCDLEN(100) +
                          OPTION(*NOSOURCE *NOLIST) LVLCHK(*NO)
             ENDDO
/**/
             IF         COND(&LEN *EQ 112) THEN(DO)
                CHKOBJ     OBJ(&PTFUPG/UPP02P) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(CC)
                ENDDO
             ENDDO
 
             IF         COND(&LEN *EQ 092) THEN(DO)
                CHKOBJ     OBJ(&PTFUPG/UPP02PB) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(CC)
                ENDDO
             ENDDO
             GOTO       CMDLBL(CC1)
CC:
             CHGVAR     VAR(&NUM) VALUE(002)
             CLRPFM     FILE(UPP01P)
             IF         COND(&LEN *EQ 112) THEN(DO)
             CALL       PGM(UP0500) PARM(&NUM)
             CPYF       FROMFILE(QTEMP/UPP01P) +
                          TOFILE(QTEMP/QDDSSRC) TOMBR(UPP02P) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
             CRTPF      FILE(&PTFUPG/UPP02P) +
                          SRCFILE(QTEMP/QDDSSRC) SRCMBR(UPP02P) +
                          OPTION(*NOSRC *NOLIST) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG(' ' *CAT &PTFUPG *CAT '/UPP02P not +
                          created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
             CALL       PGM(UP0500B) PARM(&NUM)
             CPYF       FROMFILE(QTEMP/UPP01P) +
                          TOFILE(QTEMP/QDDSSRC) TOMBR(UPP02PB) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
             CRTPF      FILE(&PTFUPG/UPP02PB) +
                          SRCFILE(QTEMP/QDDSSRC) SRCMBR(UPP02PB) +
                          OPTION(*NOSRC *NOLIST) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG(' ' *CAT &PTFUPG *CAT '/UPP02PB not +
                          created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
CC1:
             CHKOBJ     OBJ(&PTFUPG/UPP03P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(DD)
             ENDDO
             GOTO       CMDLBL(DD1)
DD:
             CHGVAR     VAR(&NUM) VALUE(003)
             CLRPFM     FILE(UPP01P)
             IF         COND(&LEN *EQ 112) THEN(DO)
                CALL       PGM(UP0500) PARM(&NUM)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CALL       PGM(UP0500B) PARM(&NUM)
             ENDDO
             CPYF       FROMFILE(QTEMP/UPP01P) +
                          TOFILE(QTEMP/QDDSSRC) TOMBR(UPP03P) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
             CRTPF      FILE(&PTFUPG/UPP03P) +
                          SRCFILE(QTEMP/QDDSSRC) SRCMBR(UPP03P) +
                          OPTION(*NOSRC *NOLIST) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/UPP03P not created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
DD1:
             CHKOBJ     OBJ(QTEMP/UPP06P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(UU)
             ENDDO
             GOTO       CMDLBL(UU1)
UU:
             CHGVAR     VAR(&NUM) VALUE(004)
             CLRPFM     FILE(UPP01P)
             IF         COND(&LEN *EQ 112) THEN(DO)
                CALL       PGM(UP0500) PARM(&NUM)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CALL       PGM(UP0500B) PARM(&NUM)
             ENDDO
             CPYF       FROMFILE(QTEMP/UPP01P) +
                          TOFILE(QTEMP/QDDSSRC) TOMBR(UPP06P) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
             CRTPF      FILE(QTEMP/UPP06P) +
                          SRCFILE(QTEMP/QDDSSRC) SRCMBR(UPP06P) +
                          OPTION(*NOSRC *NOLIST) MAXMBRS(*NOMAX) +
                          SIZE(*NOMAX) SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/UPP06P not created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
UU1:
             CLRPFM     FILE(UPP06P)
 
             CHKOBJ     OBJ(QTEMP/UPP04P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(FF)
             ENDDO
             GOTO       CMDLBL(FF1)
FF:
             CRTPF      FILE(QTEMP/UPP04P) RCDLEN(220) OPTION(*NOSRC +
                          *NOLIST) MAXMBRS(1) SIZE(40000 5000 3) +
                          SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/UPP04P not created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
FF1:
             CMPPFM     NEWFILE(&NEWL/&NEWF) NEWMBR(&NEWM) +
                          OLDFILE(&OLDL/&OLDF) OLDMBR(&OLDM) +
                          RPTTYPE(*DETAIL) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/UPP04P) OPTION(*FLGMOVLIN)
/*OLD*/
             CHKOBJ     OBJ(QTEMP/UPP05P) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             GOTO       CMDLBL(BB)
             ENDDO
             GOTO       CMDLBL(BB1)
BB:
             CHGVAR     VAR(&NUM) VALUE(001)
             CLRPFM     FILE(UPP01P)
             IF         COND(&LEN *EQ 112) THEN(DO)
                CALL       PGM(UP0500) PARM(&NUM)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CALL       PGM(UP0500B) PARM(&NUM)
             ENDDO
             CPYF       FROMFILE(QTEMP/UPP01P) +
                          TOFILE(QTEMP/QDDSSRC) TOMBR(UPP05P) +
                          MBROPT(*REPLACE) FMTOPT(*CVTSRC)
             CRTPF      FILE(QTEMP/UPP05P) SRCFILE(QTEMP/QDDSSRC) +
                          SRCMBR(UPP05P) FILETYPE(*DATA) MBR(OLD) +
                          OPTION(*NOSRC *NOLIST) MAXMBRS(*NOMAX) +
                          SIZE(40000 5000) SHARE(*YES) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/UPP05P not created ')
             GOTO       CMDLBL(ABNOR)
             ENDDO
BB1:
             CLRPFM     FILE(UPP05P)
             OVRDBF     FILE(QRPGO) TOFILE(&OLDL/&OLDF) MBR(&OLDM)
             IF         COND(&LEN *EQ 112) THEN(DO)
                CALL       PGM(UP0510)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CALL       PGM(UP0510B)
             ENDDO
             DLTOVR     FILE(QRPGO)
 
             CHGVAR     VAR(%SST(&NEWME 1 4)) VALUE(%SST(&NEWM 1 4))
             CHGVAR     VAR(%SST(&NEWME 5 6)) VALUE(&NBR)
             IF         COND(&LEN *EQ 112) THEN(DO)
                ADDPFM     FILE(&PTFUPG/UPP02P) MBR(&NEWME)
                MONMSG     MSGID(CPF5812 CPF7306)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                ADDPFM     FILE(&PTFUPG/UPP02PB) MBR(&NEWME)
                MONMSG     MSGID(CPF5812 CPF7306)
             ENDDO
 
             ADDPFM     FILE(&PTFUPG/UPP03P) MBR(&NEWME)
             MONMSG     MSGID(CPF5812 CPF7306)
 
             IF         COND(&LEN *EQ 112) THEN(DO)
                CLRPFM     FILE(&PTFUPG/UPP02P) MBR(&NEWME)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CLRPFM     FILE(&PTFUPG/UPP02PB) MBR(&NEWME)
             ENDDO
 
             CLRPFM     FILE(&PTFUPG/UPP03P) MBR(&NEWME)
 
             RTVMBRD    FILE(&NEWL/&NEWF) MBR(&NEWM) SRCTYPE(&TYP)
/*******************************/
/* Remove Headings from UPP04P */
/*******************************/
             CALL       PGM(UP0580)
 
/* Find out IBM operating system level; if API not found assume it is pre-V4R4 */
             CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +
                          &FORMAT &PRDINF X'00000000')                                    /*CUP008*/
             MONMSG     MSGID(CPF0001) EXEC(DO)                                           /*CUP008*/
                CHGVAR     VAR(%SST(&RCVVAR 20 6)) VALUE('V4R3M0')                        /*CUP008*/
             ENDDO                                                                        /*CUP008*/
             CHGVAR     VAR(&IBMLVL) VALUE(%SST(&RCVVAR 20 6))                            /*CUP008*/
                                                                                          /*CUP008*/
             IF         COND(&LEN *EQ 112) THEN(DO)
                OVRDBF     FILE(UPP02P) TOFILE(&PTFUPG/UPP02P) +
                          MBR(&NEWME)
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                OVRDBF     FILE(UPP02P) TOFILE(&PTFUPG/UPP02PB) +
                          MBR(&NEWME)
             ENDDO
             OVRDBF     FILE(UPP03P) TOFILE(&PTFUPG/UPP03P) +
                          MBR(&NEWME)
             OVRDBF     FILE(QRPGL) TOFILE(&NEWL/&NEWF) MBR(&NEWM) +
                          LVLCHK(*NO)
             IF         COND(&LEN *EQ 112) THEN(DO)
                IF         COND(&IBMLVL *LT 'V4R4M0') THEN(DO)                            /*CUP008*/
                   CALL       PGM(UP0520)
                ENDDO                                                                     /*CUP008*/
                ELSE       CMD(DO)                                                        /*CUP008*/
                   CALL       PGM(UP0521)                                                 /*CUP008*/
                ENDDO                                                                     /*CUP008*/
             ENDDO
             IF         COND(&LEN *EQ 092) THEN(DO)
                CALL       PGM(UP0520B)
             ENDDO
             DLTOVR     FILE(QRPGL)
             DLTOVR     FILE(UPP02P)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(UPP02PB)
             MONMSG     MSGID(CPF9841)
             DLTOVR     FILE(UPP03P)
/**/
             RETURN
/**/
ABNOR:
             IF         COND(&CMD *NE '       ') THEN(DO)
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL (' *CAT &LIBL *TCAT +
                          ')')
/************CALL       PGM(QCMDEXC) PARM(&CMD 285)                                    */ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
