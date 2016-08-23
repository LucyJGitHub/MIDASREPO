/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle confs. print - reprint req')     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0212C-INPUT CYCLE CONFIRMATIONS REPRINT REQUEST          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE044             Date 09Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      124684             DATE 06JAN98              */
/*                      S01408             DATE 14MAY96              */
/*                      S01465             DATE 22MAR94              */
/*                      E41909             DATE 03JUL92              */
/*                      E40940             DATE 12JUN92              */
/*                      LN0470             DATE 10JUL90              */
/*                      S01117             DATE 08FEB90              */
/*                      S01194             DATE 11DEC89              */
/*                      S01179             DATE 11SEP88              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CLE044 - Always run LE0130 regardless of S01465.            */
/*                (Upgrade to Midas Plus 1.2)                        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       124684 - If the confirmations job ends abnormally and does  */
/*                not change LESTAT position 6 back to 'N', no confs */
/*                are produced in subsequent runs. Fix is to use new */
/*                data area LECONF and ALCOBJ/DLCOBJ commands to     */
/*                to determine if the confirmations job is active -  */
/*                if the job fails, the data area is automatically   */
/*                de-allocated.                                      */
/*       S01408 - Core hook LEC0212C02 added                         */
/*                Core hook LEC0212C01 added                         */
/*       S01465 - BLI Lending Enhancement                            */
/*       E41909 - INCORRECT HANDLING OF PARAMETERS - PUT BACK &RPARM */
/*       E40940 - INCORRECT HANDLING OF PARAMETERS - REMOVE &RPARM   */
/*       LN0470 - INCORRECT HANDLING OF PARAMETERS FOR RCF           */
/*       S01117 - RELEASE 10 MULTIBRANCHING                          */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01179 - AS400 INCORPORATION                                */
/*                                                                   */
/*********************************************************************/
/**/
/*********** PGM                                                     * *S01117*/
/*********** PGM PARM(&RSEQ &RLEV &RENT)                     /*S01117* *LN0470*/
/*********** PGM PARM(&RSEQ &RLEV &RENT &RPARM)              /*LN0470* *E40940*/
/*********** PGM PARM(&RSEQ &RLEV &RENT)                      *E40940* *E41909*/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)                       /*E41909*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/*********** DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)     /*LN0470* *E40940*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*E41909*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)            */   /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)             /*124684*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
             DCL        VAR(&CLE044) TYPE(*CHAR) LEN(1)                                   /*CLE044*/
/*/COPY WNCPYSRC,LEC0212C05                                          */
/************DCLDTAARA  DTAARA(LESTAT)                             */ /*S01179*/
/************DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,LEH01028                                            */
/**/
/*     SINGLE CONFIRMATION REPRINT REQUEST - SET & RESET BUSY FLAG */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*LN0470 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             SNDPGMMSG   MSG('I/C CONFIRMATIONS REPRINT REQUEST') +
                        TOMSGQ(MRUNQ)
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
/**/                                                                  /*124684*/
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                /*124684*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 6 1) *EQ N) THEN(DO)  /*124684*/
/************   CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(Y)      /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************   DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
/*LE0150*/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)               * *S01194*/
/************** CALL       PGM(LE0150)                                /*LN0470*/
/************** DLTOVR     FILE(*ALL)                         */      /*S01194*/
/**/
/************   ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
/************   RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)             /*124684*/
/************   CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(N)      /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************ENDDO                                                    /*124684*/
/**/
/************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/*   E R R O R   M E S S A G E S                                     */
             IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +
                                               SYSTEM ERROR')
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***CHGVAR*****VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))               /*S01194*/
    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))               /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(MIDPGM)
                ENDDO
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
/**/
/*    PRINT CONFIRMATIONS - SET & RESET BUSY FLAG                   */
MIDPGM:      IF         COND(%SWITCH(XXXXX000)) THEN(DO)
                CHGJOB     SWS(10000000)
/***************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
/***************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)             /*124684*/
                SNDPGMMSG  MSG('PRINT CONFIRMATIONS') TOMSGQ(MRUNQ)
