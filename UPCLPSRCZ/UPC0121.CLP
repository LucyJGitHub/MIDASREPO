/*********************************************************************/
/*X*I****OVRDBF*FILE(UPSBSDOF)*TOFILE(QADSPOBJ)***********************/ /*             */ /*CUP033*/
/*XBI    OVRDBF FILE(UPSBSDOF) TOFILE(UPOBJDTPD)                     */                   /*CUP033*/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change subsystem routing entries -classes')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0121 - Change subsystem routing entries - classes        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK017             Date 13Jun03              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 29Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CUP013             Date 02Feb01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CUP011 *CREATE     Date 04Oct00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK017 - Release 5 packaging.  Check subsystem has been     */
/*                renamed.                                           */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CPK014 - Release 4 packaging.  Add RCVF.                    */
/*       CUP013 - Changes to error handling.                         */
/*       CUP011 - New program to change the library reference for    */
/*                 classes in a subsystem.                           */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL)                                                    /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                 */ /*CUP033*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBSYSTEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)                                */ /*CUP013*/
/************DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                              */ /*CUP013*/
/************DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)                                */ /*CUP013*/
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
/**********  DCLF       FILE(UPSBSDOF)                                      */ /*CPK017*/ /*CUP033*/
             DCLF       FILE(UPSBSDOF) OPNID(A)                                           /*CUP033*/
             DCLF       FILE(UPSVALJ0) OPNID(B)                                           /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ') THEN(DO)                                  */ /*CUP033*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF       OPNID(B)                                                          /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&B_GISVAL *EQ &PFXSVAL) THEN(DO)                             /*CUP033*/
                IF         COND(&B_GIVAL *EQ ' ') THEN(DO)                                /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&B_GIVAL)                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                ?    SYSTEMID
                MONMSG     MSGID(CPF6801) EXEC(DO)                                        /*CUP033*/
                   GOTO       CMDLBL(END)                                                 /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&SBSID)
             ENDDO
 
/* Set up library list */
             CALL       PGM(UPC0014) PARM(&SBSID)
 
/*RETRY:*****                                                                          */ /*CUP013*/
/*READNEXT:**                                                                          */ /*CUP013*/
             CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIB')
             CHGVAR     VAR(&SUBSYSTEM) VALUE('M' *TCAT &SBSID *TCAT +
                          'SBS')
 
/* Check to see if the susbsystem is correctly named yet. */                              /*CPK017*/
             CHKOBJ     OBJ(&XLIB/&SUBSYSTEM) OBJTYPE(*SBSD)                              /*CPK017*/
/* If it is not found the attempt to find it in the XLIB and rename it. */                /*CPK017*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK017*/
/**********     DSPOBJD    OBJ(&XLIB/*ALL))OBJTYPE(*SBSD) +                            */ /*CUP033*/
/**********                  OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPSBSDOF)       */ /*CPK017*/ /*CUP033*/
                DSPOBJD    OBJ(&XLIB/*ALL) OBJTYPE(*SBSD) +
                             OUTPUT(*OUTFILE) OUTFILE(UPOBJDTPD)                          /*CUP033*/
                CPYF       FROMFILE(UPOBJDTPD) TOFILE(QTEMP/UPSBSDOF) +
                             MBROPT(*REPLACE) CRTFILE(*YES)                               /*CUP033*/
/**********     RCVF                                                        */ /*CPK017*/ /*CUP033*/
/**********     ?          RNMOBJ OBJ(&XLIB/&ODOBNM))OBJTYPE(*SBSD) +                  */ /*CUP033*/
/**********                  NEWOBJ(&SUBSYSTEM) ?-ASPDEV(*)                 */ /*CPK017*/ /*CUP033*/
                RCVF       OPNID(A)                                                       /*CUP033*/
                ?          RNMOBJ OBJ(&XLIB/&A_ODOBNM) OBJTYPE(*SBSD) +
                             NEWOBJ(&SUBSYSTEM) ?-ASPDEV(*)                               /*CUP033*/
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
             CALL       PGM(UP0121) PARM(&SBSID &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/**Error*handling*brought*in*through /COPY**/ /*                                       */ /*CUP013*/
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
/************   RTVMSG  MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(UPC0121) +                  */ /*CUP013*/
/************             MSG(&MESSAGE)                                                */ /*CUP013*/
/**COPY*UPCPYSRC,C_UPERRA                                            */ /*             */ /*CUP013*/
                SNDPGMMSG  MSGID(UPM0002) MSGF(UTMSGF) +
                          MSGDTA('UPC0121') MSGTYPE(*ESCAPE)                              /*CUP013*/
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
