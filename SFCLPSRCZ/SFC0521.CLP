/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Drop deleted Midas users in COB')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - SECURITY PROFILE FACILITY                           */
/*                                                                   */
/*       SFC0521  - Drop Deleted Midas User Records in COB           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD041858           Date 24Mar17              */
/*       Prev Amend No. CBF023             Date 04Jan17              */
/*                      MD021155           Date 08Jul13              */
/*                      MD07223            Date 04Apr13              */
/*                      CCB023             Date 06Aug12              */
/*                      CBF005             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG10349           Date 06Feb06              */
/*                      228542             Date 10Aug04              */
/*                      204813             Date 11Aug03              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      201669             Date 18Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSC012             Date 23Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      109875 *Create     Date 12Nov96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD041858 - CBCOBRPD is now cleared by CBC0540.              */
/*       CBF023 - Soft Delete Feature on Security Related Modules    */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Should not clear MACBRDD                         */
/*       MD07223 - GLC4116 seq 20001 in MSGW                         */
/*       CCB023 - COB Restructure - Restructure Input Cycle          */
/*                Termination Components                             */
/*       CBF005 - BF Infrastructure: Single Security User Maintenance*/
/*                Profile                                            */
/*       BUG10349 - Wrong record retrieved from FCRREQL8             */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       204813 - Clear file CBCOBRPD at the end of a successful run.*/
/*       CSF002 - Also drop deleted records in MUSERDD. This program */
/*                will run as a COB component.                       */
/*       201669 - Remove library name when adding logical file       */
/*                members to MACBR, MBRBS, MBROS and MCMPS           */
/*     CSC012 - Release 4 packaging.  DTALIB logicals moved to      */
/*              DVLIB.                                              */
/*       109875 - Also drop deleted records in MBRBSDD, MBROSDD,     */
/*                MCMPSDD, MACBRDD to avoid error in re-inserting    */
/*                a deleted user dropped during COB and file out of  */
/*                balance during COB. Apply fix 080002 or 108848.    */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                                       /*CSF002*/
/**********  PGM        PARM(&CNAM &CSEQ)                             */     /*CSF002*/ /*BUG10349*/
             PGM        PARM(&CNAM &CSEQ &SEQ &LVL &ETY)                                /*BUG10349*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */                     /*CCB023*/
/**********  DCL        VAR(&ID) TYPE(*CHAR) LEN(2)                */                     /*CCB023*/
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)                                    /*BUG10349*/
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)                                    /*BUG10349*/
             DCL        VAR(&ETY) TYPE(*CHAR) LEN(3)                                    /*BUG10349*/
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)            */                     /*CCB023*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                    /*CSF002*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                    /*CSF002*/
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */          /*CSF002*/ /*CCB023*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CBF023*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CBF023*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CBF023*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CBF023*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CBF023*/
             DCL        VAR(&CBF023) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CBF023*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))

/** Check if CBF023 is installed */                                                       /*CBF023*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CBF023*/
             CHGVAR     VAR(&SARD) VALUE('CBF023')                                        /*CBF023*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CBF023*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*CBF023*/
                                                                                          /*CBF023*/
/** Database error */                                                                     /*CBF023*/
                                                                                          /*CBF023*/
             IF         COND(&RTNC *NE '       ' *AND &RTNC *NE +
                          '*NRF   ') THEN(DO)                                             /*CBF023*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                                 /*CBF023*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)                                                  /*CBF023*/
             GOTO       CMDLBL(ERROR)                                                     /*CBF023*/
             ENDDO                                                                        /*CBF023*/
                                                                                          /*CBF023*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CBF023) VALUE('Y'))                                        /*CBF023*/
                                                                                          /*CBF023*/
/** If CBF023 is switched on, purging will be done by GOC004019 */                        /*CBF023*/
             IF         COND(&CBF023 *EQ 'Y') THEN(GOTO +
                          CMDLBL(ENDPGM))                                                 /*CBF023*/
