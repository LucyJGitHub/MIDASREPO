/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Copy adoption programs')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC0032 - Copy adoption programs                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. BUG28037           Date 17Aug10              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP031             Date 09Mar05              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CSM002  *CREATE    Date 19Nov02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG28037 - Handle IASP, CHGOWNAUT.                          */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CUP031 - Remove prompt for library name.                    */
/*       CSM002 - Bringing Bridge Implementation into core.          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PFX &AUTL)
 
             DCL        VAR(&PFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AUTL) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSVALVAL1) TYPE(*CHAR) LEN(200)                           /*BUG28037*/
             DCL        VAR(&SYSVALVAL2) TYPE(*CHAR) LEN(200)                           /*BUG28037*/
             DCL        VAR(&SYSVAL1) TYPE(*CHAR) LEN(20)                               /*BUG28037*/
             DCL        VAR(&SYSVAL2) TYPE(*CHAR) LEN(20)                               /*BUG28037*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                /*BUG28037*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                  /*BUG28037*/
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)                                /*BUG28037*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Declare file containing list of adoption programs. */
             DCLF       FILE(UPAPGMPD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set up library list. */
             CALL       PGM(UPC0014) PARM(&PFX)
 
/* Retrieve IASP System Values. */
             CHGVAR     VAR(&SYSVAL1) VALUE('IASPinstallation')                         /*BUG28037*/
             CHGVAR     VAR(&SYSVAL2) VALUE('IASPgroup')                                /*BUG28037*/
             CALL       PGM(GPAOSVALR0) PARM(&RTNCODE &SYSVAL1 +
                          &SYSVALVAL1 &SYSVAL2 &SYSVALVAL2 ' ' ' ' +
                          ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' +
                          ' ' ' ' ' ' ')                                                /*BUG28037*/
             IF         COND(&RTNCODE *NE '       ') THEN(DO)                           /*BUG28037*/
                GOTO       CMDLBL(ABNOR)                                                /*BUG28037*/
             ENDDO                                                                      /*BUG28037*/
             CHGVAR     VAR(&IASP_YN) VALUE(&SYSVALVAL1)                                /*BUG28037*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                 /*BUG28037*/
                CHGVAR     VAR(&IASP) VALUE(&SYSVALVAL2)                                /*BUG28037*/
             ENDDO                                                                      /*BUG28037*/
 
/* Prompt for library to copy adoption programs to; this defaults to */
/***the*XLIB.*********************************************************/                   /*CSC043*/
/**********  CHGVAR     VAR(&LIBNAME) VALUE(&PFX *TCAT 'XLIB')       */                   /*CSC043*/
/** the XPLIB. */                                                                         /*CSC043*/
             CHGVAR     VAR(&LIBNAME) VALUE(&PFX *TCAT 'XPLIB')                           /*CSC043*/
             CHGVAR     VAR(&CPYLIB) VALUE(&LIBNAME)                                      /*CUP031*/
             CHGVAR     VAR(&OWNER) VALUE(&PFX *TCAT 'OWNER')                             /*CUP031*/
/**********  ?          LIBNAME ??LIBNAME(&LIBNAME)                                    */ /*CUP031*/
/**********  MONMSG     MSGID(CPF6801) EXEC(DO)                                        */ /*CUP031*/
/**********     GOTO       CMDLBL(ENDPGM)                                              */ /*CUP031*/
/**********  ENDDO                                                                     */ /*CUP031*/
/**********  RTVDTAARA  DTAARA(QTEMP/LIBNAME) RTNVAR(&CPYLIB)                          */ /*CUP031*/
/**Check*it*exists;*if*it*does*then*find*ownership.**/ /*                              */ /*CUP031*/
/**********  CHKOBJ     OBJ(&CPYLIB) OBJTYPE(*LIB)                                     */ /*CUP031*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                                        */ /*CUP031*/
/**********     GOTO       CMDLBL(ABNOR)                                               */ /*CUP031*/
/**********  ENDDO                                                                     */ /*CUP031*/
/**********  RTVOBJD    OBJ(&CPYLIB) OBJTYPE(*LIB) OWNER(&OWNER)                       */ /*CUP031*/
 
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/* If flagged to be used ... */
             IF         COND(&AAADPT *EQ 'Y') THEN(DO)
/* ... move object from 'library to be copied to' if it exists. */
                CRTDUPOBJ  OBJ(&AAPGM) FROMLIB(&CPYLIB) OBJTYPE(*PGM) +
                             TOLIB(QTEMP)
                MONMSG     MSGID(CPF2130)
                DLTPGM     PGM(&CPYLIB/&AAPGM)
                MONMSG     MSGID(CPF2105)
/* Find latest version in library list ... */
                RTVOBJD    OBJ(&AAPGM) OBJTYPE(*PGM) RTNLIB(&PGMLIB)
                MONMSG     MSGID(CPF9811) EXEC(DO)
                   GOTO       CMDLBL(READNEXT)
                ENDDO
/* ...create copy of program in library specified ... */
                CRTDUPOBJ  OBJ(&AAPGM) FROMLIB(&PGMLIB) OBJTYPE(*PGM) +
                             TOLIB(&CPYLIB)
/* Set authority according to library ownership ... */
                IF         COND(&IASP_YN *NE 'Y') THEN(DO)                              /*BUG28037*/
                   CHGOWNAUT  OBJ(&CPYLIB/&AAPGM) OBJTYPE(*PGM) +
                                NEWOWN(&OWNER) PUBAUT(*AUTL) AUTL(&AUTL) +
                                CHGLIB(N)
                ENDDO                                                                   /*BUG28037*/
                ELSE       CMD(DO)                                                      /*BUG28037*/
                   CHGOWNAUT  OBJ(&CPYLIB/&AAPGM) OBJTYPE(*PGM) +
                                NEWOWN(&OWNER) PUBAUT(*AUTL) AUTL(&AUTL) +
                                CHGLIB(N) ASP(*ASPDEV) ASPDEV(&IASP)                    /*BUG28037*/
                ENDDO                                                                   /*BUG28037*/
/* ... and change adoption parameters according to file. */
                CHGPGM     PGM(&CPYLIB/&AAPGM) USRPRF(&AAUSER) +
                             USEADPAUT(&AAUSEA)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
