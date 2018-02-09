/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Copy data - exception handling')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0260 - Copy data; exception handling                     */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP039             Date 11Jan11              */
/*                      BUG27793           Date 16Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK025             Date 03Aug06              */
/*                      CPK023             Date 16Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP039 - Calls to status program are incorrect.             */
/*       BUG27793 - Make migration multi-streamed.                   */
/*       CPK025 - MidasPlus 1.3 packaging.  General changes for      */
/*                migration.                                         */
/*       CPK023 - Improve error handling for copies.                 */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CPK025*/
             PGM        PARM(&OLDSBSID &SBSID)                                            /*CPK025*/
 
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CPK025*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CPK025*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CPK025*/
/**********  DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)                                */ /*CPK025*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CPK025*/
 
             DCL        VAR(&R4DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R4DTLIB) TYPE(*CHAR) LEN(10)                               /*BUG27793*/
             DCL        VAR(&R3DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R3DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set status to ACTIVE. */                                                             /*BUG27793*/
/**********  CALL       PGM(SMC0260) PARM('SMC000031' '*PGM' +                         */ /*CUP039*/
/**********               '*UPDATE' 'ACTIVE')                             */ /*BUG27793*/ /*CUP039*/
             CALL       PGM(SM000008) PARM('SMC0260' '*PGM' +
                          '*UPDATE' 'ACTIVE')                                             /*CUP039*/
 
/**********  RTVDTAARA  DTAARA(UPSTAT) RTNVAR(&UPSTAT)                                 */ /*CSM003*/
/**********  CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 62 2))                         */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&LIBGRP *EQ '  ') THEN(DO)                                */ /*CSM003*/
/**********     CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 60 2))                      */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CPK025*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CPK025*/
 
/* Create variables  to be used only when attempting to copy data areas */
/* from DPLIB to DMLIB.                                                 */
/**********  CHGVAR     VAR(&R4DMLIB) VALUE(&LIBGRP *TCAT 'DMLIB')                     */ /*CSM003*/
/**********  CHGVAR     VAR(&R3DMLIB) VALUE(&SBSID *TCAT 'DMLIB')                      */ /*CSM003*/
/**********  CHGVAR     VAR(&R3DPLIB) VALUE(&SBSID *TCAT 'DPLIB')                      */ /*CSM003*/
             CHGVAR     VAR(&R4DMLIB) VALUE(&SBSID *TCAT 'DMLIB')                         /*CSM003*/
             CHGVAR     VAR(&R3DMLIB) VALUE(&OLDSBSID *TCAT 'DMLIB')                      /*CSM003*/
             CHGVAR     VAR(&R3DPLIB) VALUE(&OLDSBSID *TCAT 'DPLIB')                      /*CSM003*/
             CHGVAR     VAR(&R4DTLIB) VALUE(&SBSID *TCAT 'DTALIB')                      /*BUG27793*/
 
/* For the data areas that have been moved from DPLIB to DMLIB there is */
/*  special processing.                                                 */
CFTEMP:
             CHKOBJ     OBJ(&R3DPLIB/CFTEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CPYDTAARA  FMDTAARA(&R3DMLIB/CFTEMP) +
                             TODTAARA(&R4DMLIB/CFTEMP)
                GOTO       CMDLBL(DLCDTEMP)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/CFTEMP) +
                          TODTAARA(&R4DMLIB/CFTEMP)
DLCDTEMP:
             CHKOBJ     OBJ(&R3DPLIB/DLCDTEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHKOBJ     OBJ(&R3DMLIB/DLCDTEMP) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(FFTEMP)
                ENDDO
                CPYDTAARA  FMDTAARA(&R3DMLIB/DLCDTEMP) +
                             TODTAARA(&R4DMLIB/DLCDTEMP)
                GOTO       CMDLBL(FFTEMP)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/DLCDTEMP) +
                          TODTAARA(&R4DMLIB/DLCDTEMP)
FFTEMP:
             CHKOBJ     OBJ(&R3DPLIB/FFTEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CPYDTAARA  FMDTAARA(&R3DMLIB/FFTEMP) +
                             TODTAARA(&R4DMLIB/FFTEMP)
                GOTO       CMDLBL(GLTEMP)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/FFTEMP) +
                          TODTAARA(&R4DMLIB/FFTEMP)
