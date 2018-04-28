/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Midas information screen')                   */
/*********************************************************************/
/*                                                                   */
/*      Midas - Restart Recovery Module                      */
/*                                                                   */
/*      RRC0010 - DISPLAY MIDAS INFORMATION SCREEN                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      LAST AMEND NO. S01343                DATE 15AUG91            */
/*      PREV AMEND NO. RT0165                DATE 21JUN91            */
/*                     RT0138                DATE 21JUN91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      S01343  -  SC/RR/SD MODULE RENAME PROJECT.                   */
/*                 - SCC1712 RENAMED FROM SDC1712                    */
/*      RT0165  -  New formats added for RR programs                 */
/*      RT0138  -  New program to replace messages sent to external  */
/*                 queues with a Midas-type screen, as this gives    */
/*                 a more professional image.                        */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FPGM &SCREEN &REPLY1)
 
             DCL        VAR(&SCREEN) TYPE(*CHAR) LEN(10)
             DCLF       FILE(RRC0010DF)
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*******************************************************************/
/* MESSAGES ASSOCIATED WITH &SCREEN VALUES           ¦ USED BY PGM */
/*******************************************************************/
/*                                                   ¦             */
/* CANTALCDEV - DEVICE UNAVAILABLE - CHECK IT        ¦ SDC1715     */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* CANTREADDK - FAULTY DISKETTE - TRY ANOTHER        ¦ SDC1715     */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* CANTREADTP - CANNOT PROCESS VOL. CLEAN DEVICE AND/¦ SDC1715     */ /*RT0165*/
/*              OR TRY DIFFERENT VOL.                ¦             */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* DEVNOTFND  - DEVICE NOT FOUND. MOUNT ID ON DEVICE ¦ SDC1715     */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* DEVNOTREDY - DEVICE NOT READY. MOUNT ID AND PRESS ¦ SDC1715     */ /*RT0165*/
/*              START                                ¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* DKTJNOTFND - DISKETTE VOL ID JRNIC NOT FOUND.     ¦ SDC1715     */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* ENDOFDKT   - END OF DISKETTES REACHED. MOUNT MORE,¦ SDC1715     */ /*RT0165*/
/*              INITIALISE AND PRESS ENTER TO        ¦             */ /*RT0165*/
/*              CONTINUE                             ¦             */ /*RT0165*/
/*===================================================*=============*/
/* MSTRESTABN - RESTORE MASTER LIBRARY ENDED         ¦ SDC1721     */
/*              ABNORMALLY                           ¦             */
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */
/*===================================================*=============*/
/**MSTSAVEABN***SAVE*MASTER*LIBRARY*ENDED*ABNORMALLY*¦*SDC1712******/ /*S01343*/
/* MSTSAVEABN - SAVE MASTER LIBRARY ENDED ABNORMALLY ¦ SCC1712     */ /*S01343*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */
/*===================================================*=============*/ /*RT0165*/
/* NOTTAPDKT  - SAVE DEVICE NOT TAPE OR DISKETTE     ¦ SDC1715     */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* RSTJRCVABN - RSTR JOURNAL RECEIVERS ENDED         ¦ SDC1725     */
/*              ABNORMALLY                           ¦             */
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦ SDC1753     */
/*===================================================*=============*/
/* RSTNRCVABN - SAVE NEXT RECEIVERS IN SEQUENCE ENDED¦ SDC1726     */
/*              ABNORMALLY                           ¦             */
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */
/*===================================================*=============*/
/* SAVJRCVABN - SAVE JOURNAL RECEIVERS ENDED         ¦ SDC1715     */
/*              ABNORMALLY                           ¦             */
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */
/*===================================================*=============*/
/* SETBKUPABN - (INITIAL) SETUP OF BACKUP MACHINE    ¦ SDC1750     */
/*              ENDED ABNORMALLY                     ¦             */
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */
/*===================================================*=============*/
/* SAVJRNRCVC - SAVE JOURNAL RECEIVERS CANCELLED     ¦ SDC1715     */ /*RT0165*/
/*===================================================*=============*/ /*RT0165*/
/* TAPJNOTFND - TAPE WITH VOL ID JRNIC NOT FOUND     ¦ SDC1715     */ /*RT0165*/
/*              DO YOU WISH TO RE-TRY OR CANCEL?(R/C)¦             */ /*RT0165*/
/*                                                   ¦             */
/*******************************************************************/
 