/**/
/**********  RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             */                     /*CCB023*/
/**/
/**Retreive*system*ID*from*DTAARA/SDSTAT*and*construct*data*file******/                   /*CCB023*/
/**name*in*command*string*********************************************/                   /*CCB023*/
/**/
/**********  CHGVAR     VAR(&ID) VALUE(%SST(&SDSTAT 6 2))          */                     /*CCB023*/
/************CHGVAR     VAR(&TOLIB) VALUE(&ID *TCAT 'DTALIB')                          */ /*CSC012*/
/**********  CHGVAR     VAR(&TOLIB) VALUE(&ID *TCAT 'DPLIB')       */          /*CSC012*/ /*CCB023*/
/**/
             SNDPGMMSG  MSG('SFC0521 - Drop records for deleted Midas +
                          User') TOMSGQ(MOPERQ)
                                                                                          /*CSF002*/
/**********  CHGVAR     VAR(&STAT) VALUE(' ')                      */          /*CSF002*/ /*CCB023*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */          /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/***If*restart,*copy*back*the*saved*posting*file**/                            /*CSF002*/ /*CCB023*/
/**********  IF         COND(&STAT = 'Y') THEN(DO)                 */          /*CSF002*/ /*CCB023*/
/**********     CPYF     FROMFILE(&TOLIB/MUSERDDX1) TOFILE(MUSERDD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)         */          /*CSF002*/ /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MUSERDD))                           */          /*CSF002*/ /*CCB023*/
/**********     CPYF     FROMFILE(&TOLIB/MACBRDDX1) TOFILE(MACBRDD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)   */                /*CSF002*/ /*CBF005*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MACBRDD))   */                                  /*CSF002*/ /*CBF005*/
/**********     CPYF     FROMFILE(&TOLIB/MBRBSDDX1) TOFILE(MBRBSDD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)         */          /*CSF002*/ /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBRBSDD))                           */          /*CSF002*/ /*CCB023*/
/**********     CPYF     FROMFILE(&TOLIB/MBROSDDX1) TOFILE(MBROSDD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)         */          /*CSF002*/ /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBROSDD))                           */          /*CSF002*/ /*CCB023*/
/**********     CPYF     FROMFILE(&TOLIB/MCMPSDDX1) TOFILE(MCMPSDD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)         */          /*CSF002*/ /*CCB023*/
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MCMPSDD))                           */          /*CSF002*/ /*CCB023*/
/**********  ENDDO                                                 */          /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/**Delete*backup*files,*existing*or*nonexisting**/                             /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MUSERDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MACBRDDX1)   */                            /*CSF002*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                    /*CSF002*/ /*CBF005*/
/**********  DLTF       FILE(&TOLIB/MBRBSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MBROSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MCMPSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/***Make*a*copy*of*the*files****************************************/          /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/**********  CPYF       FROMFILE(MUSERDD) TOFILE(&TOLIB/MUSERDDX1) +
/**********               TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                            */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */          /*CSF002*/ /*CCB023*/
/**********  CPYF       FROMFILE(MACBRDD) TOFILE(&TOLIB/MACBRDDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)   */                                   /*CSF002*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)   */                    /*CSF002*/ /*CBF005*/
/**********  CPYF       FROMFILE(MBRBSDD) TOFILE(&TOLIB/MBRBSDDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                            */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */          /*CSF002*/ /*CCB023*/
/**********  CPYF       FROMFILE(MBROSDD) TOFILE(&TOLIB/MBROSDDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                            */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */          /*CSF002*/ /*CCB023*/
/**********  CPYF       FROMFILE(MCMPSDD) TOFILE(&TOLIB/MCMPSDDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                            */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             */          /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                      */          /*CSF002*/ /*CCB023*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */          /*CSF002*/ /*CCB023*/
/**/
/*  Allocate DTAARA/SDSTAT for exclusive use of 'OLD'/'NEW' */
/**/
             ALCOBJ     OBJ((SDSTAT *DTAARA *EXCLRD))
/**/
/***Override*for*fast*copy***/                                                            /*CCB023*/
/**/
/**********  OVRDBF     FILE(MUSERDD) SEQONLY(*YES 100)            */          /*CSF002*/ /*CCB023*/
/**********  OVRDBF     FILE(MACBRDD) SEQONLY(*YES 100)   */                              /*CBF005*/
/**********  OVRDBF     FILE(MBRBSDD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(MBROSDD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(MCMPSDD) SEQONLY(*YES 100)            */                     /*CCB023*/
/**********  OVRDBF     FILE(BMUSERDD) SEQONLY(*YES 100)           */          /*CSF002*/ /*CCB023*/
/**********  OVRDBF     FILE(BMACBRDD) SEQONLY(*YES 100)   */                             /*CBF005*/
/**********  OVRDBF     FILE(BMBRBSDD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(BMBROSDD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**********  OVRDBF     FILE(BMCMPSDD) SEQONLY(*YES 100)           */                     /*CCB023*/
/**/
/***Copy*Midas*User*data*to*backup*files***/                                              /*CCB023*/
/**/
/************CPYF       FROMFILE(&TOLIB/MACBRDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMACBRDD) CRTFILE(*YES) MBROPT(*REPLACE)       */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMACBRDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MBRBSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMBRBSDD) CRTFILE(*YES) MBROPT(*REPLACE)       */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMBRBSDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MBROSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMBROSDD) CRTFILE(*YES) MBROPT(*REPLACE)       */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMBROSDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MCMPSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMCMPSDD) CRTFILE(*YES) MBROPT(*REPLACE)       */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMCMPSDD))                                       */ /*CSC012*/

