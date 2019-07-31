/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Counterparty Exposure Report')               */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0705   COUNTERPARTY EXPOSURE REPORT                     */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01117                  DATE  09JAN91       */
/*                      S01179                  DATE  16/09/88      */
/*                      E14874                  DATE  15/09/88      */
/*                      E13776                  DATE  02/08/88      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*      MD046248 - Finastra Rebranding                              */
/*      S01117  - MULTIBRANCHING                                    */
/*      S01179  - RELEASE                                       *      *S01179*/
/*      E14874  - CATER FOR EMPTY FILES WHEN COPYING                *  *E14874*/
/*      E13776  - AMENDED TO OPEN QUERY FILE CPLEXQF USING          *  *E14874*/
/*                CPLEX2 INSTEAD OF CPLEX. CPLEX2 IS A DUPLICATE    *  *E13776*/
/*                OF CPLEX BUT CPLEX IS USED IN SE1005, THIS        *  *E13776*/
/*                CAUSED A FORMAT ERROR.                            *  *E13776*/
/*                                                                  *  *E13776*/
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&PRM01 &PRM02 &PRM03 &PRM04)            * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&PRM01) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRM02) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRM03) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRM04) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRM05) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PRM05A) TYPE(*CHAR) LEN(5)
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
 
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
 
/* EXTRACT PROMPT PARAMETERS FROM RCF */                              /*S01117*/
             CHGVAR     VAR(&PRM01) VALUE(%SST(&RPARM 1 1))           /*S01117*/
             CHGVAR     VAR(&PRM02) VALUE(&RLEV)                      /*S01117*/
             CHGVAR     VAR(&PRM03) VALUE(%SST(&RPARM 2 1))           /*S01117*/
             CHGVAR     VAR(&PRM04) VALUE(%SST(&RPARM 3 1))           /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                          */
 
 
             CHGVAR     VAR(&MSG) +
                      VALUE('SEC0705 - Counterparty Exposure Report')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                    */
 
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES                                   */
 
 
             CLRPFM     FILE(CPEXPD) MBR(CPEXPD)
 
/* COPY SELECTED RECORDS FROM LF/SLIMHJF TO PF/CPLIMD */
 
         /*  IF     ((&PRM01 = 'C') *AND (&PRM03 = 'Y')) THEN( +        E14874*/
             IF     ((&PRM01 = 'C') *AND (&PRM03 = 'Y')) THEN(DO)     /*E14874*/
               CPYF  FROMFILE(SLIMHJF) TOFILE(CPLIMD) MBROPT(*REPLACE) +
FMTOPT(*MAP *DROP) INCCHAR(CLLV 1 *EQ &PRM02) INCREL((*IF CLCM *LT X'40') +
(*AND CLBK *NE '  '))                                                /* E14874*/
         /*          INCREL((*IF CLCM *LT X'40') (*AND CLBK *NE '  '))) E14874*/
               MONMSG CPF2817                                         /*E14874*/
               ENDDO                                                  /*E14874*/
         /*  IF     ((&PRM01 = 'C') *AND (&PRM03 = 'N')) THEN( +        E14874*/
             IF     ((&PRM01 = 'C') *AND (&PRM03 = 'N')) THEN(DO)     /*E14874*/
               CPYF  FROMFILE(SLIMHJF) TOFILE(CPLIMD) MBROPT(*REPLACE) +
FMTOPT(*MAP *DROP) INCCHAR(CLLV 1 *EQ &PRM02) INCREL((*IF CLCM *LT X'40') +
(*AND CLBK *EQ '  '))                                                /* E14874*/
         /*          INCREL((*IF CLCM *LT X'40') (*AND CLBK *EQ '  '))) E14874*/
               MONMSG CPF2817                                         /*E14874*/
               ENDDO                                                  /*E14874*/
         /*  IF     ((&PRM01 = 'P') *AND (&PRM03 = 'Y')) THEN( +        E14874*/
             IF     ((&PRM01 = 'P') *AND (&PRM03 = 'Y')) THEN(DO)     /*E14874*/
               CPYF  FROMFILE(SLIMHJF) TOFILE(CPLIMD) MBROPT(*REPLACE) +
