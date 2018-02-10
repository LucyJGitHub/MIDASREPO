/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM - Portfolio Transfer Report')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0340 PM PORTFOLIO TRANSFER REPORT                        */
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
/*       Prev Amend No. 095249             Date 06Nov95              */
/*                      S01486             Date 31Aug94              */
/*                      58180              DATE 07JUL93              */
/*                      B8087              DATE 24SEP91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       095249 - Add branch for accounts - RECOMPILE ONLY           */
/*       S01486 - Portfolio Management Upgrade to R10                */
/*       58180  - WHEN JOB SUBMITTED TO BATCH CREATE LDA IN QTEMP    */
/*       B8087  - SUBMIT JOBS TO JOBQ/FOJOBQ                         */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWMODE &WWACOF &WWCUST &WWPREF)         /*S01486*/
             PGM      PARM(&MODE &RSEQ &RLVL &RENT &PARM)             /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                 /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&CLP) TYPE(*CHAR) LEN(7) VALUE(PMC0340)   /*S01486*/
/************DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)              /*S01486*/
/************DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1)               /*S01486*/
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&RUN) TYPE(*CHAR) LEN(5)                  /*S01486*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(2)               /*S01486*/
/************DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)               /*S01486*/
/************DCL        VAR(&WWACO1) TYPE(*CHAR) LEN(2)               /*S01486*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
/************DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWPARM) TYPE(*CHAR) LEN(25)              /*S01486*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
/************DCLF       FILE(SDBANKPD)                                /*S01486*/
/************RCVF       RCDFMT(SDBANKD0)                              /*S01486*/
/************MONMSG     MSGID(CPF0000)                                /*S01486*/
 
/* Global monitor message error trap                                 */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/*  Reset external switches                                                   */
 
             CHGJOB     SWS(00000000)
/************                                                         /*S01486*/
/***Retrieve*type of job - '0' = batch                                /*S01486*/
/************            - '1' = interactive                          /*S01486*/
/************                                                         /*S01486*/
/***********RTVJOBA    TYPE(&WWTYPE)                                 /*S01486*/
/************                                                         /*S01486*/
/***If*batch*job, bypass prompt processing */                         /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(GOTO CMDLBL(BATCH))/*S01486*/
/************                                                         /*S01486*/
/***Retrieve*user profile of signed on user */                        /*S01486*/
/************                                                         /*S01486*/
/************RTVJOBA    USER(&WWUSRP)                                 /*S01486*/
/************                                                         /*S01486*/
/***Retrieve*phase of daily processing                                /*S01486*/
/************                                                         /*S01486*/
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)                 /*S01486*/
/************                                                         /*S01486*/
/***Call*program to get report parameters prompts */                  /*S01486*/
/************                                                         /*S01486*/
/*PM0800:*****CALL      PGM(PM0800) PARM(&CLP &WWUSRP &WWCYCL &WWACOF +*S01486*/
/************             &WWCUST &WWPREF &WWINBA &WWRTRN)            /*S01486*/
/************                                                         /*S01486*/
/***Data*base error processing  */                                    /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01486*/
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          /*S01486*/
/************                                                         /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/************   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +*S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
/************   GOTO       CMDLBL(ENDPGM)                             /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***If*F3*pressed in prompt program,  terminate processing            /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWRTRN *EQ '1') THEN(DO)                /*S01486*/
/************   GOTO       CMDLBL(ENDPGM)                             /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***If*batch*run chaiced, submit job and return to prompt screen      /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWINBA *EQ 'B') THEN(DO)                /*S01486*/
/*>>B8087>>*/
/************SBMJOB     CMD(CALL PGM(PMC0340) PARM('2' &WWACOF +
                          &WWCUST &WWPREF)) JOBQ(MJOBQ)*/
/************SBMJOB     CMD(CALL PGM(PMC0340) PARM('2' &WWACOF +      /*S01486*/
/************             &WWCUST &WWPREF)) JOBQ(FOJOBQ)              /*S01486*/
/*<<B8087<<*/
/************GOTO       CMDLBL(PM0800)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
/***Extract*account officer name                                      /*S01486*/
/************                                                         /*S01486*/
/*BATCH:*******CHGVAR   VAR(&WWACO1) VALUE(%SST(&WWACOF 1 2))         /*S01486*/
/************                                                         /*S01486*/
/**CREATE*DTAARA/LDA IN QTEMP */                                      /*S01486*/
/************CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +      /*S01486*/
/************             TEXT('MIDAS/ABS SD Local Data Area') *58180* *S01486*/
/************MONMSG     MSGID(CPF0000)                           58180* S01486*/
/**/                                                                  /*S01486*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 4 6))           /*S01486*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM 10 4))          /*S01486*/
             CHGVAR     VAR(&WWACOF) VALUE(%SST(&RENT 1 2))           /*S01486*/
 
