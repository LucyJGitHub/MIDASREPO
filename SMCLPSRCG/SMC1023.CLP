/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Create libraries, etc. for initial set up')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1023 - Create libraries, etc. for intiial set up         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CBF012             Date 04Jul11              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 07Sep05              */
/*                      CUP094             Date 03Feb05              */
/*                      CPK018             Date 14Jun04              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CBF012 - BF Infrastructure: Upgradability                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CSM005 - Changes to library list for MidasPlus.             */
/*       CUP094 - Changes to create MIDASOWNER user profile.         */
/*       CPK018 - Handle new program library naming convention.      */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&LIBGRP)   */                                                /*CBF012*/
             PGM        PARM(&LIBGRP &GPSBSID)                                            /*CBF012*/
 
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GPSBSID) TYPE(*CHAR) LEN(2)                                  /*CBF012*/
 
             DCL        VAR(&FOUND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DIRE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('**')
             DCL        VAR(&PATTERN2) TYPE(*CHAR) LEN(2) VALUE('##')                     /*CBF012*/
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
             DCL        VAR(&IASP_PARM) TYPE(*CHAR) LEN(18)                               /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
 
/* Declare driving file keyed on QSYS library. */
             DCLF       FILE(SMSETUL1)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
/*                                                                                        /*CSC043*/
/** and define IASP parameter for CRTLIB command. */                                      /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_PARM) VALUE('ASPDEV(' *CAT &IASP *TCAT ')')            /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/* Display list of directory entries for call to SM001025. */
             DSPDIRE    OUTPUT(*OUTFILE) OUTFILE(QTEMP/SMDIREOF)
 
READNEXT:
/* File is keyed on sequence so objects should be created in order. */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* Scan object name to replace '**' with system ID. */
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&LIBGRP)
             ENDDO
                                                                                          /*CBF012*/
/** Scan object name to replace '##' with global system ID  */                            /*CBF012*/
             CHGVAR     VAR(&RESULT) VALUE('0')                                           /*CBF012*/
             CHGVAR     VAR(&STRLEN) VALUE(10)                                            /*CBF012*/
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)                                                        /*CBF012*/
             IF         COND(&RESULT *GT 0) THEN(DO)                                      /*CBF012*/
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&GPSBSID)                  /*CBF012*/
             ENDDO                                                                        /*CBF012*/
/**If*there*is*nothing*to*be*changed*then*do*not*attempt*to*create*at*this***/ /*CPK018*/ /*CSM005*/
/**********  ELSE       CMD(DO)                                             */ /*CPK018*/ /*CSM005*/
/**********     IF         COND(&DFTYPE *EQ '*LIB') THEN(DO)                */ /*CUP094*/ /*CSM005*/
/**********        GOTO       CMDLBL(READNEXT)                              */ /*CPK018*/ /*CSM005*/
/**********     ENDDO                                                       */ /*CUP094*/ /*CSM005*/
/**********  ENDDO                                                          */ /*CPK018*/ /*CSM005*/
 
/* Scan command to replace '**' with system ID. */
SCAN:
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(300)
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&LIBGRP)
                GOTO       CMDLBL(SCAN)
             ENDDO
                                                                                          /*CBF012*/
/** Scan command to replace '##' with global system ID  */                                /*CBF012*/
SCAN2:                                                                                    /*CBF012*/
             CHGVAR     VAR(&RESULT) VALUE('0')                                           /*CBF012*/
             CHGVAR     VAR(&STRLEN) VALUE(300)                                           /*CBF012*/
             CALL       PGM(QCLSCAN) PARM(&DFCMD &STRLEN &STRPOS +
                          &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)                                                        /*CBF012*/
             IF         COND(&RESULT *GT 0) THEN(DO)                                      /*CBF012*/
                CHGVAR     VAR(%SST(&DFCMD &RESULT 2 )) VALUE(&GPSBSID)                   /*CBF012*/
                GOTO       CMDLBL(SCAN2)                                                  /*CBF012*/
             ENDDO                                                                        /*CBF012*/
 
/*                                                                                        /*CSC043*/
/** If creating a library other than XLIB and GXLIB, */                                   /*CSC043*/
/** and IASP environment is specified */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND((&DFTYPE *EQ '*LIB      ') *AND +
                          (%SST(&DFNAME 3 8) *NE 'XLIB    ') *AND +
                          (%SST(&DFNAME 3 8) *NE 'GXLIB   ') *AND +
                          (&IASP_YN *EQ 'Y')) THEN(DO)                                    /*CSC043*/
/*                                                                                        /*CSC043*/
/** append IASP parameter to command string. */                                           /*CSC043*/
/*                                                                                        /*CSC043*/
             CHGVAR     VAR(&DFCMD) VALUE(&DFCMD *BCAT &IASP_PARM)                        /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/* Special processing for certain object types. */
             IF         COND(%SST(&DFTYPE 1 1) *EQ '*') THEN(DO)
                CHKOBJ     OBJ(&DFNAME) OBJTYPE(&DFTYPE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
                ENDDO
             ENDDO
 
/* If the command is to add a directory entry then check to see if it already exists. */
             IF         COND(&DFTYPE *EQ 'ADDDIRE') THEN(DO)
                CHGVAR     VAR(&DIRE) VALUE(&DFNAME)
                CHGVAR     VAR(&FOUND) VALUE(' ')
                CALL       PGM(SM001025) PARM(&DIRE &FOUND)
                IF         COND(&FOUND *EQ 'Y') THEN(DO)
                   GOTO       CMDLBL(READNEXT)
                ENDDO
             ENDDO
/* For non-objects execute command. */
             IF         COND(%SST(&DFTYPE 1 1) *NE '*') THEN(DO)
                CALL       PGM(QCMDEXC) PARM(&DFCMD 300)
/* Authorisation list entry not removed. */
                MONMSG     MSGID(CPF2285)
/* Group profile not found. */
                MONMSG     MSGID(CPF2259)
/* Directory entry not added. */
                MONMSG     MSGID(CPF9082)
/* F3 taken from command prompt. */
                MONMSG     MSGID(CPF6801)
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
