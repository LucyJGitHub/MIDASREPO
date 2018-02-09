/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check no. of libraries that can be added')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CHKLIBLE - Check no. of libraries that added to library list*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 26Apr04              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001  *CREATE    Date 18Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NOOFLIBS &LIBS &RETURN)
 
/************DCL        VAR(&NOOFLIBS) TYPE(*DEC) LEN(2 0)                             */ /*CSC017*/
/************DCL        VAR(&LIBS) TYPE(*CHAR) LEN(252)                                */ /*CSC017*/
             DCL        VAR(&NOOFLIBS) TYPE(*DEC) LEN(3 0)                                /*CSC017*/
             DCL        VAR(&LIBS) TYPE(*CHAR) LEN(2502)                                  /*CSC017*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
 
/************DCL        VAR(&USRLIBL) TYPE(*CHAR) LEN(275)                             */ /*CSC017*/
/************DCL        VAR(&REQSPACE) TYPE(*DEC) LEN(3 0)                             */ /*CSC017*/
/************DCL        VAR(&LIBSCNT) TYPE(*DEC) LEN(2 0)                              */ /*CSC017*/
/************DCL        VAR(&USRLIBLCNT) TYPE(*DEC) LEN(2 0)                           */ /*CSC017*/
/************DCL        VAR(&NBR) TYPE(*DEC) LEN(2 0)                                  */ /*CSC017*/
/************DCL        VAR(&AVAIL) TYPE(*DEC) LEN(2 0)                                */ /*CSC017*/
/************DCL        VAR(&OCC) TYPE(*DEC) LEN(2 0)                                  */ /*CSC017*/
             DCL        VAR(&USRLIBL) TYPE(*CHAR) LEN(2750)                               /*CSC017*/
             DCL        VAR(&REQSPACE) TYPE(*DEC) LEN(4 0)                                /*CSC017*/
             DCL        VAR(&LIBSCNT) TYPE(*DEC) LEN(2 0)                                 /*CSC017*/
             DCL        VAR(&USRLIBLCNT) TYPE(*DEC) LEN(2 0)                              /*CSC017*/
             DCL        VAR(&NBR) TYPE(*DEC) LEN(3 0)                                     /*CSC017*/
             DCL        VAR(&AVAIL) TYPE(*DEC) LEN(3 0)                                   /*CSC017*/
             DCL        VAR(&OCC) TYPE(*DEC) LEN(3 0)                                     /*CSC017*/
             DCL        VAR(&NBRB) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&START1) TYPE(*DEC) LEN(3 0)                               */ /*CSC017*/
/************DCL        VAR(&START2) TYPE(*DEC) LEN(3 0)                               */ /*CSC017*/
/************DCL        VAR(&START3) TYPE(*DEC) LEN(3 0)                               */ /*CSC017*/
             DCL        VAR(&START1) TYPE(*DEC) LEN(4 0)                                  /*CSC017*/
             DCL        VAR(&START2) TYPE(*DEC) LEN(4 0)                                  /*CSC017*/
             DCL        VAR(&START3) TYPE(*DEC) LEN(4 0)                                  /*CSC017*/
             DCL        VAR(&TTLLIBS) TYPE(*DEC) LEN(3 0)                                 /*CSC017*/
             DCL        VAR(&LASTLIB) TYPE(*DEC) LEN(4 0)                                 /*CSC017*/
             DCL        VAR(&TTLSPACE) TYPE(*DEC) LEN(4 0)                                /*CSC017*/
             DCL        VAR(&LIBL25) TYPE(*CHAR) LEN(1) VALUE(N)                          /*CSC017*/
             DCL        VAR(&LIBNBRFLAG) TYPE(*CHAR) LEN(1)                               /*CSC017*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check whether 25 or 250 long library lists are being supported. */                     /*CSC017*/
             RTVDTAARA  DTAARA(QLMTUSRLIB) RTNVAR(&LIBNBRFLAG)                            /*CSC017*/
             MONMSG     MSGID(CPF1015)                                                    /*CSC017*/
             IF         COND(&LIBNBRFLAG *EQ '1') THEN(DO)                                /*CSC017*/
                CHGVAR     VAR(&LIBL25) VALUE(Y)                                          /*CSC017*/
                GOTO       CMDLBL(CHGLIBVARS)                                             /*CSC017*/
             ENDDO                                                                        /*CSC017*/