FMTOPT(*MAP *DROP) INCCHAR(CLLV 1 *EQ &PRM02) INCREL((*IF CLCM *GE X'40') +
(*AND CLBK *NE '  '))                                                /* E14874*/
         /*          INCREL((*IF CLCM *GE X'40') (*AND CLBK *NE '  '))) E14874*/
               MONMSG CPF2817                                         /*E14874*/
               ENDDO                                                  /*E14874*/
/*           IF     ((&PRM01 = 'P') *AND (&PRM03 = 'N')) THEN( + */   /*E14874*/
             IF     ((&PRM01 = 'P') *AND (&PRM03 = 'N')) THEN(DO)     /*E14874*/
               CPYF  FROMFILE(SLIMHJF) TOFILE(CPLIMD) MBROPT(*REPLACE) +
FMTOPT(*MAP *DROP) INCCHAR(CLLV 1 *EQ &PRM02) INCREL((*IF CLCM *GE X'40') +
(*AND CLBK *EQ '  '))                                                /* E14874*/
/*                   INCREL((*IF CLCM *GE X'40') (*AND CLBK *EQ '  ')))*E14874*/
               MONMSG CPF2817                                         /*E14874*/
               ENDDO                                                  /*E14874*/
 
             CHGVAR     VAR(&PRM05) VALUE(0)
 
/* CALL THE PROGRAM SE1000                        */
 
             CALL       PGM(SE1000) PARM(&PRM01 &PRM02 &PRM03 +
                                         &PRM05)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA      */
 
 ERROR1:     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0705 - Job Terminated, +
                          Database in error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE IMBALANCE ERROR */
 
 
/*           IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)           */
/*          CHGVAR     VAR(&MEM) VALUE('SEC0705 - File Controls out +
                          of balance')                              */
/*           SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ) */
/*           ENDDO                                                  */
 
/*  CHANGE DATE PARM TO CHARACTER */
 
             CHGVAR &PRM05A VALUE(&PRM05)
 
/*  OVERIDE DATABASE FILE                      */
 
/************OVRDBF     FILE(CPLEXQF) TOFILE(CPLEX) SHARE(*YES)   */  /*E13776*/
             OVRDBF     FILE(CPLEXQF) TOFILE(CPLEX2) SHARE(*YES)      /*E13776*/
 
/*  OPEN QUERY FILE CPLEXQF */
 
/*    OPNQRYF FILE((CPLEX)) FORMAT(CPLEXQF) +                     */  /*E13776*/
      OPNQRYF FILE((CPLEX2)) FORMAT(CPLEXQF) +
           KEYFLD((CLEN) (CLBK) (CLAS) (CLCU)) +
           GRPFLD(CLEN CLBK CLAS CLCU) +
           GRPSLT('(' *cat &prm05a *cat ' *gt %min(clle) +
           *and (%sum(slexp) *gt 0 +
            *or %sum(puexp) *gt 0)) *or %sum(slexp) *gt %min(clsl) * +
            1000 *or %sum(puexp) *gt %min(clpl) * 1000') +
           MAPFLD((SLEXP 'cecv * cese') (PUEXP 'cecv * cepe'))
 
/*  CALL THE PROGRAM SE1005  */
 
/************CALL       PGM(SE1005) PARM(&PRM01 &PRM02 &PRM03 +      * *S01117*/
/************                            &PRM04)                     * *S01117*/
             CALL       PGM(SE1005) PARM(&PRM01 &PRM02 &PRM03 &PRM04 +
                          &RSEQ &RENT)                                /*S01117*/
 
/*  DELETE OVERIDE */
 
             DLTOVR     *ALL
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA      */
 
 ERROR2:     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0705 - Job Terminated, +
                          Database in error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  CLOSE FILE */
 
/*           CLOF       CPLEX                                */       /*E13776*/
             CLOF       CPLEX2                                        /*E13776*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
