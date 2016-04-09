/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Customer details enquiry control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       SDC0011 - Midas     Client Details Enquiry Control          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 28MAY96              */
/*                      083833  *CREATE    Date 24FEB95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       S01408 - Core hook SDC0011002 added.                        */
/*                Core hook SDC0011001 added.                        */
/*       083833   Midas Leo Integration. Set up the overrides to     */
/*                the Leo files, and locate the access objects       */
/*                                                                   */
/*********************************************************************/
             PGM
 
/***COPY*SDCPYSRC,SDC0011INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0011INT                                          */                   /*CPK024*/
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Declare the variables to check the enhancements file */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01467')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01467) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*SDCPYSRC,SDC0011MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0011MPS                                          */                   /*CPK024*/
 
/* Access switchable features file to see if feature S01467     */
/* is installed  */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01467) VALUE('Y'))
 
/* If feature S01467 is installed, setup LEO Libraries  */
             IF         COND(&S01467 *EQ 'Y') THEN(DO)
                RTVDTAARA  DTAARA(LOPREF) RTNVAR(&DTAARA)
 
/* If either position is blank, this is an error */
                IF         COND((%SST(&DTAARA 1 1) *EQ ' ') *OR +
                             (%SST(&DTAARA 2 1) *EQ ' ')) THEN(DO)
                   CHGJOB     SWS(XXXXXXX1)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
                CHGVAR     VAR(&DMLIB) VALUE(&DTAARA *CAT 'DMLIB')
                CHGVAR     VAR(&LDLIB) VALUE(&DTAARA *CAT 'LDLIB')
                OVRDBF     FILE(TABLE2) TOFILE(&LDLIB/TABLE2)
                OVRDBF     FILE(CUSPRO) TOFILE(&DMLIB/CUSPRO)
                OVRDBF     FILE(CUSCOM) TOFILE(&DMLIB/CUSCOM)
                OVRDBF     FILE(CPACRN) TOFILE(&LDLIB/CPACRN)
                OVRDBF     FILE(TBBR) TOFILE(&DMLIB/TBBR)
                CHGDTAARA  DTAARA(*LDA (51 974)) VALUE(' ')
 
/* Retrieve Library for program CAOUCC   */
                CHGVAR     VAR(&PARM1) VALUE('CAOUCC')
                CHGVAR     VAR(&PARM2) VALUE(' ')
                CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
                CHGVAR     VAR(%SUBSTRING(*LDA 61 10)) VALUE(&PARM2)
 
/* Retrieve Library for program CAOUCU   */
                CHGVAR     VAR(&PARM1) VALUE('CAOUCU')
                CHGVAR     VAR(&PARM2) VALUE(' ')
                CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
                CHGVAR     VAR(%SUBSTRING(*LDA 71 10)) VALUE(&PARM2)
 
/* Retrieve Library for program CAOUCA   */
                CHGVAR     VAR(&PARM1) VALUE('CAOUCA')
                CHGVAR     VAR(&PARM2) VALUE(' ')
                CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
                CHGVAR     VAR(%SUBSTRING(*LDA 81 10)) VALUE(&PARM2)
 
/* Retrieve Library for program CAOUT2   */
                CHGVAR     VAR(&PARM1) VALUE('CAOUT2')
                CHGVAR     VAR(&PARM2) VALUE(' ')
                CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
                CHGVAR     VAR(%SUBSTRING(*LDA 91 10)) VALUE(&PARM2)
 
/* Retrieve Library for program CAOUBR   */
                CHGVAR     VAR(&PARM1) VALUE('CAOUBR')
                CHGVAR     VAR(&PARM2) VALUE(' ')
                CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
                CHGVAR     VAR(%SUBSTRING(*LDA 101 10)) VALUE(&PARM2)
             ENDDO
 
             OVRDBF     FILE(SDCMRKL0) SHARE(*NO)
 
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,SDC0011001                                          /*S01408*/
/*                                                                   /*S01408*/
             CALL       PGM(SD0010D) PARM(' ' 'E')
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,SDC0011002                                          /*S01408*/
/*                                                                   /*S01408*/
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/***COPY*SDCPYSRC,SDC0011MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0011MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*SDCPYSRC,SDC0011ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0011ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - interactive job */
             IF         COND(&JOBTYPE = '1') THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('The job has terminated +
                             abnormally - see job log')
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MEM)
                CALL       PGM(SCC0010) PARM('SDC0011' 'ENTER' ' ')
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/***COPY*SDCPYSRC,SDC0011END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC0011END                                          */                   /*CPK024*/
 
             DLTOVR     FILE(*ALL)
             CHGDTAARA  DTAARA(*LDA (51 60)) VALUE(' ')
 
             ENDPGM
