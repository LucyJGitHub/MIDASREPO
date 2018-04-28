/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Comms/compression programs term.')           */
/********************************************************************/
/*                                                                  */
/*     Midas - S.W.I.F.T. DIRECT LINK                               */
/*                                                                  */
/*     MSC4002 - COMMUNICATIONS/COMPRESSION PROGRAMS TERMINATION.   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 164062             Date 25Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                   CSW095            DATE 07APR95                 */
/*                   S01408            DATE 05MAY95                 */
/*                   CCB001            DATE 08JUN95                 */
/*                   S01436            DATE 28JUL93                 */
/*                   E38678            DATE 22APR92                 */
/*                   S01251            DATE 03FEB90                 */
/*                   E17524            DATE 10/04/89                */
/*                   S01192            DATE 30/01/89                */
/*                   E11801            DATE 18/03/88                */
/*                                                                  */
/*********************************************************************/
/*     CPK014 - Release 4 packaging.  Move data queues from XLIB to  */
/*               DPLIB.                                              */
/*     164062 - MSC5030 does not end if MSC4010 ends abnormally,     */
/*              causing COB to crash. Fix is to add termination      */
/*              processing for MSC5030.                              */
/*     CSW095 - S.W.I.F.T. 1995 Message Changes.                     */
/*              Increase DTQB from 1019 to 1021.                     */
/*     S01408 - Addition of core hook MSC4002MP1                     */
/*     CCB001 - Replace interactive message to allow this program    */
/*              to run in batch.                                     */
/*     S01436 - Addition of Switchable Feature for Comms Program     */
/*              for ST400. Delete and Re-create dtaara MSDTQE.       */
/*     E38678 - CHANGE REFERENCE OF SDMSDLPD TO SDMGMEPD             */
/*     S01251 - THIS HAS BEEN PUT IN BY S01117                       */
/*              SYNON FIELD/PROGRAM NAME CHANGES                     */
/*     E17524 - UNFRIENDLY ERROR PROMPT.                             */
/*     E11801 - Allocation of a data area instead of a program object*/
/*              to avoid conflict with other systems on the same     */
/*              machine.                                             */
/*     S01192 - 2780 Protocol link does not require termination of   */
/*              communications program.                              */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6) VALUE('  XLIB')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CCB001*/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSC0200) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&MSC4010) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&CJNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CJNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CTIMMIN) TYPE(*DEC) LEN(4 0) VALUE(0)
             DCL        VAR(&LTIMMIN) TYPE(*DEC) LEN(4 0) VALUE(0)
             DCL        VAR(&TIMWKN) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&DIF) TYPE(*DEC) LEN(4 0) VALUE(0)
             DCL        VAR(&TIMWKA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RPYVAL) TYPE(*CHAR) LEN(4)
/*           DCLF       FILE(SDMSDLL1)                                /*E38678*/
             DCLF       FILE(SDMGMEL1)                                /*E38678*/
/**/                                                                  /*S01436*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01436*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*01436*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01436') /*S01436*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*S01436*/
/*                                                                 */ /*S01436*/
             DCL        VAR(&DTQC) TYPE(*CHAR) LEN(10)                /*164062*/
             DCL        VAR(&LIBC) TYPE(*CHAR) LEN(10)                /*164062*/
             DCL        VAR(&DAC) TYPE(*CHAR) LEN(1)                  /*164062*/
             DCL        VAR(&LENC) TYPE(*DEC) LEN(5 0)                /*164062*/
