/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Generic Posting Interface Control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1721 - Generic Posting Interface Control                 */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2006                         */
/*                                                                   */
/*       Last Amend No. CGL160             Date 11Nov14              */
/*       Prev Amend No. AR868514           Date 24Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      242958             Date 11Oct06              */
/*                      242956             Date 11Oct06              */
/*                      CGL047 *Create     Date 30Jun06              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL160 - Cheque Details Upload via Generic Posting Interface*/
/*       AR868514 - Issue in 246313 and 242958.                      */
/*                  If GPFAIL <> 'Y' program should not end.         */
/*                  SFDC 00618318 (Child: AR872834)                  */
/*       242958 - Delay Job if File specified on DTAQ not found.     */
/*       242956 - Check Object should specify XLIB.                  */
/*       CGL047 - Midas Generic Posting Interface                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2006')
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&NBRRCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&SECOND) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&IN_DATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&OUT_DATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FROMFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NSF_PROC) TYPE(*CHAR) LEN(1) VALUE('N')                      /*CGL160*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CGL160*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                                   /*CGL160*/
 
/*  Declare generic posting interface control file  */
             DCLF       FILE(GLGPICPD)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*  Change job switch setting  */
             CHGJOB     SWS(00000000)
 
/*  Get name of xxXLIB */
             RTVOBJD    OBJ(MBATCH) OBJTYPE(*JOBD) RTNLIB(&XLIB)
 
/*  Retrieve system prefix in SDSTAT data area */                                         /*CGL160*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CGL160*/
             CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *TCAT 'DPLIB')                          /*CGL160*/
 
/* Read through control file */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* Only process file if switchable feature is on  */
             IF         COND((&GPSARN *NE ' ') *AND (&GPMIDF *EQ +
                          'Y')) THEN(DO)
               CALL     PGM(AOSARDR0) PARM(&RTCD '*VERIFY' &GPSARN)
               IF       COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(LOOP))
             ENDDO
 
/*  Check if interface has already been copied today */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&MODE) VALUE('*VERIFY')
             CALL       PGM(GL1720) PARM(&RTCD &MODE &GPSARN)
             IF         COND(&RTCD *EQ '*ERROR ') THEN(DO)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Job +
                          terminated abnormally on call to program +
                          GL1720.') TOMSGQ(MOPERQ)
                CHGJOB     SWS(XXXXXX11)
                GOTO       CMDLBL(ABNOR)
               ENDDO
             IF         COND(&RTCD *EQ '*RUN   ') THEN(GOTO CMDLBL(LOOP))
 
 
/* If incoming data queue specified then check data queue  */
/* for flag to indicate that data has been sent to Midas   */
             IF         COND(&GPIDTQ *NE ' ') THEN(DO)
 
/* Check incoming data queue exists  */
/********      CHKOBJ   OBJ(&GPIDTQ) OBJTYPE(*DTAQ)  *******/                             /*242956*/
               CHKOBJ   OBJ(&XLIB/&GPIDTQ) OBJTYPE(*DTAQ)                                 /*242956*/
               MONMSG   MSGID(CPF9801) EXEC(DO)
               CRTDTAQ  DTAQ(&XLIB/&GPIDTQ) MAXLEN(256) +
                        TEXT('Midas GL Posting Interface Data Queue')
               ENDDO
 
/* If wait time is 0 then set to -1  */
             IF         COND(&GPWAIT = 0) THEN(CHGVAR VAR(&GPWAIT) +
                          VALUE(-1))
 
/* Check data queue for flag to indicate file has arrived */
               CALL      PGM(QRCVDTAQ) PARM(&GPIDTQ &XLIB &FLDLEN +
                          &IN_DATA &GPWAIT)
 
/* If 'Close Down' message exists then end abnormally */
               IF         COND(&IN_DATA *EQ 'Close Down') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Control +
                           process ended via Close Down request. +
                           Bypass component only on operator +
                           orders.') TOMSGQ(MOPERQ)
                CHGJOB     SWS(XXXXXX11)
                GOTO       CMDLBL(ABNOR)
               ENDDO
 
/* If timeout occurs then process according to failure flag */
               IF         COND((&FLDLEN *EQ 0) *AND (&GPFAIL *EQ 'Y')) +
                          THEN(DO)
                CHGVAR     VAR(&MSGDTA) VALUE('Control process ended +
                           because interface file' *BCAT &GPIFIL +
                           *BCAT 'has not been received.')
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
               ENDDO
 
               IF         COND((&FLDLEN *EQ 0) *AND (&GPFAIL *EQ 'N')) +
                          THEN(DO)                                                      /*AR868514*/
                GOTO       CMDLBL(LOOP)                                                 /*AR868514*/
               ENDDO                                                                    /*AR868514*/