/**********  CPYF       FROMFILE(MUSERDD) TOFILE(&TOLIB/BMUSERDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */          /*CSF002*/ /*CCB023*/

/**********  CPYF       FROMFILE(MACBRDD) TOFILE(&TOLIB/BMACBRDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)   */                  /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMACBRDD))   */                                 /*CSC012*/ /*CBF005*/
/**********  CPYF       FROMFILE(MBRBSDD) TOFILE(&TOLIB/BMBRBSDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMBRBSDD))                          */          /*CSC012*/ /*CCB023*/
/**********  CPYF       FROMFILE(MBROSDD) TOFILE(&TOLIB/BMBROSDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMBROSDD))                          */          /*CSC012*/ /*CCB023*/
/**********  CPYF       FROMFILE(MCMPSDD) TOFILE(&TOLIB/BMCMPSDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMCMPSDD))                          */          /*CSC012*/ /*CCB023*/
/**/
/*  Remove logical file members for fact copying */
/**/
/**********  RMVM       FILE(MUSER) MBR(MUSER)                     */             /*CSF002 MD07223*/
/**********  MONMSG     MSGID(CPF0000)                             */             /*CSF002 MD07223*/
/************RMVM       FILE(&TOLIB/MACBR) MBR(MACBR)                                  */ /*CSC012*/
/**********  RMVM       FILE(MACBR) MBR(MACBR)   */                            /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                               /*CBF005*/
/************RMVM       FILE(&TOLIB/MBRBS) MBR(MBRBS)                                  */ /*CSC012*/
/**********  RMVM       FILE(MBRBS) MBR(MBRBS)                     */             /*CSC012 MD07223*/
/**********  MONMSG     MSGID(CPF0000)                             */                    /*MD07223*/
/************RMVM       FILE(&TOLIB/MBROS) MBR(MBROS)                                  */ /*CSC012*/
/**********  RMVM       FILE(MBROS) MBR(MBROS)                     */             /*CSC012 MD07223*/
/**********  MONMSG     MSGID(CPF0000)                             */                    /*MD07223*/
/************RMVM       FILE(&TOLIB/MCMPS) MBR(MCMPS)                                  */ /*CSC012*/
/**********  RMVM       FILE(MCMPS) MBR(MCMPS)                     */             /*CSC012 MD07223*/
/**********  MONMSG     MSGID(CPF0000)                             */                    /*MD07223*/
/**/
/***Copy*back,*including*live*records*only***/                                            /*CCB023*/
/**/
/************CPYF       FROMFILE(&TOLIB/BMACBRDD) +                                       /*CSC012*/
/************             TOFILE(&TOLIB/MACBRDD) MBROPT(*REPLACE) +                       /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                           /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                      /*CSC012*/
/************             FILE(&TOLIB/MACBRDD))                                           /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMBRBSDD) +                                       /*CSC012*/
/************             TOFILE(&TOLIB/MBRBSDD) MBROPT(*REPLACE) +                       /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                           /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                      /*CSC012*/
/************             FILE(&TOLIB/MBRBSDD))                                           /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMBROSDD) +                                       /*CSC012*/
/************             TOFILE(&TOLIB/MBROSDD) MBROPT(*REPLACE) +                       /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                           /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                      /*CSC012*/
/************             FILE(&TOLIB/MBROSDD))                                           /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMCMPSDD) +                                       /*CSC012*/
/************             TOFILE(&TOLIB/MCMPSDD) MBROPT(*REPLACE) +                       /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                           /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                      /*CSC012*/
/************             FILE(&TOLIB/MCMPSDD))                                           /*CSC012*/

/**********  CPYF       FROMFILE(BMUSERDD) TOFILE(MUSERDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MUSERDD))                           */          /*CSF002*/ /*CCB023*/
/**********  CPYF       FROMFILE(BMACBRDD) TOFILE(MACBRDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MACBRDD))   */                                  /*CSC012*/ /*CBF005*/
/**********  CPYF       FROMFILE(BMBRBSDD) TOFILE(MBRBSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBRBSDD))                           */          /*CSC012*/ /*CCB023*/
/**********  CPYF       FROMFILE(BMBROSDD) TOFILE(MBROSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBROSDD))                           */          /*CSC012*/ /*CCB023*/
/**********  CPYF       FROMFILE(BMCMPSDD) TOFILE(MCMPSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSC012*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MCMPSDD))                           */          /*CSC012*/ /*CCB023*/
                                                                                          /*CCB023*/
