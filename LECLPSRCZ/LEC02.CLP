/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle processing')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC02 - INPUT CYCLE PROCESSING                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1097513          Date 27Mar13              */
/*       Prev Amend No. CUP005             Date 21Sep10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE038             Date 11May04              */
/*                      CSC023             Date 29Jan04              */
/*                      219608             Date 14Jul03              */
/*                      CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      148720             Date 15Jan99              */
/*                      152356             Date 12Jan99              */
/*                      124684             Date 06Jan98              */
/*                      S01408             DATE 07DEC95              */
/*                      058014             DATE 04JAN94              */
/*                      E40283             DATE 23JUN92              */
/*                      S01310             DATE 23JUL91              */
/*                      E23403             DATE 20SEP90              */
/*                      BHF217             DATE 08AUG90              */
/*                      E20721             DATE 05JAN90              */
/*                      LN0002             DATE 26APR90              */
/*                      S01117             DATE 30MAR90              */
/*                      S01194             DATE 11DEC89              */
/*                      S01179             DATE 14/10/88             */
/*                      E11931             DATE 26/11/87             */
/*                      S01135             DATE 02/07/87             */
/*                      S01118             DATE 16/01/87             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR1097513 - Menu of transaction input under customer        */
/*                   lending is not showing.                         */
/*       CUP005 - Change processing of temporary files for IASP.     */
/*                QTEMP is replaced by zzXPLIB.                      */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       CLE038 - Lending Enhancement for Nordea: Allocation by Amt  */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       219608 - Amendment of Settlement Allocations needs 'before' */
/*                image to ensure the right allocations are reversed.*/
/*       CLE034 - Lending Enhancements.                              */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       148720 - Submit the confirmation job on exit from manual    */
/*                payments and principal transfers. This will        */
/*                ensure that pay/receives are not delayed.          */
/*       152356 - Suppress completion messages from MIDASRMV and     */
/*                LEC0212A from going to MOPERQ.                     */
/*       124684 - If the confirmations job ends abnormally and does  */
/*                not change LESTAT position 6 back to 'N', no confs */
/*                are produced in subsequent runs. Fix is to use new */
/*                data area LECONF and ALCOBJ/DLCOBJ commands to     */
/*                to determine if the confirmations job is active -  */
/*                if the job fails, the data area is automatically   */
/*                de-allocated.                                      */
/*       S01408 - Addition of core hooks LEC02001                    */
/*                                       LEC02002                    */
/*       058014 - Submit LE I/C Confirmation print program after     */
/*                exit from Rollover Details maintainance.           */
/*       E40283 - Data Area SWSTAT not required                      */
/*                SWSTAT already removed from code; remove DCL       */
/*                statement and tidy up code.                        */
/*       S01310 - SWIFT RATIONALISATION                              */
/*       E23403 - PROGRAM CHECKS FOR MODULE RT.                      */
/*                AMEND TO CHECK FOR RE AND IA.                      */
/*       BHF217 - RCF PARAMETERS ADDED                               */
/*       E20721 - ALL OCCURRENCES OF SBMJOB ALTERED FROM S/38        */
/*                TO AS/400 FORMAT                                   */
/*       LN0002 - LDA CREATION NEEDED FOR SUBMITTED JOB              */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01179 - AS400 INCORPORATION                                */
/*       E11931 - BATCH MESSAGE NOT REQUIRED                         */
/*       S01135 - MIDAS/TELEX DIRECT LINK                            */
/*       E81101 - INSERT OF RCLRSC (RECLAIM RESOURCES) COMMAND       */
/*                AFTER CALL PROGRAM COMMAND IN ORDER THAT RPG       */
/*                PROGRAMS THAT DO NOT SETON LR OR CLOSE THEIR       */
/*                FILES , DO NOT LEAVE FILES OPEN IN A DIFFERENT     */
/*                PROCESSING MODE TO THAT REQUIRED BY THE NEXT       */
/*                CALLED PROGRAM.                                    */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&PARM)                                     BHF217*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*BHF217*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*BHF217*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*BHF217*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*BHF217*/
             DCL        VAR(&SBPARM) TYPE(*CHAR) LEN(50)              /*BHF217*/
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(1) VALUE('''')      /*BHF217*/
/*/COPY WNCPYSRC,LEC02013                                            */
/************DCL        VAR(&STRING) TYPE(*CHAR) LEN(281)             /*BHF217*/          /*CPK014*/
/************DCL        VAR(&STRING) TYPE(*CHAR) LEN(294)                      /*CPK014*/ /*CSC023*/
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(307)                                 /*CSC023*/
/*/COPY WNCPYSRC,LEC02014                                            */
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL VAR(&LESTAT) TYPE(*CHAR) LEN(256)
/************DCL VAR(&SWSTAT) TYPE(*CHAR) LEN(256)                     *E40283*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)            */   /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSW208*/
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)                                   /*CSW208*/
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)                                  /*CSW208*/
             DCL        VAR(&LSCONF) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSW208*/
             DCL        VAR(&CSW208) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSW208*/
             DCL        VAR(&PLEC0201B) TYPE(*CHAR) LEN(1) +
                          VALUE('N')                                                      /*CSW208*/
                                                                                          /*CSW208*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE034*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CLE034*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE034')                                                 /*CLE034*/
             DCL        VAR(&JOBID) TYPE(*CHAR) LEN(10)                                   /*219608*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                   /*CUP005*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDMLIB')                                                /*219608*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDVLIB')                                                /*219608*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDPLIB')                                                /*CUP005*/
             DCL        VAR(&XPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxXPLIB')                                                /*CUP005*/
             DCL        VAR(&NEWPF) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&NEWL3) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&NEWL4) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*219608*/
             DCL        VAR(&CLE034) TYPE(*CHAR) LEN(1) VALUE('N')                        /*219608*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*219608*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) VALUE('*FREE')                     /*219608*/
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(4)                                    /*219608*/
             DCL        VAR(&PLNRF) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PVDAT) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PLASN) TYPE(*CHAR) LEN(3)                                    /*219608*/
             DCL        VAR(&PCNUM) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PFACL) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PFSEQ) TYPE(*CHAR) LEN(2)                                    /*219608*/
             DCL        VAR(&PPYRC) TYPE(*CHAR) LEN(1)                                    /*219608*/
/**********  DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(765)             */            /*219608 CLE038*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CLE038*/
/*/COPY WNCPYSRC,LEC02008                                            */
/**/
/************DCLDTAARA  DTAARA(LDA)                               */  /*S01179*/
/************DCLDTAARA  DTAARA(MMOD)                              */  /*S01179*/
/************DCLDTAARA  DTAARA(LESTAT)                            */  /*S01179*/
/************DCLDTAARA  DTAARA(SWSTAT)                            */  /*S01179*/
/**/
    /*                                                               */
/*   Create Local Data Area                                          * *LN0002*/
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')        /*LN0002*/
             MONMSG     MSGID(CPF0000)                                /*LN0002*/
/*/COPY WNCPYSRC,LEC02003                                            */
/**/
             RTVJOBA    JOB(&JOBID) NBR(&JOBNBR)                                          /*CUP005*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&XPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
 
/*             TEST FOR RETAIL AND DEALING MODULES  */
/* RETAIL */
             CHGJOB     SWS(00000000)
             RTVDTAARA  DTAARA(MMOD)  RTNVAR(&MMOD)
/*                                                                */  /*E23403*/
/************IF*********COND(%SUBSTRING(&MMOD 3 1) *EQ Y) THEN(DO)*/  /*E23403*/
/***********************CHGJOB SWS(11XXXXXX)***********************/  /*E23403*/
/************ENDDO*************************************************/  /*E23403*/
             IF COND((%SST(&MMOD 16 1) *EQ 'Y')  +
                *OR (%SST(&MMOD 23 1) *EQ 'Y'))  +
                    THEN(CHGJOB SWS(11XXXXXX))
/*                                                                */  /*E23403*/
/* DEALING */
             IF         COND(%SUBSTRING(&MMOD 2 1) *EQ Y) THEN(DO)
                        CHGJOB SWS(XX1XXXXX)
             ENDDO
/*/COPY WNCPYSRC,LEH01062                                            */
                                                                                          /*CSW208*/
             CALL       PGM(SWIF2008) PARM(&PRTCD)                                        /*CSW208*/
             IF         COND(&PRTCD *EQ 'CSW2008')  THEN(DO)                              /*CSW208*/
             CHGVAR     VAR(&CSW208) VALUE('Y')                                           /*CSW208*/
             ENDDO                                                                        /*CSW208*/
                                                                                          /*CSW208*/
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                    /*CSW208*/
             CHGVAR     VAR(&POP01) VALUE('LEFSWIFTConf')                                 /*CSW208*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 +
                          &POP04 &PVL04 &POP05 &PVL05 +
                          &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 +
                          &POP10 &PVL10)                                                  /*CSW208*/
                                                                                          /*CSW208*/
             IF         COND(&PRTCD *EQ '      ')  THEN(DO)                               /*CSW208*/
             CHGVAR     VAR(&LSCONF) VALUE(&PVL01)                                        /*CSW208*/
             ENDDO                                                                        /*CSW208*/
                                                                                          /*CSW208*/
             ENDDO                                                                        /*CSW208*/
/**/
/* IF PGM TO BE RUN IS PAY/RECEIVE SUBMIT IT */                       /*S01118*/
/**/
             IF         COND(&PARM *EQ 'LEC0213   ') THEN(DO)         /*S01118*/
                SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)               /*S01118*/
/************   SBMJOB     JOB(LEC0213) JOBD(MBATCH) USER(*JOBD) +      BHF217*/
/************                RQSDTA('CALL LEC0213') INLLIBL(*JOBD) +    BHF217*/
/************                MSGQ(MOPERQ)                  *S01118*    *BHF217*/
    /*                                                               */
             CHGVAR     VAR(&SBPARM) VALUE(&ASP *CAT &RSEQ *CAT &ASP  +
                  *BCAT &RLEV *BCAT &ASP *CAT &RENT *CAT &ASP)        /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 1 6)) VALUE('SBMJOB')        /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 8 4)) VALUE('CMD(')          /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 12 4)) VALUE('CALL')         /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 17 4)) VALUE('PGM(')         /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 21 10)) VALUE(LEC0213)       /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 31 7)) VALUE(') PARM(')      /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 38 213)) VALUE(&SBPARM)      /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 251 7)) VALUE(')) JOB(')     /*BHF217*/
             CHGVAR     VAR(%SST(&STRING 258 10)) VALUE(LEC0213)      /*BHF217*/
/************CHGVAR     VAR(%SST(&STRING 268 1)) VALUE(')')        */ /*BHF217*/
    CHGVAR     VAR(%SST(&STRING 268 14)) VALUE(') JOBD(MBATCH)')      /*BHF217*/
/************CALL       PGM(QCMDEXC) PARM(&STRING 281)                /*BHF217*/          /*CPK014*/
             CHGVAR     VAR(%SST(&STRING 282 12)) VALUE(' USER(*JOBD)')                   /*CPK014*/
/************CALL       PGM(QCMDEXC) PARM(&STRING 294)                         /*CPK014*/ /*CSC023*/
             CHGVAR     VAR(%SST(&STRING 295 12)) VALUE(' OUTQ(*JOBD)')                   /*CSC023*/
             CALL       PGM(QCMDEXC) PARM(&STRING 307)                                    /*CSC023*/
    /*                                                               */
/************   SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) + ** *E20721*/
/************************    RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) **/ /*S01118*/
                                                                      /*E20721*/
                                                                      /*E20721*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*152356*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +     /*152356*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)      /*E20721*/ /*152356*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                  /*152356*/          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
/******SNDPGMMSG  MSG('Customer lending pay/receive submitted +     *  *E11931*/
/************         to batch') TOPGMQ(*EXT)             *  *S01118*  *E11931*/
                GOTO       CMDLBL(ENDPGM)                             /*S01118*/
             ENDDO                                                    /*S01118*/
/**/                                                                                      /*CLE034*/
/* Determine if CLE034 installed  */                                                      /*CLE034*/
/**/                                                                                      /*CLE034*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                                 /*CLE034*/
/**/                                                                                      /*CLE034*/
/* Error */                                                                               /*CLE034*/
/**/                                                                                      /*CLE034*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CLE034*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                            /*CLE034*/
             CHGJOB (XXXXXX11)                                                            /*CLE034*/
             GOTO       CMDLBL(ERROR)                                                     /*CLE034*/
             ENDDO                                                                        /*CLE034*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE034*/
             OVRDBF     FILE(LESTALLX) TOFILE(LESTALL2) +
                        SHARE(*NO)                                                        /*CLE034*/
                                                                                          /*219608*/
             CHGVAR     VAR(&CLE034) VALUE('Y')                                           /*219608*/
/* Create temporary file to hold 'before' image of LESTALPD */                            /*219608*/
/**********  CPYF       FROMFILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD) +                    */ /*CUP005*/
/**********               CRTFILE(*YES)                                     */ /*219608*/ /*CUP005*/
             CPYF       FROMFILE(LEBSTLPD) TOFILE(&XPLIB/LEBSTLPD) +
                          CRTFILE(*YES)                                                   /*CUP005*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)                                   /*219608*/
/**********             CLRPFM FILE(QTEMP/LEBSTLPD)                         */ /*219608*/ /*CUP005*/
                        CLRPFM FILE(&XPLIB/LEBSTLPD)                                      /*CUP005*/
/**********  GOTO       CMDLBL(FILEND)         /* File already exists*/         /*219608 AR1097513*/
                        ENDDO                                                             /*219608*/
                                                                                          /*219608*/
/* Global monitor message */                                                              /*219608*/
                                                                                          /*219608*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))                                                  /*219608*/
                                                                                          /*219608*/
/* Logical files LEBSTLL3 & LEBSTLL4 need to be based over the copy                       /*219608*/
/* of LEBSTLPD which was just created in QTEMP. This is achieved                          /*219608*/
/* by CRTDUPOBJ of LF to QTEMP (called 'job name' to ensure                               /*219608*/
/* uniqueness), MOVOBJ to xxDMLIB, CRTDUPOBJ back to QTEMP.                               /*219608*/
                                                                                          /*219608*/
/**********  RTVJOBA    JOB(&JOBID)                                         */ /*219608*/ /*CUP005*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                */ /*219608*/ /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DVLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
             CHGVAR     VAR(&NEWPF) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'PD')                                                           /*CUP005*/
             CHGVAR     VAR(&NEWL3) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L3')                                                           /*CUP005*/
             CHGVAR     VAR(&NEWL4) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L4')                                                           /*CUP005*/
                                                                                          /*219608*/
/* Create Logical file LEBSTLL3:                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(LEBSTLL3) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(LEBSTLL3) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(&JOBID)                                    /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEBSTLL3)                     */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(LEBSTLL3)                                  /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
/*                                                                                        /*219608*/
/* Create Logical file LEBSTLL4:                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(LEBSTLL4) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(LEBSTLL4) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(&JOBID)                                    /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEBSTLL4)                     */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(LEBSTLL4)
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
                                                                                          /*219608*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLPD) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWPF)                                                  /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLL3) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWL3)                                                  /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLL4) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWL4)                                                  /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
             MOVOBJ     OBJ(&XPLIB/&NEWPF) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
             MOVOBJ     OBJ(&XPLIB/&NEWL3) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
             MOVOBJ     OBJ(&XPLIB/&NEWL4) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
             MONMSG     MSGID(CPF3201)                                                 /*AR1097513*/
 
FILEND:                                                                                   /*219608*/
/**********  OVRDBF     FILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD)               */ /*219608*/ /*CUP005*/
/**********  OVRDBF     FILE(LEBSTLL3) TOFILE(QTEMP/LEBSTLL3)               */ /*219608*/ /*CUP005*/
/**********  OVRDBF     FILE(LEBSTLL4) TOFILE(QTEMP/LEBSTLL4)               */ /*219608*/ /*CUP005*/
             OVRDBF     FILE(LEBSTLPD) TOFILE(&DPLIB/&NEWPF)                              /*CUP005*/
             OVRDBF     FILE(LEBSTLL3) TOFILE(&DPLIB/&NEWL3)                              /*CUP005*/
             OVRDBF     FILE(LEBSTLL4) TOFILE(&DPLIB/&NEWL4)                              /*CUP005*/
                                                                                          /*219608*/
/**********  STRJRNPF   FILE(QTEMP/LEBSTLPD) JRN(ICJRN) +                              */ /*CUP005*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                    */ /*219608*/ /*CUP005*/
             STRJRNPF   FILE(&DPLIB/&NEWPF) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                                                /*CUP005*/
             MONMSG     MSGID(CPF7030)                                                    /*219608*/
/**/                                                                                      /*219608*/
             ENDDO                                                                        /*CLE034*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*/COPY WNCPYSRC,LEC02004                                            */
             CALL       PGM(&PARM)
             RCLRSC                                                   /*E81101*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
/*/COPY WNCPYSRC,LEC02009                                            */
                GOTO ENDPGM
             IF         COND(&CLE034 = 'Y') THEN(DO)                                      /*219608*/
                                                                                          /*219608*/
/* Close file LEBSTLPD on access object AOBSTLR0 using Option '*FREE':                    /*219608*/
             CALL       PGM(AOBSTLR0) PARM(&PRTCD &POPTN &PTYPE +
                          &PLNRF &PVDAT &PLASN &PCNUM &PFACL +
                          &PFSEQ &PPYRC &DSSDY)                                           /*219608*/
                                                                                          /*219608*/
/**********  ENDJRNPF   FILE(QTEMP/LEBSTLPD) +                                         */ /*CUP005*/
/**********               JRN(ICJRN)                                        */ /*219608*/ /*CUP005*/
             ENDJRNPF   FILE(&DPLIB/&NEWPF) JRN(ICJRN)                                    /*CUP005*/
                                                                                          /*219608*/
             DLTOVR     FILE(LEBSTLPD)                                                    /*219608*/
             DLTOVR     FILE(LEBSTLL3)                                                    /*219608*/
             DLTOVR     FILE(LEBSTLL4)                                                    /*219608*/
                                                                                          /*219608*/
             DLTF       FILE(&DPLIB/&NEWL3)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWL4)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWPF)                                               /*CUP005*/
 
             ENDDO                                                                        /*219608*/
             ENDDO
/*/COPY WNCPYSRC,LEC02005                                            */
/**/
/*********** DLTOVR     FILE(TABLE)                                  * *S01194*/
             CHGJOB     SWS(000XXXXX)
/**/
STRDO01:     IF         COND(%SWITCH(XXXXX000)) THEN(DO)
/**/
/* PRINT CONFIRMATION */
/***************IF         COND(&PARM *NE LEC0202 *AND &PARM *NE +*/ /*058014*/
/***************                LEC0203 *AND &PARM *NE LEC0204  + */ /*058014*/
/***************                *AND &PARM *NE LEC0205 *AND +     */ /*058014*/
/***************                &PARM *NE LEC0211) +              */ /*058041*/
/***************           THEN(GOTO ENDPGM)                      */ /*058014*/
/***************  IF         COND(&PARM *NE LEC0202 *AND &PARM   +
/***************                  *NE LEC0203 *AND &PARM *NE     +
/***************                  LEC0204 *AND &PARM *NE LEC0205 +
/***************                  *AND &PARM *NE LEC0211 *AND    +
/***************                  &PARM *NE LEC0206) +
/***************           THEN(GOTO ENDPGM)                  /*058014 148720*/
/*/COPY WNCPYSRC,LEC02010                                            */
/**********       IF         COND(&PARM *NE LEC0202 *AND &PARM   +                        /*CSW208*/
/**********                       *NE LEC0203 *AND &PARM *NE     +                        /*CSW208*/
/**********                       LEC0204 *AND &PARM *NE LEC0205 +                        /*CSW208*/
/**********                       *AND &PARM *NE LEC0211 *AND    +                        /*CSW208*/
/**********                       &PARM *NE LEC0210 *AND         +                        /*CSW208*/
/**********                       &PARM *NE LEC2130 *AND         +                        /*CSW208*/
/**********                       &PARM *NE LEC0206) +                                    /*CSW208*/
/**********                THEN(GOTO ENDPGM)                                   /*148720*/ /*CSW208*/
                                                                                          /*CSW208*/
                   IF        COND(&CSW208 *EQ 'Y' *AND           +
                                  &LSCONF *EQ 'Y' *AND           +
                                  &PARM *EQ LEC0201B) THEN(DO)                            /*CSW208*/
                             CHGVAR &PLEC0201B VALUE('Y')                                 /*CSW208*/
                             ENDDO                                                        /*CSW208*/
                                                                                          /*CSW208*/
                  IF         COND(&PARM *NE LEC0202 *AND &PARM   +
                                  *NE LEC0203 *AND &PARM *NE     +
                                  LEC0204 *AND &PARM *NE LEC0205 +
                                  *AND &PARM *NE LEC0211 *AND    +
                                  &PARM *NE LEC0210 *AND         +
                                  &PARM *NE LEC2130 *AND         +
                                  &PARM *NE LEC0206 *AND         +
                                  &PLEC0201B *NE 'Y') +
                           THEN(GOTO ENDPGM)                                              /*CSW208*/
/**/
         /**/
         /*  IF SWIFT OR TELEX PRESENT THEN CHECK FOR P/R ACTIVE    */
         /*   AND ALSO FOR CONFIRMATIONS ACTIVE                     */
         /**/
/************IF         COND((%SST(&MMOD 28 1) *EQ 'Y') *OR  +   */   /*S01135*/
/************              (%SST(&MMOD 36 1) *EQ 'Y')) THEN(DO)  */   /*S01135*/
/************IF         COND((%SST(&MMOD 28 1) *EQ 'Y') *OR +
/************             (%SST(&MMOD 55 1) *EQ 'Y')    *OR +
/************             (%SST(&MMOD 36 1) *EQ 'Y')) THEN(DO) /*S01135 S01310*/
         /**/
             RTVDTAARA  DTAARA(LESTAT)  RTNVAR(&LESTAT)
/*/COPY WNCPYSRC,LEC02006                                            */
         /**/                                                         /*124684*/
  /*************IF         COND(%SST(&LESTAT 6 2) *EQ 'NN') THEN(DO)  /*124684*/
                IF         COND(%SST(&LESTAT 7 1) *EQ 'N') THEN(DO)   /*124684*/
/*/COPY WNCPYSRC,LEC02007                                            */
         /**/
  /*************   ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*124684*/
  /*************   CHGDTAARA  DTAARA(LESTAT (6 1)) VALUE('Y')         /*124684*/
  /*************   DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*124684*/
         /**/
         /*     CHECK IF SWIFT COMPRESSION IS ACTIVE                */
         /*       IF IT IS,THEN DO NOT RUN CONFIRMATIONS            */
/******************RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&SWSTAT)          /*S01310*/
/************IF         COND((%SST(&SWSTAT 9 1) *EQ Y) *AND +  */     /*S01135*/
/************             (%SST(&MMOD 18 1) *EQ N)) THEN(DO)   */     /*S01135*/
/******************IF         COND((%SST(&SWSTAT 9 1) *EQ Y) *AND +
/************                 (%SST(&MMOD 51 1) *EQ 'Y') *OR +
/************                 (%SST(&SWSTAT 9 1) *EQ Y) *AND +
/************             (%SST(&MMOD 18 1) *EQ N)) THEN(DO)   /*S01135 S01310*/
/******************   ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01310*/
/******************   CHGDTAARA  DTAARA(LESTAT (6 1)) VALUE('N')      /*S01310*/
/******************   DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01310*/
/******************ENDDO                                              /*S01310*/
         /*   SUBMIT CONFIRMATIONS TO JOBQ IF ALL CONDITIONS ARE OK */
/******************ELSE   DO                                          /*S01310*/
                      SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/******************   SBMJOB  JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) + *E20721*/
/*******************     RQSDTA('CALL   LEC0212A') MSGQ(MOPERQ)    **  *E20721*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC02001                                             /*S01408*/
                                                                      /*S01408*/
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)           /*124684*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(CONF))        /*124684*/
/************SBMJOB     JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) +      /*152356*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   LEC0212A') +   /*152356*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ) +    /*E20721*/ /*152356*/
/************SBMJOB     JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   LEC0212A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                  /*152356*/          /*CSC023*/
             SBMJOB     JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   LEC0212A') +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC02002                                             /*S01408*/
                                                                      /*S01408*/
/*******************  SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) + *E20721*/
/**********************  RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)   ****   *E20721*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*152356*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +     /*152356*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)      /*E20721*/ /*152356*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                  /*152356*/          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
                   ENDDO
CONF:                                                                 /*124684*/
/***************ENDDO                                                 /*S01310*/
/************ENDDO                                                    /*S01310*/
         /*    IF SWIFT NOT PRESENT THEN CHECK IF CONFIRMATIONS     */
         /*      ACTIVE                                             */
/************ELSE   DO                                                /*S01310*/
         /**/
/***************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)             /*S01310*/
         /**/
/***************IF         COND(%SST(&LESTAT 6 1) *EQ 'N') THEN(DO)   /*S01310*/
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*S01310*/
/******************CHGDTAARA  DTAARA(LESTAT (6 1)) VALUE('Y')         /*S01310*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*S01310*/
         /**/
/******************SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)            /*S01310*/
/****************  SBMJOB  JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD)  +  /*E20721*/
/******************   RQSDTA('CALL   LEC0212A') MSGQ(MOPERQ)   ***    /*E20721*/
/************SBMJOB     JOB(LEC0212A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   LEC0212A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) /*E20721          S01310*/
/****************  SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD)  + * *E20721*/
/*******************  RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)   ********* *E20721*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
/************             INLLIBL(*JOBD) MSGQ(MOPERQ) /*E20721          S01310*/
/***************ENDDO                                                 /*S01310*/
/************ENDDO                                                    /*S01310*/
         /**/
             GOTO     CMDLBL(ENDPGM)
         /**/
          ENDDO
/**/
/*                          ERROR MESSAGES                     */
/**/
ERROR:          IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - LOANS +
                              TRANSACTION INDEX FULL')
                              ROLLBACK
/*/COPY WNCPYSRC,LEC02011                                            */
                ENDDO
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA        */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/******************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))/*S01194*/
                   CHGVAR    VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50)) /*S01194*/
                   ROLLBACK
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOMSGQ(MOPERQ)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOPGMQ(*EXT)
/*/COPY WNCPYSRC,LEC02012                                            */
/**/
                   GOTO       CMDLBL(ENDPGM)
/**/
                ENDDO
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