/*  SEND HEADER/TRAILER INFORMATION  */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)
             RTVJOBA    JOB(&WSID) USER(&USER)
             SNDF       RCDFMT(HEADER)
             SNDF       RCDFMT(TRAILER)
 
/*  SEND REQUESTED SCREEN  */
 
/**  CANTALCDEV  **/                                                  /*RT0165*/
/* UNABLE TO ALLOCATE DEVICE */                                       /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'CANTALCDEV') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(CANTALCDEV)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  CANTREADDK  **/                                                  /*RT0165*/
/* UNABLE TO READ DISKETTE DUE TO SURFACE DEFECT */                   /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'CANTREADDK') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(CANTREADDK)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  CANTREADTP  **/                                                  /*RT0165*/
/* CANNOT PROCESS MOUNTED VOLUME */                                   /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'CANTREADTP') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(CANTREADTP)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  DEVNOTFND   **/                                                  /*RT0165*/
/* DEVICE NOT FOUND */                                                /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'DEVNOTFND') THEN(DO)        /*RT0165*/
                SNDRCVF    RCDFMT(DEVNOTFND)                          /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  DEVNOTREDY  **/                                                  /*RT0165*/
/* DEVICE NOT READY */                                                /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'DEVNOTREDY') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(DEVNOTREDY)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  DKTJNOTFND  **/                                                  /*RT0165*/
/* DISKETTE WITH VOLUME ID JRNIC NOT FOUND */                         /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'DKTJNOTFND') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(DKTJNOTFND)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  ENDOFDKT    **/                                                  /*RT0165*/
/* END OF DISKETTE(S) REACHED */                                      /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'ENDOFDKT') THEN(DO)         /*RT0165*/
                SNDRCVF    RCDFMT(ENDOFDKT)                           /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  MSTRESTABN  **/
/* RESTORE MASTER LIBRARY ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'MSTRESTABN') THEN(DO)
                SNDRCVF    RCDFMT(MSTRESTABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  MSTSAVEABN  **/
/* SAVE MASTER LIBRARY ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'MSTSAVEABN') THEN(DO)
                SNDRCVF    RCDFMT(MSTSAVEABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  NOTTAPDKT   **/                                                  /*RT0165*/
/* SAVE DEVICE FOR SAVE JOURNAL RECEIVERS NOT "TAPE" OR "DKTE" */     /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'NOTTAPDKT') THEN(DO)        /*RT0165*/
                SNDRCVF    RCDFMT(NOTTAPDKT)                          /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  RSTJRCVABN  **/
/* RESTORE JOURNAL RECEIVERS - ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RSTJRCVABN') THEN(DO)
                SNDRCVF    RCDFMT(RSTJRCVABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RSTNRCVABN  **/
/* RESTORE NEXT RECEIVERS IN SEQUENCE  - ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RSTNRCVABN') THEN(DO)
                SNDRCVF    RCDFMT(RSTNRCVABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SAVJRCVABN  **/
/* SAVE JOURNAL RECEIVERS - ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'SAVJRCVABN') THEN(DO)
                SNDRCVF    RCDFMT(SAVJRCVABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SAVJRNRCVC  **/                                                  /*RT0165*/
/* SAVE JOURNAL RECEIVERS - CANCELLED */                              /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'SAVJRNRCVC') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(SAVJRNRCVC)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
                                                                      /*RT0165*/
/**  SETBKUPABN  **/
/* INITIAL SETUP OF BACKUP MACHINE - ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'SETBKUPABN') THEN(DO)
                SNDRCVF    RCDFMT(SETBKUPABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  TAPJNOTFND  **/                                                  /*RT0165*/
/* TAPE WITH VOLUME ID JRNIC NOT FOUND */                             /*RT0165*/
                                                                      /*RT0165*/
             IF         COND(&SCREEN *EQ 'TAPJNOTFND') THEN(DO)       /*RT0165*/
                SNDRCVF    RCDFMT(TAPJNOTFND)                         /*RT0165*/
                GOTO       CMDLBL(END)                                /*RT0165*/
             ENDDO                                                    /*RT0165*/
 
 
/*  END OF PROGRAM PROCESSING  */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             RCLRSC
 
             ENDPGM