/*/COPY WNCPYSRC,MSC4002005                                          */
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*/COPY WNCPYSRC,MSC4002001                                          */
/*                                                                  */
             SNDPGMMSG  MSG('SWIFT Communications/Compression +
                          Programs Termination') TOMSGQ(MRUNQ)
/*                                                                  */
/* Obtain the system identifier and set up &XLIB to be used as LIB  */
/*                                                                  */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&XLIB) VALUE(&SYSID *CAT 'XLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC4002MP1                                          */
                                                                      /*S01408*/
/*                                                                 */ /*S01192*/
/* Retrieve protocol parameter from ICD                            */ /*S01192*/
/*                                                                 */ /*S01192*/
             RCVF                                                     /*S01192*/
/*/COPY WNCPYSRC,MSC4002003                                          */
/*********** IF         COND(&BSKHST *EQ '2780') THEN(DO)      /*S01192 S01117*/
/*           IF         COND(&BSPRUS *EQ '2780') THEN(DO)             /*E38678*/
             IF         COND(&ENPRUS *EQ '2780') THEN(DO)             /*E38678*/
/*                                                                 */ /*S01192*/
/**Clear*dataq*MSDTQA*by*deleting*and*recreating*it                         */ /*S01192*/ /*CPK014*/
/* Clear data queue MSDTQA. */                                                            /*CPK014*/
/*                                                                 */ /*S01192*/
/************         DLTDTAQ    DTAQ(MSDTQA)                                  /*S01192*/ /*CPK014*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQA) MAXLEN(1) +                           /*CPK014*/
/************                    AUT(*CHANGE)                                  /*S01192*/ /*CPK014*/
                      CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                    /*CPK014*/
                      GOTO       CMDLBL(END)                          /*S01192*/
             ENDDO                                                    /*S01192*/
/*                                                                   */
/* If Compression Program is Active (Can not be allocated), set      */
/* flag for further conditioning of processing.                      */
/*                                                                   */
/********    ALCOBJ     OBJ((MS0200 *PGM *EXCL)) WAIT(1)   *******/   /*E11801*/
             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(1)           /*E11801*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CHGVAR     VAR(&MSC0200) VALUE(Y)
             ENDDO
/*                                                                   */
/* If Transmission Program is Active (Can not be allocated), set     */
/* flag for further conditioning of processing.                      */
/*                                                                   */
/********    ALCOBJ     OBJ((MS4010 *PGM *EXCL)) WAIT(1)    ******/   /*E11801*/
             ALCOBJ     OBJ((MS4010 *DTAARA *EXCL)) WAIT(1)           /*R11801*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
                CHGVAR     VAR(&MSC4010) VALUE(Y)
             ENDDO
/*                                                                   */
/* If MS0200 is active and MS4010 active, execute the following      */
/*                                                                   */
             IF         COND(&MSC0200 *EQ 'Y' *AND &MSC4010 *EQ 'Y') +
                          THEN(DO)
/*                                                                   */
/* Send termination message to MS0200                                */
/*                                                                   */
               CALL       PGM(QSNDDTAQ) PARM(MSDTQA *LIBL X'00001F' T)
/*                                                                   */
/* Wait for MS0200 to terminate                                      */
/*                                                                   */
/*ALCOBJ1:        ALCOBJ     OBJ((MS0200 *PGM *EXCL)) WAIT(30) *****/ /*E11801*/
ALCOBJ1:        ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(30)       /*E11801*/
                MONMSG     MSGID(CPF0000) EXEC(GOTO ALCOBJ1)
/*                                                                   */
/* Wait for MS4010 to terminate                                      */
/*                                                                   */
/*ALCOBJ2:        ALCOBJ     OBJ((MS4010 *PGM *EXCL)) WAIT(30)  *****  *E11801*/
ALCOBJ2:        ALCOBJ     OBJ((MS4010 *DTAARA *EXCL)) WAIT(30)       /*E11801*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
/*                                                                   */
/* Access machine time                                               */
/*                                                                   */
                RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&CTIME)
/*                                                                   */
/* Convert current time to minutes                                   */
/*                                                                   */
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&CTIME 1 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&CTIMMIN) VALUE(&TIMWKN * 60)
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&CTIME 3 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&CTIMMIN) VALUE(&CTIMMIN + &TIMWKN)
/*                                                                   */
/* Access last time of change from MSSTAT                            */
/*                                                                   */
                   RTVDTAARA  DTAARA(MSSTAT (53 4)) RTNVAR(&LTIME)
