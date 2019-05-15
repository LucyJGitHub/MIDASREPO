/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM daily transactions report')                  */
/********************************************************************/
/*                                                                  */
/*       Midas - Portfolio Management Module                    */
/*                                                                  */
/*       PMC0400 - DAILY TRANSACTIONS  REPORT                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM004             Date 08Feb96              */
/*                      S01408             Date 11May95              */
/*                      S01486             DATE 10OCT94             */
/*                      059770             DATE 06NOV92             */
/*                      056522             DATE 08JUN93             */
/*                      049421             DATE 18JAN93             */
/*                      S01189             DATE 25MAR92             */
/*                      R05878             DATE 24APR91             */
/*                      R10041             DATE 16SEP90             */
/*                      R00300             DATE 28AUG90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM004 - Bank Portfolios                                   */
/*       S01408 - Addition of core hook PMC0400MP1                   */
/*       S01486 - PORTFOLIO MANAGEMENT UPGRADE TO R10               */
/*       059770 - ADD MONMSG FOR EMPTY FILE IN CASE OF RESTART      */
/*       056522 - TAKE A SECURITY COPY OF FILE PMTRCNZZ             */
/*       049421 - HEADER BOX STANDARDISATION                        */
/*       S01189 - COB RECOVERY PROCESSING                           */
/*       R05878 - COMPONEN NOT RESTARTABLE                          */
/*       R10041 - POSTINGS EXTRACT RUN HERE TO PICK UP DETAILS OF   */
/*                POSTINGS GENERATED TODAY                          */
/*       R00300 - MESSAGE FILE CHANGES                              */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&FULCOM)                          R10041*/
/*>>S01189>>*/
/**********  PGM                                             /*R10041*/
/************PGM        PARM(&CNAM &CSEQ)                            * *S01486*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLVL &RENT)           /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(2)                  /*S01486*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&FULCOM) TYPE(*CHAR) LEN(1)        R10041*/
             DCL        VAR(&FULCOM) TYPE(*CHAR) LEN(1) VALUE(C)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)      /*R10041*/
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)        /*R10041*/
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)          R05878  S01189*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)      /*R05878*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)         /*R05878*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)    /*R05878*/
             DCL        VAR(&FCPORS) TYPE(*CHAR) LEN(1)               /*CPM004*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM004*/
             DCL        VAR(&SDPORT) TYPE(*CHAR) LEN(200)             /*CPM004*/
 
             CHGJOB     SWS(00000000)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)       /*R05878*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))   /*R05878*/
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB') /*R05878 S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0400MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC0400 - PM Daily Transactions Report') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)      /*R10041*/
             MONMSG     MSGID(CPF9801) EXEC(DO)              /*R10041*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)                      /*R10041*/
             ENDDO                                           /*R10041*/
/**/                                                                  /*CPM004*/
/*  Check if Bank Portfolio is supported. */                          /*CPM004*/
/**/                                                                  /*CPM004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM004*/
/**/                                                                  /*CPM004*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &SDPORT)       /*CPM004*/
/**/                                                                  /*CPM004*/
/*  Database error handling.                                          /*CPM004*/
/**/                                                                  /*CPM004*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ERROR))                              /*CPM004*/
             ELSE       CMD(CHGVAR VAR(&FCPORS) VALUE(%SST(&SDPORT +
                          112 1)))                                    /*CPM004*/
/**/                                                                  /*CPM004*/
 
/* CHECK FOR COMPONENT RESTART */
/*>>S01189>>*/
/**********  RTVDTAARA  DTAARA(PMSTAT (16 3)) RTNVAR(&BUSY)  /*R05878*/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'NEW') THEN(DO)           R05878  S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)
/*<<S01189<<*/
/************OVRDBF     FILE(XPMTRCNPP) SEQONLY(*YES 100)  /*R05878*/ /*S01486*/
/************CPYF       FROMFILE(XPMTRCNPP) TOFILE(PMTRCNPP) +        /*S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)   /*R05878*/ /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(PMTRCNPP))                /*059770 */  /*S01486*/
             OVRDBF     FILE(XPMTRCNPD) SEQONLY(*YES 100)  /*R05878*/ /*S01486*/
             CPYF       FROMFILE(XPMTRCNPD) TOFILE(PMTRCNPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMTRCNPD))                             /*S01486*/
