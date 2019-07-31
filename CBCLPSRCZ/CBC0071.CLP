/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Save/restore COB files for NDSU BOB save')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0071 - Save/Restore COB Data for BOB Save Restore.       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSC012             Date 18Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 102672             Date 21MAY96              */
/*                      102353             Date 21May96              */
/*                      102354             Date 15MAY96              */
/*                      097895  *CREATE    Date 02JAN96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC012 - Movement of files from DTALIB.  Release 4 change.  */
/*       102672 - Only run pgm SDC1775 to rebuild access paths if    */
/*                pgm is run in 'Restore' mode.                      */
/*       102353 - Check for folder not found message (CPF8A77) as    */
/*                well as document not found message (CPF8A82) when  */
/*                deleting Trader Support/Transaction marker doc.    */
/*       102354 - Delete data area XCBRUN before attempting to       */
/*                create a duplicate object of CBRUN.                */
/*       097895 - New program to save and restore the COB processing */
/*                files and dataareas to allow the BOB save to be    */
/*                restored and the COB run from that point.          */
/*                Additionally it attempts to delete a Trader        */
/*                marker document, and to rebuild the access paths   */
/*                for all unique-keyed logicals.                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RTNCODE)
 
/*/COPY WNCPYSRC,CBC0071INT                                          */
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE(XXDMLIB)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE(XXDPLIB)
/************DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10) +                             */ /*CSC012*/
/************             VALUE(XXDTALIB)                                              */ /*CSC012*/
             DCL        VAR(&XCBRUN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TSFOLDER) TYPE(*CHAR) LEN(5) +
                          VALUE('TSM  ') /* Trader Support folder +
                          name */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7) /* Message ID */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Setup database library names */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&PREFIX)
             CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(&PREFIX)
/************CHGVAR     VAR(%SST(&DTALIB 1 2)) VALUE(&PREFIX)                          */ /*CSC012*/
 
/*/COPY WNCPYSRC,CBC0071MPS                                          */
 
/* Save of COB data mode */
 
             IF         COND(&MODE *EQ 'S') THEN(DO)
 
/* Save COB components runtime file */
 
                CPYF       FROMFILE(CBCOMSPD) +
                             TOFILE(&DMLIB/XCBCOMSPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
 
/* Update BOB save component to failed status */
 
                OVRDBF     FILE(XCBCOMS) TOFILE(XCBCOMSPD)
 
                CALL       PGM(CB0071) PARM(&RTNCODE)
 
                IF         COND(&RTNCODE *EQ 'FAIL') THEN(GOTO +
                             CMDLBL(ABNOR))
 
/* Save COB data area */
 
                DLTDTAARA  DTAARA(&DMLIB/XCBRUN)                      /*102354*/
                MONMSG     MSGID(CPF0000)                             /*102354*/
                CRTDUPOBJ  OBJ(CBRUN) FROMLIB(&DPLIB) +
                             OBJTYPE(*DTAARA) TOLIB(&DMLIB) +
                             NEWOBJ(XCBRUN)
 
             ENDDO
 
/* Restore of COB data mode */
 
             IF         COND(&MODE *EQ 'R') THEN(DO)
 
/* Restore modified COB components runtime file */
 
/************   CPYF       FROMFILE(XCBCOMSPD) +                                       */ /*CSC012*/
/************                TOFILE(&DTALIB/CBCOMSPD) +                                */ /*CSC012*/
/************                MBROPT(*REPLACE) CRTFILE(*NO)                             */ /*CSC012*/
                CPYF       FROMFILE(XCBCOMSPD) TOFILE(&DPLIB/CBCOMSPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)                                   /*CSC012*/
 
/* Restore COB data area */
 
                RTVDTAARA  DTAARA(XCBRUN) RTNVAR(&XCBRUN)
 
                CHGDTAARA  DTAARA(CBRUN *ALL) VALUE(&XCBRUN)
 
/* Set number of failed components on CBSTAT to 1 */
 
                CHGDTAARA  DTAARA(CBSTAT (14 4)) VALUE('001N')
 
/* Call the program to perform interactive rebuild of all +           /*102672*/
/* unique-keyed access paths.  Note that, although supposedly +       /*102672*/
/* interactive, this program submits four batch jobs, each called +   /*102672*/
/* ALL_FILES.                                                         /*102672*/
             CALL       PGM(SDC1775) PARM('*INTERACT' '*UNIQUE')      /*102672*/
                                                                      /*102672*/
             ENDDO
 
/* Set MSPECIAL to 'EOD' */
 
             CLRMSGQ    MSGQ(MSPECIAL)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG(EOD) TOMSGQ(MSPECIAL)
 
/* Delete the Trader Support/Transaction Interface marker document, +
   if it is present */
             CHGVAR     VAR(%SST(&TSFOLDER 4 2)) VALUE(&PREFIX)
             DLTDLO     DLO(COBFIN.TSM) FLR(&TSFOLDER)
 
/**Monitor*for*the*create*failing;*if*it*does*fail,*receive*the +  */ /*102353*/
/**most*recent*diagnostic*message.**If*this*is*NOT*CPF8A82*+**     */ /*102353*/
/**(document*not*found*in*folder)*then*there*is*an*error.**        */ /*102353*/
                                                                      /*102353*/
/* Monitor for the delete failing; if it does fail, receive the +     /*102353*/
/* most recent diagnostic message. If this is NOT CPF8A82 (document + /*102353*/
/* not found in folder) or CPF8A77 (folder not found) then there      /*102353*/
/* is an error.                                                       /*102353*/
             MONMSG     MSGID(CPF8A16) EXEC(DO)
                RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSGID(&MSGID)
/***************IF         COND(&MSGID *NE 'CPF8A82') THEN(GOTO +  */ /*102353*/
/***************             CMDLBL(ABNOR))                        */ /*102353*/
                IF         COND(&MSGID *NE 'CPF8A82' *AND &MSGID +
                             *NE 'CPF8A77') THEN(GOTO CMDLBL(ABNOR))  /*102353*/
             ENDDO
 
/**Call*the*program to perform interactive rebuild of all +        */ /*102672*/
/**unique-keyed*access paths.  Note that, although supposedly +    */ /*102672*/
/**interactive,*this program submits four batch jobs, each called +*/ /*102672*/
/**ALL_FILES.***                                                   */ /*102672*/
/************CALL       PGM(SDC1775) PARM('*INTERACT' '*UNIQUE')   */ /*102672*/
 
/*/COPY WNCPYSRC,CBC0071MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,CBC0071ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CBC0071 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,CBC0071END                                          */
 
             DLTOVR     FILE(XCBCOMSPD)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
