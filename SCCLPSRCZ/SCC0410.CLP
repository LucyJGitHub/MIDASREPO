/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Beginning of business database save (NDS)')  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC0410 - Beginning of Business Database Save               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118516             Date 15May97              */
/*                      110242             DATE 07NOV96              */
/*                      102348             DATE 15MAY96              */
/*                      097895             DATE 02JAN96              */
/*                      CSC001             DATE 29MAR95              */
/*                      S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       118516   - Send warning of COB file lock to Cashier branch  */
/*                monitors.                                          */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       102348 - After calls to SCC1712 and to SCC2454, check job   */
/*                switches for error.  If error, go to ABNOR without */
/*                submitting RCFMONITOR.                             */
/*       097895 - Add call to CBC0071 to make a copy of some of the  */
/*                COB data objects to be used if the NDSU BOB save   */
/*                is restored.                                       */
/*       CSC001 - Move save to ICIFINISH                             */
/*       S01495 - COB Enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Initial processing                                              */
/**/
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&BIND) TYPE(*CHAR) LEN(1) VALUE('B')
             DCL        VAR(&TIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CSC001*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CSC001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSC001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CSC001*/
             DCL        VAR(&COBDATA) TYPE(*CHAR) LEN(10)             /*097895*/
 
             DCL        VAR(&DTAQ)   TYPE(*CHAR)  LEN(10)             /*118516*/
             DCL        VAR(&LIB)    TYPE(*CHAR)  LEN(10) +
                          VALUE('*LIBL')                              /*118516*/
             DCL        VAR(&LEN)    TYPE(*DEC)   LEN(5 0) VALUE(8)   /*118516*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(8) +
                          VALUE('COBLOCK ')                           /*118516*/
             DCL        VAR(&A8BRCD) TYPE(*CHAR) LEN(3)               /*118516*/
             DCL        VAR(&A8BRST) TYPE(*CHAR) LEN(1)               /*118516*/
             DCL        VAR(&CRT003) TYPE(*LGL) VALUE('0')            /*118516*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/* */                                                                 /*CSC001*/
/* If CSC001 then save in ICIFINISH                                */ /*CSC001*/
/* files                                                           */ /*CSC001*/
                                                                      /*CSC001*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CSC001*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CSC001*/
             CHGVAR     VAR(&SARD) VALUE('CSC001')                    /*CSC001*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CSC001*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CSC001*/
/* No save go end */                                                  /*CSC001*/
             GOTO       CMDLBL(ENDPGM)                                /*CSC001*/
             ENDDO                                                    /*CSC001*/
 
/* Check for switchable feature CRT003 - The Cashier Interface */     /*118516*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*118516*/
             CHGVAR     VAR(&SARD) VALUE('CRT003')                    /*118516*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*118516*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CRT003) VALUE('1'))                    /*118516*/
                                                                      /*118516*/
             IF         COND(&CRT003 *EQ '1') THEN(DO)                /*118516*/
                                                                      /*118516*/
/* Send messages to all the branch monitors of Cashier branches */    /*118516*/
/* warning of an impending COB lock on files                    */    /*118516*/
                                                                      /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*FIRST')                     /*118516*/
IN1:                                                                  /*118516*/
                                                                      /*118516*/
/* Use the access object to read through the branch file */           /*118516*/
                                                                      /*118516*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*118516*/
             CHGVAR     VAR(&SARD) VALUE('      ')                    /*118516*/
             CALL       PGM(AOBRCHR0) PARM(&RTN &OPN &SARD &SFMT)     /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*NEXT')                      /*118516*/
             CHGVAR     VAR(&A8BRST) VALUE(%SST(&SFMT 177 1))         /*118516*/
             CHGVAR     VAR(&A8BRCD) VALUE(%SST(&SFMT 1 3))           /*118516*/
                                                                      /*118516*/
/* On error (i.e. *NRF), leave loop */                                /*118516*/
                                                                      /*118516*/
             IF         COND(&RTN *NE '       ') THEN(GOTO OUT1)      /*118516*/
                                                                      /*118516*/
/* Check if retail branch is a cashier branch, if so send warning     /*118516*/
/* to branch monitor.                                                 /*118516*/
                                                                      /*118516*/
             IF         COND(&A8BRST *NE 'N') THEN(DO)                /*118516*/
                CHGVAR     VAR(&DTAQ) VALUE('CASHTF_' *CAT &A8BRCD)   /*118516*/
                CALL       QSNDDTAQ PARM(&DTAQ &LIB &LEN &DATA)       /*118516*/
             ENDDO                                                    /*118516*/
                                                                      /*118516*/
/* Read next record */                                                /*118516*/
 
             GOTO       CMDLBL(IN1)                                   /*118516*/
                                                                      /*118516*/
OUT1:                                                                 /*118516*/
                                                                      /*118516*/
/* Close access object to allow second read later */                  /*118516*/
                                                                      /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*FREE')                      /*118516*/
             CALL       PGM(AOBRCHR0) PARM(&RTN &OPN &SARD &SFMT)     /*118516*/
             ENDDO                                                    /*118516*/
/**/
/* Save COB files for BOB save restore */                             /*097895*/
                                                                      /*097895*/
             CALL       PGM(CBC0071) PARM('S' &COBDATA)               /*097895*/
                                                                      /*097895*/
             IF         COND(&COBDATA *NE ' ') THEN(GOTO +
                          CMDLBL(ABNOR))                              /*097895*/
                                                                      /*097895*/
             SNDPGMMSG  MSG('Beginning of Business Database Save') +
                          TOMSGQ(MOPERQ)
/**/
/* Retrieve Auto COB details                                       */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/* If option to save the next day database on Auto COB is *DISK,   */
/* CALL SCC2454, otherwise call SCC1712                            */
/**/
             IF         COND(%SST(&CB_AUTO 36 5) *EQ '*DISK') THEN(DO)
/**/
/* Call SCC2454 to save the master library                         */
/**/
             CALL       PGM(SCC2454)
             IF         COND((%SWITCH(XXXXXX1X)) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(DO)             /* 102348 */
             GOTO       CMDLBL(ABNOR)                               /* 102348 */
             ENDDO                                                  /* 102348 */
             ENDDO
             ELSE       CMD(DO)
/**/
/* Call SCC1712 to save the master library                         */
/**/
             CALL       PGM(SCC1712) PARM(&BIND &TIND)
             IF         COND((%SWITCH(XXXXXX1X)) *OR +
                          (%SWITCH(XXXXXXX1))) THEN(DO)             /* 102348 */
             GOTO       CMDLBL(ABNOR)                               /* 102348 */
             ENDDO                                                  /* 102348 */
/**/
/* Call CB0602U to update COB data fields on CBAICDPD              */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETDB    ')
             CHGVAR     VAR(%SST(&CB_AUTO 88 5)) VALUE('*TAPE')
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))
             CHGVAR     VAR(%SST(&CB_AUTO 107 5)) VALUE('     ')
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/* If submit save savefile jobs on Auto COB is *YES and the COB    */
/* receiver save option is *DISK, submit the job to call SCC2455   */
/**/
             IF         COND((%SST(&CB_AUTO 57 4) *EQ '*YES') *AND +
                          (%SST(&CB_AUTO 83 5) *EQ '*DISK')) THEN(DO)
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +      /*110242*/
/*************            JOBD(SAVEJOBD) RTGDTA(*JOBD) */             /*110242*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CPK014*/
/************             JOBD(SAVEJOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +                          /*CSC023*/
/************             JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +                      /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2455)) JOB(MIDAS_SAVE) +
                          JOBD(SAVEJOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO
/**/
             ENDDO