/* >>> 056522 >>> */
/************CPYF       FROMFILE(XPMTRCNZZ) TOFILE(PMTRCNZZ) +        /*S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             CPYF       FROMFILE(XPMTRCNPA) TOFILE(PMTRCNPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
/* <<< 056522 <<< */
             ENDDO                                           /*R05878*/
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)         /*R05878*/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/************OVRDBF     FILE(PMTRCNPP) SEQONLY(*YES 100)  /*R05878*/  /*S01486*/
/************CPYF       FROMFILE(PMTRCNPP) TOFILE(&TOLIB/XPMTRCNPP) + /*S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) +            /*S01486*/
/************             FMTOPT(*NONE)                    /*R05878*/ /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(XPMTRCNPP))              /*R05878*/    /*S01486*/
             OVRDBF     FILE(PMTRCNPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMTRCNPD) TOFILE(&TOLIB/XPMTRCNPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRCNPD))                            /*S01486*/
/* >>> 056522 >>> */
/************CPYF       FROMFILE(PMTRCNZZ) TOFILE(&TOLIB/XPMTRCNZZ) + /*S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) +            /*S01486*/
/************             FMTOPT(*NONE)                               /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(XPMTRCNZZ))                            /*S01486*/
             CPYF       FROMFILE(PMTRCNPA) TOFILE(&TOLIB/XPMTRCNPA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRCNPA))                            /*S01486*/
/* <<< 056522 <<< */
/*>>S01189>>*/
/**********  CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')   /*R05878*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO                                           /*R05878*/
 
/* RETRIEVE DTAARA MMOD TO CHECK MODULES PRESENT */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/* CALL RETAIL TRANSACTION EXTRACT */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))   /*R10041*/
             IF         COND(&MDID = 'Y') THEN(DO)           /*R10041*/
             CALL       PGM(PMC0398)                         /*R10041*/
/* PROCESS ANY DATA BASE ERROR                               /*R10041*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                     /*R10041*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM      /*R10041*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(GOTO +
                          CMDLBL(ERROR))                     /*R10041*/
             ENDDO                                           /*R10041*/
 
             IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                        '   ')) THEN(DO)                              /*S01486*/
             CHGVAR     VAR(&ENT) VALUE(%SST(&RENT 1 2))              /*S01486*/
/************OVRDBF     FILE(PMTRCNJF) SHARE(*YES)                    /*S01486*/
/************OVRDBF     FILE(PMTRCNL0) SHARE(*YES)            *S01486* *S01486*/
             IF         COND(&FCPORS *EQ 'B') THEN(DO)                /*CPM004*/
             OVRDBF     FILE(PMTRCNL1) POSITION(*KEY 1 PMTRCNP2 +
                          &ENT) SHARE(*YES)                           /*CPM004*/
             OPNDBF     FILE(PMTRCNL1) OPTION(*ALL)                   /*CPM004*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*CPM004*/
             DLTOVR     FILE(PMTRCNL1)                                /*CPM004*/
             CLOF       OPNID(PMTRCNL1)                               /*CPM004*/
             ENDDO                                                    /*CPM004*/
             ENDDO                                                    /*CPM004*/
             IF         COND(&FCPORS *NE 'B') THEN(DO)                /*CPM004*/
             OVRDBF     FILE(PMTRCNL0) POSITION(*KEY 1 PMTRCNP1 +
                          &ENT) SHARE(*YES)                           /*S01486*/
             OPNDBF     FILE(PMTRCNL0) OPTION(*ALL)                   /*S01486*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01486*/
             DLTOVR     FILE(PMTRCNL0)                                /*S01486*/
             CLOF       OPNID(PMTRCNL0)                               /*S01486*/
             ENDDO                                                    /*CPM004*/
             ENDDO                                                    /*S01486*/
             ENDDO                                                    /*S01486*/