/*  Override open query file                                                  */
 
/**********  OVRDBF     FILE(PMACCCUS) SHARE(*YES)   ***********/     /*S01486*/
             OVRDBF     FILE(PMACCUL0) SHARE(*YES)                    /*S01486*/
             MONMSG     MSGID(CPF0000)
 
/***MODE*=*'2' (Audit):                                               /*S01486*/
/************IF         COND(&WWMODE *EQ '2') THEN(DO)                /*S01486*/
 
/*  Account officer, customer and portfolio '*ALL'                            */
 
/************IF         COND((&WWACOF *EQ '*ALL') *AND (&WWCUST *EQ + /*S01486*/
/************             '*ALL  ') *AND (&WWPREF *EQ '*ALL')) THEN(DO)*S01486*/
             IF         COND((&RENT *EQ 'ALL') *AND (&WWCUST *EQ +
                         '*ALL') *AND (&WWPREF *EQ '*ALL'))  THEN(DO) /*S01486*/
                                                                      /*S01486*/
/*********** OPNQRYF    FILE((PMACCCUS)) KEYFLD((AZPRTL *ASCEND) + */ /*S01486*/
/***********              (AZACOC) (P8CNUM) (P8FPTF) (P8MODI) +    */ /*S01486*/
/***********              (P8SESN) (P8TRNB))                       */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) KEYFLD((AZACOC) (P8CNUM) +
                          (P8FPTF) (P8MODI) (P8SESN) (P8TRNB))        /*S01486*/
             ENDDO
 
/*  Account officer entered; customer and portfolio '*ALL'                */
 
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *EQ + /*S01486*/
/***********              '*ALL  ') *AND (&WWPREF *EQ '*ALL')) THEN(DO/*S01486*/
             IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *EQ +
                         '*ALL') *AND (&WWPREF *EQ '*ALL'))  THEN(DO) /*S01486*/
/*********** OPNQRYF    FILE((PMACCCUS)) QRYSLT(' AZACOC *EQ "' *CAT +/*S01486*/
/***********              &WWACOF *CAT '"') KEYFLD((AZPRTL *ASCEND) + /*S01486*/
/***********              (AZACOC) (P8CNUM) (P8FPTF) (P8MODI) +    */ /*S01486*/
/***********              (P8SESN) (P8TRNB))                       */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) QRYSLT(' AZACOC *EQ "' *CAT +
                          &WWACOF *CAT '"') KEYFLD((AZACOC) +
                          (P8CNUM) (P8FPTF) (P8MODI) (P8SESN) +
                          (P8TRNB))                                   /*S01486*/
             ENDDO
 
/*  Account officer and customer entered; portfolio '*ALL'                */
 
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE + /*S01486*/
/***********              '*ALL  ') *AND (&WWPREF *EQ '*ALL')) THEN(DO/*S01486*/
             IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *NE +
                         '*ALL') *AND (&WWPREF *EQ '*ALL'))  THEN(DO) /*S01486*/
/*********** OPNQRYF    FILE((PMACCCUS)) QRYSLT('AZACOC *EQ "' *CAT + /*S01486*/
/***********              &WWACOF *CAT '" *AND *MAPFLD/BBXXXX *EQ "' +/*S01486*/
/***********              *CAT &WWCUST *CAT '"') KEYFLD((AZPRTL +     /*S01486*/
/***********              *ASCEND) (AZACOC) (P8CNUM) (P8FPTF) +       /*S01486*/
/***********              (P8MODI) (P8SESN) (P8TRNB)) MAPFLD((BBXXXX +/*S01486*/
/***********              BBCUST *CHAR 6))                         */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) QRYSLT('AZACOC *EQ "' *CAT +
                          &WWACOF *CAT '" *AND *MAPFLD/BBXXXX *EQ +
                          "' *CAT &WWCUST *CAT '"') KEYFLD((AZACOC) +
                          (P8CNUM) (P8FPTF) (P8MODI) (P8SESN) +
                          (P8TRNB)) MAPFLD((BBXXXX BBCUST *CHAR 6)) +
                          /*S01486*/
             ENDDO
 
/*  Account officer, customer and portfolio entered                       */
 
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE + /*S01486*/
/***********              '*ALL  ') *AND (&WWPREF *NE '*ALL')) THEN(DO/*S01486*/
             IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *NE +
                         '*ALL') *AND (&WWPREF *NE '*ALL'))  THEN(DO) /*S01486*/
