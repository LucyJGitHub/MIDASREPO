/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Reorganise DEALSD* file members')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - DEALING MODULE                                      */
/*                                                                   */
/*       DLC0609 - REORGANISE DEALS FILE MEMBERS                     */
/*                                                                   */
/*       Function:  This program calculates the number of deleted    */
/*                  records on the deals files as a % of the total   */
/*                  number of live and deleted records; if it is     */
/*                  more than 10%, the file is reorganised.          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR830247           Date 15Nov12              */
/*                      AR829000           Date 15Nov12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/*                      CPK019             Date 28Jun04              */
/*                      CLE025             Date 20Oct03              */
/*                      CDL018             Date 03Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 09May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      197643             Date 25May01              */
/*                      CIR003             Date 13Sep00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      126469  *CREATE    Date 14Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR830247 - CADLFAPP not reorganized                         */
/*                  (Child: AR830248)                                */
/*       AR829000 - Several Physical Files are not reogranized       */
/*                  (Child: AR829001)                                */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK019 - Wrong monitor message.                             */
/*       CLE025 - Credit Lines                                       */
/*       CDL018 - Multiple Settlement Accounts on Loans/Deposit      */
/*       CPK015 - Monitor the RGZPFM to allow for an empty file.     */
/*       197643 - Move the second set of file processing to another  */
/*                program as this CL cannot process the same file    */
/*                twice.                                             */
/*       CIR003 - Principal Exchange on Cross-Ccy IRS.               */
/*       126469 - New program created to reorganise the deals files. */
/*                This program replaces DLC0606BR1 and DLC0606BR2.   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CIR003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CIR003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CIR003*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CIR003*/
             DCL        VAR(&CIR003) TYPE(*CHAR) LEN(1)                                   /*CIR003*/
             DCL        VAR(&CDL018) TYPE(*CHAR) LEN(1)                                   /*CDL018*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1)                                   /*CLE025*/
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&MBRCHK) TYPE(*CHAR) LEN(10)                                  /*228542*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(QAFDMBRL)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR003*/
             CHGVAR     VAR(&SARD) VALUE('CIR003')                                        /*CIR003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CIR003*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR003) VALUE('Y'))                                        /*CIR003*/
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL018*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL018) VALUE('Y'))                                        /*CDL018*/
                                                                                          /*CLE025*/
/** Check if enhancement CLE025 (Multi-Option Facilities) is on */                        /*CLE025*/
                                                                                          /*CLE025*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                                             /*CLE025*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE025*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CLE025*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE025) VALUE('Y'))                                        /*CLE025*/
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
                                                                                        /*AR830247*/
             CALL       PGM(SCC000060) PARM('CADLFAPP' '*FIRST')                        /*AR830247*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*AR830247*/
 
             IF         COND(&CDL018 *EQ 'Y') THEN(DO)                                    /*CDL018*/
/**********  RGZPFM     FILE(DLFSACPD)                                         /*CDL018*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995)                                      */ /*CDL018*/ /*CPK019*/
/**********  MONMSG     MSGID(CPF2981)                                         /*CPK019*/ /*228542*/
             CALL       PGM(SCC000060) PARM('DLFSACPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO                                                                        /*CDL018*/
 
             DSPFD      FILE(DEALSD*) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/RGZDEALS)
/*/COPY WNCPYSRC,DLC0609001                                          */
 
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/RGZDEALS)
 RCVF:
 
             RCVF
 
/* Monitor for EOF */
 
             MONMSG     MSGID(CPF0864) EXEC(DO)
/*********      IF         COND(&CIR003 *EQ 'Y') THEN(DO)                      /*CIR003*/ /*197643*/
/*********         DSPFD   FILE(DLGXSTPD) TYPE(*MBRLIST) +
/*********                 OUTPUT(*OUTFILE) OUTFILE(QTEMP/RGZDEALS)            /*CIR003*/ /*197643*/
/*********         OVRDBF  FILE(QAFDMBRL) TOFILE(QTEMP/RGZDEALS)               /*CIR003*/ /*197643*/
/*********         CHGVAR  VAR(&MLNDTR) VALUE(&MLNDTR *  9)                    /*CIR003*/ /*197643*/
/*********         RCVF                                                        /*CIR003*/ /*197643*/
/*********         IF      COND(&MLNDTR *GE &MLNRCD) +                         /*CIR003*/ /*197643*/
/*********                 THEN(RGZPFM  FILE(&MLFILE) MBR(&MLNAME))            /*CIR003*/ /*197643*/
/*********     ENDDO                                                           /*CIR003*/ /*197643*/
                CALL       PGM(DLC0610)                                                   /*197643*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(END))                                                 /*197643*/
                                                                                          /*CLE025*/
/**********     IF         COND(&CLE025 *EQ 'Y') THEN(DO) */                     /*CLE025 AR829000*/
                   CALL       PGM(DLC000611)                                              /*CLE025*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                                CMDLBL(ABNOR))                                            /*CLE025*/
/**********     ENDDO */                                                         /*CLE025 AR829000*/
 
               GOTO       CMDLBL(END)
             ENDDO
 
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&MBRCHK) VALUE(&MLNAME)                                       /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&MBRCHK &CHKPOSN 1))                        /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&MBRCHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/* Physical Files  */
             IF         COND(&MLFTYP *NE 'P')       +
                         THEN(GOTO RCVF)
 
/* Deleted records > 0 */
             IF         COND(&MLNDTR *EQ 0)       +
                         THEN(GOTO RCVF)
 
             IF         COND(&MLFILE *EQ 'DEALSDA'  +
                        *OR  &MLFILE *EQ 'DEALSDF') +
                         THEN(GOTO RCVF)
 
             CHGVAR     VAR(&MLNDTR) VALUE(&MLNDTR *  9)
 
/* Deleted records > 10% */
             IF         COND(&MLNDTR *GE &MLNRCD)   +
                         THEN(DO)
/**********  RGZPFM     FILE(&MLFILE) MBR(&MLNAME)                                        /*228542*/
/**********  MONMSG     MSGID(CPF2995)                                      */ /*CPK015*/ /*CPK019*/
/**********  MONMSG     MSGID(CPF2981)                                         /*CPK019*/ /*228542*/
             CALL       PGM(SCC000060) PARM(&MLFILE &MBRCHK)                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0609 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             ENDPGM
