/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC End of input cycle initiation phase')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ICIFINISH - End of Input Cycle Initiation Phase.            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC058             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27089           Date 08Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      BUG5730            Date 21Apr05              */
/*                      CSC023             Date 02Feb04              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 26Mar02              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      196358             Date 26Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002             Date 01Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      136947             Date 11Jun98              */
/*                      119592             Date 04Aug97              */
/*                      118513             Date 22MAY97              */
/*                      S01408             DATE 17SEP96              */
/*                      S01408             DATE 02SEP96              */
/*                      CSC001             DATE 29MAR95              */
/*                      077466             DATE 17OCT94              */
/*                      S01495             DATE 01OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC058 - Change to CCB016 - Bypass of DBBOB Save            */
/*       BUG27089 - SCKOBJLCB failed                                 */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG5730 - Remove change of MPHAS to 'A' in ICIFINISH.       */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSW025 - Midas Message Manager                              */
/*                - Save/restore message manager library             */
/*       CSC011 - 24x7 Midas Availability                            */
/*       196358 - Submit receiver size monitor.                      */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*       136947 - Run Cashier processing as a separate component     */
/*       119592 - Correction to 118513                               */
/*       118513 - Make the cashier interface start up dependent upon */
/*                the BOB SAVE switchable feature (CSC001)           */
/*       S01408 - Addition of core hook ICIFINIS02                   */
/*       S01408 - Addition og core hook ICIFINIS01                   */
/*       CSC001 - Save database at this point                        */
/*       077466 - Move change of MPHAS to 'A' to this program        */
/*                from SCC0411.                                      */
/*       S01495 - New program created to mark the end of the         */
/*                input cycle initiation phase of dependency         */
/*                based close of business.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CSC001*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CSC001*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSC001*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CSC001*/
             DCL        VAR(&CRT003) TYPE(*LGL) VALUE('0')            /*118513*/
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(7)                 /*118513*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CPB002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CPB002*/
             DCL        VAR(&SEQNO) TYPE(*DEC) LEN(10 0)                                  /*CSC011*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC011*/
             DCL        VAR(&RCVR) TYPE(*CHAR) LEN(10)                                    /*CSC011*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CSW025*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
             DCL        VAR(&COMRTN) TYPE(*CHAR) LEN(1)                                   /*CSC058*/
 
/*/COPY WNCPYSRC,ICIFINIS04                                          */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
                                                                                          /*CSW025*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')                              /*CSW025*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))                            /*CSW025*/
                                                                                          /*CSW025*/
/*/COPY WNCPYSRC,ICIFINIS05                                          */
/* */                                                                 /*CSC001*/
/* If CSC001 then save in ICIFINISH                                */ /*CSC001*/
/* files                                                           */ /*CSC001*/
                                                                      /*CSC001*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CSC001*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CSC001*/
             CHGVAR     VAR(&SARD) VALUE('CSC001')                    /*CSC001*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CSC001*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CSC001*/
/* */                                                                 /*CSC001*/
/* Call SCC0410B to save database */                                  /*CSC001*/
/* */                                                                 /*CSC001*/
             CALL       PGM(AOCOMR0) PARM('ICIFINISH' '00001' +
                          'ICIFIN001' &COMRTN)                                            /*CSC058*/
             IF         COND(&COMRTN *EQ 'N') THEN(DO)                                    /*CSC058*/
                                                                                          /*CSC058*/
             CALL       PGM(SCC0410B)                                 /*CSC001*/
/* */                                                                 /*CSC001*/
/* If switches U7 or U8 on exit with error */                         /*CSC001*/
/* */                                                                 /*CSC001*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*119592*/
             GOTO       CMDLBL(ABNOR)                                 /*119592*/
             ENDDO                                                    /*119592*/
                                                                                          /*CSC058*/
             ENDDO                                                                        /*CSC058*/
                                                                      /*119592*/
             ENDDO                                                    /*CSC001*/
                                                                                          /*CSW025*/
             IF COND(&CSW025 *EQ 'Y') THEN(DO)                                            /*CSW025*/
             CALL       PGM(MEC0720)                                                      /*CSW025*/
                                                                                          /*CSW025*/
