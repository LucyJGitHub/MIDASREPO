/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change system references')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC8005 - Change system references                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. BUG27793           Date 08Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK016             Date 07Oct03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CUP020  *CREATE    Date 03Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27793 - Make migration multi-streamed.                   */
/*       CPK016 - Release 5 packaging.  Add overrides.               */
/*       CUP020 - New utility for changing system IDs                */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FROMSYSID &TOSYSID)                                    */ /*BUG27793*/
             PGM        PARM(&FROMSYSID &TOSYSID &MODE)                                 /*BUG27793*/
 
             DCL        VAR(&FROMSYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOSYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(4)                                   /*BUG27793*/
 
             DCL        VAR(&FDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CGDTA) TYPE(*CHAR) LEN(512)
             DCL        VAR(&TIDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&CFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RPTRG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')                   /*BUG27793*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Set status to ACTIVE. */                                                             /*BUG27793*/
             IF         COND(&MODE *EQ '*MIG') THEN(DO)                                 /*BUG27793*/
                CALL       PGM(SM000008) PARM('UPC8005' '*PGM' +
                             '*UPDATE' 'ACTIVE')                                        /*BUG27793*/
             ENDDO                                                                      /*BUG27793*/
 
             CHGVAR     VAR(&TDMLIB) VALUE(&TOSYSID *TCAT 'DMLIB')
 
SDSTAT:
             CHGDTAARA  DTAARA(&TDMLIB/SDSTAT (6 2)) VALUE(&TOSYSID)
CGDTA:
             RTVDTAARA  DTAARA(&TDMLIB/CGDTA) RTNVAR(&CGDTA)
             IF         COND(%SST(&CGDTA 7 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/CGDTA (7 2)) VALUE(&TOSYSID)
             ENDDO
TIDTA:
             RTVDTAARA  DTAARA(&TDMLIB/TIDTA) RTNVAR(&TIDTA)
             IF         COND(%SST(&TIDTA 11 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/TIDTA (11 2)) VALUE(&TOSYSID)
             ENDDO
CFSTAT:
             RTVDTAARA  DTAARA(&TDMLIB/CFSTAT) RTNVAR(&CFSTAT)
             IF         COND(%SST(&CFSTAT 1 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/CFSTAT (1 2)) VALUE(&TOSYSID)
             ENDDO
             IF         COND(%SST(&CFSTAT 4 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/CFSTAT (4 2)) VALUE(&TOSYSID)
             ENDDO
MSSTAT:
             RTVDTAARA  DTAARA(&TDMLIB/MSSTAT) RTNVAR(&MSSTAT)
             IF         COND(%SST(&MSSTAT 255 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/MSSTAT (255 2)) VALUE(&TOSYSID)
             ENDDO
RPTRG:
             RTVDTAARA  DTAARA(&TDMLIB/RPTRG) RTNVAR(&RPTRG)
             IF         COND(%SST(&RPTRG 1 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/RPTRG (1 2)) VALUE(&TOSYSID)
             ENDDO
             IF         COND(%SST(&RPTRG 21 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/RPTRG (21 2)) VALUE(&TOSYSID)
             ENDDO
             IF         COND(%SST(&RPTRG 39 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/RPTRG (39 2)) VALUE(&TOSYSID)
             ENDDO
             IF         COND(%SST(&RPTRG 49 2) *NE '  ') THEN(DO)
                CHGDTAARA  DTAARA(&TDMLIB/RPTRG (49 2)) VALUE(&TOSYSID)
             ENDDO
CFBRCHPD:
             OVRDBF     FILE(CFBRCHPD) TOFILE(&TDMLIB/CFBRCHPD)
             CALL       PGM(UP8005) PARM(&TOSYSID)
             DLTOVR     FILE(CFBRCHPD)
MSSENDPD:
             OVRDBF     FILE(MSSENDPD) TOFILE(&TDMLIB/MSSENDPD)                           /*CPK016*/
             CALL       PGM(UP8006) PARM(&FROMSYSID &TOSYSID)
             DLTOVR     FILE(MSSENDPD)                                                    /*CPK016*/
MSRCVFPD:
             OVRDBF     FILE(MSRCVFPD) TOFILE(&TDMLIB/MSRCVFPD)                           /*CPK016*/
             CALL       PGM(UP8016) PARM(&FROMSYSID &TOSYSID)
             DLTOVR     FILE(MSRCVFPD)                                                    /*CPK016*/
 
             IF         COND(&MODE *EQ '*MIG') THEN(DO)                                 /*BUG27793*/
/* If successful then update driving file. */                                           /*BUG27793*/
                CALL       PGM(SM000008) PARM('UPC8005' '*PGM' +
                             '*UPDATE' 'PASSED')                                        /*BUG27793*/
             ENDDO                                                                      /*BUG27793*/
 
             GOTO       CMDLBL(ENDPGM)
 
ERROR:
             IF         COND(&RECURSIVE *EQ 'N') THEN(DO)                               /*BUG27793*/
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')                                   /*BUG27793*/
                CHGJOB     SWS(XXXXXX11)
/* Set status to FAILED. */                                                             /*BUG27793*/
                IF         COND(&MODE *EQ '*MIG') THEN(DO)                              /*BUG27793*/
                   CALL       PGM(SM000008) PARM('UPC8005' '*PGM' +
                                '*UPDATE' 'FAILED')                                     /*BUG27793*/
                ENDDO                                                                   /*BUG27793*/
             ENDDO                                                                      /*BUG27793*/
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
