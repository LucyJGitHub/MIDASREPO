/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Upgrade command selection and savefile')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UTC0900 - Create Data Backup prior to Bridge Processing     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP034             Date 25Jan06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP022             Date 31Mar04              */
/*                      CSF002             Date 01Sep03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CPK015             DATE 09Dec02              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CUP020             Date 10Oct02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CUP017             Date 28Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CUP008             Date 27Sep00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CUP006             Date 11Jan00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPK010             Date 04Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001             Date 15Feb99              */
/*                      138018             Date 30Jul98              */
/*                      CUP004 *CREATE     Date 10Jun98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP034 - Reduce size of implementation library              */
/*       CUP022 - Use command ACTIONFILE instead of individual file  */
/*                command &CMD.                                      */
/*              - Prompt command BUILD. Commnd REVIEW is prompted    */
/*                only when review type parm = 'Y'.                  */
/*              - Move the update of FCREPTPD to UPC000799.          */
/*              - Remove call of UPC0895.                            */
/*       CSF002 - Global Processing changes for SPF.                 */
/*       CPK015 - Remove Amend parameter.                            */
/*       CUP020 - Added the extra parameter for the review for       */
/*                CBCMPNPD, MITEM, FCREPTPD                          */
/*       CUP017 - Enhancements to Action Files.                      */
/*       CUP008 - Library for data file now not forced to be DTALIB  */
/*       CUP006 - Update UTMENUPD if changed and length of &SAVFILE  */
/*                changed                                            */
/*       CPK010 - Errors found in DBAR3.00 alpha site                */
/*       CUP001 - Introduction of BRIDGE                             */
/*       138018 - Add processing for FCREPTPD trailer                */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
/*       Position in &PARM parameter                                 */
/*       Position 1 - Reset                                          */
/*       Position 2 - Build                                          */
/*       Position 3 - Review                                         */
/*       Position 4 - Process                                        */
/*       Position 5 - Conflict Report                                */
/*       Position 6 - Review Type                                    */
/*********************************************************************/
/******      PGM        PARM(&CMD &PARM &FILE)                                            /*CUP022*/
             PGM        PARM(&PARM &FILE)                                                 /*CUP022*/
 
/******      DCL        VAR(&CMD) TYPE(*CHAR) LEN(10)                                     /*CUP022*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(30)                                     /*CUP022*/
             DCL        VAR(&CMDPMT) TYPE(*CHAR) LEN(30)                                  /*CUP022*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RESET) TYPE(*CHAR) LEN(4) VALUE(*NO)
             DCL        VAR(&BUILD) TYPE(*CHAR) LEN(4) VALUE(*NO)
             DCL        VAR(&REVIEW) TYPE(*CHAR) LEN(4) VALUE(*NO)
             DCL        VAR(&CONFLICT) TYPE(*CHAR) LEN(4) VALUE(*NO)                      /*CUP017*/
             DCL        VAR(&PROCESS) TYPE(*CHAR) LEN(4) VALUE(*NO)
             DCL        VAR(&SAVLIB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&SAVFILE) TYPE(*CHAR) LEN(20)                                 /*CUP006*/
             DCL        VAR(&SAVFILE) TYPE(*CHAR) LEN(10)                                 /*CUP006*/
/************DCL        VAR(&CMDSTR) TYPE(*CHAR) LEN(100)                                 /*CUP022*/
/************DCL        VAR(&CMDLEN) TYPE(*DEC) LEN(15 5) VALUE(100)                      /*CUP022*/
             DCL        VAR(&CMDSTR) TYPE(*CHAR) LEN(150)                                 /*CUP022*/
             DCL        VAR(&CMDLEN) TYPE(*DEC) LEN(15 5) VALUE(150)                      /*CUP022*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&UPGLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(20)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&SDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UTPROC) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CUP006*/
             DCL        VAR(&SVAL) TYPE(*CHAR) LEN(200)                                   /*CUP034*/
             DCL        VAR(&AORTN) TYPE(*CHAR) LEN(7)                                    /*CUP034*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000)
 
/* Main processing */
             CHGJOB     SWS(XXXXXX00)
 