GLTEMP:
             CHKOBJ     OBJ(&R3DPLIB/GLTEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CPYDTAARA  FMDTAARA(&R3DMLIB/GLTEMP) +
                             TODTAARA(&R4DMLIB/GLTEMP)
                GOTO       CMDLBL(LETEMP)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/GLTEMP) +
                          TODTAARA(&R4DMLIB/GLTEMP)
LETEMP:
             CHKOBJ     OBJ(&R3DPLIB/LETEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CPYDTAARA  FMDTAARA(&R3DMLIB/LETEMP) +
                             TODTAARA(&R4DMLIB/LETEMP)
                GOTO       CMDLBL(SETEMP)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/LETEMP) +
                          TODTAARA(&R4DMLIB/LETEMP)
SETEMP:
             CHKOBJ     OBJ(&R3DPLIB/SETEMP) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CPYDTAARA  FMDTAARA(&R3DMLIB/SETEMP) +
                             TODTAARA(&R4DMLIB/SETEMP)
                GOTO       CMDLBL(CMPRND)
             ENDDO
             CPYDTAARA  FMDTAARA(&R3DPLIB/SETEMP) +
                          TODTAARA(&R4DMLIB/SETEMP)
 
CMPRND:
             CHKOBJ     OBJ(&R3DPLIB/CMPRND) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/**********     GOTO       CMDLBL(ENDPGM)                                            */ /*BUG27793*/
                GOTO       CMDLBL(TABLEV4)                                              /*BUG27793*/
             ENDDO
             CPYF       FROMFILE(&R3DPLIB/CMPRND) +
                          TOFILE(&R4DMLIB/CMPRND) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2868) EXEC(DO)                           /*CPK023*/
/**********     GOTO       CMDLBL(ENDPGM)                                 */ /*CPK023*/ /*BUG27793*/
                GOTO       CMDLBL(TABLEV4)                                              /*BUG27793*/
             ENDDO                                                                        /*CPK023*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)                           /*CPK023*/
/**********     GOTO       CMDLBL(ENDPGM)                                 */ /*CPK023*/ /*BUG27793*/
                GOTO       CMDLBL(TABLEV4)                                              /*BUG27793*/
             ENDDO                                                                        /*CPK023*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870) EXEC(DO)                           /*CPK023*/
/**********     GOTO       CMDLBL(ENDPGM)                                 */ /*CPK023*/ /*BUG27793*/
                GOTO       CMDLBL(TABLEV4)                                              /*BUG27793*/
             ENDDO                                                                        /*CPK023*/
 
TABLEV4:                                                                                /*BUG27793*/
             CHKOBJ     OBJ(&R3DMLIB/TABLEV4) OBJTYPE(*FILE)                            /*BUG27793*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG27793*/
                GOTO       CMDLBL(SUCCESS)                                              /*BUG27793*/
             ENDDO                                                                      /*BUG27793*/
             CPYF       FROMFILE(&R3DMLIB/TABLEV4) +
                          TOFILE(&R4DTLIB/TABLEV4) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)                                            /*BUG27793*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2868)                                  /*BUG27793*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*BUG27793*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)                                  /*BUG27793*/
 
SUCCESS:                                                                                /*BUG27793*/
/* Set status to PASSED. */                                                             /*BUG27793*/
/**********  CALL       PGM(SMC0260) PARM('SMC000031' '*PGM' +                         */ /*CUP039*/
/**********               '*UPDATE' 'PASSED')                             */ /*BUG27793*/ /*CUP039*/
             CALL       PGM(SM000008) PARM('SMC0260' '*PGM' +
                          '*UPDATE' 'PASSED')                                             /*CUP039*/
 
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
/* Set status to FAILED. */                                                             /*BUG27793*/
/**********  CALL       PGM(SMC0260) PARM('SMC000031' '*PGM' +                         */ /*CUP039*/
/**********               '*UPDATE' 'FAILED')                             */ /*BUG27793*/ /*CUP039*/
             CALL       PGM(SM000008) PARM('SMC0260' '*PGM' +
                          '*UPDATE' 'FAILED')                                             /*CUP039*/
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
