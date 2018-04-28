/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Restart confirmations print')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0212D-RESTART CONFIRMATIONS                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*     Prev Amend No. 124684              DATE 06JAN98              */
/*                    S01408              DATE 14MAY96              */
/*                    S01117              DATE 08FEB90              */
/*                    S01194              DATE 11DEC89              */
/*                    S01179              DATE 11SEP88               */
/*                                                                  */
/********************************************************************/
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       124684 - If the confirmations job ends abnormally and does  */
/*                not change LESTAT position 6 back to 'N', no confs */
/*                are produced in subsequent runs. Fix is to use new */
/*                data area LECONF and ALCOBJ/DLCOBJ commands to     */
/*                to determine if the confirmations job is active -  */
/*                if the job fails, the data area is automatically   */
/*                de-allocated.                                      */
/*       S01408 - Core hook LEC0212D02 added                        */
/*                Core hook LEC0212D01 added                        */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)             /*124684*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*           DCLDTAARA  DTAARA(LESTAT)                             */ /*S01179*/
/*           DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
/*/COPY WNCPYSRC,LEC0212D03                                          */
/*   PRINT CONFIRMATIONS - SET & RESET BUSY FLAG               */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)                /*124684*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 6 1) *EQ N) THEN(DO)  /*124684*/
/************   CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(Y)      /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************   DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
/**/                                                                  /*124684*/
                ALCOBJ     OBJ((LECONF *DTAARA *EXCL)) WAIT(0)        /*124684*/
                MONMSG     MSGID(CPF0000) EXEC(GOTO ABNOR)            /*124684*/
                CHGJOB     SWS(10000000)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/*********** CALL       PGM(LE0130)                                  * *S01117*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212D01                                           /*S01408*/
/**                                                                   /*S01408*/
             CALL       PGM(LE0130) PARM('     ' 'ALL')               /*S01117*/
/**                                                                   /*S01408*/
/*/COPY WNCPYSRC,LEC0212D02                                           /*S01408*/
/**                                                                   /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/*/COPY WNCPYSRC,LEC0212D04                                          */
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
/**/
                CHGJOB     SWS(000XXXXX)
/************   ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))              /*124684*/
/************   RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)             /*124684*/
/************   CHGVAR     VAR(%SUBSTRING(&LESTAT 6 1)) VALUE(N)      /*124684*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*124684*/
/************ENDDO                                                    /*124684*/
/**/
/************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/*   E R R O R   M E S S A G E S                                     */
ABNOR:                                                                /*124684*/
             IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +
                                               SYSTEM ERROR')
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))          */ /*S01194*/
      CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))             /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
ENDPGM:      ENDCMTCTL
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
