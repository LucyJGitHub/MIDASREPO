/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Facility Maintenance')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/********LEC0606*-*COMMITMENT*FEE*&*FACILITIES*UPDATE*PHASE*ONE*******/
/*       LEC0606A - FACILITIES UPDATE                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. AR1061928          Date 30Nov12              */
/*       Prev Amend No. AR1055539          Date 12Nov12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      239910             Date 29Jun06              */
/*                      228542             Date 10Aug04              */
/*                      CLE039             Date 20Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      120277                  Date  24Feb99       */
/*                      127762                  DATE  28MAY98       */
/*                      098436                  DATE  08JUL96       */
/*                      MOF60                   DATE  27MAR92       */
/*                      S01194                  DATE  08FEB90       */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       AR1061928 - LEC06 on MSGW during clean COB                 */
/*       AR1055539 - Various errors encountered in COB during       */
/*                   Link Test                                      */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       239910 - LERC30A Failed                                     */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CLE039 - General LE Enhancement                             */
/*       120277 - Risk participant / Assignments should be dropped  */
/*                if related to facilities which are dropped        */
/*       127762 - Copy expired facilities (RECI = 'E') from FCUPDFM */
/*                to PEFCLFM after call to LE0461, so that RECI on  */
/*                facility history can be brought in line. LE0461   */
/*                sets RECI to 'E'. LER032 updates history.         */
/*                (Applied fix 109200)                              */
/*       098436 - Cannot clear LKEY2ZZ because already in use.      */
/*                File should not be cleared in this component as   */
/*                it now calls LE0461 rather than LE0460.           */
/*       MOF60  - CHANGES TO LE0460 & SAVE OF FACILITIES FILE       */
/*                BEFORE UPDATE                                     */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                          /*CLE134*/
             PGM        PARM(&RERUN)                                                      /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('FACILITIES UPDATE ')
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
                                                                                          /*CLE039*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
                                                                                          /*CLE134*/
             STRCMTCTL  LCKLVL(*ALL) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                  /*CLE039*/
             MONMSG     MSGID(CPF8351)                                                    /*CLE039*/
                                                                                          /*CLE039*/
/*/COPY WNCPYSRC,LEC0606A02                                          */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*/COPY WNCPYSRC,LEC0606A03                                          */
/**/
/* CLEAR OUTPUT FILES FOR LE0460                                    */
             CLRPFM     FILE(FCUPDHH)
             CLRPFM     FILE(FCUPDFM)
             CLRPFM     FILE(FCUPDFN)
             CLRPFM     FILE(FCUPDZZ)
             CLRPFM     FILE(LEEPRTPD)                                /*120277*/
/**/
/************CLRPFM     FILE(LKEY2HH)                            */ /*098436*/
/************CLRPFM     FILE(LKEY2DP)                            */ /*098436*/
/************CLRPFM     FILE(LKEY2ZZ)                            */ /*098436*/
 
/*       CHANGE TO TAKE COPY OF REVERSED & CLOSED                  */
/*       FACILITY DETAILS BEFORE DROPPED                           */
 
     CLRPFM FILE(PEFCLFM)
     CPYF FROMFILE(FCLTYFM) TOFILE(PEFCLFM) +
          MBROPT(*ADD) INCREL((*IF RECI *EQ 'R') (*OR RECI *EQ 'C'))
/**/                                                                                      /*239910*/
     CLRPFM FILE(PEFCLTQD)                                                                /*239910*/
     CPYF FROMFILE(LEFCLTQD) TOFILE(PEFCLTQD) +
          MBROPT(*ADD) CRTFILE(*NO)                                                       /*239910*/
/**/                                                                                      /*239910*/
/*/COPY WNCPYSRC,LEC0606A01                                          */
 
/**/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEI)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)        *S01194*/
/**/
/*  THE FOLLOWING MEMBERS WERE DELETED FROM LEC06A/LEC0605   */                        /*AR1055539*/
/*  AND CAUSES ERRORS ON LE0461, ADD THE SAID MEMBERS        */                        /*AR1055539*/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                             /*AR1055539*/
             ADDLFM     FILE(MLOANL1) MBR(MLOANL1)                                     /*AR1055539*/
/**********  MONMSG     MSGID(CPF5812)                  */                   /*AR1055539 AR1061928*/
             MONMSG     MSGID(CPF5812 CPF7306)                                         /*AR1061928*/
             ADDLFM     FILE(MQLONCK) MBR(MQLONCK)                                     /*AR1055539*/
/**********  MONMSG     MSGID(CPF5812)                  */                   /*AR1055539 AR1061928*/
             MONMSG     MSGID(CPF5812 CPF7306)                                         /*AR1061928*/
             ENDDO                                                                     /*AR1055539*/
/* FACILITIES FILE UPDATE PHASE ONE                                 */
/************CALL PGM(LE0460)****************************************/ /* CPF */
             CALL PGM(LE0461)                                          /* CPF */
                                                                                          /*CLE039*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)                                  /*CLE039*/
                COMMIT                                                                    /*CLE039*/
/**********     RGZPFM     FILE(LENOTEPD)                                      /*CLE039*/ /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                              /*CLE039*/ /*228542*/
                CALL       PGM(SCC000060) PARM('LENOTEPD' '*FIRST')                       /*228542*/
                                                                                          /*228542*/
/**********     RGZPFM     FILE(LEFCLTQD)                                      /*CLE039*/ /*228542*/
/**********     MONMSG     MSGID(CPF2995 CPF2981)                              /*CLE039*/ /*228542*/
                CALL       PGM(SCC000060) PARM('LEFCLTQD' '*FIRST')                       /*228542*/
                                                                                          /*228542*/
             ENDDO                                                                        /*CLE039*/
                                                                                          /*CLE039*/
/**/
/*/COPY WNCPYSRC,LEC0606A04                                          */
/**Copy Expired Facility Details. RECI can be set to 'E' in LE0461.   /*127762*/
             CPYF       FROMFILE(FCUPDFM) TOFILE(PEFCLFM) +
                          MBROPT(*ADD) INCREL((*IF RECI *EQ 'E'))     /*127762*/
/*                                                                    /*127762*/
/************** DLTOVR     FILE(TABLE)                                 *S01194*/
/**/
/* CLEAR FILES NO LONGER REQUIRED, IF JOB TERMINATED SUCCESSFULLY   */
/**          IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)          **/
/** MOF60  CHANGE TO TAKE KEEP ACTION RECORDS UNTIL         MOF60  */
/** AFTER FACILITY UPDATE (LER020)                                 */
/*                                                                 */
/*              CLRPFM     FILE(ACTN5DH)                           */
/*              CLRPFM     FILE(ACTN5DK)                           */
/*              CLRPFM     FILE(ACTN5DN)                           */
/*              CLRPFM     FILE(ACTN5ZX)                           */
/*                                                                 */
/** END MOF60 CHANGES                                       MOF60  */
/* */
/************ENDDO***************************************************/ /* CPF */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**********  ENDPGM     */                                                                /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