/* Get system prefix. */                                                                  /*CUP034*/
             CALL       PGM(AOSVALR0) PARM(&AORTN +
                          'BrgMidasSystemPrefix' &SVAL ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' +
                          ' ' ' ' ' ' ' ' ')                                              /*CUP034*/
             IF         COND(&AORTN *NE '       ') THEN(DO)                               /*CUP034*/
                GOTO       CMDLBL(ABNOR)                                                  /*CUP034*/
             ENDDO                                                                        /*CUP034*/
             ELSE       CMD(DO)                                                           /*CUP034*/
                CHGVAR     VAR(&PREFIX) VALUE(%SST(&SVAL 1 2))                            /*CUP034*/
             ENDDO                                                                        /*CUP034*/
 
             CALL       PGM(UPC0014) PARM(&PREFIX)                                        /*CUP034*/
 
/* Set &CMD as 'ACTIONFILE filename' */                                                   /*CUP022*/
             CHGVAR     VAR(&CMD) VALUE('ACTIONFILE' *BCAT +
                          'FILE(' *TCAT &FILE *TCAT ')')                                  /*CUP022*/
 
/* Set &CMDPMT as ACTIONFILE for prompt' */                                               /*CUP022*/
             CHGVAR     VAR(&CMDPMT) VALUE('ACTIONFILE' *BCAT +
                          '?*FILE(' *TCAT &FILE *TCAT ')')                                /*CUP022*/
 
/**Retrieve*data*library*prefix*from*SDSTAT*data*area**/ /*                            */ /*CUP034*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                           */ /*CUP034*/
 
             RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE) RTNLIB(&SDTALIB)                        /*CUP008*/
 
/**Create*UPDFFDPD*file*in QTEMP by calling UPC0895 */                                    /*CUP022*/
/************CHGVAR     VAR(&SDTALIB) VALUE(&PREFIX *CAT 'DTALIB')                     */ /*CUP008*/
/************CALL       PGM(UPC0895) PARM(&FILE &SDTALIB)                                 /*CUP022*/
 
/* Chose required processing option */
             IF         COND(%SST(&PARM 1 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&RESET) VALUE('*YES')
                GOTO       CMDLBL(RESET)
             ENDDO
 
             IF         COND(%SST(&PARM 2 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&BUILD) VALUE('*YES')
                GOTO       CMDLBL(BUILD)
             ENDDO
 
             IF         COND(%SST(&PARM 3 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&REVIEW) VALUE('*YES')
             IF         COND(%SST(&PARM 6 1) *EQ 'Y') THEN(DO)                            /*CUP020*/
                GOTO       CMDLBL(REVIEW2)                                                /*CUP020*/
             ENDDO                                                                        /*CUP020*/
/*           ELSE                                                   */         /*CUP020*/ /*CUP022*/
                GOTO       CMDLBL(REVIEW)
             ENDDO
 
             IF         COND(%SST(&PARM 4 1) *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&PROCESS) VALUE('*YES')
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND(%SST(&PARM 5 1) *EQ 'Y') THEN(DO)                            /*CUP017*/
                CHGVAR     VAR(&CONFLICT) VALUE('*YES')                                   /*CUP017*/
                GOTO       CMDLBL(CONFLICT)                                               /*CUP017*/
             ENDDO                                                                        /*CUP017*/
 
/* Reset processing */
 RESET:
/* Set up messages for Midas Information Screen  */
 
             RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE) RTNLIB(&UPGLIB)
             CHGVAR     VAR(&MSGDTA) VALUE(&FILE *CAT &UPGLIB)
             RTVMSG     MSGID(SCM0158) MSGF(MIDASMSG) +
                          MSGDTA(&MSGDTA) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
 
             RTVMSG     MSGID(SCM0159) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0160) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('UTC0900' 'OPTION2' &REPLY1)
             IF         COND(&REPLY1 *EQ 'N') THEN(GOTO CMDLBL(END))
 
/* Save xxDTALIB data to xxDPLIB prior to any processing */
             CHGVAR     VAR(&SAVFILE) VALUE('@' *CAT &FILE)
             CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')
             DLTF       FILE(&SAVLIB/&SAVFILE)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(&FILE) TOFILE(&SAVLIB/&SAVFILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
 
/* Carry out command using parameters required for RESET operation */
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*RESET(*YES)')                   /*CUP022*/
             CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT 'RESET(*YES)')                     /*CUP022*/
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)
             MONMSG     MSGID(CPF6801)
             GOTO       CMDLBL(END)
 
/* Build processing */
 BUILD:
 