/*********** OPNQRYF    FILE((PMACCCUS)) QRYSLT('AZACOC *EQ "' *CAT + /*S01486*/
/***********              &WWACOF *CAT '" *AND *MAPFLD/BBXXXX *EQ  "' /*S01486*/
/***********              *CAT &WWCUST *CAT '"  *AND P8FPTF *EQ "' +  /*S01486*/
/***********              *CAT &WWPREF *CAT '"') KEYFLD((AZPRTL +     /*S01486*/
/***********              *ASCEND) (AZACOC) (P8CNUM) (P8FPTF) +       /*S01486*/
/***********              (P8MODI) (P8SESN) (P8TRNB)) MAPFLD((BBXXXX +/*S01486*/
/***********              BBCUST *CHAR 6))                         */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) QRYSLT('AZACOC *EQ "' *CAT +
                          &WWACOF *CAT '" *AND *MAPFLD/BBXXXX *EQ  +
                          "' *CAT &WWCUST *CAT '"  *AND P8FPTF *EQ +
                          "' *CAT &WWPREF *CAT '"') KEYFLD((AZACOC) +
                          (P8CNUM) (P8FPTF) (P8MODI) (P8SESN) +
                          (P8TRNB)) MAPFLD((BBXXXX BBCUST *CHAR 6))   /*S01486*/
             ENDDO
 
/*  Account officer and customer '*ALL'; portfolio '9997'                 */
 
/*********** IF         COND((&WWACOF *EQ '*ALL') *AND (&WWCUST *EQ + /*S01486*/
/***********            '*ALL  ') *AND (&WWPREF *EQ '9997')) THEN(DO) /*S01486*/
             IF         COND((&RENT *EQ 'ALL') *AND (&WWCUST *EQ +
                        '*ALL  ') *AND (&WWPREF *EQ '9997')) THEN(DO) /*S01486*/
/*********** OPNQRYF    FILE((PMACCCUS)) QRYSLT('P8FPTF *EQ "9997"') +/*S01486*/
/***********              KEYFLD((AZPRTL *ASCEND) (AZACOC) (P8CNUM) + /*S01486*/
/***********              (P8FPTF) (P8MODI) (P8SESN) (P8TRNB))     */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) QRYSLT('P8FPTF *EQ "9997"') +
                          KEYFLD((AZACOC) (P8CNUM) (P8FPTF) +
                          (P8MODI) (P8SESN) (P8TRNB))                 /*S01486*/
             ENDDO
 
/*  Account officer entered; customer '*ALL'; portfolio '9997'            */
 
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *EQ + /*S01486*/
/***********              '*ALL  ') *AND (&WWPREF *EQ '9997')) THEN(DO/*S01486*/
             IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *EQ +
                          '*ALL  ') *AND (&WWPREF *EQ '9997')) THEN(DO)
/*********** OPNQRYF    FILE((PMACCCUS)) QRYSLT('AZACOC *EQ "' *CAT + /*S01486*/
/***********              &WWACOF *CAT '" *AND P8FPTF *EQ "9997"') +  /*S01486*/
/***********              KEYFLD((AZPRTL *ASCEND) (AZACOC) (P8CNUM) + /*S01486*/
/***********              (P8FPTF) (P8MODI) (P8SESN) (P8TRNB))     */ /*S01486*/
             OPNQRYF    FILE((PMACCUL0)) QRYSLT('AZACOC *EQ "' *CAT +
                          &WWACOF *CAT '" *AND P8FPTF *EQ "9997"') +
                          KEYFLD((AZACOC) (P8CNUM) (P8FPTF) +
                          (P8MODI) (P8SESN) (P8TRNB))                 /*S01486*/
             ENDDO
 
/*********** ENDDO                                                 */ /*S01486*/
 
/*********** CALL       PGM(PM0340) PARM(&WWMODE &WWACOF &WWCUST +    /*S01486*/
/***********              &WWPREF)                                 */ /*S01486*/
             CALL       PGM(PM0340) PARM(&MODE &RSEQ)                 /*S01486*/
/*********** CLOF       OPNID(PMACCCUS)                            */ /*S01486*/
/*********** DLTOVR     FILE(PMACCCUS)                             */ /*S01486*/
             DLTOVR     FILE(PMACCUL0)                                /*S01486*/
 
/*  Data base error processing  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          */ /*S01486*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
/************                                                         /*S01486*/
/**If*batch*job, terminate processing */                              /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************   GOTO       CMDLBL(ENDPGM)                             /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/**Return*to*prompt screen */                                         /*S01486*/
/************                                                         /*S01486*/
/************GOTO       CMDLBL(PM0800)                                /*S01486*/
/************                                                         /*S01486*/
                GOTO       CMDLBL(ENDPGM)                             /*S01486*/
 ENDTAG:     DMPCLPGM
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
