/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Margin Extract for Dummy Loans')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC315 - Margin profitability extract for dummy loans      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E49419             Date 11Jan93              */
/*                      BH3382             DATE 30Jul92              */
/*                      MOF60              DATE 23MAR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       E49419  -  LER315 has been re-instated for daily accruals   */
/*                  and LER316 is now called by LERC316              */
/*       BH3382  -  Changed to call new margin calculation program   */
/*                  LER316                                           */
/*                  Clear of ACTN3 moved in from CLP/LEC0604         */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
 
PGM  PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
     DCL VAR(&RTCD) TYPE(*CHAR) LEN(7)                                                    /*CLE134*/
     DCL VAR(&OPTN) TYPE(*CHAR) LEN(7)                                                    /*CLE134*/
     DCL VAR(&SAR)  TYPE(*CHAR) LEN(6)                                                    /*CLE134*/
     DCL VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                                /*CLE134*/
     DCL VAR(&CLE134) TYPE(*CHAR) LEN(1)  VALUE('N')                                      /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
     SNDPGMMSG  MSG('Margin Profitability Extract for Dummy Loans') +
                                       TOMSGQ(MRUNQ)
 
/* Check the current status of this component */
 
     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
     IF COND(&STAT *EQ 'Y') THEN(DO)
 
 
            CPYF FROMFILE(XLEPMGD) TOFILE(LEPEMGD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEMGD))
            CPYF FROMFILE(XLEPMGZ) TOFILE(LEPEMGZ) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(LEPEMGZ))
 
     ENDDO
 
     ELSE DO
 
/* Take Security Copy of Profitability Format Files */
 
     CPYF       FROMFILE(LEPEMGD) TOFILE(XLEPMGD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPMGD))
     CPYF       FROMFILE(LEPEMGZ) TOFILE(XLEPMGZ) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEPMGZ))
 
/* Set the status to failed (&STAT = Y) in case the program fails */
 
     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
     ENDDO
 
  /* Call Margin Extract Program */
 
  /*         CALL       LER315                                 BH3382*/
/************CALL*******LER316**********************BH3382*/ /*E49419*/
             CALL       LER315                               /*E49419*/
 
  /* IF ERROR, SEND MSG & COPY BACK SECURITY FILES     */
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') +
                           TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
     ELSE DO
 
/** Check if CLE134 is ON */                                                              /*CLE134*/
       CHGVAR     VAR(&SAR)  VALUE('CLE134')                                              /*CLE134*/
       CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                            /*CLE134*/
/**/                                                                                      /*CLE134*/
       IF         COND(&RTCD = '       ') +
                     THEN(CHGVAR VAR(&CLE134) VALUE('Y'))                                 /*CLE134*/
/**/                                                                                      /*CLE134*/
/** if car is on, then save ACTN3DH, DK, DN, ZX to work files */                          /*CLE134*/
/**/                                                                                      /*CLE134*/
       IF         COND(&CLE134  *EQ 'Y') THEN(DO)                                         /*CLE134*/
         CLRPFM     FILE(LEACT3DH)                                                        /*CLE134*/
         CLRPFM     FILE(LEACT3DN)                                                        /*CLE134*/
         CLRPFM     FILE(LEACT3DK)                                                        /*CLE134*/
         CLRPFM     FILE(LEACT3ZX)                                                        /*CLE134*/
/**/                                                                                      /*CLE134*/
         CPYF       FROMFILE(ACTN3DH) TOFILE(LEACT3DH) +
                       MBROPT(*REPLACE)                                                   /*CLE134*/
         MONMSG     MSGID(CPF2817 CPF2869)                                                /*CLE134*/
         CPYF       FROMFILE(ACTN3DN) TOFILE(LEACT3DN) +
                       MBROPT(*REPLACE)                                                   /*CLE134*/
         MONMSG     MSGID(CPF2817 CPF2869)                                                /*CLE134*/
         CPYF       FROMFILE(ACTN3DK) TOFILE(LEACT3DK) +
                       MBROPT(*REPLACE)                                                   /*CLE134*/
         MONMSG     MSGID(CPF2817 CPF2869)                                                /*CLE134*/
         CPYF       FROMFILE(ACTN3ZX) TOFILE(LEACT3ZX) +
                       MBROPT(*REPLACE)                                                   /*CLE134*/
         MONMSG     MSGID(CPF2817 CPF2869)                                                /*CLE134*/
       ENDDO                                                                              /*CLE134*/
/**/                                                                                      /*CLE134*/
                   CLRPFM     FILE(ACTN3DH)                /* BH3382 */
                   CLRPFM     FILE(ACTN3DK)                /* BH3382 */
                   CLRPFM     FILE(ACTN3DN)                /* BH3382 */
                   CLRPFM     FILE(ACTN3ZX)                /* BH3382 */
 
/* If the component has completed successfully reset the status field */
 
     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