/**/
/* If background RCF distribution program is not already running,  */
/* start it up                                                     */
/**/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ACTIVE))
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +                                  /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                     /*CPK014*/
/************             OUTQ(*JOBD) INLLIBL(*JOBD) RTGDTA(*JOBD)                        /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
 ACTIVE:
/**/
                                                                      /*118516*/
/* Inform cashier branches that COB file lock is over */              /*118516*/
                                                                      /*118516*/
             CHGVAR     VAR(&DATA) VALUE('COBUNLCK')                  /*118516*/
             IF         COND(&CRT003 *EQ '1') THEN(DO)                /*118516*/
                                                                      /*118516*/
/* Send messages to all the branch monitors of Cashier branches */    /*118516*/
/* warning of an impending COB lock on files                    */    /*118516*/
                                                                      /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*FIRST')                     /*118516*/
                                                                      /*118516*/
IN2:                                                                  /*118516*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*118516*/
             CHGVAR     VAR(&SARD) VALUE('      ')                    /*118516*/
             CALL       PGM(AOBRCHR0) PARM(&RTN &OPN &SARD &SFMT)     /*118516*/
             CHGVAR     VAR(&OPN) VALUE('*NEXT')                      /*118516*/
             CHGVAR     VAR(&A8BRST) VALUE(%SST(&SFMT 177 1))         /*118516*/
             CHGVAR     VAR(&A8BRCD) VALUE(%SST(&SFMT 1 3))           /*118516*/
                                                                      /*118516*/
/* At end of file, leave */                                           /*118516*/
                                                                      /*118516*/
             IF         COND(&RTN *NE '       ') THEN(GOTO OUT2)      /*118516*/
                                                                      /*118516*/
/* Check if retail branch is a cashier branch */                      /*118516*/
                                                                      /*118516*/
             IF         COND(&A8BRST *NE 'N') THEN(DO)                /*118516*/
                CHGVAR     VAR(&DTAQ) VALUE('CASHTF_' *CAT &A8BRCD)   /*118516*/
                CALL       QSNDDTAQ PARM(&DTAQ &LIB &LEN &DATA)       /*118516*/
             ENDDO                                                    /*118516*/
                                                                      /*118516*/
             GOTO       CMDLBL(IN2)                                   /*118516*/
OUT2:                                                                 /*118516*/
             ENDDO                                                    /*118516*/
/* Write current journal sequence number to file SCJSEQPD */                              /*CCB020*/
             SCWRTJREG  EVENT(BOBSAV) COMP(SCC0410) CMPSEQ(00001) +
                          FLAG('S') TEXT('Beginning of business +
                          database save')                                                 /*CCB020*/
             GOTO ENDPGM
/**/
/* Error processing                                                */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Beginning of Business Database Save +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