/*                                                                   */
/* Convert last time from MSSTAT to minutes                          */
/*                                                                   */
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&LTIME 1 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&LTIMMIN) VALUE(&TIMWKN * 60)
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&LTIME 3 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&LTIMMIN) VALUE(&LTIMMIN + &TIMWKN)
/*                                                                   */
/* Subtract last time from current time                              */
/*                                                                   */
                   CHGVAR     VAR(&DIF) VALUE(&CTIMMIN - &LTIMMIN)
/*                                                                   */
/* If &DIF is negative, add 1440 to &DIF to allow for working        */
/* through midnight.                                                 */
/*                                                                   */
             IF         COND(&DIF *LE 0) THEN(DO)
                CHGVAR     VAR(&DIF) VALUE(&DIF + 1440)
             ENDDO
/*                                                                   */
/* If greater than fifteen minutes, prompt to allow cancelation of   */
/* transmission pgm                                                  */
/*                                                                   */
                   IF         COND(&DIF *GT 15) THEN(DO)
/*E17524*/                                                            /*E17524*/
/*           SNDUSRMSG  MSG('Possible problem with Transmission to +*/
/*                        S.W.I.F.T. network - see Appendix A of +  */
/*                        instruction manual)') VALUES(Y N) DFT(N) +*/
/*                        TOMSGQ(*EXT) MSGRPY(&RPYVAL)              */
/**********  SNDUSRMSG  MSG('Possible problem with Transmission to +
/**********               S.W.I.F.T. network - Enter Y to end +
/**********               communication or N to retry') VALUES(Y N) +
/**********               DFT(N) TOMSGQ(*EXT) MSGRPY(&RPYVAL)         /*CCB001*/
                      SNDUSRMSG  MSG('Possible problem with +
                                   transmission to +
                                   S.W.I.F.T. network.') +
                                   TOMSGQ(MOPERQ)                     /*CBC001*/
/*E17524*/                                                            /*E17524*/
/**********           IF         COND(&RPYVAL *EQ 'Y   ') THEN(DO)    /*CCB001*/
/*                                                                   */
/* Cancel Transmission program                                       */
/*                                                                   */
                      RTVDTAARA  DTAARA(MSSTAT (1 51)) RTNVAR(&MSSTAT)
                      CHGVAR     VAR(&CJNAM) VALUE(%SST(&MSSTAT 26 10))
                      CHGVAR     VAR(&CUNAM) VALUE(%SST(&MSSTAT 36 10))
                      CHGVAR     VAR(&CJNO) VALUE(%SST(&MSSTAT 46 6))
                      ENDJOB  JOB(&CJNO/&CUNAM/&CJNAM) OPTION(*IMMED)
                      CHGDTAARA  DTAARA(MSSTAT (23 1)) VALUE('N')
                      CHGDTAARA  DTAARA(MSSTAT (26 27)) VALUE(' ')
/*                                                                   */
/* Reset status's of messages not transmitted                        */
/*                                                                   */
                      CALL       PGM(MS4015)
/************                                                        */                   /*CPK014*/
/**Clear*dataq*MSDTQA*by*deleting*and*recreating*it                  */                   /*CPK014*/
/************                                                        */                   /*CPK014*/
/************         DLTDTAQ    DTAQ(MSDTQA)                                             /*CPK014*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQA) MAXLEN(1) +                           /*CPK014*/
/************                    AUT(*CHANGE)                                             /*CPK014*/
 
/* Clear data queue MSDTQA. */                                                            /*CPK014*/
                      CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                    /*CPK014*/
 
/************                                                        */                   /*CPK014*/
/**Clear*dataq*MSDTQB*by*deleting*and*recreating*it                  */                   /*CPK014*/
/************                                                        */                   /*CPK014*/
/************         DLTDTAQ    DTAQ(MSDTQB)                                          */ /*CPK014*/
/***********          CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1019) +                        /*CSW095*/
/************                    AUT(*CHANGE)                                             /*CSW095*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1021) +                        /*CPK014*/
/************                    AUT(*CHANGE)                                  /*CSW095*/ /*CPK014*/
 
/* Clear data queue MSDTQB. */                                                            /*CPK014*/
                      CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                    /*CPK014*/
 
/**********           ENDDO **/                                       /*CCB001*/
/**********           ELSE (DO) **/                                   /*CCB001*/
/* Goto ALCOBJ2                       */
/**********           GOTO       CMDLBL(ALCOBJ2) **/                  /*CCB001*/
/**********           ENDDO **/                                       /*CCB001*/
                   ENDDO
                ELSE (DO)
/* Goto ALCOBJ2                       */
                   GOTO       CMDLBL(ALCOBJ2)
                ENDDO
/*******        DLCOBJ     OBJ((MS4010 *PGM *EXCL))          ********  *E11801*/
                DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                /*E11801*/
                ENDDO
             ENDDO
/*                                                                   */
/* If MS0200 active and MS4010 not active, execute the following     */
/*                                                                   */
             IF         COND(&MSC0200 *EQ 'Y' *AND &MSC4010 *EQ 'N') +
                          THEN(DO)
/*                                                                   */
/* Send termination message to MS0200                                */
/*                                                                   */
               CALL       PGM(QSNDDTAQ) PARM(MSDTQA *LIBL X'00001F' T)
/*                                                                   */
/* Wait for MS0200 to terminate                                      */
/*                                                                   */
/*ALCOBJ3:       ALCOBJ     OBJ((MS0200 *PGM *EXCL)) WAIT(30)  ******  *E11801*/
ALCOBJ3:       ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(30)        /*E11801*/
               MONMSG     MSGID(CPF0000) EXEC(GOTO ALCOBJ3)
/*                                                                   */
/* Reset message status's and clear msdtqb                           */
/*                                                                   */
               CALL       PGM(MS4015)
/************  DLTDTAQ    DTAQ(MSDTQB)                                                    /*CPK014*/
/***********   CRTDTAQ  DTAQ(&XLIB/MSDTQB) MAXLEN(1019) AUT(*CHANGE)  /*CSW095*/
/************  CRTDTAQ  DTAQ(&XLIB/MSDTQB) MAXLEN(1021) AUT(*CHANGE)           /*CSW095*/ /*CPK014*/
               CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                           /*CPK014*/
             ENDDO
/*                                                                   */
/* If MS0200 not active and MS4010 active, execute the following     */
/*                                                                   */
             IF         COND(&MSC0200 *EQ 'N' *AND &MSC4010 *EQ 'Y') +
                          THEN(DO)
/*                                                                   */
/* Send termination message to MS0200                                */
/*                                                                   */
              CALL       PGM(QSNDDTAQ) PARM(MSDTQB *LIBL X'00003F' T00)
/*                                                                   */
/* Wait for MS4010 to terminate                                      */
/*                                                                   */
/*ALCOBJ4:        ALCOBJ     OBJ((MS4010 *PGM *EXCL)) WAIT(30)  *****  *E11801*/
ALCOBJ4:        ALCOBJ     OBJ((MS4010 *DTAARA *EXCL)) WAIT(30)       /*E11801*/
                MONMSG     MSGID(CPF0000) EXEC(DO)
/*                                                                   */
/* Access machine time                                               */
/*                                                                   */
                RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&CTIME)
