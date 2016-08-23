/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Override IBM version 2 files')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Report Control Facility Module                  */
/*                                                                   */
/*       FCC0220 - REPORT REQUESTS CONTROL PROGRAM OVERRIDE IBM      */
/*                VERSION 2 FILES                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 076789           DATE 03OCT94                */
/*       PREV AMEND NO. 049424           DATE 11JAN93                */
/*                      044847           DATE 23SEP92                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*        076789 - Overrides moved to MLC0000                        */
/*        049424 - IBM HAVE RENAMED THE OFFICE FILES AGAIN AT        */
/*                 V2R2. THE PROGRAM HAS BEEN AMENDED TO CALL A      */
/*                 NEW ACCESS OBJECT AOIBMDR0 WHICH RETURNS THE      */
/*                 OBJECT NAME AT THE MACHINE'S PRESENT IBM          */
/*                 RELEASE LEVEL FOR OVERRIDE PURPOSES.              */
/*        044847 - PROGRAM WRITTEN TO BE CALLED FROM MITEM TO        */
/*                 OVERRIDE FILES AS THEY HAVEN'T THE SAME NAME ON   */
/*                 DIFFERENT VERSIONS OF QUSRSYS.                    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGRPG &MODE)
 
             DCL        VAR(&PGRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)        /*049424*076789*/
/************DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)      /*049424*076789*/
/************DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)        /*049424*076789*/
/************DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)        /*049424*076789*/
/**/
/*  GLOBAL MONITOR MESSAGE  */
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/**CHECK*THAT*PROGRAM*IS*RUNNING*ON*IBM*VERSION*2*****/    /*044847*/ /*049424*/
/**IF*ONE*OF*THE*FILES*EXISTS,*THEN*ALL*OF*THEM*WILL**/    /*044847*/ /*049424*/
/**OVERRIDE*FILES*AS*THEY*HAVEN'T*THE*SAME*NAME*ON****/    /*044847*/ /*049424*/
/**DIFFERENT*IBM*VERSIONS*OF*QUSRSYS.*****************/    /*044847*/ /*049424*/
/**/                                                                  /*044847*/
/*********** CHKOBJ     OBJ(QAOKDY01) OBJTYPE(*FILE)       /*044847*/ /*049424*/
/*********** MONMSG  MSGID(CPF9801) EXEC(GOTO CMDLBL(MAIN))/*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDP01) TOFILE(QAOKDY01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKLP02) TOFILE(QAOKLY02)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/*********** OVRDBF     FILE(QAOKDL01) TOFILE(QAOKDG01)    /*044847*/ /*049424*/
/*********** MONMSG     MSGID(CPF0000)                     /*044847*/ /*049424*/
 
/* CHECK FOR RENAMED IBM FILES AND SETUP OVERRIDES IF NECCESSARY */   /*049424*/
 
/* DETERMINE THE MACHINE OPERATING SYSTEM LEVEL */                    /*049424*/
                                                                      /*049424*/
/******RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)   /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKDP01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDP01)          /*049424*074789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE PF/QAOKLP02 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKLP02)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
                                                                      /*049424*/
/* CHECK FOR FILE LF/QAOKDL01 */                                      /*049424*/
                                                                      /*049424*/
/************CHGVAR     VAR(&OLDNAME) VALUE(QAOKDL01)          /*049424*076789*/
                                                                      /*049424*/
/************CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +
/************             &OLDNAME &VALUE)                     /*049424*076789*/
                                                                      /*049424*/
/************IF         COND(&RTNCDE *NE '*NRF') THEN(DO)      /*049424*076789*/
/************CHGVAR VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))    /*049424*076789*/
/************   OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)     /*049424*076789*/
/************ENDDO                                             /*049424*076789*/
 
 SKIP:
 
/**/
/*  CALL TO REPORT MAINTENANCE PROGRAM IN DIFFERENT MODES  */
/**/
             CALL       PGM(&PGRPG) PARM(&RTN &MODE)
/**/
/*  IF DATABASE ERROR OCCURRED  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBEND))
 
/************DLTOVR     FILE(QAOKDP01 QAOKLP02 QAOKDL01)       /*044847*076789*/
/************MONMSG     MSGID(CPF0000)                         /*044847*076789*/
 
/**/
/*  EXIT THE PROGRAM IF PROCESSING COMPLETES NORMALLY  */
/**/
             GOTO       CMDLBL(THEEND)
 
/**/
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA  */
/**/
 DBEND:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/*  ABNORMAL TERMINATION PROCESSING  */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM FCC0220 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
/**/
/*  END OF PROGRAM PROCESSING  */
/**/
THEEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
