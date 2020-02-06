/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Delete batch')                               */
/*********************************************************************/
/*                                                                   */
/*  Midas - General Ledger Module                                    */
/*                                                                   */
/*  GLC0111X - Delete Batch Control                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG26093           Date 22Sep09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      244686             Date 28Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                 BUG7603           Date 26Jul05                    */
/*                 CGL013            Date 29Mar02                    */
/*                 CPK016            Date 04Jun03                    */
/*                 CGL016            Date 01Aug02                    */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 S01408            Date 12JUN95                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CER059 - German Feature Upgrade to Delhi                         */
/*  BUG26093 - Extended Narratives are not refreshed with reused     */
/*             batch numbers                                         */
/*  244686  - Added the missing fields to GLJESHPD which CAP086      */
/*            and CSC024 introduced to GZGLJENHPD in order for the   */
/*            2 files to be synchronized. (Recompile only)           */
/*  BUG7603 - Message waiting in job GL0111X in SIT system           */
/*  CGL013 - MT94x Messages Generation                               */
/*  CPK016 - Externalise STRCMTCTL code for ease of later upgrade.   */
/*  CGL016 - Projected Movements Update Prior to Authorisation       */
/*  S01408 - Addition of core hooks GLC0111XP1                       */
/*                                  GLC0111XPE                       */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&BTNB) */                                                    /*CGL016*/
/**********  PGM        PARM(&RTCD &BTNB) */                                  /*CGL016*/ /*BUG7603*/
             PGM        PARM(&RTCD &BTNB &TPLT)                                          /*BUG7603*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&BTNB) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL016*/
             DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CGL013*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CGL013*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CGL013*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CGL013*/
             DCL        VAR(&CGL013) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL013*/
             DCL        VAR(&TPLT) TYPE(*CHAR) LEN(1)                                    /*BUG7603*/
/**/                                                                  /*CGL016*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                              /*CGL016*/
/**/                                                                  /*CGL016*/
/* Start commitment control - job is submitted                        /*CGL016*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                            /*CGL016*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/**/
             IF         COND(&TPLT *EQ 'Y') THEN(DO)                                     /*BUG7603*/
             OVRDBF     FILE(GLJENHL0) TOFILE(GLJESHL0)
             OVRDBF     FILE(GLJENPL0) TOFILE(GLJESPL0)
             OVRDBF     FILE(GLJENPL1) TOFILE(GLJESPL1)
             OVRDBF     FILE(GLJENPL2) TOFILE(GLJESPL2)
             OVRDBF     FILE(GLJENSL0) TOFILE(GLJESSL0)
             OVRDBF     FILE(GLJENSL1) TOFILE(GLJESSL1)
                                                                                          /*CGL013*/
/** Access SCSARDPD to check if CGL013 is on */                                           /*CGL013*/
                                                                                          /*CGL013*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CGL013*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CGL013*/
             CHGVAR     VAR(&PSARD) VALUE('CGL013')                                       /*CGL013*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CGL013*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                        /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 = 'Y') THEN(DO)                                      /*CGL013*/
             OVRDBF     FILE(GLJENXL2) TOFILE(GLJESXL2)                                   /*CGL013*/
             OVRDBF     FILE(GLJENXL3) TOFILE(GLJESXL3)                                   /*CGL013*/
             OVRDBF     FILE(GLJENXL4) TOFILE(GLJESXL4)                                   /*CGL013*/
             ENDDO                                                                        /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC0111XP1                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
/**/
             IF         COND(&MULT *EQ '  ') THEN(DO)
                CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
/**/
             CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*S01253*/
             OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)               /*S01253*/
/**/
/************CALL       PGM(GL0111X) PARM(' ' &BTNB)                  /*CGL016*/
             CALL       PGM(GL0111X) PARM(&RTCD &BTNB)                /*CGL016*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                          /*BUG7603*/
             ROLLBACK                                                                    /*BUG7603*/
             ENDDO                                                                       /*BUG7603*/
/**/
             DLTOVR     FILE(GLJENHL0 GLJENPL0 GLJENPL1 GLJENPL2 +
                          GLJENSL0 GLJENSL1)
                                                                                          /*CGL013*/
             IF         COND(&CGL013 = 'Y') THEN(DO)                                      /*CGL013*/
             DLTOVR     FILE(GLJENXL2 GLJENXL3 GLJENXL4)                                  /*CGL013*/
             ENDDO                                                                        /*CGL013*/
             ENDDO                                                                       /*BUG7603*/
                                                                                         /*BUG7603*/
             IF         COND(&TPLT *EQ 'N') THEN(DO)                                     /*BUG7603*/
                                                                                         /*BUG7603*/
/** Access SCSARDPD to check if CGL013 is on */                                          /*BUG7603*/
                                                                                         /*BUG7603*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                     /*BUG7603*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                     /*BUG7603*/
             CHGVAR     VAR(&PSARD) VALUE('CGL013')                                      /*BUG7603*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                 /*BUG7603*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                       /*BUG7603*/
/**********  IF         COND(&CGL013 = 'Y') THEN(DO)                        /*BUG7603*/ /*BUG26093*/
/**********  OVRDBF     FILE(GLJENXL2) TOFILE(GLJESXL2)                     /*BUG7603*/ /*BUG26093*/
/**********  OVRDBF     FILE(GLJENXL3) TOFILE(GLJESXL3)                     /*BUG7603*/ /*BUG26093*/
/**********  OVRDBF     FILE(GLJENXL4) TOFILE(GLJESXL4)                     /*BUG7603*/ /*BUG26093*/
/**********  ENDDO                                                          /*BUG7603*/ /*BUG26093*/
                                                                                         /*BUG7603*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                                                 /*BUG7603*/
                                                                                         /*BUG7603*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                                    /*BUG7603*/
                CHGVAR     VAR(&MULT) VALUE('GB')                                        /*BUG7603*/
             ENDDO                                                                       /*BUG7603*/
                                                                                         /*BUG7603*/
             CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')                     /*BUG7603*/
             OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)                                  /*BUG7603*/
                                                                                         /*BUG7603*/
             CALL       PGM(GL0111X) PARM(&RTCD &BTNB)                                   /*BUG7603*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                          /*BUG7603*/
             ROLLBACK                                                                    /*BUG7603*/
             ENDDO                                                                       /*BUG7603*/
                                                                                         /*BUG7603*/
/**********  IF         COND(&CGL013 = 'Y') THEN(DO)                        /*BUG7603*/ /*BUG26093*/
/**********  DLTOVR     FILE(GLJENXL2 GLJENXL3 GLJENXL4)                    /*BUG7603*/ /*BUG26093*/
/**********  ENDDO                                                          /*BUG7603*/ /*BUG26093*/
             ENDDO                                                                       /*BUG7603*/
/*                                                                    /*CGL016*/
/* Only if the whole transaction is ok, commit to DB                  /*CGL016*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CGL016*/
/*                                                                    /*CGL016*/
             COMMIT                                                   /*CGL016*/
             GOTO       CMDLBL(EXIT)                                  /*CGL016*/
/*                                                                    /*CGL016*/
             ENDDO                                                    /*CGL016*/
/*                                                                    /*CGL016*/
 ERROR:      SNDPGMMSG  MSG('Error in batch handling program - +
                          Rollback')                                  /*CGL016*/
/*                                                                    /*CGL016*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC0111XPE                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**********  ENDPGM                                                   /*CGL016*/
 EXIT:       ENDPGM                                                   /*CGL016*/
