/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail enquiries pre-processing')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC2074 - PRE-PROCESSING FOR RETAIL II ENQUIRIES            */
/*                 (FOR SECURITY PROFILE FACILITY)                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. CCB002             DATE 13SEP96              */
/*                      S01413             DATE 13APR93              */
/*                      RT0021                  07MAY91              */
/*                      S01194                  26MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*        MD046248 - Finastra Rebranding                             */
/*        CCB002  -  COB Performance Enhancements                    */
/*                   Access now via access object                    */
/*                   Override removed                                */
/*        S01413  -  Retail 3 Incorporation                          */
/*        RT0021  -  Program L2UMOPN replaced by GLOPEN1             */
/*        S01194  -  New Standing Data                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
 
/************OVRDBF     FILE(TABLE) TOFILE(TABRE2)                   * *S01194*/
             OVRDBF     FILE(RENUM)  TOFILE(ACNUM)                    /*S01413*/
             MONMSG CPF0000                                           /*S01413*/
 
/************IF         COND(&OPT *EQ '0') THEN(CALL PGM(REC0360)) */ /*S01413*/
             IF         COND(&OPT *EQ '0') THEN(CALL PGM(REC360))     /*S01413*/
             ELSE       CMD(DO)
/***************OVRDBF     FILE(MEMO) TOFILE(MEMOS)                   *CCB002*/
                CHGJOB     SWS(10000000)
 
/***************CALL       PGM(REOPEN) PARM('L2UMOPN') ***/          /*RT0021*/
                CALL       PGM(REOPEN) PARM('GLOPEN1')               /*RT0021*/
 
                CHGDTAARA  DTAARA(LDA (1 8)) VALUE('RE0270  ')
                CHGDTAARA  DTAARA(LDA (132 1)) VALUE(&OPT)
 
                CALL       PGM(MDSINPUT)
                RCLRSC
 
/***************DLTOVR     FILE(MEMO)                                 *CCB002*/
             ENDDO
 
/************DLTOVR     FILE(TABLE)                                  * *S01194*/
             DLTOVR     FILE(RENUM)                                   /*S01413*/
             DLTDTAARA WTRAN                                          /*S01413*/
             MONMSG CPF0000                                           /*S01413*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