/* If switches U7 or U8 on exit with error */                                             /*CSW025*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(GOTO ABNOR)                             /*CSW025*/
             ENDDO                                                                        /*CSW025*/
                                                                                          /*CSW025*/
/***/                                                      /*118513*/ /*136947*/
/**Call*REC4420*to*start*Cashier*Interface*backgrounnd*jobs/*118513*/ /*136947*/
/**Cashier*Interface*switchable*feature*CRT003*is*'ON'.    /*118513*/ /*136947*/
/***/                                                      /*118513*/ /*136947*/
/**Check*for*switchable*feature*CRT003*-*The*Cashier*Interf/*118513*/ /*136947*/
/************CHGVAR     VAR(&RTN) VALUE('       ')         /*118513*/ /*136947*/
/************CHGVAR     VAR(&OPN) VALUE('*VERIFY')         /*118513*/ /*136947*/
/************CHGVAR     VAR(&SARD) VALUE('CRT003')         /*118513*/ /*136947*/
/************CALL       PGM(AOSARDR0) PARM(&RTN1 &OPN &SARD/*118513*/ /*136947*/
/************IF         COND(&RTN1 *EQ '       ') THEN(CHGVAR +       /*136947*/
/************             VAR(&CRT003) VALUE('1'))         /*118513*/ /*136947*/
/************                                              /*118513*/ /*136947*/
/************IF         COND(&CRT003 *EQ '1') THEN(DO)     /*118513*/ /*136947*/
/************CALL       PGM(REC4420)                       /*118513*  /*136947*/
/************ENDDO                                         /*118513*/ /*136947*/
/***/                                                      /*CSC001*/ /*136947*/
/**If*switches*U7*or*U8*on*exit*with*error */              /*CSC001*/ /*136947*/
/***/                                                      /*CSC001*/ /*136947*/
/************IF         COND(%SWITCH(XXXXXX1X) *OR +                  /*136947*/
/************             %SWITCH(XXXXXXX1)) THEN(DO)      /*CSC001*/ /*136947*/
/************GOTO       CMDLBL(ABNOR)                      /*CSC001*/ /*136947*/
/************ENDDO*/                                       /*CSC001*/ /*136947*/
/***/                                                      /*CSC001*/ /*136947*/
/************ENDDO ************************                     /*CSC001119592*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,ICIFINIS01                                       */  /*S01408*/
                                                                      /*S01408*/
 
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CSC011*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CSC011*/
             CHGVAR     VAR(&SARD) VALUE('CSC011')                                        /*CSC011*/
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CSC011*/
                                                                                          /*CSC011*/
/** If error occured in AOSARDR0, perform abnormal termination */                         /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTN *NE '       ' *AND &RTN *NE +
                        '*NRF   ') THEN(DO)                                               /*CSC011*/
                SNDPGMMSG  MSG('Program error in AOSARDR0') +
                           TOMSGQ(MOPERQ)                                                 /*CSC011*/
                GOTO       CMDLBL(ABNOR)                                                  /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/** If switchable feature CSC011 is installed, set      */                                /*CSC011*/
/** Transition Started field to 'Y' in SCSUPP           */                                /*CSC011*/
/** and update journal sequence records.                */                                /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*CSC011*/
                                                                                          /*CSC011*/
/* Retrieve last journal entry seq. no. of currently attached journal */                  /*CSC011*/
                                                                                          /*CSC011*/
                RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                             RTNSEQNBR(&SEQNO) RTNRCV(&RCVR)                              /*CSC011*/
                                                                                          /*CSC011*/
                SNDPGMMSG  MSG('SC000030 - Data Replication SOD +
                             Initialisation Run Started') +
                             TOMSGQ(MOPERQ SC24X7Q)                                       /*CSC011*/
                                                                                          /*CSC011*/
/* Call Start of Day Initialisation Run */                                                /*CSC011*/
                                                                                          /*CSC011*/
                CALL       PGM(SC000030) PARM(&SEQNO)                                     /*CSC011*/
                                                                                          /*CSC011*/
/* Database error processing */                                                           /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CSC011*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                           /*CSC011*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ)                                            /*CSC011*/
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                SC000030 ended abnormally - see joblog +
                                ') TOMSGQ(MOPERQ SC24X7Q)                                 /*CSC011*/
                   GOTO       CMDLBL(ABNOR)                                               /*CSC011*/
                ENDDO                                                                     /*CSC011*/
                                                                                          /*CSC011*/
/* Retrieve and update SCDRSTAT */                                                        /*CSC011*/
                                                                                          /*CSC011*/
                ALCOBJ     OBJ((SCDRSTAT *DTAARA *EXCLRD)) WAIT(5)                        /*CSC011*/
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ABNOR))                        /*CSC011*/
                                                                                          /*CSC011*/
                CHGDTAARA  DTAARA(SCDRSTAT (15 10)) VALUE('          ')                   /*CSC011*/
                                                                                          /*CSC011*/
