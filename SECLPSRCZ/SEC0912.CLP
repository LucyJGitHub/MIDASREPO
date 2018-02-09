/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Unrealized Profit & Loss Using N-T-P Anal')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC0912 - Unrealised Profit and Loss Analysis Using N-T-P   */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 229177             Date 02Sep04              */
/*                      CAS008             Date 11May04              */
/*                      224132             Date  22Dec03             */
/*                      CAS006  *CREATE    Date  21Jan03             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       229177 - ZSFILE failed due to SE0917 and SE0919 shared      */
/*                the same sequence no. However, assigned sequence   */
/*                no. should be unique. Amend program to rename and  */
/*                and initialise sequence no. for SE0919.            */
/*       CAS008 - Delayed Hedge Assessment                           */
/*       224132 - Run Rprts with Price Format for Yield Based        */
/*                Securities First                                   */
/*       CAS006 - Hedge Accounting Phase B                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DTBS) TYPE(*CHAR) LEN(1)
 
/* Entry Parameters */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RSEQ1) TYPE(*CHAR) LEN(5)  +
                          VALUE('     ')                                                  /*229177*/
 
/* Declare the variables to check the enhancements file */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CAS006')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD1) TYPE(*CHAR) LEN(7)                                    /*CAS008*/
             DCL        VAR(&SARD1) TYPE(*CHAR) LEN(6)                                    /*CAS008*/
             DCL        VAR(&CAS008) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS008*/
                                                                                          /*224132*/
             CHGVAR     VAR(&PRTYPE) VALUE('P')                                           /*224132*/
                                                                                          /*224132*/
             CLRPFM     FILE(SEMKVDPD)                                                    /*CAS008*/
REPEAT:                                                                                   /*224132*/
 
             CLRPFM     FILE(SEMKVLPD)
 
/* Check if enhancement CAS006 in installed */
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ENDPGM))
                                                                                          /*CAS008*/
             CHGVAR     VAR(&SARD1) VALUE('CAS008')                                       /*CAS008*/
             CHGVAR     VAR(&RTCD1) VALUE('       ')                                      /*CAS008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD1 &OPTN &SARD1 &FMT)                      /*CAS008*/
             IF         COND(&RTCD1 *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS008) VALUE('Y'))                                        /*CAS008*/
                                                                                          /*CAS008*/
             IF         COND(&CAS008 *EQ 'Y' *AND &PRTYPE *EQ 'P') +
                          THEN(DO)                                                        /*CAS008*/
             CPYF       FROMFILE(UPLHXD) TOFILE(QTEMP/XUPLHXD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CAS008*/
             MONMSG     MSGID(CPF2817)                                                    /*CAS008*/
             ENDDO                                                                        /*CAS008*/
                                                                                          /*CAS008*/
 
/* Extract prompt parameters from RCF */
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))
/**********  CHGVAR     VAR(&PRTYPE) VALUE(%SST(&RPARM 2 1)) */                           /*224132*/
 
/* If Date Basis is 'B'oth, generate report by Trade Date first */
             IF         COND(&OPTION *EQ 'B') THEN(CHGVAR VAR(&DTBS) +
                          VALUE('T'))
             ELSE       CMD(CHGVAR VAR(&DTBS) VALUE(&OPTION))
 
 
/* Send Program Message */
             CHGVAR     VAR(&MEM) VALUE('SEC0912 - Unrealised Profit +
                          & Loss Analysis Using Net Treasury Price')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
AGAIN:
 
/* Clear Switches */
             CHGJOB     SWS(00000000)
 
/* Clear Output Files */
             CLRPFM     FILE(UPLNXD)
 
/* Perform overrides depending on inout parameter */
             IF         COND(&DTBS *EQ 'T') THEN(OVRDBF FILE(BKPHJ3) +
                          TOFILE(BKPHJ3T))
             ELSE       CMD(OVRDBF FILE(BKPHJ3T) TOFILE(BKPHJ3V))
 
/* Call SE0916 (Ectract) */
                CALL       PGM(SE0916) PARM(&DTBS)
 
/* If no error, CALL SE0915 (Report) */
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Position file to the particular branch */
                   IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                              'ALL')) THEN(DO)
                      OVRDBF     FILE(UPLNX) POSITION(*KEY 1 UPLNXDF &RENT)
                      OPNDBF     FILE(UPLNX) OPTION(*ALL)
                      MONMSG     MSGID(CPF0000) EXEC(DO)
                         DLTOVR     FILE(UPLNX)
                   ENDDO
 
                   CLOF       OPNID(UPLNX)
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
                CALL       PGM(SE0917) PARM(&DTBS &PRTYPE &RSEQ &RENT)
                                                                                          /*CAS008*/
             IF         COND(&CAS008 *EQ 'Y' *AND &PRTYPE *EQ 'P') +
                          THEN(DO)                                                        /*CAS008*/
                CALL       PGM(SE0919) PARM(&DTBS &PRTYPE &RSEQ1  &RENT)                  /*229177*/
/**********     CALL       PGM(SE0919) PARM(&DTBS &PRTYPE &RSEQ  &RENT) */     /*CAS008*/ /*229177*/
                                                                                          /*CAS008*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CAS008*/
             CPYF       FROMFILE(QTEMP/XUPLHXD) TOFILE(UPLHXD) +
                          MBROPT(*REPLACE)                                                /*CAS008*/
             MONMSG     MSGID(CPF2817)                                                    /*CAS008*/
             ENDDO                                                                        /*CAS008*/
             ENDDO                                                                        /*CAS008*/
                                                                                          /*CAS008*/
             ENDDO
 
/* For Database errors recover data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0912 - Job Terminated, +
                           Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* Normal completion - Clear output files */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CLRPFM     FILE(UPLNXD)
             ENDDO
 
/* Delete all file overrides */
 
             DLTOVR *ALL
 
/* If Date Basis is 'B'oth, generate 2nd part of report which is Value Date */
             IF         COND(&OPTION *EQ 'B' *AND &DTBS *EQ 'T') +
                          THEN(DO)
             CHGVAR     VAR(&DTBS) VALUE('V')
             GOTO       CMDLBL(AGAIN)
             ENDDO
                                                                                          /*224132*/
             IF         COND(&PRTYPE *EQ 'P') THEN(DO)                                    /*224132*/
             CHGVAR     VAR(&PRTYPE) VALUE('Y')                                           /*224132*/
             GOTO       CMDLBL(REPEAT)                                                    /*224132*/
             ENDDO                                                                        /*224132*/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             ENDPGM
