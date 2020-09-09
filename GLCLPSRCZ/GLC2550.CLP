/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account postings drop')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC2550 - Account postings archive to historic posting file */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. EML102B            Date 03Sep20              */
/*       Prev Amend No. EML102             Date 28Nov19              */
/*                      MD046248           Date 27Oct17              */
/*                      MD021155           Date 09Jul13              */
/*                      CGL127AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRE008             Date 04Apr02              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      185705             DATE 19Dec00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/*                      170465             Date 29Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CEU013             DATE 09APR98              */
/*                      107793             Date 22JAN97              */
/*                      S01408             Date 29AUG96              */
/*                      057596 *REWRITE    Date 29AUG96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       EML102B - Changes required due to TS processing             */
/*                 (EML102 changes not required in CLP)              */
/*                 Amendment of core hook GLC2550INT                 */
/*                 Amendment of core hook GLC2550MPS                 */
/*                 Amendment of core hook GLC2550002                 */
/*       EML102 - Upgrade of UNL007 to FB2.1 SP23                    */
/*                UNL007 - Extended Narratives                       */
/*                   Use /COPY GLC2550INT, GLC2550MPS, GLC2550002)   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Not all redundant processing removed             */
/*       CGL127AC - COB Restructure - GL COB Optimisation Phase 1    */
/*       CRE008 - Cash Management                                    */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       185705 - Addition to 170465                                */
/*       CCB009 - Journal files throughout close of business         */
/*       170465 - GLC2550 stopped with message wait status due to    */
/*                journal receiver reached the maximum size and did  */
/*                not create a new receiver automatically.           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU013 - EMU Account Postings Narrative                     */
/*       107793 - Create LDA if not already there.                   */
/*              - If run in I/C, need to journal GLACPHPD            */
/*       S01408 - Core hook GLC2550INT added.                        */
/*                Core hook GLC2550MPS added.                        */
/*                Core hook GLC2550MPE added.                        */
/*                Core hook GLC2550ERR added.                        */
/*                Core hook GLC2550END added.                        */
/*                Core hook GLC2550001 added.                        */
/*                Core hook GLC2550MP5 added.                        */
/*         Note - these hooks have been re-instated is the same      */
/*                functional position as before but, due to the      */
/*                program rewrite, the code within these hooks may   */
/*                need to be amneded for some clients.               */
/*                Hooks GLC2550MP1-4 and GLC2250002-3 were not       */
/*                reinstated because there was no equivalent         */
/*                position in the rewritten version of the pgm.      */
/*       057596 - GLC2550 rewritten to speed up account posting      */
/*                archive process.  The main changes is to use       */
/*                commitment control on updates, which means that    */
/*                no security copies or recovery processing is       */
/*                needed.                                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
/*/COPY WNCPYSRC,GLC2550INT                                          */
/**/
/* Declare variables */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)              */                   /*CGL127AC*/
/**********  DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                               */ /*MD021155*/
/**********  DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) VALUE('  +                   */ /*MD021155*/
/**********               DMLIB   ')                                                 */ /*MD021155*/
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10) VALUE('  +                    */ /*MD021155*/
/**********               JLIB    ')                                                 */ /*MD021155*/
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR)  LEN(1)                      */ /*107793 CGL127AC*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/            /*CCB009 CGL127AC*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */            /*CCB009 CGL127AC*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)           */            /*CCB009 CGL127AC*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC2550001                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.****************************/            /*CCB009 CGL127AC*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                         */            /*CCB009 CGL127AC*/

             CHGJOB     SWS(XXXXXX00)

