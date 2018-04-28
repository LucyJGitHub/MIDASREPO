/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Create deliverables list')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0090 - Create Deliverables List                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR936709           Date 26Mar12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK020             Date 28Jul04              */
/*                      CPK018             Date 05Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001  *CREATE    Date 29Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR936709 - Create UPERRMQT earlier in the process.          */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK020 - Handle deliverable data.                           */
/*       CPK018 - MidasPlus packaging.  UPDLVCPD in Global layer.    */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRC &DLVLIB &DFTLIB &CRTOPT &PROJECT)
 
/* Command parameters */
 
/**COPY*UPCPYSRCG,UPGSVALDCL*                                        */ /*  */ /*CPK018*/ /*CUP033*/
             DCL        VAR(&SRC) TYPE(*CHAR) LEN(202)
             DCL        VAR(&DLVLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&DFTLIB) TYPE(*CHAR) LEN(8)                                */ /*CPK020*/
             DCL        VAR(&DFTLIB) TYPE(*CHAR) LEN(10)                                  /*CPK020*/
             DCL        VAR(&CRTOPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PROJECT) TYPE(*CHAR) LEN(10)
 
/* Work variables */
             DCL        VAR(&SVAL) TYPE(*CHAR) LEN(200)                                   /*CUP033*/
             DCL        VAR(&GPSBSID) TYPE(*CHAR) LEN(2)                                  /*CUP033*/
             DCL        VAR(&AORTN) TYPE(*CHAR) LEN(7)                                    /*CUP033*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(10)                               */ /*CUP033*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&NBRSRC) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&NBRSRCB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&SRC1) TYPE(*CHAR) LEN(10)                                 */ /*CPK010*/
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&START1) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&START2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Delete and recreate temporary error message file. */                                 /*AR936709*/
             DLTF       FILE(QTEMP/UPERRMQT)                                            /*AR936709*/
             MONMSG     MSGID(CPF0000)                                                  /*AR936709*/
             CRTPF      FILE(QTEMP/UPERRMQT) RCDLEN(100) +
                          TEXT('Temporary error file for CRTDLVLST')                    /*AR936709*/
                                                                                        /*AR936709*/
/* Ensure deliverables library is top of library list */
             RMVLIBLE   LIB(&DLVLIB)
             MONMSG     MSGID(CPF0000)
 
             ADDLIBLE   LIB(&DLVLIB)
 
/* Retrieve system prefix and set up library names */
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                           */ /*CPK018*/
/**********  CHGVAR     VAR(&DVLIB) VALUE(&PREFIX *TCAT 'DVLIB')                       */ /*CPK018*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')                       */ /*CPK018*/
/**COPY*UPCPYSRCG,UPGSVALCL1*                                        */ /*  */ /*CPK018*/ /*CUP033*/
 
             CALL       PGM(GPAOSVALR0) PARM(&AORTN +
                          'BrgMidasGlobalPrefix' &SVAL ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ')                                              /*CUP033*/
             IF         COND(&AORTN *NE '       ') THEN(DO)                               /*CUP033*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
             ELSE       CMD(DO)                                                           /*CUP033*/
                CHGVAR     VAR(&GPSBSID) VALUE(%SST(&SVAL 1 2))                           /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             CHGVAR     VAR(&DVLIB) VALUE(&GPSBSID *TCAT 'GVLIB')                         /*CPK018*/
             CHGVAR     VAR(&DPLIB) VALUE(&GPSBSID *TCAT 'GPLIB')                         /*CPK018*/
 
/* Check for deliverables file in library list.                */
/* If file is not in deliverables library then it is core      */
/* version of file and must be copied to deliverables library. */
             RTVOBJD    OBJ(UPDLVCPD) OBJTYPE(*FILE) RTNLIB(&DTALIB)
             IF         COND(&DTALIB *NE &DLVLIB) THEN(DO)
                MOVOBJ     OBJ(&DPLIB/UPDLVCPD) OBJTYPE(*FILE) +
                          TOLIB(&DVLIB)
                CRTDUPOBJ OBJ(UPDLVC*) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&DLVLIB) DATA(*NO)
                MOVOBJ     OBJ(&DVLIB/UPDLVCPD) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB)
             ENDDO
 
/**If**NONE*is*specified*then*skip*source*file*processing**/ /*                        */ /*CPK018*/
/**********  CHGVAR     VAR(&SRC1) VALUE(%SST(&SRC 3 10))                              */ /*CPK018*/
/**********  IF        COND(&SRC1 *EQ '*NONE') THEN(GOTO CMDLBL(MAINT))                */ /*CPK018*/
 
/* If *REPLACE is requested clear the deliverables list file */
             IF         COND(&CRTOPT *EQ '*REPLACE') THEN(DO)
                CLRPFM     FILE(UPDLVCPD)
             ENDDO
 
/* Retrieve number of source files from list variable */
             CHGVAR     VAR(&NBRSRCB) VALUE(%SST(&SRC 1 2))
             CHGVAR     VAR(&NBRSRC) VALUE(%BIN(&NBRSRCB))
             CHGVAR     VAR(&START1) VALUE(3)
 
/* Generate deliverables list from source files */
SRCLOOP:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE &NBRSRC) THEN(DO)
                CHGVAR     VAR(&START2) VALUE(&START1 + 10)
                CHGVAR     VAR(&SRCF) VALUE(%SST(&SRC &START1 10))
                CHGVAR     VAR(&SRCLIB) VALUE(%SST(&SRC &START2 10))
 
                CALL       PGM(UP0090) PARM(&SRCF &SRCLIB &DFTLIB +
                             &PROJECT)
 
                CHGVAR     VAR(&START1) VALUE(&START1 + 20)
                GOTO       CMDLBL(SRCLOOP)
             ENDDO
 
/* Process deliverable data if required. */                                               /*CPK020*/
             IF         COND(&DFTLIB *NE '*NONE') THEN(DO)                                /*CPK020*/
                CALL       PGM(UPC0094) PARM(&DFTLIB)                                     /*CPK020*/
             ENDDO                                                                        /*CPK020*/
 
/**Maintain*deliverables*list**/ /*                                                    */ /*CPK018*/
/*MAINT:***                                                                            */ /*CPK018*/
/**********  OVRMSGF    MSGF(Y2USRMSG) TOMSGF(GBY2USRMSG)                              */ /*CPK018*/
/**********  CALL       PGM(UP0090D) PARM(&RTNCDE)                                     */ /*CPK018*/
 
             RETURN
 
 ABNOR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
