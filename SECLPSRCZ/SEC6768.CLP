/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Drop of Blocked Positions')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC6768 - SE Drop of Blocked Positions                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU017             Date 03Avr98              */
/*                      CSE007             Date 17Dec97              */
/*                      S01408             Date 10May95              */
/*                      S01496             Date 07Oct94              */
/*                      S10978             Date 19May93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU017 - Securities Redenomination Euro Changes             */
/*       CSE007 - Corporate Actions                                  */
/*       S01408 - Addition of core hook SEC6768MPS                   */
/*       S01496 - Incorporation of JYSKE Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
                                                                      /*CSE007*/
             DCL        VAR(&CSE007) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSE007*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE007*/
             DCL        VAR(&CEU017) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU017*/
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')     */ /*S01496*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*S01496*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6768MPS                                          */
                                                                      /*S01408*/
 
/* Send Information Program Message */
             SNDPGMMSG  MSG('SEC6768 - DROP OF BLOCKED POSITIONS') +
                          TOMSGQ(MRUNQ)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
                                                                      /*CSE007*/
/* Check if feature CSE007 is switched ON. */                         /*CSE007*/
                                                                      /*CSE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE007*/
             CHGVAR     VAR(&SAR) VALUE('CSE007')                     /*CSE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE007*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CSE007) VALUE('Y'))          /*CSE007*/
                                                                      /*CEU017*/
/* Check if feature CEU017 is switched ON. */                         /*CEU017*/
                                                                      /*CEU017*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU017*/
             CHGVAR     VAR(&SAR) VALUE('CEU017')                     /*CEU017*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU017*/
             IF         COND(&RTCD *EQ '       ') +
                        THEN(CHGVAR VAR(&CEU017) VALUE('Y'))          /*CEU017*/
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(SEBLKPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(XSEBLKPPD) SEQONLY(*YES 100)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/* Override to SEQONLY(*YES 100) Corporate Actions Blocked */         /*CSE007*/
/* Positions file and copy.                                */         /*CSE007*/
             OVRDBF     FILE(SECOBKPD)  SEQONLY(*YES 100)             /*CSE007*/
             OVRDBF     FILE(XSECOBKPD) SEQONLY(*YES 100)             /*CSE007*/
             ENDDO                                                    /*CSE007*/
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If it's a Restart, Restore Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DLIB/XSEBLKPPD) TOFILE(SEBLKPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEBLKPPD))
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CSE007 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/* Restore Security copy of Corporate Actions Positions file. */      /*CSE007*/
             CPYF       FROMFILE(&DLIB/XSECOBKPD) TOFILE(SECOBKPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*CSE007*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SECOBKPD))                             /*CSE007*/
             ENDDO                                                    /*CSE007*/
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(&DLIB/XSEBLKPPD)
             MONMSG MSGID(CPF0000)
 
             CPYF       FROMFILE(SEBLKPPD) TOFILE(&DLIB/XSEBLKPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/* Delete Copy of Corporate Actions Blocked Positions file. */        /*CSE007*/
             DLTF       FILE(&DLIB/XSECOBKPD)                         /*CSE007*/
             MONMSG MSGID(CPF0000)                                    /*CSE007*/
                                                                      /*CSE007*/
/* Create Copy of Corporate Actions Blocked Positions file. */        /*CSE007*/
             CPYF       FROMFILE(SECOBKPD) TOFILE(&DLIB/XSECOBKPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*CSE007*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CSE007*/
             ENDDO                                                    /*CSE007*/
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
 
/* Delete overrides */
             DLTOVR     FILE(SEBLKPPD XSEBLKPPD)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/* Delete override on Corporate Actions Blocked Positions file. */    /*CSE007*/
             DLTOVR     FILE(SECOBKPD XSECOBKPD)                      /*CSE007*/
             ENDDO                                                    /*CSE007*/
 
/* Call RPG name */
             CALL       PGM(SE6768)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6768 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6768 ENDED ABNORMALLY FOR JOB ' *CAT  +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Delete Security Copies */
             DLTF       FILE(&DLIB/XSEBLKPPD)
             MONMSG MSGID(CPF0000)
                                                                      /*CSE007*/
/* If feature CSE007 is switched ON. */                               /*CSE007*/
/* or feature CEU017 is switched ON. */                               /*CEU017*/
/************IF         COND(&CSE007 *EQ 'Y') THEN(DO)         /*CSE007 CEU017*/
             IF         COND((&CSE007 *EQ 'Y') *OR +
                            (&CEU017 *EQ 'Y')) THEN(DO)               /*CEU017*/
                                                                      /*CSE007*/
/* Delete Security Copy of Corporate Actions Blocked Positions */     /*CSE007*/
/* file.                                                       */     /*CSE007*/
             DLTF       FILE(&DLIB/XSECOBKPD)                         /*CSE007*/
             MONMSG MSGID(CPF0000)                                    /*CSE007*/
             ENDDO                                                    /*CSE007*/
 
ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