/*                                                                   */
/* Convert current time to minutes                                   */
/*                                                                   */
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&CTIME 1 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&CTIMMIN) VALUE(&TIMWKN * 60)
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&CTIME 3 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&CTIMMIN) VALUE(&CTIMMIN + &TIMWKN)
/*                                                                   */
/* Access last time of change from MSSTAT                            */
/*                                                                   */
                   RTVDTAARA  DTAARA(MSSTAT (53 4)) RTNVAR(&LTIME)
/*                                                                   */
/* Convert last time from MSSTAT to minutes                          */
/*                                                                   */
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&LTIME 1 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&LTIMMIN) VALUE(&TIMWKN * 60)
                   CHGVAR     VAR(&TIMWKA) VALUE(%SST(&LTIME 3 2))
                   CHGVAR     VAR(&TIMWKN) VALUE(&TIMWKA)
                   CHGVAR     VAR(&LTIMMIN) VALUE(&LTIMMIN + &TIMWKN)
/*                                                                   */
/* Subtract last time from current time                              */
/*                                                                   */
                   CHGVAR     VAR(&DIF) VALUE(&CTIMMIN - &LTIMMIN)
/*                                                                   */
/* If &DIF is negative, add 1440 to &DIF to allow for working        */
/* through midnight.                                                 */
/*                                                                   */
                  IF         COND(&DIF *LE 0) THEN(DO)
                     CHGVAR     VAR(&DIF) VALUE(&DIF + 1440)
                  ENDDO