/*  Set location of incoming interface file from data queue */
               CHGVAR     VAR(&FROMFILE) VALUE(%SST(&IN_DATA 1 10))
               CHGVAR     VAR(&FROMLIB) VALUE(%SST(&IN_DATA 11 10))
                                                                                          /*242958*/
/* If File not found, delay job and try again according to wait time */                   /*242958*/
              CHGVAR    VAR(&SECOND) VALUE(0)                                             /*242958*/
CHK_LOOP:     CHKOBJ    OBJ(&FROMLIB/&FROMFILE) OBJTYPE(*FILE)                            /*242958*/
              MONMSG     MSGID(CPF9801) EXEC(DO)                                          /*242958*/
                IF       COND((&GPWAIT *GT &SECOND) *OR (&GPWAIT *EQ 99999)) THEN(DO)     /*242958*/
                  DLYJOB     DLY(5)                                                       /*242958*/
                  CHGVAR     VAR(&SECOND) VALUE(&SECOND + 5)                              /*242958*/
                  GOTO       CMDLBL(CHK_LOOP)                                             /*242958*/
                ENDDO                                                                     /*242958*/
                ELSE (DO)                                                                 /*242958*/
                                                                                          /*242958*/
/* If File not found and wait time exceeded fail component if required */                 /*242958*/
/* Otherwise end process normally                                      */                 /*242958*/
                  IF         COND((&GPFAIL *EQ 'Y')) THEN(DO)                             /*242958*/
                    CHGVAR     VAR(&MSGDTA) VALUE('Control process ended +
                               because interface file' *BCAT &GPIFIL +
                               *BCAT 'does not exist.')                                   /*242958*/
                    SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                               TOMSGQ(MOPERQ)                                             /*242958*/
                    GOTO       CMDLBL(ABNOR)                                              /*242958*/
                  ENDDO                                                                   /*242958*/
                  ELSE (DO)                                                               /*242958*/
/**********         GOTO       CMDLBL(END) */                                    /*242958 AR868514*/
                    GOTO       CMDLBL(LOOP)                                             /*AR868514*/
                  ENDDO                                                                   /*242958*/
                ENDDO                                                                     /*242958*/
              ENDDO                                                                       /*242958*/
 
            ENDDO
 
/* If interface file specified then set variables  */
             IF         COND(&GPIFIL *NE ' ') THEN(DO)
 
/* Set variables  */
               CHGVAR    VAR(&FROMFILE) VALUE(&GPIFIL)
               CHGVAR    VAR(&FROMLIB) VALUE(&GPILIB)
               CHGVAR    VAR(%SST(&IN_DATA 1 10)) VALUE(&GPIFIL)
               CHGVAR    VAR(%SST(&IN_DATA 11 10)) VALUE(&GPILIB)
               CHGVAR    VAR(&SECOND) VALUE(0)
 
/* Check if any data in file  */
 LOOP1:        IF         COND(&GPTFIL *NE ' ') THEN(DO)
               RTVMBRD   FILE(&GPTLIB/&GPTFIL) NBRCURRCD(&NBRRCD)
               ENDDO
               ELSE CMD(DO)
               RTVMBRD   FILE(&GPILIB/&GPIFIL) NBRCURRCD(&NBRRCD)
               ENDDO
 
/* If no records then delay job and try again according to wait time */
               IF        COND((&NBRRCD *EQ 0)) THEN(DO)
                IF        COND((&GPWAIT *GT &SECOND) *OR  +
                          (&GPWAIT *EQ 99999)) THEN(DO)
                 DLYJOB     DLY(5)
                 CHGVAR     VAR(&SECOND) VALUE(&SECOND + 5)
                 GOTO       CMDLBL(LOOP1)
                ENDDO
               ENDDO
 
/* If no records and wait time exceeded fail component if required */
               IF         COND((&NBRRCD *EQ 0) *AND (&GPWAIT *LE +
                          &SECOND) *AND (&GPFAIL *EQ 'Y')) THEN(DO)
                CHGVAR     VAR(&MSGDTA) VALUE('Control process ended +
                           because interface file' *BCAT &GPIFIL +
                           *BCAT 'has not been received.')
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
               ENDDO
 
             ENDDO
 
 
