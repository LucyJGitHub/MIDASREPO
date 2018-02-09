/*********************************************************************/
/*OVR    OVRDBF FILE(CASHDTAQ) TOFILE(QADSPOBJ)                      */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI daily clearing of data queues')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4408 - CI Daily Deletion of CASH Transaction Data Queues */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 01Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163583             Date 05Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCI001             Date 10NOV98              */
/*                      122060 *CREATE     Date  5Aug97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       163583 - Insert MONMSG on RCBF for CASHDTAQ                 */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       122060 - Drafts Issuance.                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)          */     /*CCI001*/
/************DCL        VAR(&XLIB)  TYPE(*CHAR) LEN(10)                        /*CCI001*/ /*CPK015*/
             DCL        VAR(&PREF)  TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CNT)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CHR)   TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(CASHDTAQ)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/**Get*System*Prefix*and**oncat*to*PLIB******************************/ /*CCI001*/
/**/                                                                   /*CCI001*/
/**Get*System Prefix*and*concat*to*XLIB**/                                     /*CCI001*/ /*CPK015*/
/************                                                                             /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)                             */ /*CPK015*/
/*********** CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')  */      /*CCI001*/
/************CHGVAR     VAR(&XLIB) VALUE(&PREF *TCAT 'XLIB')                   /*CCI001*/ /*CPK015*/
 
 READ:
             RCVF       RCDFMT(QLIDOBJD)
/*********** MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))   */      /*163583*/
             MONMSG     MSGID(CPF0864 CPF4101) EXEC(GOTO +
                          CMDLBL(EOF))                                  /*163583*/
 
             CHGVAR     VAR(&CNT) VALUE(1)
             CHGVAR     VAR(&ERROR) VALUE('0')
             CHGVAR     VAR(&VALID) VALUE(%SST(&ODOBNM 5 6))
             CHGVAR     VAR(&CHR) VALUE(%SST(&VALID 1 1))
 
LOOP1:
             IF COND((&CNT *LE 6) *AND (&ERROR *EQ '0')) +
               THEN(DO)
 
               IF COND((&CHR *EQ '1') *OR (&CHR *EQ '2') +
                   *OR (&CHR *EQ '3') *OR (&CHR *EQ '4') +
                   *OR (&CHR *EQ '5') *OR (&CHR *EQ '6') +
                   *OR (&CHR *EQ '7') *OR (&CHR *EQ '8') +
                   *OR (&CHR *EQ '9') *OR (&CHR *EQ '0')) +
                 THEN(DO)
                   CHGVAR VAR(&CNT) VALUE(&CNT + 1)
                   IF COND(&CNT *LE 6) THEN(DO)
                     CHGVAR VAR(&CHR) VALUE(%SST(&VALID &CNT 1))
                   ENDDO
                   GOTO LOOP1
                 ENDDO
               ELSE (DO)
                 CHGVAR VAR(&ERROR) VALUE('1')
               ENDDO
               ENDDO
 
             IF COND(&ERROR *EQ '0') THEN(DO)
/************** DLTDTAQ DTAQ(&DPLIB/&ODOBNM)          */                /*CCI001*/
/************** DLTDTAQ DTAQ(&XLIB/&ODOBNM)                                    /*CCI001*/ /*CPK015*/
                DLTDTAQ    DTAQ(&ODOBNM)                                                  /*CPK015*/
                MONMSG  MSGID(CPF2105)
             ENDDO
 
             GOTO       CMDLBL(READ)
EOF:
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
               REC4408 ended abnormally - see job log') +
               TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
