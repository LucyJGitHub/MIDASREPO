/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Rebuild binding directory - CPP')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC9002 - CPP for RBDBNDDIR (Rebuild binding directory)     */
/*                 command.                                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK022             Date 29Jul05              */
/*       Prev Amend No. CPK018  *MOVED     Date 26Apr04              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      141051             Date 07Oct98              */
/*                      137831             Date 26JUN98              */
/*                      CAP002  *CREATE    Date 04NOV97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*       141051 - Use a program to add binding directory entries so  */
/*                each *MODULE/*SRVPGM is added with *LIBL rather    */
/*                the specific library.                              */
/*       137831 - A full library list could cause a subscript out of */
/*                range error when reading through the library list. */
/*                Move the check for end of list to before the       */
/*                relevant CHGVAR.                                   */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DIRANDLIB &OBJLIB &OBJTYP)
 
             DCL        VAR(&DIRANDLIB) TYPE(*CHAR) LEN(20) /* +
                          Binding directory and library */
             DCL        VAR(&OBJLIB) TYPE(*CHAR) LEN(10) /* Library +
                          containing modules and sevice programs */
             DCL        VAR(&OBJTYP) TYPE(*CHAR) LEN(7) /* Which +
                          object type(s) to include */
 
             DCL        VAR(&BNDDIR) TYPE(*CHAR) LEN(10) /* Binding +
                          directory name */
             DCL        VAR(&BNDDIRLIB) TYPE(*CHAR) LEN(10) /* +
                          Binding directory library */
 
