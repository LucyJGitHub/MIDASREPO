/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Reroute at i/c termination')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0105   - Program called after reroute of job             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB014             Date 25Apr05              */
/*       Prev Amend No. BG8662             Date 26Oct05              */
/*                      CPK017             Date 17Sep03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003             Date 04Sep00              */
/*                      179977             Date 09Jan01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 02SEP96              */
/*                                         Date 07AUG95              */
/*                      CCB001             Date 21APR95              */
/*                      S01463             Date 18APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*       BG8662 - Reinstate remove of msg from MSTATUS               */
/*                SCC0105 does not accept reply of 'N'               */
/*       CPK017 - Midas Plus Packaging.                              */
/*                - Remove interactive screen.                       */
/*                - Comment out the remove of msg from MSTATUS.      */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CTI003 - Addition of CTI003.  Check that the TI COB Control */
/*                job is not active when COB starts.                 */
/*       179977 - When we reply N to run CLBP an additional message  */
/*                to MSTATUS.                                        */
/*       S01408 - Addition of core hoohs SCC0105001                  */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCC0105INT                                       */
/*                - SCC0105MPS                                       */
/*                - SCC0105MPE                                       */
/*                - SCC0105ERR                                       */
/*                - SCC0105END                                       */
/*       CCB001 - Remove the parameter from the call to SCC0400.     */
/*       S01463 - New program to allow rerouting of job to be        */
/*                updated without the need to change subsystem       */
/*                routing entries.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
/*/COPY WNCPYSRC,SCC0105INT                                          */
             DCL        VAR(&AUS025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&AUTSCH) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ZERO) TYPE(*LGL)  LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CLBP) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)                                   /*CTI003*/
                                                                                          /*CSC011*/
/** Declare variables used to call AOSARDR0 */                                            /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CSC011*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC011*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC011*/
/*/COPY WNCPYSRC,SCC0105005                                          */
 
/* Declare EOD file to show on screen */
 
/**********  DCLF       FILE(SCEODRQH) RCDFMT(MIDASWAIT1 MIDASWAIT2)                   */ /*CPK017*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
                                                                                          /*CSC011*/
               RTVJOBA  JOB(&JOB)                                                         /*CSC011*/
                                                                                          /*CSC011*/
/** Initialise variables for AOSARDR0 */                                                  /*CSC011*/
                                                                                          /*CSC011*/
               CHGVAR VAR(&RTNC) VALUE('       ')                                         /*CSC011*/
               CHGVAR VAR(&SARD) VALUE('CSC011')                                          /*CSC011*/
               CHGVAR VAR(&OPTN) VALUE('*VERIFY')                                         /*CSC011*/
                                                                                          /*CSC011*/
/** Call AOSARDR0 to check if Switchable CSC011 is switched on */                         /*CSC011*/
                                                                                          /*CSC011*/
               CALL   PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                         /*CSC011*/
                                                                                          /*CSC011*/
/* Error */                                                                               /*CSC011*/
                                                                                          /*CSC011*/
               IF     COND(&RTNC *NE '       ' *AND &RTNC *NE +
                      '*NRF   ') THEN(DO)                                                 /*CSC011*/
                        SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                        TOMSGQ(MOPERQ)                                                    /*CSC011*/
                        GOTO   CMDLBL(ABNOR)                                              /*CSC011*/
               ENDDO                                                                      /*CSC011*/
                                                                                          /*CSC011*/
               IF     COND(&RTNC *EQ '       ') THEN(CHGVAR +
                        VAR(&CSC011) VALUE('Y'))                                          /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SCC0105MPS                                          */
             CHGVAR     VAR(&RTNC)    VALUE('       ')                                    /*CCB014*/
             CHGVAR     VAR(&OPTN)    VALUE('*VERIFY')                                    /*CCB014*/
             CHGVAR     VAR(&SARD)    VALUE('CCB014')                                     /*CCB014*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*CCB014*/
                                                                                          /*CCB014*/
/* CHECK TO SEE IF AUTOMATIC SCHEDULING IS ON                     */                      /*CCB014*/
                                                                                          /*CCB014*/
             IF         COND(&RTNC *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                        /*CCB014*/
                                                                                          /*CCB014*/
             IF         COND(&CCB014 *EQ 'Y') THEN(DO)                                    /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&AUTSCH)                              /*CCB014*/
             ENDDO                                                                        /*CCB014*/
                                                                                          /*CCB014*/
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC1))                                      /*CCB014*/
 
/* Show screen */
 
/**********  CHGVAR     VAR(&MSG1) VALUE('Input cycle termination +                    */ /*CPK017*/
/**********               executing')                                                  */ /*CPK017*/
/**********  SNDF       RCDFMT(MIDASWAIT1)                                             */ /*CPK017*/
/**********  SNDF       RCDFMT(MIDASWAIT2)                                             */ /*CPK017*/
 
