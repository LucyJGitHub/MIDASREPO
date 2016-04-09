/*********************************************************************/
/*XBI    OVRDBF FILE(UPSBSDOF) TOFILE(QADSPOBJ)                      */                   /*CPK017*/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change subsystem routing entries')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0120 - Change subsystem routing entries                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK017             Date 13Jun03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Prev Amend No. CUP016             Date 30Dec02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 29Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP013             Date 02Feb01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CUP011             Date 04Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 21Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK017 - Release 5 packaging.  Check subsystem has been     */
/*                renamed.                                           */
/*       CUP016 - Add implementation software to core.               */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CPK014 - Release 4 packaging.  Add RCVF.                    */
/*       CUP013 - Changes to error handling.                         */
/*       CUP011 - Change program to either pick up system ID from    */
/*                 Bridge ICD or a command prompt.                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&SBSID)                                                   */ /*CUP011*/
/************PGM                                                            */ /*CUP011*/ /*CUP016*/
             PGM        PARM(&SBSID)                                                      /*CUP016*/
 
/************DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                      */ /*CUP011*/ /*CUP016*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP016*/
 
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                      */ /*CUP011*/ /*CUP016*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBSYSTEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)                                */ /*CUP013*/
/************DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                              */ /*CUP013*/
/************DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)                                */ /*CUP013*/
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                      */ /*CUP011*/ /*CUP016*/
             DCLF       FILE(UPSBSDOF)                                                    /*CPK017*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/************CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)                                */ /*CUP016*/
/************CHGJOB     SWS(XXXXXX00)                                                  */ /*CUP016*/
 
/************RCVF                                                           */ /*CPK014*/ /*CUP016*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/                    /*CUP011*/ /*CUP016*/
/************IF         COND(&SBSID *EQ ' ') THEN(DO)                       */ /*CUP011*/ /*CUP016*/
/************   ?    SYSTEMID                                               */ /*CUP011*/ /*CUP016*/
/************   RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&SBSID)               */ /*CUP011*/ /*CUP016*/
/************ENDDO                                                          */ /*CUP011*/ /*CUP016*/
 
/* Set up library list */                                                                 /*CUP011*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP011*/
                                                                                          /*CUP011*/
/*RETRY:*****                                                                          */ /*CUP013*/
/*READNEXT:**                                                                             /*CUP013*/
             CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIB')
             CHGVAR     VAR(&SUBSYSTEM) VALUE('M' *TCAT &SBSID *TCAT +
                          'SBS')
 
/* Check to see if the susbsystem is correctly named yet. */                              /*CPK017*/
             CHKOBJ     OBJ(&XLIB/&SUBSYSTEM) OBJTYPE(*SBSD)                              /*CPK017*/
/* If it is not found the attempt to find it in the XLIB and rename it. */                /*CPK017*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK017*/
                DSPOBJD    OBJ(&XLIB/*ALL) OBJTYPE(*SBSD) +
                             OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPSBSDOF)                     /*CPK017*/
                RCVF                                                                      /*CPK017*/
                ?          RNMOBJ OBJ(&XLIB/&ODOBNM) OBJTYPE(*SBSD) +
                             NEWOBJ(&SUBSYSTEM) ?-ASPDEV(*)                               /*CPK017*/
                MONMSG     MSGID(CPF6801) EXEC(DO)                                        /*CPK017*/
                   GOTO       CMDLBL(END)                                                 /*CPK017*/
                ENDDO                                                                     /*CPK017*/
             ENDDO                                                                        /*CPK017*/
 
/* Display subsystem description to print */
             DSPSBSD    SBSD(&XLIB/&SUBSYSTEM) OUTPUT(*PRINT)
 
/* Create physical file to receive subsystem data */
             DLTF       FILE(QTEMP/UPSBSD)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/UPSBSD) RCDLEN(132) TEXT('Midas +
                          UP Subsystem description - from spool file')
 
/* Copy spool file to physical file */
             CPYSPLF    FILE(QPRTSBSD) TOFILE(QTEMP/UPSBSD) +
                          SPLNBR(*LAST)
 
/* Call program to process file and change routing entries */
             CHGVAR     VAR(&ERROR) VALUE(' ')
             CALL       PGM(UP0120) PARM(&SBSID &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/**Error*handling*brought*in*through /COPY**/ /*                                       */ /*CUP013*/
/************IF         COND(&RECURSIVE *NE 'Y') THEN(DO)                              */ /*CUP016*/
/************   CHGVAR     VAR(&RECURSIVE) VALUE('Y')                                  */ /*CUP016*/
/************   RTVMSG  MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0120) +                  */ /*CUP013*/
/************             MSG(&MESSAGE)                                                */ /*CUP013*/
/**COPY*UPCPYSRC,C_UPERRA                                            */ /*             */ /*CUP013*/
/************   SNDPGMMSG  MSGID(UPM0002) MSGF(UTMSGF) +                               */ /*CUP016*/
/************             MSGDTA('UPC0120') MSGTYPE(*ESCAPE)                */ /*CUP013*/ /*CUP016*/
/************ENDDO                                                                     */ /*CUP016*/
 
             CHGJOB     SWS(XXXXXX11)                                                     /*CUP016*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