/*/COPY WNCPYSRC,GLC2550MPS                                          */
/**/
/* Send Message to MRUNQ */
/**/
             SNDPGMMSG  MSG('GLC2550 - Archive postings to historic +
                          postings file') TOMSGQ(MRUNQ)
/**/
/* Determine phase of system */                                       /*107793*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */            /*107793 CGL127AC*/
                                                                      /*107793*/
/* Format library Names */
/**/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                          */ /*MD021155*/
/**********  CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&SYSID)                          */ /*MD021155*/
/**********  CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&SYSID)                           */ /*MD021155*/
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')                                  /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC2550MP5                                     */    /*S01408*/
/**/                                                                  /*S01408*/
/*  CREATE JRNRCV WITH AUTHORITY *PUBLIC *ALL IN CASE COMP'T ENDS  */
/*  AND IS RESTARTED BY A DIFFERENT USER WHO MAY REQUIRE AUTHORITY */
/*  TO DELETE THIS JOURNAL RECEIVER                                */
LOOP1:
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CGL127AC*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CGL127AC*/
                                                                      /*107793*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)              */            /*107793 CGL127AC*/
/*/COPY WNCPYSRC,GLC2550006                                          */
                                                                      /*107793*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRGLC2550) TEXT('Temporary +  */ /*170465*/
/**********               journal for component GLC2550')          */ /*170465*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRGLC2550) THRESHOLD(1919999) +
                          TEXT('Temporary journal for component +
                          GLC2550')                                */            /*170465 CGL127AC*/
/**********  MONMSG     MSGID(CPF7010) EXEC(DO)                    */                   /*CGL127AC*/
/**/
/**********  DLTJRN     JRN(&JLIB/JGLC2550)                        */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF2105)                             */                   /*CGL127AC*/
/**/
/**CANNOT*MONITOR*FOR*CPA*MSGS.*BUT*MUST*ENSURE*JOB*TAKES*DEFAULT****/                  /*CGL127AC*/
/**REPLY*FOR*MESSAGE*CPA7025,*(DELETE*ISSUED*WITHOUT*FULL*SAVE.)*****/                  /*CGL127AC*/
/**********  CHGJOB     INQMSGRPY(*DFT)                            */                   /*CGL127AC*/
/************DLTJRNRCV  JRNRCV(&JLIB/JRGLC2550)******/                /*185705*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC255*)                    */            /*185705 CGL127AC*/
/**********  CHGJOB     INQMSGRPY(*RQD)                            */                   /*CGL127AC*/
/**/
/**********  GOTO       CMDLBL(LOOP1)                              */                   /*CGL127AC*/
/**/
/**********  ENDDO                                                 */                   /*CGL127AC*/
/*/COPY WNCPYSRC,GLC2550007                                          */

/***CREATE*JOURNAL*WITH*AUTHORITY**PUBLIC**ALL*IN*CASE*COB*ENDS*****/                   /*CGL127AC*/
/***AND*IS*RESTARTED*BY*A*DIFFERENT*USER*WHO*MAY*REQUIRE*AUTHORITY**/                   /*CGL127AC*/
/***TO*DELETE*THIS*JOURNAL******************************************/                   /*CGL127AC*/
 LOOP2:
/*/COPY WNCPYSRC,GLC2550008                                          */
/**********  CRTJRN     JRN(&JLIB/JGLC2550) JRNRCV(&JLIB/JRGLC2550)*/ /*170465*/
/**********               TEXT('FF C.O.B. Journal') AUT(*ALL)      */ /*170465*/
/**********  CRTJRN     JRN(&JLIB/JGLC2550) JRNRCV(&JLIB/JRGLC2550) +
                          MNGRCV(*SYSTEM) TEXT('Post Drop Journal') +
                          AUT(*ALL)                                */            /*170465 CGL127AC*/
/**********  MONMSG     MSGID(CPF7010 CPF7015) EXEC(DO)            */                   /*CGL127AC*/
/**********  DLTJRN     JRN(&JLIB/JGLC2550)                        */                   /*CGL127AC*/
/**********  GOTO       CMDLBL(LOOP2)                              */                   /*CGL127AC*/
/**********  ENDDO                                                 */                   /*CGL127AC*/
/*/COPY WNCPYSRC,GLC2550009                                          */
                                                                      /*107793*/
