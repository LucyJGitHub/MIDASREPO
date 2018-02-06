/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Restart/recovry after pgm fail(s)')          */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing              */
/*                                                                   */
/*       CBC0095  RESTART/RECOVERY AFTER PROGRAM FAILURE(S)          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 07Nov11              */
/*                      196122             Date 10Aug01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 13Apr95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging.  Data queues moved from XLIB  */
/*                to DPLIB.                                          */
/*       196122  -  Creation of CBDTQA/B/C/D use *LIBCRTAUT          */
/*       S01408  -  Core hook added CBC0095MP1                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DOLDST)
/**/
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(2)
             DCL        VAR(&DTQBLEN)  TYPE(*DEC) LEN(5) VALUE(8)
/************DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                                  /*CPK014*/
/************DCL        VAR(&DTAQLIB)  TYPE(*CHAR) LEN(10) +                              /*CPK014*/
/************           VALUE('  XLIB    ')                                               /*CPK014*/
             DCL        VAR(&MSGB) TYPE(*CHAR) LEN(8) VALUE('STREAM  ')
             DCL        VAR(&DOLDST) TYPE(*DEC) LEN(2)
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
/************                                                                             /*CPK014*/
/**DELETE*AND*RECREATE*DATA*QUEUES*A*B*&*C**/                                             /*CPK014*/
/************                                                                             /*CPK014*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)                              /*CPK014*/
/************CHGVAR     VAR(%SST(&DTAQLIB 1 2))  VALUE(&PRELIB)                           /*CPK014*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0095MP1                                          */
                                                                      /*S01408*/
/**/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQA)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQB)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQC)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************                                                                             /*CPK014*/
/********    CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +
/************             scheduler data queue') AUT(*USE)         */   /*196122*/
/********    CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) TEXT('COB +
/************             free streams data queue') AUT(*USE)      */   /*196122*/
/********    CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +
/************             restart data queue') AUT(*USE)           */   /*196122*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +                      /*CPK014*/
/************             scheduler data queue') AUT(*LIBCRTAUT)               /*196122*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) TEXT('COB +                       /*CPK014*/
/************             free streams data queue') AUT(*LIBCRTAUT)            /*196122*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +                       /*CPK014*/
/************             restart data queue') AUT(*LIBCRTAUT)                 /*196122*/ /*CPK014*/
 
/* Clear data queues CBDTQA, CBDTQB and CBDTQC. */                                        /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQA' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQB' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQC' '*LIBL ')                             /*CPK014*/
/**/
             CHGVAR     VAR(&CNT) VALUE(0)
LOOP:        CHGVAR     VAR(%SST(&MSGB 7 2)) VALUE(&CNT)
/************CALL QSNDDTAQ PARM('CBDTQB    ' &DTAQLIB &DTQBLEN +                          /*CPK014*/
/************              &MSGB)                                                         /*CPK014*/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQB    ' '*LIBL     ' +
                          &DTQBLEN &MSGB)                                                 /*CPK014*/
             CHGVAR     VAR(&CNT)    VALUE(&CNT + 1)
             IF         COND(&CNT *LT &DOLDST) THEN(GOTO LOOP)
/**/
             GOTO ENDPGM
/**/
ABNOR:                  SNDPGMMSG  MSG('CBC0095 - RESTART/RECOVERY +
                        AFTER PROGRAM FAILURE TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        CHGJOB SWS(XXXXXX11)
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