/************ELSE       CMD(OVRDBF FILE(PMTRCNL0) SHARE(*YES)S01486*/ /*CPM004*/
             ELSE       CMD(DO)                                       /*CPM004*/
             IF         COND(&FCPORS *EQ 'B') THEN(OVRDBF +
                          FILE(PMTRCNL1) SHARE(*YES))                 /*CPM004*/
             ELSE       CMD(OVRDBF FILE(PMTRCNL0) SHARE(*YES))        /*CPM004*/
                                                                      /*CPM004*/
             ENDDO                                                    /*CPM004*/
 
/************OPNQRYF    FILE((*LIBL/PMTRCNJF)) KEYFLD((AZPRTL) +      /*S01486*/
/************             (SAACOC) (SACNUM) (SAPTFR) (PADSPS) +       /*S01486*/
/************             (SARCOA) (SARSEA) (SAINNR) (SATDSS) +       /*S01486*/
/************             (SATRNB))                                   /*S01486*/
             IF         COND(&FCPORS *EQ 'B') THEN(DO)                /*CPM004*/
             OPNQRYF    FILE((*LIBL/PMTRCNL1)) KEYFLD( +
                          (SABACO) (SABCNM) (SAPTFR) (PADSPS) +
                          (SARCOA) (SARSEA) (SAINNR) (SATDSS) +
                          (SATRNB))                                   /*CPM004*/
             CHGJOB     SWS(01000000)                                 /*CPM004*/
             ENDDO                                                    /*CPM004*/
             ELSE       CMD(DO)                                       /*CPM004*/
             OPNQRYF    FILE((*LIBL/PMTRCNL0)) KEYFLD( +
                          (SAACOC) (SACNUM) (SAPTFR) (PADSPS) +
                          (SARCOA) (SARSEA) (SAINNR) (SATDSS) +
                          (SATRNB))                                   /*S01486*/
             CHGJOB     SWS(10000000)                                 /*CPM004*/
             ENDDO                                                    /*CPM004*/
/**/                                                                  /*CPM004*/
/************CALL       PGM(PM0400) PARM(&FULCOM)                    * *S01486*/
             CALL       PGM(PM0400) PARM(&FULCOM &RSEQ &RENT)         /*S01486*/
/************CLOF       OPNID(PMTRCNJF)                               /*S01486*/
/************DLTOVR     FILE(PMTRCNJF)                                /*S01486*/
             IF         COND(&FCPORS *EQ 'B') THEN(DO)                /*CPM004*/
             CLOF       OPNID(PMTRCNL1)                               /*CPM004*/
             DLTOVR     FILE(PMTRCNL1)                                /*CPM004*/
             ENDDO                                                    /*CPM004*/
             ELSE       CMD(DO)                                       /*CPM004*/
             CLOF       OPNID(PMTRCNL0)                               /*S01486*/
             DLTOVR     FILE(PMTRCNL0)                                /*S01486*/
             ENDDO                                                    /*CPM004*/
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/************   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52)) /*S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01486*/
/************                                                      R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) + **/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             CHGVAR     VAR(&MEM) VALUE('PMC0400  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
/*              GOTO ENDPGM                                    R05878*/
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)     /*R05878*/
/*>>S01189>>*/
/**********  CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')   /*R05878*/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/************DLTF       FILE(XPMTRCNPP)                    /*R05878*/ /*S01486*/
             DLTF       FILE(XPMTRCNPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)                       /*R05878*/
/* >>> 056522 >>> */
/************DLTF       FILE(XPMTRCNZZ)                               /*S01486*/
             DLTF       FILE(XPMTRCNPA)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/* <<< 056522 <<< */
             ENDDO                                           /*R05878*/
 
/**********ENDPGM:      ENDPGM                                         *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
         ENDPGM                                                       /*S01486*/