/* Carry out command using parameters required for BUILD operation */
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*BUILD(*YES) +                 */ /*CUP017*/
/************             ??REVIEW(*NO) ??OLDLIB(' *TCAT &PREFIX +                     */ /*CUP017*/
/************             *TCAT ') ??NEWLIB(XX)')                                      */ /*CUP017*/
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*BUILD(*YES) +
                          ??REVIEW(*NO) ??OLDLIB(' *TCAT &SDTALIB +
                          *TCAT ') ??NEWLIB(xxDTALIB)')                        /*CUP017*/ /*CUP022*/
/* If review type ='Y', prompt review type as well. */                                    /*CUP022*/
             IF         COND(%SST(&PARM 6 1) *EQ 'Y') THEN+
                (CHGVAR     VAR(&CMDSTR) VALUE(&CMDPMT *BCAT '?*BUILD(*YES) +
                              ??REVIEW(*NO) ??OLDLIB(' *TCAT &SDTALIB +
                              *TCAT ') ??NEWLIB(xxDTALIB) +
                              ??REVTYP(*ALL)'))
             ELSE +
                (CHGVAR     VAR(&CMDSTR) VALUE(&CMDPMT *BCAT '?*BUILD(*YES) +
                              ??REVIEW(*NO) ??OLDLIB(' *TCAT &SDTALIB +
                              *TCAT ') ??NEWLIB(xxDTALIB)'))                             /*CUP022*/
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)
             MONMSG     MSGID(CPF6801)
             GOTO       CMDLBL(END)
 
/* Review processing */
 REVIEW:
 
/* Carry out command using parameters required for BUILD operation */
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*REVIEW(*YES)')                  /*CUP022*/
             CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT 'REVIEW(*YES)')                    /*CUP022*/
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)
             MONMSG     MSGID(CPF6801)
             GOTO       CMDLBL(END)
/* Review processing 2 This is related to some of the review options having run options   /*CUP020*/
                                                                                          /*CUP020*/
 REVIEW2:                                                                                 /*CUP020*/
                                                                                          /*CUP020*/
/* Carry out command using parameters required for BUILD operation */                     /*CUP020*/
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT +
                          '?*REVIEW(*YES) ??REVTYP(*ALL)')                     /*CUP020*/ /*CUP022*/
             CHGVAR     VAR(&CMDSTR) VALUE(&CMDPMT *BCAT +
                          '?*REVIEW(*YES) ??REVTYP(*ALL)')                                /*CUP022*/
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)                                /*CUP020*/
             MONMSG     MSGID(CPF6801)                                                    /*CUP020*/
             GOTO       CMDLBL(END)                                                       /*CUP020*/
 
/* Conflict processing */                                                                 /*CUP017*/
CONFLICT:                                                                                 /*CUP017*/
/* Carry out command using parameters required for CONFLICT operation */                  /*CUP017*/
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*CONFLICT(*YES)')                 /*CUP022*/
             CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT 'CONFLICT(*YES)')                   /*CUP022*/
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)                                /*CUP017*/
             MONMSG     MSGID(CPF6801)                                                    /*CUP017*/
             GOTO       CMDLBL(END)                                                       /*CUP017*/
 
/* Process processing */
 PROCESS:
 