/*                                                                   */
/* If greater than fifteen minutes, prompt to allow cancelation of   */
/* transmission pgm                                                  */
/*                                                                   */
                   IF         COND(&DIF *GT 15) THEN(DO)
/*E17524*/                                                            /*E17524*/
/*           SNDUSRMSG  MSG('Possible problem with Transmission to + */
/*                        S.W.I.F.T. network - see Appendix A of +   */
/*                        instruction manual)') VALUES(Y N) DFT(N) + */
/*                        TOMSGQ(*EXT) MSGRPY(&RPYVAL)               */
             SNDUSRMSG  MSG('Possible problem with Transmission to +
                          S.W.I.F.T. network - Enter Y to end +
                          communication or N to retry') VALUES(Y N) +
                          DFT(N) TOMSGQ(*EXT) MSGRPY(&RPYVAL)
/*E17524*/                                                            /*E17524*/
                      IF         COND(&RPYVAL *EQ 'Y   ') THEN(DO)
/*                                                                   */
/* Cancel Transmission program                                       */
/*                                                                   */
                      RTVDTAARA  DTAARA(MSSTAT (1 51)) RTNVAR(&MSSTAT)
                      CHGVAR     VAR(&CJNAM) VALUE(%SST(&MSSTAT 26 10))
                      CHGVAR     VAR(&CUNAM) VALUE(%SST(&MSSTAT 36 10))
                      CHGVAR     VAR(&CJNO) VALUE(%SST(&MSSTAT 46 6))
                      ENDJOB  JOB(&CJNO/&CUNAM/&CJNAM) OPTION(*IMMED)
                      CHGDTAARA  DTAARA(MSSTAT (23 1)) VALUE('N')
                      CHGDTAARA  DTAARA(MSSTAT (26 27)) VALUE(' ')
                      CALL       PGM(MS4015)
/************                                                        */                   /*CPK014*/
/**Clear*dataq*MSDTQB*by*deleting*and*recreating*it                  */                   /*CPK014*/
/************                                                        */                   /*CPK014*/
/************         DLTDTAQ    DTAQ(MSDTQB)                                             /*CPK014*/
/***********          CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1019) +                        /*CSW095*/
/************                    AUT(*CHANGE)                                             /*CSW095*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1021) +                        /*CPK014*/
/************                    AUT(*CHANGE)                                  /*CSW095*/ /*CPK014*/
 
/* Clear data queue MSDTQB. */                                                            /*CPK014*/
                      CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                    /*CPK014*/
                                                                      /*164062*/
/*   Send 'T' to MSDTQD, in order to stop reference generation         *164062*/
/*   and stop MSC5030.                                                 *164062*/
             CHGVAR     VAR(&DTQC) VALUE('MSDTQD')                    /*164062*/
             CHGVAR     VAR(&LIBC) VALUE('*LIBL')                     /*164062*/
             CHGVAR     VAR(&LENC) VALUE(1)                           /*164062*/
             CHGVAR     VAR(&DAC) VALUE('T')                          /*164062*/
             CALL       PGM(QSNDDTAQ) PARM(&DTQC &LIBC &LENC &DAC)    /*164062*/
                                                                      /*164062*/
                      ENDDO
                      ELSE (DO)
/* Goto ALCOBJ4                       */
                      GOTO       CMDLBL(ALCOBJ4)
                      ENDDO
                   ENDDO
                ELSE (DO)
/* Goto ALCOBJ4                       */
                   GOTO       CMDLBL(ALCOBJ4)
                ENDDO
/********       DLCOBJ     OBJ((MS4010 *PGM *EXCL))           *******  *E11801*/
                DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                /*E11801*/
                ENDDO
             ENDDO
/************                                                        */                   /*CPK014*/
/**Clear*dataq*MSDTQA*by*deleting*and*recreating*it                  */                   /*CPK014*/
/************                                                        */                   /*CPK014*/
/************DLTDTAQ    DTAQ(MSDTQA)                                                      /*CPK014*/
/************CRTDTAQ    DTAQ(&XLIB/MSDTQA) MAXLEN(1) +                                    /*CPK014*/
/************           AUT(*CHANGE)                                                      /*CPK014*/
 
/* Clear data queue MSDTQA. */                                                            /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                             /*CPK014*/
 
             GOTO       CMDLBL(END)
/**/
/* Check the switchable features file for S01436, to check if the    */
/* bank use an ST400. If so, they have an extra data queue.          */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD     +
                          &DSFDY)                                     /*S01436*/