/*  CALL SCC0010 TO REQUEST CONFIRMATION OF STAT COB REQUEST  */
/** when CSC011 is switched off.                              */                          /*CSC011*/
 
             IF         COND(&CSC011 *EQ 'N') THEN(DO)                                    /*CSC011*/
             RTVMSG     MSGID(SCM0012) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0011) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')
/*/COPY WNCPYSRC,SCC0105003                                          */
             CALL       PGM(SCC0010) PARM('SCC0105' 'OPTION' &CLBP)
/*/COPY WNCPYSRC,SCC0105004                                          */
 
             IF         COND(&CLBP *NE 'Y') THEN(DO)
/**********    RCVMSG     MSGQ(MSTATUS) RMV(*YES)                           */ /*CPK017*/ /*179977*/
               RCVMSG     MSGQ(MSTATUS) RMV(*YES)                                         /*BG8662*/
               RRTJOB     RTGDTA('MIDASIC')
             ENDDO
             ENDDO                                                                        /*CSC011*/
 
/* If TI is present as a module then check if Midas/TI Interface CoB */                   /*CTI003*/
/*  is active.                                                       */                   /*CTI003*/
             CALL       PGM(AOMMODR0) PARM('*DBERR' '*FIRST' &MMOD)                       /*CTI003*/
             IF         COND(%SST(&MMOD 103 1) *EQ 'Y') THEN(DO)                          /*CTI003*/
                ALCOBJ     OBJ((TIDTA *DTAARA *EXCLRD)) WAIT(5)                           /*CTI003*/
                MONMSG     MSGID(CPF1002) EXEC(DO)                                        /*CTI003*/
                                                                                          /*CTI003*/
/*  Call SCC0010 to Display 'Cannot Start CoB now' message */                             /*CTI003*/
                   RTVMSG     MSGID(SCM0163) MSGF(MIDASMSG) MSG(&MESSAGE)                 /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                   /*CTI003*/
                   RTVMSG     MSGID(SCM0164) MSGF(MIDASMSG) MSG(&MESSAGE)                 /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)                   /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')                           /*CTI003*/
                   CALL       PGM(SCC0010) PARM('SCC0105' 'ENTER ' ' ')                   /*CTI003*/
                                                                                          /*CTI003*/
/*  Re-route the job back to input cycle */                                               /*CTI003*/
                   RRTJOB     RTGDTA('MIDASIC')                                           /*CTI003*/
                                                                                          /*CTI003*/
                ENDDO                                                                     /*CTI003*/
                DLCOBJ     OBJ((TIDTA *DTAARA *EXCLRD))                                   /*CTI003*/
             ENDDO                                                                        /*CTI003*/
/*/COPY WNCPYSRC,SCC0105002                                          */
             RTVJOBA    JOB(&JOB)
             CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK) PGM(*SAME)
 
/**********  CALL       PGM(SCC0400) PARM(&ZERO) */                   /*CCB001*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC0105001                                        */ /*S01408*/
                                                                      /*S01408*/
TAGUSC1:                                                                                  /*CCB014*/
             CALL       PGM(SCC0400)                                  /*CCB001*/
 
             IF     COND(&CSC011 *EQ 'Y') THEN(DO)                                        /*CSC011*/
                                                                                          /*CSC011*/
                CHGDTAARA DTAARA(SCREOP (1 1)) VALUE('Y')                                 /*CSC011*/
                                                                                          /*CSC011*/
/** Call program SC004330 (24x7 Re-open Option Prompt) */                                 /*CSC011*/
                                                                                          /*CSC011*/
                CALL   PGM(SC004330)                                                      /*CSC011*/
                                                                                          /*CSC011*/
/** Database error processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                IF     COND(%SWITCH(XXXXXX11)) THEN(DO)                                   /*CSC011*/
                           SNDPGMMSG MSG('PROGRAM ERROR +
                                     OCCURRED IN SC004330') +
                                     TOMSGQ(MOPERQ)                                       /*CSC011*/
                           GOTO      CMDLBL(ABNOR)                                        /*CSC011*/
                ENDDO                                                                     /*CSC011*/
                                                                                          /*CSC011*/
/** Call program SCC004340 (Re-open Input Cycle Processing) */                            /*CSC011*/
                                                                                          /*CSC011*/
                CALL   PGM(SCC004340)                                                     /*CSC011*/
                                                                                          /*CSC011*/
/** Database error processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                IF     COND(%SWITCH(XXXXXX11)) THEN(DO)                                   /*CSC011*/
                           SNDPGMMSG MSG('PROGRAM ERROR +
                                     OCCURRED IN SCC004340') +
                                     TOMSGQ(MOPERQ)                                       /*CSC011*/
                           GOTO      CMDLBL(ABNOR)                                        /*CSC011*/
                ENDDO                                                                     /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SCC0105MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0105ERR                                          */
 
/* Inform user that the program is in error */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                         SCC0105 ended abnormally - see job log') +
                         TOMSGQ(MOPERQ &JOB)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0105END                                          */
 
             ENDPGM
