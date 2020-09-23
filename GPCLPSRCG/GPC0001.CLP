/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GP Universal transactions update mgr SUBMIT')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPC0001 - Universal Transactions Update Manager SUBMIT      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. AR957053           Date 14May12              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CSC054             Date 23Feb12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      245526             Date 07Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      242243             Date 02Oct06              */
/*                      CLE040             Date 05Jul04              */
/*                      BUG4147            Date 02Sep04              */
/*                      CSC020             Date 31Mar04              */
/*                      BUG1950            Date 20May04              */
/*                      CGP003             Date 19Mar04              */
/*                      CSC023             Date 29Jan04              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR957053 - At MP1.4.11.06 IR01, GOC0122 00001 runs in COB if*/
/*                  CLE106 and CLE016 are switched on (Pf/SCSARCPD). */
/*                  Call EODMONITOR if these features are switched ON*/
/*                  (Child: AR957055)                                */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC054 - Period End Adjustments                             */
/*       245526 - EODMONITOR should also be run if CGL014 is on      */
/*       242243 - EODMONITOR now called from GLC005010               */
/*       CLE040 - Collateralised Lending Phase 2                     */
/*      BUG4147 - Autostart of management limits jobs                */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*       BUG1950 - Complete missing deliverables for Management      */
/*                Limits. Should name the jobq correctly.            */
/*       CGP003 - Management Limits                                  */
/*                Required to inform Management Limits about         */
/*                changes in spot rates                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CGP003*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGP003*/
             DCL        VAR(&CLE106) TYPE(*CHAR) LEN(1) VALUE('N')                      /*AR957053*/
             DCL        VAR(&CGL014) TYPE(*CHAR) LEN(1) VALUE('N')                      /*AR957053*/
             DCL        VAR(&CLE016) TYPE(*CHAR) LEN(1) VALUE('N')                      /*AR957053*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((GPUTJSPD *FILE *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((GPUTJSPD *FILE *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************SBMJOB     JOB(GP_UTU_MGR) JOBD(GPBATCH) +                                   /*CSC023*/
/************             JOBQ(GPUTMJOBQ) USER(*JOBD) RTGDTA(*JOBD) +                     /*CSC023*/
/************             RQSDTA('CALL GPC0002') INLLIBL(*JOBD)                           /*CSC023*/
 
             SBMJOB     JOB(GP_UTU_MGR) JOBD(GPBATCH) +
                          JOBQ(GPUTMJOBQ) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GPC0002') INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
                                                                                          /*CGP003*/
/* Submit global journal monitor job.       */                                            /*CSC020*/
             SBMJOB     JOB(GP_JRN_MON) JOBD(GPBATCH) +
                          JOBQ(GPUTUJOBQ) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL SCC2477') INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC020*/
                                                                                          /*CSC020*/
/* Check if Management Limits Feature is on */                                            /*CGP003*/
                                                                                          /*CGP003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGP003*/
             CALL       PGM(GPAOSARDR0) PARM(&RTCD '*VERIFY' +
                          'CGP003' &FMT)                                                  /*CGP003*/
                                                                                          /*CGP003*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CGP003*/
                SNDPGMMSG  MSG('GPAOSARDR0 - PROGRAM ERROR') +
                          TOPGMQ(*EXT) TOMSGQ(GPOPERQ)
                CHGJOB     JOB(XXXXXX11)                                                  /*CGP003*/
                GOTO       CMDLBL(END)                                                    /*CGP003*/
             ENDDO                                                                        /*CGP003*/
                                                                                          /*CGP003*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGP003*/
