/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Call MEC0845 via RCF')                          */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0845R - Outgoing message detail print - Call via RCF    */
/*                                                                  */
/*       Call FC0400X with parameters for ME0845                    */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD053953           Date 14Aug19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD053953 - TAIC021 - Message Manager Print Option          */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&TRN &BRANCH &MBIN &CFON)
 
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Parameters */
             DCL        VAR(&TRN) TYPE(*CHAR) LEN(16)   /* TRN       */
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3) /* BRANCH    */
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)   /* MULTI BR? */
             DCL        VAR(&CFON) TYPE(*CHAR) LEN(1)   /* CF MODULE */
 
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                   /*MD053953*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                  /*MD053953*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CFC003')                   /*MD053953*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                  /*MD053953*/
 
             CHGVAR     VAR(%SST(&RPARM 1 16)) VALUE(&TRN)
             CHGVAR     VAR(%SST(&RPARM 17 1)) VALUE(&CFON)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                      /*MD053953*/
                                                                                        /*MD053953*/
             IF         COND(&RTCD *EQ '*NRF') THEN(DO)                                 /*MD053953*/
             CALL       PGM(FC0040X) PARM(' ' 'ME0845' 'MEC0845' +
                          '10001' &RPARM &MBIN 'B' &BRANCH)
             ENDDO                                                                      /*MD053953*/
             ELSE      CMD(DO)                                                          /*MD053953*/
             CALL       PGM(FC0040X) PARM(' ' 'ME0845' 'MEC0845' +
                          '10001' &RPARM &MBIN 'S' &BRANCH)                             /*MD053953*/
             ENDDO                                                                      /*MD053953*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