/************DCL        VAR(&USRLIBL) TYPE(*CHAR) LEN(275)                             */ /*CSC017*/
/************DCL        VAR(&PTR) TYPE(*DEC) LEN(3 0)                                  */ /*CSC017*/
             DCL        VAR(&USRLIBL) TYPE(*CHAR) LEN(2750)                               /*CSC017*/
             DCL        VAR(&PTR) TYPE(*DEC) LEN(4 0)                                     /*CSC017*/
             DCL        VAR(&ADDTYPE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
/***COPY*UTCPYSRC,STDERR_DCL                                          */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR_DCL                                          */                  /*CPK022*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QABNDBND)
 
/*/COPY WNCPYSRC,UTC9002INT                                          */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,UTC9002MPS                                          */
 
/** Separate binding directory and library **/
             CHGVAR     VAR(&BNDDIR) VALUE(&DIRANDLIB)
             CHGVAR     VAR(&BNDDIRLIB) VALUE(%SST(&DIRANDLIB 11 10))
 
/* For better performance, remove all binding directory entries     +
   for the library(ies) that are specified.                         +
   If one library or *CURLIB is specified, just do that library.    +
   If *USRLIBL or *LIBL is specified, do *USRLIBL.                  +
   Display the binding directory and remove anything still          +
   referenced afterwards as a catchall.                             +
*/
             IF         COND(&OBJLIB *NE '*LIBL' *AND &OBJLIB *NE +
                          '*USRLIBL') THEN(DO)
                RMVBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                   OBJ((&OBJLIB/*ALL *SRVPGM))
                RMVBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                   OBJ((&OBJLIB/*ALL *MODULE))
             ENDDO
 
             IF         COND(&OBJLIB *EQ '*LIBL' *OR &OBJLIB *EQ +
                          '*USRLIBL') THEN(DO)
                RTVJOBA    USRLIBL(&USRLIBL)
 
                CHGVAR     VAR(&PTR) VALUE(1)
RMVLOOP1:
                CHGVAR     VAR(&LIB) VALUE(%SST(&USRLIBL &PTR 10))
                IF         COND(&LIB = ' ') THEN(GOTO CMDLBL(ENDRMV1)) +
                                                             /*137831*/
/************** IF        COND(&PTR *GT 275 *OR &LIB = ' ') THEN(GOTO +
                             CMDLBL(ENDRMV1))      *****/    /*137831*/
                IF (&LIB *NE 'QTEMP') THEN(DO)
                   RMVBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                      OBJ((&LIB/*ALL *SRVPGM))
                   RMVBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                      OBJ((&LIB/*ALL *MODULE))
                ENDDO
 
                CHGVAR     VAR(&PTR) VALUE(&PTR + 11)
/************   IF         COND(&PTR *GT 275) THEN(GOTO +                              */ /*CSC017*/
/************                CMDLBL(ENDRMV1))                               */ /*137831*/ /*CSC017*/
             IF         COND(&PTR *GT 2750) THEN(GOTO CMDLBL(ENDRMV1))                    /*CSC017*/
                GOTO       CMDLBL(RMVLOOP1)
             ENDDO
ENDRMV1:
 
/** Prepare the file to be used                                     */
             OVRDBF     FILE(QABNDBND) TOFILE(QTEMP/&BNDDIR)
 
             DLTF       FILE(QTEMP/&BNDDIR)
             MONMSG     MSGID(CPF2105)
 
/*  Remove all objects still on the binding directory               */
/*   In order to do this we first need to build a list of the    */
/*      items that are on the binding directory...                  */
             DSPBNDDIR  BNDDIR(&BNDDIRLIB/&BNDDIR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/&BNDDIR)
 
/*   ...and then remove all of those items                          */
RMVLOOP2:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ADD))
 
             RMVBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +
                          OBJ((&BNOLNM/&BNOBNM &BNOBTP))
 
             GOTO       CMDLBL(RMVLOOP2)
ADD:
 
/*  If the object library specified is anything other than *USRLIBL */
/*   simply add them all (service programs first)                   */
 
             IF         COND(&OBJLIB *NE '*USRLIBL') THEN(DO)
                IF         COND(&OBJTYP = '*BOTH' *OR &OBJTYP = +
                             '*SRVPGM') THEN(DO)
/**********        ADDBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +          */ /*141051*/
/**********           OBJ((&OBJLIB/*ALL *SRVPGM)) POSITION(*LAST)   */ /*141051*/
                   CALL       PGM(UTC9006) PARM(&BNDDIRLIB &BNDDIR +
                                &OBJLIB *SRVPGM *LAST)                 /*141051*/
                ENDDO
 
                IF         COND(&OBJTYP = '*BOTH' *OR &OBJTYP = +
                             '*MODULE') THEN(DO)
/**********        ADDBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +          */ /*141051*/
/**********           OBJ((&OBJLIB/*ALL *MODULE)) POSITION(*LAST)   */ /*141051*/
                   CALL       PGM(UTC9006) PARM(&BNDDIRLIB &BNDDIR +
                                &OBJLIB *MODULE *LAST)                 /*141051*/
                ENDDO
             ENDDO
 
/*  If the object library specified is *USRLIBL, then process the   */
/*   list of libraries in the user portion of the library list one  */
/*   at a time, adding them all (service programs first)            */
/*  In order to put all service programs before any modules, the    */
/*   list of libraries is processed twice,                          */
 
             IF         COND(&OBJLIB = '*USRLIBL') THEN(DO)
                RTVJOBA    USRLIBL(&USRLIBL)
 
/*  Processing for service programs                                 */
                IF         COND(&OBJTYP *NE '*BOTH' *AND &OBJTYP *NE +
                             '*SRVPGM') THEN(DO)
                   GOTO       CMDLBL(ENDSVP)
                ENDDO
 
                CHGVAR     VAR(&PTR) VALUE(1)
ADDSVPLOOP:
                CHGVAR     VAR(&LIB) VALUE(%SST(&USRLIBL &PTR 10))
                IF         COND(&LIB = ' ') THEN(GOTO CMDLBL(ENDSVP))  +
                                                             /*137831*/
/************** IF        COND(&PTR *GT 275 *OR &LIB = ' ') THEN(GOTO +
                             CMDLBL(ENDSVP))    ****/        /*137831*/
                IF (&LIB *NE 'QTEMP') THEN(DO)
                                                                       /*141051*/
/**********        ADDBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +          */ /*141051*/
/**********           OBJ((&LIB/*ALL *SRVPGM)) POSITION(*LAST)      */ /*141051*/
                   CALL       PGM(UTC9006) PARM(&BNDDIRLIB &BNDDIR +
                                &LIB *SRVPGM *LAST)                    /*141051*/
                ENDDO
 
                CHGVAR     VAR(&PTR) VALUE(&PTR + 11)
/************   IF         COND(&PTR *GT 275) THEN(GOTO CMDLBL(ENDSVP)) +              */ /*CSC017*/
/************                                                               */ /*137831*/ /*CSC017*/
                IF         COND(&PTR *GT 2750) THEN(GOTO CMDLBL(ENDSVP))                  /*CSC017*/
 
                GOTO       CMDLBL(ADDSVPLOOP)
ENDSVP:
 
/*  Processing for modules                                          */
                IF         COND(&OBJTYP *NE '*BOTH' *AND &OBJTYP *NE +
                             '*MODULE') THEN(DO)
                   GOTO       CMDLBL(ENDMOD)
                ENDDO
 
                CHGVAR     VAR(&PTR) VALUE(1)
ADDMODLOOP:
                CHGVAR     VAR(&LIB) VALUE(%SST(&USRLIBL &PTR 10))
                IF         COND(&LIB = ' ') THEN(GOTO CMDLBL(ENDMOD))  +
                                                             /*137831*/
/************** IF        COND(&PTR *GT 275 *OR &LIB = ' ') THEN(GOTO +
                             CMDLBL(ENDMOD))    *****/       /*137831*/
 
                IF (&LIB *NE 'QTEMP') THEN(DO)
                                                                       /*141051*/
/**********        ADDBNDDIRE BNDDIR(&BNDDIRLIB/&BNDDIR) +          */ /*141051*/
/**********           OBJ((&LIB/*ALL *MODULE)) POSITION(*LAST)      */ /*141051*/
                   CALL       PGM(UTC9006) PARM(&BNDDIRLIB &BNDDIR +
                                &LIB *MODULE *LAST)                    /*141051*/
                ENDDO
 
                CHGVAR     VAR(&PTR) VALUE(&PTR + 11)
/************   IF         COND(&PTR *GT 275) THEN(GOTO CMDLBL(ENDMOD)) +              */ /*CSC017*/
/************                                                               */ /*137831*/ /*CSC017*/
                IF         COND(&PTR *GT 2750) THEN(GOTO CMDLBL(ENDMOD))                  /*CSC017*/
                GOTO       CMDLBL(ADDMODLOOP)
ENDMOD:
             ENDDO
 
/*/COPY WNCPYSRC,UTC9002MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,UTC9002ERR                                          */
 
/***COPY*UTCPYSRC,STDERR                                              */                  /*CPK022*/
/*/COPY GPCPYSRCG,STDERR                                              */                  /*CPK022*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,UTC9002END                                          */
 
             ENDPGM