/**********  SBMJOB     JOB(GPC0015) JOBD(GPBCKGRD) JOBQ(GPBCKGRD) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GPC0015') INLLIBL(*JOBD)   **********/ /*CGP003*/ /*BUG1950*/
             SBMJOB     JOB(GPC0015) JOBD(GPBCKGRD) JOBQ(GPBCKJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GPC0015') INLLIBL(*JOBD)                          /*BUG1950*/
                                                                                         /*BUG4147*/
             SBMJOB     JOB(GLC005010) JOBD(GPBATCH) JOBQ(GPNOMAX) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GLC005010') INLLIBL(*JOBD)                        /*BUG4147*/
                                                                                          /*CLE040*/
/* Start the End of Day Monitor Job */                                                    /*CLE040*/
/**********                                                                        /*CLE040 242243*/
/**********  CALL       PGM(GLC005020)                                             /*CLE040 242243*/
/**********                                                                        /*CLE040 242243*/
             ENDDO                                                                        /*CGP003*/
 
             ELSE       CMD(DO)                                                           /*245526*/
 
               CHGVAR     VAR(&RTCD) VALUE('       ')                                     /*245526*/
               CALL       PGM(GZAOSARDR0) PARM(&RTCD '*VERIFY' +
                            'CGL014' &FMT)                                                /*245526*/
               IF         COND(&RTCD *EQ *BLANKS) THEN(CHGVAR +
                            VAR(&CGL014) VALUE('Y'))                                    /*AR957053*/
               CHGVAR     VAR(&RTCD) VALUE('       ')                                   /*AR957053*/
               CALL       PGM(GZAOSARDR0) PARM(&RTCD '*VERIFY' +
                            'CLE016' &FMT)                                              /*AR957053*/
               IF         COND(&RTCD *EQ *BLANKS) THEN(CHGVAR +
                            VAR(&CLE016) VALUE('Y'))                                    /*AR957053*/
               CHGVAR     VAR(&RTCD) VALUE('       ')                                   /*AR957053*/
               CALL       PGM(GZAOSARDR0) PARM(&RTCD '*VERIFY' +
                            'CLE106' &FMT)                                              /*AR957053*/
               IF         COND(&RTCD *EQ *BLANKS) THEN(CHGVAR +
                            VAR(&CLE106) VALUE('Y'))                                    /*AR957053*/
                                                                                        /*AR957053*/
/** If any features switched on then start EODMONITOR */                                /*AR957053*/
                                                                                        /*AR957053*/
               IF         COND(&CGL014 *EQ 'Y' *OR &CLE016 *EQ 'Y' +
                            *OR &CLE106 *EQ 'Y') THEN(DO)                               /*AR957053*/
                  CALL       PGM(GLC005020)                                             /*AR957053*/
               ENDDO                                                                    /*AR957053*/
/**********    IF         COND(&RTCD *NE '       ' *AND &RTCD *NE + */                  /*AR957053*/
/**********               '*NRF   ') THEN(DO) */                                 /*245526 AR957053*/
/**********      SNDPGMMSG  MSG('GZAOSARDR0 - PROGRAM ERROR') + */                      /*AR957053*/
/**********                 TOPGMQ(*EXT) TOMSGQ(GPOPERQ) */                      /*245526 AR957053*/
/**********      CHGJOB     JOB(XXXXXX11) */                                     /*245526 AR957053*/
/**********      GOTO       CMDLBL(END) */                                       /*245526 AR957053*/
/**********    ENDDO */                                                          /*245526 AR957053*/
                                                                                          /*245526*/
               IF         COND(&RTCD *EQ '       ') THEN(DO)                              /*245526*/
                CALL       PGM(GLC005020)                                                 /*245526*/
               ENDDO                                                                      /*245526*/
             ENDDO                                                                        /*245526*/
                                                                                          /*245526*/
/** Submit PEA Handshaking Jobs */                                                        /*CSC054*/
                                                                                          /*CSC054*/
             SBMJOB     JOB(GP_PEA) JOBD(GPBATCH) +
                          JOBQ(GPNOMAX) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GPC000300') INLLIBL(*JOBD) OUTQ(*JOBD)             /*CSC054*/
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('GPC0001 has ended ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(GPOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
