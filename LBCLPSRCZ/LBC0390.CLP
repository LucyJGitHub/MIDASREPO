/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Borrowing Power Weightings Review Report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0390 - Borrowing Power Weightings Review Report          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 05May95              */
/*                      S01498             DATE 11AUG94              */
/*                      35723              DATE 11FEB92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       S01408 - Addition of core hook LBC0390MPS                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
/*********** PGM                                                   */ /*S01498*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)           /*S01498*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01498*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01498*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*S01498*/
             DCL        VAR(&SAVLIB) TYPE(*CHAR) LEN(7)               /*S01498*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*S01498 CCB020*/
             DCL        VAR(&CBFLG) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* Bypass COB Recovery if pgm is called from I/C menu                 /*S01498*/
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                      */ /*S01498 CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT Phase Check  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&CBFLG)                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*S01498 CCB020*/
             IF         COND(&CBFLG *EQ '*YES') THEN(DO)                                  /*CCB020*/
               CHGVAR     VAR(&BUSY) VALUE(' ')                       /*S01498*/
               CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)         /*S01498*/
/*                                                                    /*S01498*/
/* Retrieve the System prefix to get the save library 'xxDPLIB'       /*S01498*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)        /*S01498*/
               CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')    /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0390MPS                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01498*/
               IF        COND(&BUSY *EQ 'N') THEN(DO)                 /*S01498*/
/**/                                                                  /*S01498*/
/**  This is not a restart - copy master to back up file */           /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(LBBPWRPD) TOFILE(&SAVLIB/XLBBPWRPD) +
                          CRTFILE(*YES)                               /*S01498*/
                 CHGVAR     VAR(&BUSY) VALUE('Y')                     /*S01498*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)       /*S01498*/
               ENDDO                                                  /*S01498*/
               ELSE CMD(DO)                                           /*S01498*/
/**/                                                                  /*S01498*/
/**  This is a restart - copy back up file to master file */          /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(&SAVLIB/XLBBPWRPD) TOFILE(LBBPWRPD) +
                          MBROPT(*REPLACE)                            /*S01498*/
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM FILE(SDLBCSPD))             /*S01498*/
               ENDDO                                                  /*S01498*/
             ENDDO                                                    /*S01498*/
/* EXECUTE PROGRAM                                                   */
/*********** CALL       PGM(*LIBL/LB0390)                          */ /*S01498*/
             CALL       PGM(LB0390) PARM(&RSEQ)                       /*S01498*/
 
/* ERROR DURING PROCESSING                                           */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             CHGJOB     SWS(XXXXXX11)                                 /*35723*/
             SNDPGMMSG  MSG('LBC0390 - Ended abnormally') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0390 - Ended abnormally') +
                          TOMSGQ(MOPERQ)
                   GOTO    CMDLBL(END)                                /*35723*/
             ENDDO
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             SNDPGMMSG  MSG('LBC0390 - Database error') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0390 - Database error') TOMSGQ(MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('LBC0390 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('LBC0390 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)
             ENDDO
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*S01498 CCB020*/
             IF         COND(&CBFLG *EQ '*YES') THEN(DO)                                  /*CCB020*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01498*/
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)         /*S01498*/
/**/                                                                  /*S01498*/
/**  Delete dummy files */                                            /*S01498*/
/**/                                                                  /*S01498*/
               DLTF       FILE(&SAVLIB/XLBBPWRPD)                     /*S01498*/
               MONMSG     MSGID(CPF0000 MCH0000)                      /*S01498*/
             ENDDO                                                    /*S01498*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
