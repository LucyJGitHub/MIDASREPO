/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CL for SWIFT Msg Transmission Closedown')       */
/*********************************************************************/
/*                                                                   */
/*       Midas S.W.I.F.T. DIRECT LINK                            */
/*                                                                   */
/*     MSC4015 - S.W.I.F.T. MESSAGE TRANSMISSION CLOSEDOWN           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSW095             Date 07Apr95              */
/*                   S01408             DATE 05MAY95                 */
/*                   S01179             DATE 12/09/88                */
/*                   E12831             DATE 31/05/88                */
/*                   E11657             DATE 23/09/87                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     CPK014 - Release 4 packaging.  Move data queues from XLIB to  */
/*               DPLIB.                                              */
/*     S01408 - Addition of core hook MSC4015MP1                     */
/*     CSW095 - S.W.I.F.T. 1995 Message Changes.                     */
/*              Increase DTQB from 1019 to 1021.                     */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400            */
/*     E12831 - TERMINATE MESSAGE COMPRESSION PROGRAM BEFORE         */
/*              RESETTING MESSAGE STATUSES                           */
/*     E11657 - VALUE OF VARIABLE &LIB SHOULD BE SET TO XLIB;        */
/*              NOT WORK                                             */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/*     DECLARE VARIABLES AND DATA AREA                               */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*                                                                   */
/*   DCL        VAR(&LIB) TYPE(*CHAR) LEN(6) VALUE('  WORK') */      /*E11657*/
      DCL        VAR(&LIB) TYPE(*CHAR) LEN(6) VALUE('  XLIB')        /*E11657*/
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
/*           DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/*                                                                   */
/*     Audit message to MRUNQ                                        */
/*                                                                   */
             SNDPGMMSG  MSG('SWIFT Communications Error Report') +
                          TOMSGQ(MRUNQ)
/*                                                        */          /*E12831*/
/* Send termination message to MS0200                     */          /*E12831*/
/*                                                        */          /*E12831*/
             CALL       PGM(QSNDDTAQ) +
                        PARM(MSDTQA *LIBL X'00001F' T)                /*E12831*/
/*                                                        */          /*E12831*/
/* Wait for MS0200 to terminate                           */          /*E12831*/
/*                                                        */          /*E12831*/
ALCOBJ1:     ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(30)          /*E12831*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO ALCOBJ1)             /*E12831*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                   /*E12831*/
/*                                                                   */
/*     DELETE THEN RECREATE DATA QUEUES                              */
/*                                                                   */
/*           RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT)  RTNVAR(&SDSTAT)               /*S01179*/
             CHGVAR     VAR(&SYS) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(%SST(&LIB 1 2)) VALUE(&SYS)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC4015MP1                                          */
                                                                      /*S01408*/
/************DLTDTAQ    DTAQ(&LIB/MSDTQA)                                                 /*CPK014*/
/************DLTDTAQ    DTAQ(&LIB/MSDTQB)                                                 /*CPK014*/
/************                                                        */                   /*CPK014*/
/************CRTDTAQ    DTAQ(&LIB/MSDTQA) MAXLEN(1) TEXT('MIDAS/SWIFT +                   /*CPK014*/
/************             - USED TO ACTIVATE COMPRESSION PROGRAM')                        /*CPK014*/
/************CRTDTAQ    DTAQ(&LIB/MSDTQB) MAXLEN(1021) +                                  /*CPK014*/
/************             TEXT('MIDAS/SWIFT - HOLDS MESSAGES TO BE +                      /*CPK014*/
/************             TRANSMITTED')                                        /*CSW095*/ /*CPK014*/
/*********** CRTDTAQ    DTAQ(&LIB/MSDTQB) MAXLEN(1019) +
                          TEXT('MIDAS/SWIFT - HOLDS MESSAGES TO BE +
                          TRANSMITTED')                               /*CSW095*/
 
             CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                             /*CPK014*/
/*                                                                   */
/*   CALL MS4015 THEN END PROGRAM                                    */
/*                                                                   */
             CALL       PGM(MS4015)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
