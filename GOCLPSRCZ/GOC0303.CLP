/*********************************************************************/
/*XBIA*  DSPOBJD OBJ(TRANSA) OBJTYPE(*FILE) DETAIL(*BASIC)           */
/*XBIA*  OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJD)                     */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Journal Receiver Chain Refresh')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0303 - Journal Receiver Chain Refresh                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9305            Date 21Jul06              */
/*                      BUG6098            Date 09May05              */
/*                      CSC020             Date 31Mar04              */
/*                      BUG2941            Date 01Jun04              */
/*                      BG1928             Date 15Apr04              */
/*                      CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       BUG9305 - The Run Time is shorter than the Compile Time     */
/*                 for the DSPOBJD file. (Recompile)                 */
/*       BUG6098- When unable to alocate file, end job after a       */
/*                short time.                                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       BUG2941 - Parameter mismatch problem.  Need to redeliver    */
/*                 BUG1928 (sources GOC0302 and GOC0303 only).       */
/*       BG1928 - Audit deliverable data missing                     */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
/*********** PGM ****************************************************/                    /*BG1928*/
             PGM        PARM(&UPDATL)                                                     /*BG1928*/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&UPDATL) TYPE(*CHAR) LEN(1)                                   /*BG1928*/
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&CDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&LENT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCLF       FILE(QTEMP/DSPOBJD)
 
/** GLOBAL MONITOR MESSAGE */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Get zone */
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
/* error */
/*********   IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* Display all journal receivers */
 
/*********   DSPOBJD    OBJ(*LIBL/ICRCV*) OBJTYPE(*JRNRCV) +
                          DETAIL(*BASIC) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/DSPOBJD) *******************************************CSC020*/
             DSPOBJD    OBJ(*LIBL/IR*) OBJTYPE(*JRNRCV) +
                          DETAIL(*BASIC) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/DSPOBJD)                                          /*CSC020*/
 
             OVRDBF     FILE(DSPOBJD) TOFILE(QTEMP/DSPOBJD) +
                          POSITION(*RRN 1)
 
 READ:       RCVF
/* EOF. Goto main processing section */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/**********  IF         COND(&ODJRNM *= 'ICJRN     ') THEN(GOTO +
                          CMDLBL(READ))                                              */ /*BUG18886*/
             IF         COND(&ODJRNM *NE 'ICJRN     ') THEN(GOTO +
                          CMDLBL(READ))                                                 /*BUG18886*/
 
             RTVJRNE    JRN(ICJRN) RCVRNG(&ODOBNM &ODOBNM) +
                          TOENT(*FIRST) RTNSEQNBR(&FENT)
             MONMSG     MSGID(CPF7053) EXEC(GOTO CMDLBL(READ))
 
             RTVJRNE    JRN(ICJRN) RCVRNG(&ODOBNM &ODOBNM) +
                          FROMENT(*LAST) TOENT(*LAST) RTNSEQNBR(&TENT)
 
/* Journal Chain Update */
 
             CHGVAR     VAR(&CDAT) VALUE(%SST(&ODCDAT 5 2) *CAT +
                          %SST(&ODCDAT 1 2) *CAT %SST(&ODCDAT 3 2))
             CHGVAR     VAR(&LENT) VALUE(&FENT)
             IF         COND(&UPDATL = 'Y') THEN(CHGVAR VAR(&LENT) +
                          VALUE(&TENT))                                                   /*BG1928*/
/* Check if file GPAUJCPD lock */                                                        /*BUG6098*/
             ALCOBJ     OBJ((GPAUJCPD *FILE *SHRUPD)) WAIT(60)                           /*BUG6098*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(FILELOCK))                       /*BUG6098*/
             CALL       PGM(GPAUJCUPD) PARM(&RTCD &ERMS &UPDATL +
                          &ZOZONE &ODOBNM &CDAT &FENT &TENT &LENT)                        /*BG1928*/
/*********** CALL       PGM(GPAUJCUPD) PARM(&RTCD &ERMS 'N' &ZOZONE + *****************/  /*BG1928*/
/***********              &ODOBNM &CDAT &FENT &TENT &LENT)            *****************/  /*BG1928*/
/* error */
             DLCOBJ     OBJ((GPAUJCPD *FILE *SHRUPD))                                    /*BUG6098*/
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* Next record */
             GOTO       CMDLBL(READ)
 
/* File Locked by other job */                                                           /*BUG6098*/
 FILELOCK:   SNDPGMMSG  MSG('FILE GPAUJCPD LOCKED BY OTHER JOB') +
                          TOMSGQ(MOPERQ)                                                 /*BUG6098*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6098*/
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM GOC0303 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