/* Delete the records where RECI si not equal to D                 */                     /*CCB023*/
                                                                                          /*CCB023*/
             SCRUNSQL   SQL('DELETE FROM MUSERDD WHERE RECI <> +
                          ''D''')                                                         /*CCB023*/
/**********  SCRUNSQL   SQL('DELETE FROM MACBRDD WHERE RECI <> +                     */ /*MD021155*/
/**********               ''D''')                                             */ /*CCB023 MD021155*/
             SCRUNSQL   SQL('DELETE FROM MBRBSDD WHERE RECI <> +
                          ''D''')                                                         /*CCB023*/
             SCRUNSQL   SQL('DELETE FROM MBROSDD WHERE RECI <> +
                          ''D''')                                                         /*CCB023*/
             SCRUNSQL   SQL('DELETE FROM MCMPSDD WHERE RECI <> +
                          ''D''')                                                         /*CCB023*/
                                                                                          /*CCB023*/
/**/
/***Delete*backup*files***/                                                               /*CCB023*/
/**/
/************DLTF       FILE(&TOLIB/BMACBRDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMBRBSDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMBROSDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMCMPSDD)                                          */ /*CSC012*/

/**********  DLTF       FILE(BMUSERDD)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(BMACBRDD)   */                                    /*CSC012*/ /*CBF005*/
/**********  DLTF       FILE(BMBRBSDD)                             */          /*CSC012*/ /*CCB023*/
/**********  DLTF       FILE(BMBROSDD)                             */          /*CSC012*/ /*CCB023*/
/**********  DLTF       FILE(BMCMPSDD)                             */          /*CSC012*/ /*CCB023*/
/**/
/*  Reorganise master files */
/**/
/**********  RGZPFM     FILE(MUSERDD)                                          /*CSF002*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                         /*CSF002*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MUSERDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/************MONMSG     MSGID(CPF0000)                                                    /*CSC012*/
/************RGZPFM     FILE(&TOLIB/MACBRDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MACBRDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
/**********  CALL       PGM(SCC000060) PARM('MACBRDD' '*FIRST')   */           /*228542*/ /*CBF005*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))   */                                  /*228542*/ /*CBF005*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MBRBSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MBRBSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MBRBSDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MBROSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MBROSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MBROSDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MCMPSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MCMPSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MCMPSDD' '*FIRST')                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/*           CLRPFM     FILE(CBCOBRPD) */                                      /*204813* *MD041858*/
/*           MONMSG     MSGID(CPF0000) */                                      /*204813* *MD041858*/
/**/
/*  Successful completion  */
/**/
             SNDPGMMSG  MSG('SFC0520 - Records successfully dropped') +
                          TOMSGQ(MOPERQ)
                          GOTO ENDPGM
/**/
ERROR:  CHGJOB SWS(XXXXXX11)
/**/
/*  Enable access paths  */
/**/
/********** ENDPGM:      ADDLFM     FILE(&TOLIB/MACBR) MBR(MACBR) SHARE(*YES)  */         /*201669*/
ENDPGM:                                                                                   /*201669*/
             ADDLFM     FILE(MUSER) MBR(MUSER) SHARE(*YES)                                /*CSF002*/
             MONMSG     MSGID(CPF0000)                                                    /*CSF002*/
/**********  ADDLFM     FILE(MACBR) MBR(MACBR) SHARE(*YES)   */                /*201669*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                               /*CBF005*/
/**********  ADDLFM     FILE(&TOLIB/MBRBS) MBR(MBRBS) SHARE(*YES)  */                     /*201669*/
             ADDLFM     FILE(MBRBS) MBR(MBRBS) SHARE(*YES)                                /*201669*/
             MONMSG     MSGID(CPF0000)
/**********  ADDLFM     FILE(&TOLIB/MBROS) MBR(MBROS) SHARE(*YES)  */                     /*201669*/
             ADDLFM     FILE(MBROS) MBR(MBROS) SHARE(*YES)                                /*201669*/
             MONMSG     MSGID(CPF0000)
/**********  ADDLFM     FILE(&TOLIB/MCMPS) MBR(MCMPS) SHARE(*YES)  */                     /*201669*/
             ADDLFM     FILE(MCMPS) MBR(MCMPS) SHARE(*YES)                                /*201669*/
             MONMSG     MSGID(CPF0000)
                                                                                          /*CSF002*/
/***Clear*the*saved*files**/                                                   /*CSF002*/ /*CCB023*/
                                                                                          /*CSF002*/
/**********  CHGVAR     VAR(&STAT) VALUE('N')                      */          /*CSF002*/ /*CCB023*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MUSERDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MACBRDDX1)   */                            /*CSF002*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                    /*CSF002*/ /*CBF005*/
/**********  DLTF       FILE(&TOLIB/MBRBSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MBROSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**********  DLTF       FILE(&TOLIB/MCMPSDDX1)                     */          /*CSF002*/ /*CCB023*/
/**********  MONMSG     MSGID(CPF0000)                             */          /*CSF002*/ /*CCB023*/
/**/
/*  Deallocate DTAARA/SDSTAT */
/**/
/**********  DLCOBJ     OBJ((SDSTAT *DTAARA *EXCLRD))              */                     /*CCB023*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