/**/
/************   IF         COND(%SUBSTRING(&LESTAT 6 1) *EQ N) THEN(DO/*124684*/
/************      CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(Y)   /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************      DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*124684*/
/***************** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)            * *S01194*/
/**/
/***************** CALL       PGM(LE0130)                            * *S01117*/
/*/COPY WNCPYSRC,LEC0212C06                                          */
/**/                                                                                      /*CLE044*/
/** Access SAR file to determine if switchable feature CLE044     */                      /*CLE044*/
/** is switched ON.  If ON, print LE0130 and suppress LE1150.     */                      /*CLE044*/
/**/                                                                                      /*CLE044*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE044*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE044*/
             CHGVAR     VAR(&SAR) VALUE('CLE044')                                         /*CLE044*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE044*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE044) VALUE('Y'))                                        /*CLE044*/
/**/                                                                 /*S01465*/
/**/                                                                 /*S01465*/
/** Access SAR file to determine if switchable feature S01465     */ /*S01465*/
/** is switched ON                                                */ /*S01465*/
/**/                                                                 /*S01465*/
                   CHGVAR     VAR(&RTCD) VALUE('       ')            /*S01465*/
                   CHGVAR     VAR(&OPTN) VALUE('*VERIFY')            /*S01465*/
                   CHGVAR     VAR(&SAR) VALUE('S01465')              /*S01465*/
                   CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN +
                                 &SAR &SCSARD)                       /*S01465*/
/*/COPY WNCPYSRC,LEC0212C07                                          */
/***************** IF         COND(&RTCD *EQ '       ') THEN(DO)     /*S01465*/           /*CLE044*/
                   IF         COND((&RTCD *EQ '       ') *AND +
                                 (&CLE044 *NE 'Y')) THEN(DO)                              /*CLE044*/
/*/COPY WNCPYSRC,LEC0212C03                                          */
                      OVRDBF     FILE(CLOAN2) TOFILE(CLOAN) +
                                 SHARE(*NO)                          /*S01465*/
                      CALL       PGM(LE1150) PARM(&RSEQ 'ALL')       /*S01465*/
/*/COPY WNCPYSRC,LEC0212C04                                          */
                      MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                                    EXEC(DO)                         /*S01465*/
                      ROLLBACK                                       /*S01465*/
                      SNDPGMMSG  MSG('Transaction failed. Re-input +
                        necessary. Enter to continue.') TOPGMQ(*EXT) /*S01465*/
                      ENDDO                                          /*S01465*/
                   ENDDO                                             /*S01465*/
                   ELSE       CMD(DO)                                /*S01465*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212C01                                           /*S01408*/
/**                                                                   /*S01408*/
                   CALL       PGM(LE0130) PARM(&RSEQ 'ALL')           /*S01117*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212C02                                           /*S01408*/
/**                                                                   /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/*/COPY WNCPYSRC,LEC0212C08                                          */
                   ENDDO                                             /*S01465*/
/**/
/**********        DLTOVR     FILE(*ALL)                    */        /*S01194*/
/**********        ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))           /*124684*/
/**********        RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)          /*124684*/
/**********        CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(N)   /*124684*/
/**********  CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/**********     ENDDO                                                 /*124684*/
/**/
/**********     DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
                CHGJOB     SWS(0XXXXXXX)
/**/
/*   ERROR MESSAGES                                           */
                IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)
/**/
                   IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                      CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +
                                                  SYSTEM ERROR')
                   ENDDO
   /**/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/********CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))      */  /*S01194*/
         CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))          /*S01194*/
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOMSGQ(MOPERQ MRUNQ)
                      GOTO       CMDLBL(ENDPGM)
                   ENDDO
   /**/
                   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
                ENDDO
/**/
             ENDDO
/**/
             ENDCMTCTL                                                /*LN0470*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*124684*/
ENDPGM:                                                               /*124684*/
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
             ENDPGM                                                   /*124684*/
/**/                                                                  /*124684*/
/***********ENDPGM:      ENDPGM                                       /*124684*/