/* Save xxDTALIB data to xxDPLIB prior to any processing */
/************CHGVAR   VAR(&SAVFILE) VALUE('@' *CAT %SST(&FILE 2 9))*/ /*CUP001*/
             CHGVAR     VAR(&SAVFILE) VALUE('@' *CAT &FILE)           /*CUP001*/
             CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')
             DLTF       FILE(&SAVLIB/&SAVFILE)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(&FILE) TOFILE(&SAVLIB/&SAVFILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
 
/* Carry out command using parameters required for PROCESS operation */
/************IF         COND(&CMD *EQ 'CBCMPNPD') THEN(DO)                             */ /*CPK015*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '??PROCESS+                   */ /*CUP017*/
/************             (*YES) ??AMEND(*NO)')                                        */ /*CUP017*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*PROCESS+                   */ /*CPK015*/
/************             (*YES) ??AMEND(*NO)')                             */ /*CUP017*/ /*CPK015*/
/************   GOTO       CMDLBL(CALL)                                                */ /*CPK015*/
/************ENDDO                                                                     */ /*CPK015*/
/************IF         COND(&CMD *EQ 'MITEMDD') THEN(DO)                              */ /*CPK015*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '??PROCESS+                   */ /*CUP017*/
/************             (*YES) ??AMEND(*NO)')                                        */ /*CUP017*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*PROCESS+                   */ /*CPK015*/
/************             (*YES) ??AMEND(*NO)')                             */ /*CUP017*/ /*CPK015*/
/************   GOTO       CMDLBL(CALL)                                                */ /*CPK015*/
/************ENDDO                                                                     */ /*CPK015*/
/************IF         COND(&CMD *EQ 'UTMENUPD') THEN(DO)                                /*CUP022*/
             IF         COND(&FILE *EQ 'UTMENUPD') THEN(DO)                               /*CUP022*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT '?*PROCESS+                   */ /*CPK010*/
/************             (*YES) ?*AMEND(*NO)')                                        */ /*CPK010*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT +                             */ /*CUP017*/
/************             '??PROCESS(*YES) ??AMEND(*NO)')                      /*CPK010*/ /*CUP017*/
/************   CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT +                             */ /*CPK015*/
/************                '?*PROCESS(*YES) ??AMEND(*NO)')                */ /*CUP017*/ /*CPK015*/
/** Copy to a temporary file first and override to that one so it can be updated          /*CUP006*/
                                                                                          /*CUP006*/
                CPYF       FROMFILE(UTMENUL0) TOFILE(QTEMP/UTMENUQT) +
                             MBROPT(*REPLACE) CRTFILE(*YES)                               /*CUP006*/
                OVRDBF     FILE(UTMENUL0) TOFILE(QTEMP/UTMENUQT)                          /*CUP006*/
                CHGDTAARA  DTAARA(UPSTAT (55 1)) VALUE('Y')                               /*CUP006*/
                CHGVAR     VAR(&UTPROC) VALUE('Y')                                        /*CUP006*/
/************   GOTO       CMDLBL(CALL)                                                */ /*CPK015*/
             ENDDO
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT +                                */ /*CUP017*/
/************             '??PROCESS(*YES)')                                           */ /*CUP017*/
/************CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT +
                          '?*PROCESS(*YES)')                                              /*CUP022*/
             CHGVAR     VAR(&CMDSTR) VALUE(&CMD *BCAT 'PROCESS(*YES)')                    /*CUP022*/
 
CALL:
 
/* Set up messages for Midas Information Screen  */
 
             RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE) RTNLIB(&UPGLIB)
             CHGVAR     VAR(&MSGDTA) VALUE(&FILE *CAT &UPGLIB)
             RTVMSG     MSGID(SCM0158) MSGF(MIDASMSG) +
                          MSGDTA(&MSGDTA) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
 
             RTVMSG     MSGID(SCM0159) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0160) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('UTC0900' 'OPTION2' &REPLY1)
             IF         COND(&REPLY1 *EQ 'N') THEN(GOTO CMDLBL(END))
 
             CALL       PGM(QCMDEXC) PARM(&CMDSTR &CMDLEN)
             MONMSG     MSGID(CPF6801)
 
/**Reset*MITEMZZ*(MITEMDD*trailer)**/ /*                                               */ /*CSF002*/
/***********                                                                           */ /*CSF002*/
/*********** IF         COND(&CMD *EQ 'MITEMDD') THEN(CALL PGM(UP0823))                */ /*CSF002*/
                                                                      /*138018*/
/**Reset*FCRPDSPA (FCREPTPD trailer) */                               /*138018*/          /*CUP022*/
/***********                                                          /*138018*/          /*CUP022*/
/*********** IF         COND(&CMD *EQ 'FCREPTPD') THEN(CALL +
                          PGM(UP0828))                             */ /*138018*/          /*CUP022*/
                                                                      /*138018*/
/* If UTMENUPD is being updated, delete overrides                                         /*CUP006*/
             IF         COND(&UTPROC *EQ 'Y') THEN(DO)                                    /*CUP006*/
                DLTOVR     FILE(UTMENUL0)                                                 /*CUP006*/
             ENDDO                                                                        /*CUP006*/
                                                                                          /*CUP006*/
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Copy back save-file if error occurred (U7 & U8 on) */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CPYF       FROMFILE(&SAVLIB/&SAVFILE) TOFILE(&FILE) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CHGJOB     SWS(XXXXXX00)
             ENDDO
 
             SNDPGMMSG  MSGID(UT00001) MSGF(*LIBL/UTMSGF) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
 
             ENDPGM
