/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle confs. print - reprint all')     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0212B-INPUT CYCLE CONFIRMATIONS PRINT - REPRINT ALL      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR322731           Date 01Aug12              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE044             DATE 09Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      124684             DATE 06JAN98              */
/*                      S01408             DATE 14MAY96              */
/*                      S01465             DATE 22MAR94              */
/*                      E40940                  12JUN92              */
/*                      LN0470                  10JUL90              */
/*                      S01117                  09FEB90              */
/*                      S01194                  11DEC89              */
/*                      S01179                  14SEP88              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR322731 - LEC0212A and APISERVER locks LTRIX file. Apply   */
/*                  fix 252833A (Child:AR322732)                     */
/*       252833A - Prevent LTRIX RRN 1 from being locked             */
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
/*       S01408 - Core hook LEC0212B02 added                         */
/*                Core hook LEC0212B01 added                         */
/*       S01465 - BLI Lending Enhancement                            */
/*       E40940 - MIPGM PROCESSING SEEMS DESIGNED TO RUN IF DBERR    */
/*                BUT CAN ONLY RUN IF U7/U8 OFF.  THIS PROCESSING    */
/*                IS REDUNDANT - REMOVE.                             */
/*       LN0470 - INCORRECT HANDLING OF COMMITMENT CONTROL           */
/*                ALSO BRANCH PROCESSING NOT CORRECT                 */
/*       S01117 - MULTIBRANCHING RELEASE 10                          */
/*       S01194 - NEW STANDING DATA                                  */
/*       S01179 -AS400 INCORPORATION                                 */
/*                                                                   */
/*********************************************************************/
/**/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)             /*124684*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
             DCL        VAR(&CLE044) TYPE(*CHAR) LEN(1)                                   /*CLE044*/
/*/COPY WNCPYSRC,LEC0212B04                                          */
/************DCLDTAARA  DTAARA(LESTAT)                             */ /*S01179*/
/************DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,LEH01027                                            */
/*    IF PRINT ALREADY ACTIVE - STOP PRINT                   */
 
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                /*124684*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 6 1) *EQ Y) THEN(DO)  /*124684*/
/************   CALL       PGM(LE0140)                                /*124684*/
/************ENDDO                                                    /*124684*/
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)           /*124684*/
/**********  MONMSG     MSGID(CPF0000) EXEC(CALL  PGM(LE0140)) */                 /*124684 252833A*/
             MONMSG     MSGID(CPF0000)                                                   /*252833A*/
/**/
/*    REPRINT ALL                                            */
             CHGJOB     SWS(01000000)
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                /*124684*/
/************CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(Y)         /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
             SNDPGMMSG  MSG('INPUT CYCLE CONFIRMATIONS REPRINT') +
                        TOMSGQ(MRUNQ)
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*LN0470 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *LN0470*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*LN0470*/
                 OVRDBF    FILE(SLTIX) POSITION(*KEY 1 LTRIXF +
                           &RENT)                                     /*LN0470*/
                 OPNDBF    FILE(SLTIX) OPTION(*ALL)                   /*LN0470*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*LN0470*/
                     DLTOVR     FILE(SLTIX)                           /*LN0470*/
                 ENDDO                                                /*LN0470*/
             ENDDO                                                    /*LN0470*/
/**/
/************CALL       PGM(LE0130)                                  * *S01117*/
/************CALL       PGM(LE0130) PARM(&RSEQ 'ALL')         *S01117* *LN0470*/
/*/COPY WNCPYSRC,LEC0212B06                                          */
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
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*S01465*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  /*S01465*/
             CHGVAR     VAR(&SAR) VALUE('S01465')                    /*S01465*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*S01465*/
/*/COPY WNCPYSRC,LEC0212B07                                          */
/*********** IF         COND(&RTCD *EQ '       ') THEN(DO)           /*S01465*/           /*CLE044*/
             IF         COND((&RTCD *EQ '       ') *AND +
                        (&CLE044 *NE 'Y')) THEN(DO)                                       /*CLE044*/
/*/COPY WNCPYSRC,LEC0212B03                                          */
                OVRDBF     FILE(CLOAN2) TOFILE(CLOAN) SHARE(*NO)     /*S01465*/
                CALL       PGM(LE1150) PARM(&RSEQ &RENT)             /*S01465*/
/*/COPY WNCPYSRC,LEC0212B05                                          */
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)   /*S01465*/
                ROLLBACK                                             /*S01465*/
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)   /*S01465*/
                ENDDO                                                /*S01465*/
             ENDDO                                                   /*S01465*/
             ELSE       CMD(DO)                                      /*S01465*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212B01                                           /*S01408*/
/**                                                                   /*S01408*/
             CALL       PGM(LE0130) PARM(&RSEQ &RENT)                 /*LN0470*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212B02                                           /*S01408*/
/**                                                                   /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/*/COPY WNCPYSRC,LEC0212B08                                          */
             ENDDO                                                   /*S01465*/
/**/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGJOB     SWS(000XXXXX)
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                /*124684*/
/************CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(N)         /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/*   E R R O R   M E S S A G E S                                    */
             IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +
                                               SYSTEM ERROR')
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*****CHGVAR*****VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))             /*S01194*/
      CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))             /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
/***********       GOTO       CMDLBL(MIDPGM)                           *E40940*/
                ENDDO
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
/*  REDUNDANT PROCESSING                                               *E40940*/
/*****RETURN*TO*ORIGINAL*MODE*IN*CASE*PRINT*WAS*STOPPED********/      /*E40940*/
/*MIDPGM:****** IF         COND(%SWITCH(XXXXX000)) THEN(DO)            *E40940*/
/***********    CHGJOB     SWS(10000000)                               *E40940*/
/***********    ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))               *E40940*/
/***********    RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)              *E40940*/
/***********    IF         COND(%SUBSTRING(&LESTAT 6 1) *EQ N) THEN(DO)*E40940*/
/***********       CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(Y)    *E40940*/
/*********** CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                  *E40940*/
/***********       DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))            *E40940*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*********** CALL       PGM(LE0130)                                  * *S01117*/
/*********** CALL       PGM(LE0130) PARM('     ' 'ALL')      /*S01117* *E40940*/
/************DLTOVR     FILE(*ALL)                                   * *S01194*/
/***********       ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))            *E40940*/
/***********       RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)           *E40940*/
/***********       CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(N)    *E40940*/
/*********** CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                  *E40940*/
/***********    ENDDO                                                  *E40940*/
/***********    DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))               *E40940*/
/**/
/*   E R R O R   M E S S A G E S                                     */
/***********    IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)       *E40940*/
/***********       IF         COND(%SWITCH(XXXXXX10)) THEN(DO)         *E40940*/
/***********          CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +   *E40940*/
/***********                                      SYSTEM ERROR')       *E40940*/
/***********       ENDDO                                               *E40940*/
/***********       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)         *E40940*/
/***********          RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)              *E40940*/
/***********CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))    */ /*S01194*/
/***********CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50)) S01194 *E40940*/
/***********        SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)+ *E40940*/
/***********                       TOMSGQ(MOPERQ MRUNQ)                *E40940*/
/***********          GOTO       CMDLBL(ENDPGM)                        *E40940*/
/***********       ENDDO                                               *E40940*/
/***********       SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)           *E40940*/
/***********    ENDDO                                                  *E40940*/
/*********** ENDDO                                                     *E40940*/
/**/
             ENDCMTCTL                                                /*LN0470*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**********ENDPGM:      ENDPGM                                        /*124684*/
ENDPGM:      DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
             ENDPGM                                                   /*124684*/