/* Extra check for V5R1M0 to see if the QLMTUSRLIB exists in QGPL.  If */                 /*CSC017*/
/*  it does not then check for existence of QLILMTLIBL.                */                 /*CSC017*/
             CHKOBJ     OBJ(QGPL/QLMTUSRLIB) OBJTYPE(*DTAARA)                             /*CSC017*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CSC017*/
                CHKOBJ     OBJ(QUSRSYS/QLILMTLIBL) OBJTYPE(*DTAARA)                       /*CSC017*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                        /*CSC017*/
                   GOTO       CMDLBL(CHGLIBVARS)                                          /*CSC017*/
                ENDDO                                                                     /*CSC017*/
                CHGVAR     VAR(&LIBL25) VALUE(Y)                                          /*CSC017*/
             ENDDO                                                                        /*CSC017*/
CHGLIBVARS:                                                                               /*CSC017*/
             IF         COND(&LIBL25 *EQ 'Y') THEN(DO)                                    /*CSC017*/
                CHGVAR     VAR(&TTLLIBS) VALUE(25)                                        /*CSC017*/
                CHGVAR     VAR(&LASTLIB) VALUE(265)                                       /*CSC017*/
                CHGVAR     VAR(&TTLSPACE) VALUE(276)                                      /*CSC017*/
             ENDDO                                                                        /*CSC017*/
             ELSE       CMD(DO)                                                           /*CSC017*/
                CHGVAR     VAR(&TTLLIBS) VALUE(250)                                       /*CSC017*/
                CHGVAR     VAR(&LASTLIB) VALUE(2740)                                      /*CSC017*/
                CHGVAR     VAR(&TTLSPACE) VALUE(2751)                                     /*CSC017*/
             ENDDO                                                                        /*CSC017*/
 
/* Retrieve current library list */
             RTVJOBA    USRLIBL(&USRLIBL)
 
/* If a number of libraries has been requested then see if there is  */
/* enough library entries                                            */
             IF         COND(&NOOFLIBS *NE 0) THEN(DO)
/* Perform calculation to see if there is enough spaces in the       */
/* library list to allow the number of libraries to be added.        */
                CHGVAR     VAR(&REQSPACE) VALUE(&NOOFLIBS * 11)
/************   CHGVAR     VAR(&REQSPACE) VALUE(276 - &REQSPACE)                       */ /*CSC017*/
                CHGVAR     VAR(&REQSPACE) VALUE(&TTLSPACE - &REQSPACE)                    /*CSC017*/
/* REQSPACE is now the start point which would be needed to fit in   */
/* the number of libraries required; if this position in the user    */
/* library list is blank it means there is enough room.              */
                IF         COND(%SST(&USRLIBL &REQSPACE 1) *EQ ' ') +
                          THEN(DO)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
                ELSE       CMD(DO)
                   CHGVAR     VAR(&RETURN) VALUE('F')
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
             ENDDO
 
/* If specific libraries have been requested then check if there is  */
/* enough space in the list or if enough of the specified libraries  */
/* exist in the library list already.                                */
/* &NBR is number of libraries entered in command list               */
 
             CHGVAR     VAR(&NBRB) VALUE(%SST(&LIBS 1 2))
             CHGVAR     VAR(&NBR) VALUE(%BIN(&NBRB))
 
/* Find number of available spaces in library list                   */
/************CHGVAR     VAR(&START1) VALUE(265)                                        */ /*CSC017*/
             CHGVAR     VAR(&START1) VALUE(&LASTLIB)                                      /*CSC017*/
/* &AVAIL is the number of spaces available in the job's lib. list   */
             CHGVAR     VAR(&AVAIL) VALUE(0)
 
 AVAIL:
             IF         COND(%SST(&USRLIBL &START1 1) *EQ ' ') THEN(DO)
                CHGVAR     VAR(&AVAIL) VALUE(&AVAIL + 1)
                CHGVAR     VAR(&START1) VALUE(&START1 - 11)
                GOTO       CMDLBL(AVAIL)
             ENDDO
 
