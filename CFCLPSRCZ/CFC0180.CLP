/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CF MIDAS/TRAM interface control')               */
/*********************************************************************/
/*                                                                   */
/*     Midas - CONFIRMATION MATCHING                         */
/*                                                                   */
/*     CFC0180 -  MIDAS/TRAM INTERFACE CONTROL                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD053298           Date 16May19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01310             Date 06Dec90              */
/*                     00000            DATE 00XXX00                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     MD053298 - TRAM application cannot process .dat files as      */
/*                midas.dat file is created too soon by the          */
/*                CFCONTROL job                                      */
/*       MD046248 - Finastra Rebranding                              */
/*     CCB020 - COB Restructure - Secondary COB Infrastructure       */
/*     S01310 - SWIFT RATIONALISATION                                */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCL        VAR(&CFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ENTRY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNVAR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TFRPD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&TRAMID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LENB) TYPE(*DEC) LEN(5 0) VALUE(1)   /*S01304*/
             DCL        VAR(&EODM) TYPE(*CHAR) LEN(1) VALUE(' ')  /*S01304*/
             DCL        VAR(&WAITZ) TYPE(*DEC) LEN(5 0) VALUE(1)  /*S01304*/
/*/COPY WNCPYSRC,CFC0180003                                          */

             DCLF       SDCONFPD

/* Global monitor messages                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) +
                          EXEC(GOTO ABNOR)

/* This program is a background job, run throughout Input Cycle */
/* It is called once from I/C Term and COB                      */
/* If run during IC initiation delay until MPHAS is A, B or C   */

/*START:***   RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)              */                     /*CCB020*/
/**********  IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE 'B') +                  */ /*CCB020*/
/**********               *AND (&MPHAS *NE 'C')) THEN(DO)                              */ /*CCB020*/
/**********  DLYJOB     DLY(300)                                                       */ /*CCB020*/
/**********  GOTO START                                                                */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/

             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                    /*MD053298*/
/*/COPY WNCPYSRC,CFC0180004                                          */
/* Create Local Data Area for a batch job */
             IF         COND(&MPHAS *NE 'C') THEN(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG       MSGID(CPF0000)
             ENDDO

/* Clear CFDTQZ to remove old messages from SDC05 */
 CLEAR:      CHGVAR     VAR(&EODM) VALUE(' ')
             CALL       PGM(QRCVDTAQ) PARM(CFDTQZ *LIBL &LENB &EODM &WAITZ)
             IF         COND(&EODM *EQ 'Y') THEN(GOTO CLEAR)

/* Access SDCONFPD */
             RCVF
             DLCOBJ     OBJ((SDCONFPD *FILE *SHRRD))

/* Calculate input cycle transfer period */
/**********  IF         COND(&MPHAS *EQ 'A') THEN(CHGVAR VAR(&TFRPD) +                 */ /*CCB020*/
/**********               VALUE(&DSTFFQ * 60))                                         */ /*CCB020*/
             IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G'))   +
                          THEN(CHGVAR VAR(&TFRPD) VALUE(&DSTFFQ * 60))                    /*CCB020*/

             RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)

/**If*in*IC*termination*or*COB******/                                                     /*CCB020*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********  IF         COND((&MPHAS *EQ 'B') *OR (&MPHAS *EQ 'C')) +                  */ /*CCB020*/
/**********               THEN(DO)                                                     */ /*CCB020*/
/* If in Close of Business                                                                  CCB020*/
             IF         COND(&MPHAS *EQ 'C') THEN(DO)                                     /*CCB020*/
             CALL       PGM(CFC0185) PARM(&TRAMID &DSIOIA &DSICIA +
                          &MPHAS &DSGTOC &RTNVAR)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(&RTNVAR *EQ '1') THEN(GOTO CMDLBL(ABNOR))

/*/COPY WNCPYSRC,CFC0180005                                          */
/* If COB call CF0070 to clear feedback file */
             IF         COND(&MPHAS *EQ 'C') THEN(DO)
/*/COPY WNCPYSRC,CFC0180001                                          */
             CALL       PGM(CF0070)
/*/COPY WNCPYSRC,CFC0180002                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO

/* Call status changes audit after final feedback collection */
             CALL       PGM(CFC0030)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO
             ENDDO
             ENDDO

/* IC loop delayed by transfer period after first time through */
ICLOOP:      RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)

/**********  IF         COND((&MPHAS *EQ 'A')) THEN(DO)                                */ /*CCB020*/
             IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                          THEN(DO)                                                        /*CCB020*/
             CHGDTAARA  DTAARA(CFSTAT (49 6)) VALUE('DELAY ')
             RTVDTAARA  DTAARA(CFSTAT) RTNVAR(&CFSTAT)
             IF         COND(&ENTRY *EQ 'N') THEN(CALL PGM(QRCVDTAQ) +
                          PARM(CFDTQZ *LIBL &LENB &EODM &TFRPD)) +

/* If the Phase of Day has changed since the DELAY started exit */
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********  IF         COND(&MPHAS *NE 'A') THEN(GOTO +                               */ /*CCB020*/
/**********               CMDLBL(ENDIC))                                               */ /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE 'G')) +
                          THEN(GOTO CMDLBL(ENDIC))                                        /*CCB020*/
             IF         COND(&EODM *EQ 'Y') THEN(GOTO ENDIC)

             CHGVAR     VAR(&ENTRY) VALUE(N)

             CALL       PGM(CFC0185) PARM(&TRAMID &DSIOIA &DSICIA +
                          &MPHAS &DSGTOC &RTNVAR)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(&RTNVAR *EQ '1') THEN(GOTO CMDLBL(ABNOR))
/*/COPY WNCPYSRC,CFC0180006                                          */

/* Blank out TRAM Id for next loop */
             CHGVAR     VAR(&TRAMID) VALUE('   ')

             GOTO ICLOOP
             ENDDO

/* If the program completes successfully, update ACTIVE/DELAY flag */
/*                                                                 */
/* If not in Input Cycle, do not change status to blanks           */
/* as this could cause another submit of CFCONTROL by              */
/* SDC05 when one is already active (in DELAY mode)                */

 ENDIC:      CHGDTAARA  DTAARA(CFSTAT (49 6)) VALUE('      ')
             GOTO END

 ABNOR:      IF COND(&RTNVAR *EQ '1') THEN(CHGVAR &PGM 'CFC0185   ')
             IF COND(&RTNVAR *NE '1') THEN(CHGVAR &PGM 'CFC0180   ')
                                                                      /*S01304*/
             CHGDTAARA  DTAARA(CFSTAT (49 6)) VALUE('      ')
                                                                      /*S01304*/
             SNDPGMMSG  MSG('Confirmation Matching Control ended +
                          abnormally in ' *CAT &PGM) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
