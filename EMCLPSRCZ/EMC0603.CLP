/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EM CREATE INPUT CYCLE EXPOSURE FILE')           */
/********************************************************************/
/*                                                                  */
/*              Midas EXPOSURE MANAGEMENT MODULE                */
/*                                                                  */
/*       EMC0603 INPUT CYCLE EXPOSURE FILE CREATE                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*           Last Amend No. MD030956         Date  09Oct14           */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*           Prev Amend No. CTI002           Date  20Nov98          */
/*                          S01408           Date  20Jun95          */
/*                          S01473           DATE  26JUL94          */
/*                          E23410           DATE  19OCT90          */
/*                          E19670           DATE  15FEB90          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*        MD030956 - Additional changes to BFM-TI enhancement       */
/*        CTI002 - Trade innovation phase 2                         */
/*        S01408 - Addition of core hooks EMC0603MP1                */
/*        S01473 - Leo Midas Integration. Addition of call to       */
/*                 EM0705 to update EMCEXX2 for LC's.               */
/*        E23410 - PROGRAM CHECKS FOR MODULES RT AND RE.            *  *E23410*/
/*                 AMEND TO CHECK FOR RE AND IA.                    *  *E23410*/
/*        E19670 - WRONG POSITION BEING CHECKED IN THE DATA FILE    */
/*                 'MMOD' WHICH MEANT THAT 'SYNDICATED LENDING' WAS */
/*                 BEING CHECKED FOR INSTEAD OF 'CUSTOMER LENDING'  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)
/* Variables required for Leo Midas Integration S01473   */           /*S01473*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01473*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01473*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01473') /*S01473*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01473*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                /*S01473*/
             DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(7)                /*S01473*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)                /*S01473*/
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)                 /*S01473*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)                  /*S01473*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*S01473*/
/* CTI002 Start */
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*CTI002*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CTI002*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CTI002')                             /*CTI002*/
             DCL        VAR(&XRTCD) TYPE(*CHAR) LEN(7)                                  /*MD030956*/
             DCL        VAR(&XSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CTI007')                                               /*MD030956*/
/* CTI002 End   */
/**/                                                                  /*S01473*/
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CLRPFM     FILE(EMLEEE4)
             CLRPFM     FILE(EMLEEH1)
             CLRPFM     FILE(EMLEET1)
             CLRPFM     FILE(EMCEXX1)       /* CLEAR EMCEX FILES */
             CLRPFM     FILE(EMCEXX2)
             CLRPFM     FILE(EMCEXX3)
/**/
/**** CHECK MODULE INDICATORS ****/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
/**          IF         ((%SST(&MMOD 4 1)) *EQ 'Y') + */     /*E19670*/
/**                     CHGJOB SWS(X1XXXXXX)          */     /*E19670*/
             IF         ((%SST(&MMOD 10 1)) *EQ 'Y') +
                        CHGJOB SWS(X1XXXXXX)                 /*E19670*/
/**/
/*                                                             E23410*/
/************IF*********((%SST(&MMOD 3 1)) *EQ 'Y') +*****************/
/***********************CHGJOB SWS(1XXXXXXX)**************************/
             IF         ((%SST(&MMOD 23 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX)
/*                                                             E23410*/
             ELSE IF    ((%SST(&MMOD 16 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX)
/**/
             IF         COND(%SWITCH(X1XXXXXX)) THEN(CALL EM0650)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO ERROR)
/**/
             CALL EM0700
/* CTI002 Start */                                                    /*CTI002*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*CTI002*/
             CALL       PGM(AOSARDR0) PARM(&XRTCD &SOPTN &XSARD)                        /*MD030956*/
/**/                                                                  /*CTI002*/
/* ERROR */                                                           /*CTI002*/
/**/                                                                  /*CTI002*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ' *OR &XRTCD *NE '         '    +
                           *AND &XRTCD *NE '*NRF   ') THEN(DO)                          /*MD030956*/
/**********               '*NRF   ') THEN(DO)                                    /*CTI002 MD030956*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*CTI002*/
             CHGJOB (XXXXXX11)                                        /*CTI002*/
             GOTO       CMDLBL(ERROR)                                 /*CTI002*/
             ENDDO                                                    /*CTI002*/
/**/                                                                  /*CTI002*/
/* Switchable Feature installed    */                                 /*CTI002*/
/**/                                                                  /*CTI002*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)                      /*CTI002 MD030956*/
             IF         COND(&SRTCD *EQ '       ' *OR &XRTCD *EQ  +
                             '       ') THEN(DO)                                        /*MD030956*/
             CALL       PGM(EM0730)                                   /*CTI002*/
             ENDDO                                                    /*CTI002*/
/* CTI002 End   */                                                    /*CTI002*/
/**/
/* Check the switchable features file for the number S01473. If +
   this exists, override the files used to the Leo files, and call +
   the Leo Program location program SCC1110 for the Leo programs */   /*S01473*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*S01473*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01473*/
                                                                      /*S01473*/
               RTVDTAARA  DTAARA(LOPREF) RTNVAR(&PREF)                /*S01473*/
                                                                      /*S01473*/
/* If either position is blank, this is an error, end the program */  /*S01473*/
                 IF         COND((%SST(&PREF 1 1) *EQ ' ') *OR +
                            (%SST(&PREF 2 1) *EQ ' ')) THEN(DO)       /*S01473*/
/* If it is, send message and terminate */                            /*S01473*/
                 CHGVAR     VAR(&MESSAGE) VALUE('The Leo Prefix data +
                              area has not been set up')              /*S01473*/
                 CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE) /*S01473*/
                 CALL       PGM(SCC0010) PARM('EMC0301' 'ENTER' ' ')  /*S01473*/
                 GOTO       CMDLBL(ERROR)                             /*S01473*/
                 ENDDO                                                /*S01473*/
                                                                      /*S01473*/
/* Set up the names of the Leo DMLIB, LDLIB and DTALIB using the  +
   system prefix so the files can be overriden  */                    /*S01473*/
                 CHGVAR     VAR(&DMLIB) VALUE(&PREF *CAT 'DMLIB')     /*S01473*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EMC0603MP1                                          */
                                                                      /*S01408*/
                 CHGVAR     VAR(&LDLIB) VALUE(&PREF *CAT 'LDLIB')     /*S01473*/
                                                                      /*S01473*/
/* Override the files required by the RPG to the Leo libraries */     /*S01473*/
                 OVRDBF     FILE(LCMAST) TOFILE(&DMLIB/LCMAST)        /*S01473*/
                 OVRDBF     FILE(LCNEGS) TOFILE(&DMLIB/LCNEGS)        /*S01473*/
                 OVRDBF     FILE(CPACRN) TOFILE(&LDLIB/CPACRN)        /*S01473*/
                                                                      /*S01473*/
/* Clear the data area from positions 51 to 80 */                     /*S01473*/
                 CHGDTAARA  DTAARA(*LDA (51 30)) VALUE(' ')           /*S01473*/
                                                                      /*S01473*/
/* Locate the Leo programs used by the RPG program via the Midas +
   program SCC1110. Place the returned libraries in the *LDA for */   /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(SCC1110) PARM('CAOULM' &LIBL)             /*S01473*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01473*/
               CHGDTAARA  DTAARA(*LDA (51 10)) VALUE(&LIBL)           /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
               CHGVAR     VAR(&ERR) VALUE('Y')                        /*S01473*/
               GOTO       CMDLBL(MSG)                                 /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(SCC1110) PARM('CAOULN' &LIBL)             /*S01473*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01473*/
               CHGDTAARA  DTAARA(*LDA (61 10)) VALUE(&LIBL)           /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
               CHGVAR     VAR(&ERR) VALUE('Y')                        /*S01473*/
               GOTO       CMDLBL(MSG)                                 /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             CALL       PGM(SCC1110) PARM('CAOUCA' &LIBL)             /*S01473*/
             IF         COND(&LIBL *NE ' ') THEN(DO)                  /*S01473*/
               CHGDTAARA  DTAARA(*LDA (71 10)) VALUE(&LIBL)           /*S01473*/
             ENDDO                                                    /*S01473*/
             ELSE       CMD(DO)                                       /*S01473*/
               CHGVAR     VAR(&ERR) VALUE('Y')                        /*S01473*/
               GOTO       CMDLBL(MSG)                                 /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
MSG:         IF         COND(&ERR *EQ 'Y') THEN(DO)                   /*S01473*/
/* Send an error message and terminate */                             /*S01473*/
             CHGVAR     VAR(&MESSAGE) VALUE('One or more Leo +
                          programs cannot be located')                /*S01473*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*S01473*/
             CALL       PGM(SCC0010) PARM('EMC0301' 'ENTER' ' ')      /*S01473*/
             GOTO       CMDLBL(ERROR)                                 /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
               CALL       PGM(EM0705)                                 /*S01473*/
               DLTOVR     FILE(LCMAST)                                /*S01473*/
               DLTOVR     FILE(LCNEGS)                                /*S01473*/
               DLTOVR     FILE(CPACRN)                                /*S01473*/
               CHGDTAARA  DTAARA(*LDA (51 30)) VALUE(' ')             /*S01473*/
             ENDDO                                                    /*S01473*/
                                                                      /*S01473*/
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)
             CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('N')
/**/
    ERROR:
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