/* Occupied library spaces are 25 - AVAIL; this is used as one of    */
/* the controls for the next loop.                                   */
/************CHGVAR     VAR(&OCC) VALUE(25 - &AVAIL)                                   */ /*CSC017*/
             CHGVAR     VAR(&OCC) VALUE(&TTLLIBS - &AVAIL)                                /*CSC017*/
 
/* Check if any of the libraries exist in library list               */
/* &START2 is used to locate the starting point of library names in  */
/* the list entered in the command.                                  */
             CHGVAR     VAR(&START2) VALUE(3)
/* &START3 is used to locate the starting point of library names in  */
/* the current job's library list.                                   */
             CHGVAR     VAR(&START3) VALUE(1)
/* &LIBSCNT stores the number of libraries from the list entered in  */
/* the command that have been processed during the CHECK loop.       */
             CHGVAR     VAR(&LIBSCNT) VALUE(1)
/* &USRLIBCNT stores the number of libraries from the current job    */
/* library list that have been processed during the CHECK loop.      */
             CHGVAR     VAR(&USRLIBLCNT) VALUE(1)
 
/**                                                                 */
/* The following block of code loops through all of the requested   */
/* libraries and checks whether it is already in the user portion   */
/* of the library list.  If is is already there, the number of      */
/* needed spaces is effectively reduced by one.  At the end, needed */
/* and available spaces are compared to determine if the specified  */
/* libraries will fit.                                              */
/* At any time, if the available spaces are greater than the needed */
/* spaces, overall check is valid so simply exit.                   */
/* When a match is found, one of the requested libraries is in      */
/* *USRLIBL, so increase the relevant counts/pointers (including    */
/* the one of available spaces) and reset the *USRLIBL pointer to 1.*/
/* If a match is not found for the current *USRLIBL entry, go on to */
/* the next one.                                                    */
/* If a match is not found at all in *USRLIBL entry, go on to the   */
/* next requested library.                                          */
 
CHECK:
/* Available spaces > greater than needed spaces so exit            */
             IF         COND(&AVAIL *GE &NBR) THEN(GOTO +
                          CMDLBL(ENDPGM))
 
             IF         COND(&LIBSCNT *LE &NBR) THEN(DO)
/*  Loop around requested libraries                                 */
 
                IF         COND(&USRLIBLCNT *LE &OCC) THEN(DO)
/* Loop around *USRLIBL                                             */
 
                   IF COND(%SST(&LIBS &START2 10) *EQ +
                           %SST(&USRLIBL &START3 10)) THEN(DO)
/* Match found, requested libraries is in *USRLIBL                  */
                      CHGVAR     VAR(&AVAIL) VALUE(&AVAIL + 1)
                      CHGVAR     VAR(&START2) VALUE(&START2 + 10)
                      CHGVAR     VAR(&START3) VALUE(1)
                      CHGVAR     VAR(&LIBSCNT) VALUE(&LIBSCNT + 1)
                      CHGVAR     VAR(&USRLIBLCNT) VALUE(1)
                      GOTO CHECK
                   ENDDO
 
/* Match not found for current *USRLIBL entry, go on to next one    */
                   CHGVAR     VAR(&START3) VALUE(&START3 + 11)
                   CHGVAR     VAR(&USRLIBLCNT) VALUE(&USRLIBLCNT + 1)
                   GOTO CHECK
                ENDDO
 
/* Match not found at all in  *USRLIBL, go on to next requested lib */
                CHGVAR     VAR(&START2) VALUE(&START2 + 10)
                CHGVAR     VAR(&START3) VALUE(1)
                CHGVAR     VAR(&LIBSCNT) VALUE(&LIBSCNT + 1)
                CHGVAR     VAR(&USRLIBLCNT) VALUE(1)
                GOTO CHECK
             ENDDO
 
/* If AVAIL is less than the number required then set RETURN to      */
/* FAIL                                                              */
             IF         COND(&AVAIL *LT &NBR) THEN(DO)
                CHGVAR     VAR(&RETURN) VALUE('F')
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
ABNOR:
             SNDPGMMSG  MSG('Program CHKLIBLE ended abnormally; +
                          please check joblog') TOPGMQ(*EXT)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
