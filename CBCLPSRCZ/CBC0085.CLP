/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Reset dataqueues after COB halt')            */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0085  RESET DATA QUEUES AFTER COB HALT                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 07Nov11              */
/*                      196122             Date 10Aug01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      S01408             Date 18Apr95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CPK014 - Release 4 packaging.  Data queues moved from XLIB  */
/*                to DPLIB.                                          */
/*       196122 - change aut of cbdtaq/b/c/d to *LIBCRTAUT           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01408  -  Core hook added CBC0085MP1                       */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&FROM &DOLDST &ERR)
/**/
             DCL        VAR(&FROM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DOLDST)  TYPE(*DEC) LEN(2)
             DCL        VAR(&ERR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(2)
             DCL        VAR(&DTQALEN)  TYPE(*DEC) LEN(5) VALUE(16)
             DCL        VAR(&DTQBLEN)  TYPE(*DEC) LEN(5) VALUE(8)
             DCL        VAR(&DTQCLEN)  TYPE(*DEC) LEN(5) VALUE(1)
/************DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                                  /*CPK014*/
/************DCL        VAR(&DTAQLIB)  TYPE(*CHAR) LEN(10) +                              /*CPK014*/
/************           VALUE('  XLIB    ')                                               /*CPK014*/
             DCL        VAR(&MSGA) TYPE(*CHAR) LEN(16) +
                          VALUE('DUMMY          H')
             DCL        VAR(&MSGB) TYPE(*CHAR) LEN(8) VALUE('STREAM  ')
             DCL        VAR(&MSGC) TYPE(*CHAR) LEN(1) VALUE('R')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* RESET SWITCHES U7 & U8 */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* BEGIN COMMITMENT CONTROL AND CALL PROGRAM */
/**/
/**********  STRCMTCTL  LCKLVL(*CHG) */                                        /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/**********  MONMSG     MSGID(CPF8351) */                                                 /*CPK016*/
/**/
             CALL       PGM(CB0085)
/**/
             ENDCMTCTL
             MONMSG     MSGID(CPF8356)
/**/
/** IF NO DATABASE ERRORS THEN DO */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/**DELETE*AND*RECREATE*DATA*QUEUES*A*&*C */                                               /*CPK014*/
/************                                                                             /*CPK014*/
/************   RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)                           /*CPK014*/
/************   CHGVAR     VAR(%SST(&DTAQLIB 1 2))  VALUE(&PRELIB)                        /*CPK014*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0085MP1                                          */
                                                                      /*S01408*/
/************                                                                             /*CPK014*/
/************   DLTDTAQ    DTAQ(&DTAQLIB/CBDTQA)                                          /*CPK014*/
/************   MONMSG     MSGID(CPF2105)                                                 /*CPK014*/
/************   DLTDTAQ    DTAQ(&DTAQLIB/CBDTQC)                                          /*CPK014*/
/************   MONMSG     MSGID(CPF2105)                                                 /*CPK014*/
/************                                                                             /*CPK014*/
/*******        CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +
/************             scheduler data queue') AUT(*USE)          */     /*196122*/
/*******        CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +
/************             restart data queue') AUT(*USE)            */     /*196122*/
/************   CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +                   /*CPK014*/
/************             scheduler data queue') AUT(*LIBCRTAUT)               /*196122*/ /*CPK014*/
/************   CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +                    /*CPK014*/
/************             restart data queue') AUT(*LIBCRTAUT)                 /*196122*/ /*CPK014*/
 
/* Clear data queues CBDTQA and CBDTQC. */                                                /*CPK014*/
                CALL       PGM(QCLRDTAQ) PARM('CBDTQA' '*LIBL ')                          /*CPK014*/
                CALL       PGM(QCLRDTAQ) PARM('CBDTQC' '*LIBL ')                          /*CPK014*/
/**/
/**IF*PARAMETER*=*'Y'*THEN*DELETE,*RECREATE*AND*RESET*DTAQ/CBDTQB */                      /*CPK014*/
/* If PARAMETER = 'Y' then clear data queue CBDTQB. */                                    /*CPK014*/
/**/
                IF COND(&FROM *EQ 'Y') THEN(DO)
/************      DLTDTAQ    DTAQ(&DTAQLIB/CBDTQB)                                       /*CPK014*/
/************      MONMSG     MSGID(CPF2105)                                              /*CPK014*/
/**********        CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) +
/************              AUT(*USE) TEXT('COB free streams data +
/************              queue')                              */         /*196122*/
/************      CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) +                           /*CPK014*/
/************              AUT(*LIBCRTAUT) TEXT('COB free streams data +                  /*CPK014*/
/************              queue')                                             /*196122*/ /*CPK014*/
 
                   CALL       PGM(QCLRDTAQ) PARM('CBDTQB' '*LIBL ')                       /*CPK014*/
/**/
                   CHGVAR     VAR(&CNT) VALUE(0)
LOOP:              CHGVAR     VAR(%SST(&MSGB 7 2)) VALUE(&CNT)
/************      CALL QSNDDTAQ PARM('CBDTQB    ' &DTAQLIB &DTQBLEN +                    /*CPK014*/
/************                    &MSGB)                                                   /*CPK014*/
                   CALL       PGM(QSNDDTAQ) PARM('CBDTQB    ' '*LIBL     ' +
                                &DTQBLEN &MSGB)                                           /*CPK014*/
                   CHGVAR     VAR(&CNT)    VALUE(&CNT + 1)
                   IF         COND(&CNT *LT &DOLDST) THEN(GOTO LOOP)
                ENDDO
/************   CALL QSNDDTAQ PARM('CBDTQA    ' &DTAQLIB &DTQALEN +                       /*CPK014*/
/************              &MSGA)                                                         /*CPK014*/
/************   CALL QSNDDTAQ PARM('CBDTQC    ' &DTAQLIB &DTQCLEN +                       /*CPK014*/
/************              &MSGC)                                                         /*CPK014*/
                CALL       PGM(QSNDDTAQ) PARM('CBDTQA    ' '*LIBL     ' +
                             &DTQALEN &MSGA)                                              /*CPK014*/
                CALL       PGM(QSNDDTAQ) PARM('CBDTQC    ' '*LIBL     ' +
                             &DTQCLEN &MSGC)                                              /*CPK014*/
             ENDDO
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
/**/
ABNOR:                  SNDPGMMSG  MSG('CBC0085 - RESET OF DATA +
                        QUEUES TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        CHGJOB SWS(XXXXXX11)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        CHGVAR VAR(&ERR) VALUE('Y')
                        MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
             ENDPGM