/**********  ENDDO                                                 */            /*107793 CGL127AC*/
/**/
RETRY:
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)              */            /*107793 CGL127AC*/
/*/COPY WNCPYSRC,GLC2550010                                          */
/**********  STRJRNPF   FILE(APOSTPD) JRN(JGLC2550) IMAGES(*BOTH)  */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */                   /*CGL127AC*/
/**********  STRJRNPF   FILE(GLAPSTPD) JRN(JGLC2550) IMAGES(*BOTH) */            /*CEU013 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CEU013 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CEU013 CGL127AC*/
/**********  STRJRNPF   FILE(APOSTRA) JRN(JGLC2550) IMAGES(*BOTH)  */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */                   /*CGL127AC*/
/**********  STRJRNPF   FILE(GLACPHPD) JRN(JGLC2550) IMAGES(*BOTH) */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */                   /*CGL127AC*/
/**********  STRJRNPF   FILE(GLAPSTGA) JRN(JGLC2550) IMAGES(*BOTH) */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CRE008 CGL127AC*/
/**********  STRJRNPF   FILE(GLAPSTZS) JRN(JGLC2550) IMAGES(*BOTH) */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CRE008 CGL127AC*/
/*/COPY WNCPYSRC,GLC2550002                                          */
/**********  ENDDO                                                 */            /*107793 CGL127AC*/
/**********  ELSE       CMD(DO)                                    */            /*107793 CGL127AC*/
/**********  STRJRNPF   FILE(APOSTPD) JRN(ICJRN) IMAGES(*BOTH)     */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*107793 CGL127AC*/
/**********  STRJRNPF   FILE(APOSTRA) JRN(ICJRN) IMAGES(*BOTH)     */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*107793 CGL127AC*/
/**********  STRJRNPF   FILE(GLACPHPD) JRN(ICJRN) IMAGES(*BOTH)    */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*107793 CGL127AC*/
/**********  STRJRNPF   FILE(GLAPSTGA) JRN(ICJRN) IMAGES(*BOTH)    */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CRE008 CGL127AC*/
/**********  STRJRNPF   FILE(GLAPSTZS) JRN(ICJRN) IMAGES(*BOTH)    */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CRE008 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CRE008 CGL127AC*/
/*/COPY WNCPYSRC,GLC2550004                                          */
/**********  ENDDO                                                 */            /*107793 CGL127AC*/

/**********  GOTO       CMDLBL(BYPASS)                             */                   /*CGL127AC*/

JRNFAIL:
/**********  CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)              */                   /*CGL127AC*/
/**********  IF         COND(&COUNT *LE 3) THEN(DO)                */                   /*CGL127AC*/
/**********  DLYJOB     DLY(60)                                    */                   /*CGL127AC*/
/**********  GOTO       CMDLBL(RETRY)                              */                   /*CGL127AC*/
/**********  ENDDO                                                 */                   /*CGL127AC*/
/**********  ELSE       CMD(DO)                                    */                   /*CGL127AC*/
/**********  GOTO       CMDLBL(ABNOR)                              */                   /*CGL127AC*/
/**********  ENDDO                                                 */                   /*CGL127AC*/
/**********  ENDDO                                                 */            /*CCB009 CGL127AC*/
BYPASS:
/**/
/*/COPY WNCPYSRC,GLC2550003                                          */
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG)                                    CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
/**********  MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +                         /*CPK016*/
/**********               VALUE('Y'))                                                     /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
             IF         COND(&CMTRTN *EQ '*ACTIVE   ') THEN(CHGVAR +
                          VAR(&CMTCTL) VALUE('Y'))
/*/COPY WNCPYSRC,GLC2550014                                          */
             OVRDBF     FILE(GLAPSGL0) TOFILE(GLAPSGAL0)              /*CRE008*/
             OVRDBF     FILE(GLAPSZL0) TOFILE(GLAPSZSL0)              /*CRE008*/
             CALL       PGM(GL2550)
/**/
/* Reset restart flag and clear SAVF if run succesful */
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
/* Database Error has occurred */
/**/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/*/COPY WNCPYSRC,GLC2550MPE                                          */

             GOTO       CMDLBL(END)
/*/COPY WNCPYSRC,GLC2550015                                          */
/**/
/* Abnormal termination processing                       */
/**/
 ABNOR:
/*/COPY WNCPYSRC,GLC2550ERR                                          */
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program GLC2550 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 END:
/*/COPY WNCPYSRC,GLC2550END                                          */
                                                                      /*107793*/
/**********  ROLLBACK                                              */            /*107793 CGL127AC*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
                                                                      /*107793*/
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO

/*/COPY WNCPYSRC,GLC2550011                                          */
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CGL127AC*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CGL127AC*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JGLC2550)                   */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CGL127AC*/
/**********  ENDJRNPF   FILE(GLACPHPD) JRN(ICJRN)                  */            /*107793 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*107793 CGL127AC*/

/**********  DLTJRN     JRN(&JLIB/JGLC2550)                        */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CGL127AC*/
/*/COPY WNCPYSRC,GLC2550012                                          */

/**********  CHGJOB     INQMSGRPY(*DFT)                            */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CGL127AC*/
/*/COPY WNCPYSRC,GLC2550013                                          */
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC2550)                    */ /*170465*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC255*)                    */            /*170465 CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CGL127AC*/
/*/COPY WNCPYSRC,GLC2550005                                          */
/**********  CHGJOB     INQMSGRPY(*RQD)                            */                   /*CGL127AC*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CGL127AC*/
/**********  ENDDO                                                 */            /*CCB009 CGL127AC*/

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