/* Clear interim posting files & file control */
             CLRPFM     FILE(GLICHKPD)
             CLRPFM     FILE(GLPCHKPD)
             CLRPFM     FILE(GLPCHKPA)
 
/* Allocate interface file  */
             ALCOBJ     OBJ((&FROMLIB/&FROMFILE *FILE *EXCL)) +
                          WAIT(10)
             MONMSG     MSGID(CPF1002) EXEC(DO)
               CHGVAR     VAR(&MSGDTA) VALUE('Job terminated because +
                           file' *BCAT &FROMFILE *BCAT 'in library' +
                           *BCAT &FROMLIB *BCAT 'is in use by another +
                           job')
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA)  +
                           TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Copy data from incoming interface file to interim posting file */
             CPYF       FROMFILE(&FROMLIB/&FROMFILE) +
                          TOFILE(GLPCHKPD) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             IF         COND(&GPTFIL *NE ' ') THEN(DO)
             CPYF       FROMFILE(&GPTLIB/&GPTFIL) +
                          TOFILE(GLPCHKPA) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             IF         COND(&GPNSF *NE ' ') THEN(DO)                                     /*CGL160*/
             IF         COND(&NSF_PROC *EQ 'N') THEN(DO)                                  /*CGL160*/
             CPYF       FROMFILE(GLACNTQD) TOFILE(GLACNXQD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                             /*CGL160*/
             CHGVAR     VAR(&NSF_PROC) VALUE('Y')                                         /*CGL160*/
             CPYF       FROMFILE(GLACNXQD) TOFILE(&TOLIB/XGLACNXQD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*MAP *DROP)                                              /*CGL160*/
             ENDDO                                                                        /*CGL160*/
             ENDDO                                                                        /*CGL160*/
/* Run Check Program */
             CALL       PGM(GL1721) PARM(&RTCD &IN_DATA &OUT_DATA +
                          &GPSARN &GPDESC)
 
/* Check for Database errors trapped by program */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CPYF       FROMFILE(&TOLIB/XGLACNXQD) TOFILE(GLACNXQD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                             /*CGL160*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check return code from call of GL1721  */
             IF         COND(&RTCD *NE ' ') THEN(DO)
               CHGVAR     VAR(&MSGDTA) VALUE('Process failed to +
                           verify data from external interface' +
                           *BCAT &GPSARN *BCAT &GPDESC)
               SNDPGMMSG  MSG(&MSGDTA) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* If outgoing data queue specified in contol data file */
            IF         COND(&GPODTQ *NE ' ') THEN(DO)
 
/* Check outgoing data queue exists */
              CHKOBJ    OBJ(&XLIB/&GPODTQ) OBJTYPE(*DTAQ)
              MONMSG    MSGID(CPF9801) EXEC(DO)
              CRTDTAQ   DTAQ(&XLIB/&GPODTQ) MAXLEN(256) +
                        TEXT('Midas GL Posting Interface Data Queue')
              ENDDO
 
/* Send Reply to data queue */
               CALL       PGM(QSNDDTAQ) PARM(&GPODTQ &XLIB +
                          &FLDLEN &OUT_DATA)
 
/* Send message showing control data */
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&OUT_DATA)
 
             ENDDO
 
/*  Update interface run date on control file  */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&MODE) VALUE('*UPDATE')
             CALL       PGM(GL1720) PARM(&RTCD &MODE &GPSARN)
             IF         COND(&RTCD *EQ '*ERROR ') THEN(DO)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Job +
                          terminated abnormally on call to program +
                          GL1720.') TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Copy interim check file to GLGPIPPD */
             CPYF       FROMFILE(GLICHKPD) TOFILE(GLGPIPPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* Clear interface file and deallocate object */
             IF         COND(&GPCLRF *EQ 'Y') THEN(DO)
             CLRPFM     FILE(&FROMLIB/&FROMFILE)
             CLRPFM     FILE(&GPTLIB/&GPTFIL)
             MONMSG     MSGID(CPF0000)
             ENDDO
             DLCOBJ     OBJ((&FROMLIB/&FROMFILE *FILE *EXCL))
 
/*  Read next interface control record  */
             GOTO       CMDLBL(LOOP)
 
/* End program normally */
             GOTO       CMDLBL(END)
 
/* Abnormal ending  */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys Banking +
                          Systems Ltd.')
             ENDPGM
