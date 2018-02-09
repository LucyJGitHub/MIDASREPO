/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Template Standing Journals')                    */
/********************************************************************/
/*                                                                  */
/*      Midas - General Ledger Module                       */
/*                                                                  */
/*      GLC1430  - TEMPLATE STANDING JOURNALS                       */
/*                 MIDAS OVERIDE DATABASE FILE FOR GLJENHL0         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      186206             Date 26Oct00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 14Aug96             */
/*                      S01251             Date 03Feb90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       186206 - Journal Entry API fixes. Produce only one dump    */
/*                per JE batch. Generate JE Valid errors report.    */
/*                Prevent record locking error in JE database       */
/*                updater.                                          */
/*       S01408  -  Core Hook GLC1430001 Added                      */
/*               -  Core Hook GLC1430MPS Added                      */
/*       S01251 - SYNON FIELD/PROGRAM NAME CHANGES                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
                                                                                          /*CRE020*/
/*/COPY WNCPYSRC,GLC1430002                                          */
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)                          /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *EQ '       ') THEN(DO)                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&PRTCD *NE '*NRF   ' *AND +
                     &PRTCD *NE '       ') THEN(DO)                                       /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(END)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
/**********  OVRDBF     FILE(GLBRREL0) SHARE(*NO)                  */ /*S01251*/
             OVRDBF     FILE(GLJENHL0) SHARE(*NO)                     /*S01251*/
             OVRDBF     FILE(GLBTNOL0) SHARE(*NO)                     /*186206*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1430MPS                                   */      /*S01408*/
/**/                                                                  /*S01408*/
 
/**********  CALL       PGM(GLILDFR) PARM(' ')                     */ /*S01251*/
             CALL       PGM(GL0161D) PARM(' ')                        /*S01251*/
 
/**********  DLTOVR     FILE(GLBRREL0)                             */ /*S01251*/
             DLTOVR     FILE(GLJENHL0)                                /*S01251*/
             DLTOVR     FILE(GLBTNOL0)                                /*186206*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1430001                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''GL0101R'' ''GL''' *CAT ')')                               /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
END:                                                                                      /*CRE020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