/* Initialise Starting Receiver */                                                        /*CSC011*/
                                                                                          /*CSC011*/
                CHGDTAARA  DTAARA(SCDRSTAT (26 10)) VALUE(&RCVR)                          /*CSC011*/
                                                                                          /*CSC011*/
                DLCOBJ     OBJ((SCDRSTAT *DTAARA *EXCLRD))                                /*CSC011*/
                                                                                          /*CSC011*/
                SNDPGMMSG  MSG('SC000030 - Data Replication SOD +
                             Initialisation Run completed +
                             successfully.') TOMSGQ(MOPERQ SC24X7Q)                       /*CSC011*/
                                                                                          /*CSC011*/
/*----------------------> */
                CHGDTAARA  DTAARA(SCSUPP (1 1)) VALUE('Y')                                /*CSC011*/
             ENDDO                                                                        /*CSC011*/
 
/**********  CHGDTAARA  DTAARA(MPHAS) VALUE('A') */                           /*077466*/ /*BUG5730*/
/**********  SCWRTJREG EVENT(MPHAS) FLAG(A) TEXT('MPHAS changed from F to A') /*CSC020*/ /*BUG5730*/
                                                                      /*077466*/
/*                                                                                        /*196358*/
/* try to allocate data area SCJRNLOCK.                                                   /*196358*/
/*                                                                                        /*196358*/
             ALCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(1)                            /*196358*/
/*                                                                                        /*196358*/
/* If not allocated, then journal size monitor is active.                                 /*196358*/
/*                                                                                        /*196358*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP))                            /*196358*/
/*                                                                                        /*196358*/
/* Otherwise submit the journal size monitor job.                                         /*196358*/
/*                                                                                        /*196358*/
/************SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +                          /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE)             /*196358*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)            /*CSC023*/
             DLCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL))                                    /*196358*/
SKIP:                                                                                     /*196358*/
/*                                                                                        /*196358*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,ICIFINIS02                                       */  /*S01408*/
                                                                      /*S01408*/
/* */                                                                 /*CSC001*/
/* Send journal for recovery purposes      */                         /*CSC001*/
/* */                                                                 /*CSC001*/
/*/COPY WNCPYSRC,ICIFINIS06                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('BJ') */                              /*CSC001*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('BJ') FORCE(*YES)                                /*BUG9619*/
/* */                                                                 /*CSC001*/
/*/COPY WNCPYSRC,ICIFINIS03                                          */
 
/* Access PF/SDMMODPD to determine which modules are live */          /*CPB002*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &FMT)       /*CPB002*/
 
             IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)       /*CPB002*/
               ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +
                          TRGEVENT(*INSERT) PGM(PB6602)               /*CPB002*/
                                                                      /*CPB002*/
               ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +
                          TRGEVENT(*UPDATE) PGM(PB6602) +
                          TRGUPDCND(*CHANGE)                          /*CPB002*/
             ENDDO                                                    /*CPB002*/
                                                                                        /*BUG27089*/
/* If background RCF distribution program is not running yet,      */                   /*BUG27089*/
/* start it up                                                     */                   /*BUG27089*/
                                                                                        /*BUG27089*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(0)                             /*BUG27089*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))                           /*BUG27089*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                                     /*BUG27089*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                /*BUG27089*/
                                                                                        /*BUG27089*/
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing */
 
 ABNOR:
/*/COPY WNCPYSRC,ICIFINIS07                                          */
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program ICIFINISH ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,ICIFINIS08                                          */
             ENDPGM