/**/                                                                  /*S01436*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*S01436*/
/**Clear*MSDTQE*by*deleting*and*recreating*it.                       */                   /*CPK014*/
/* Clear data queue MSDTQE. */                                                            /*CPK014*/
/**/
               ALCOBJ     OBJ((MSC5030 *DTAARA *EXCL)) WAIT(30)       /*E11801*/
               MONMSG     MSGID(CPF0000)
/*                                                                   */
/************  DLTDTAQ    DTAQ(MSDTQE)                                                    /*CPK014*/
/************  CRTDTAQ  DTAQ(&XLIB/MSDTQE) MAXLEN(1) AUT(*CHANGE)                         /*CPK014*/
               CALL       PGM(QCLRDTAQ) PARM('MSDTQE' '*LIBL ')                           /*CPK014*/
/**/
               DLCOBJ     OBJ((MSC5030 *DTAARA *EXCL))                /*E11801*/
               ENDDO
/*                                                                   */
/*   Send 'T' to MSDTQD, in order to stop reference generation         *164062*/
/*   and stop MSC5030.                                                 *164062*/
                                                                      /*164062*/
             CHGVAR     VAR(&DTQC) VALUE('MSDTQD')                    /*164062*/
             CHGVAR     VAR(&LIBC) VALUE('*LIBL')                     /*164062*/
             CHGVAR     VAR(&LENC) VALUE(1)                           /*164062*/
             CHGVAR     VAR(&DAC) VALUE('T')                          /*164062*/
             CALL       PGM(QSNDDTAQ) PARM(&DTQC &LIBC &LENC &DAC)    /*164062*/
                                                                      /*164062*/
/*/COPY WNCPYSRC,MSC4002004                                          */
 ABNOR:      SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                          Communications termination ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
/* Deallocate Communications and Compression Programs                */
/*                                                                   */
/* END:        DLCOBJ     OBJ((MS0200 *PGM *EXCL))            *******  *E11801*/
 END:        DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                   /*E11801*/
             MONMSG     MSGID(CPF0000)
/*******     DLCOBJ     OBJ((MS4010 *PGM *EXCL))              *******  *E11801*/
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                   /*E11801*/
             MONMSG     MSGID(CPF0000)
/*                                                                   */
/*/COPY WNCPYSRC,MSC4002002                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
