/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail maintenance pre-processing')          */
/********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC2073 - PRE-PROCESSING FOR RETAIL II MAINTENANCE          */
/*                (FOR SECURITY PROFILE FACILITY)                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 211225             Date 09Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB002             Date 30Aug96              */
/*                      S01413             Date 13Apr93              */
/*                      E22479                  18JUN90              */
/*                      S01194                  26MAR90              */
/*                      S01146                  18NOV87              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       211225  -  Remove running of batch job REC5310. Update of   */
/*                  PF/RESTCHPD is now processed in pgm RE0240WC.    */
/*                  Apply fix 183776.                                */
/*       CCB002  -  COB Performance Enhancements                     */
/*                  Access now via access object                     */
/*                  Override removed                                 */
/*       S01413  -  Retail 3 Incorporation.                          */
/*       E22479  -  Microfiche Enhancements changed the Dataarea     */
/*                  SUNDTA to be length 112.                         */
/*       S01194  -  New Standing Data                                */
/*                                                                   */
/*********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &PGNM &MODE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PGNM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(2)
/************DCL********&SUNDTA*******TYPE(*CHAR)**LEN(111)*** *E22479/*S01146*/
             DCL        &SUNDTA       TYPE(*CHAR)  LEN(112)           /*E22479*/
/*/COPY WNCPYSRC,REC2073002                                          */
/* */                                                                 /*S01413*/
/* Data Area WTRAN */                                                 /*S01413*/
/* */                                                                 /*S01413*/
             CHKOBJ     OBJ(WTRAN) OBJTYPE(*DTAARA)                   /*S01413*/
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SUITE))       /*S01413*/
             DLTDTAARA  DTAARA(WTRAN)                                 /*S01413*/
 SUITE:                                                               /*S01413*/
 
/************OVRDBF     FILE(TABLE) TOFILE(TABRE2)                   * *S01194*/
/************OVRDBF     FILE(MEMO) TOFILE(MEMOS)                       *CCB002*/
             CHGJOB     SWS(00000000)
 
             CALL       PGM(REOPEN) PARM(&PGNM)
 
             CHGDTAARA  DTAARA(LDA (1 8)) VALUE(&PGM)
             CHGDTAARA  DTAARA(LDA (132 2)) VALUE(&MODE)
/* MICROFICHE PROCESSING - REQUIRED IF SUNDTA PRESENT & NON-BLANK */  /*S01146*/
                RTVDTAARA  DTAARA(SUNDTA *ALL) RTNVAR(&SUNDTA)        /*S01146*/
                MONMSG     MSGID(CPF1015)                             /*S01146*/
                IF         COND(&SUNDTA *NE ' ') THEN(DO)             /*S01146*/
                   CHGJOB     SWS(XXXX1XXX)                           /*S01146*/
                ENDDO                                                 /*S01146*/
 
             CALL       PGM(MDSINPUT)
             RCLRSC
 
/*/COPY WNCPYSRC,REC2073001                                          */
/************DLTOVR     FILE(TABLE MEMO)                             * *S01194*/
/************DLTOVR     FILE(MEMO)                               *S01194CCB002*/
 
/**********  SBMJOB     JOB(REC5310) JOBD(MBATCH) USER(*JOBD) +                           /*211225*/
/**********               RTGDTA(*JOBD) RQSDTA('CALL   REC5310') +                        /*211225*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*S01413*/ /*211225*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
