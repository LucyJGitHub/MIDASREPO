/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Country to Branch Tax Rates Rept.')          */
/********************************************************************/
/*                                                                  */
/*  Midas   Securities Trading Module                       */
/*                                                                  */
/*  SEC1980 - COUNTRY TO BRANCH TAX RATES REPORT                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01447                  DATE 10NOV93             */
/*  PREV AMEND NO. Ennnnn                  DATE DDMMMYY             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  S01447 - Program created for SE Withholding Tax enhancement.    */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTYP &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL       VAR(&MEM)    TYPE(*CHAR)  LEN(50)
             DCL       VAR(&LDA)    TYPE(*CHAR)  LEN(256)
             DCL       VAR(&RSEQ)   TYPE(*CHAR)  LEN(5)
             DCL       VAR(&RLEV)   TYPE(*CHAR)  LEN(1)
             DCL       VAR(&RTYP)   TYPE(*CHAR)  LEN(1)
             DCL       VAR(&RENT)   TYPE(*CHAR)  LEN(3)
/**/
             MONMSG MSGID(CPF0000 MCH0000 RPG0000) +
                         EXEC(GOTO CMDLBL(ERROR))
/**/
/* CLEAR SWITCHES */
             CHGJOB SWS(00000000)
 
/* IF PROGRAM  ALLED IN INPUT CYCLE */
 
             IF         COND((&RTYP *EQ 'I') *OR (&RTYP *EQ 'U')) +
                          THEN(DO)
/**/
/*  IF CREATE A TEMPORARY LDA                */
/**/
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(*BLANKS) TEXT('Temporary data area +
                          for SE1980 report pgm')
               MONMSG     MSGID(CPF1023)
               CALL       PGM(SE1980) PARM(&RTYP &RSEQ &RENT)
 
             ENDDO
/**/
/* IF AUDIT REPORT REQUESTED        */
 
             IF         COND(&RTYP *EQ 'A') THEN(DO)
 
             SNDPGMMSG  MSG('SEC1980 - Country to Branch Tax Rates +
                          Report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
               CALL       PGM(SE1980) PARM(&RTYP &RSEQ &RENT)
 
             ENDDO
/**/
/* IF COB REPORT REQUESTED        */
 
             IF         COND(&RTYP *EQ 'F') THEN(DO)
 
             SNDPGMMSG  MSG('SEC1980 - Country to Branch Tax Rates +
                          Report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
               CALL       PGM(SE1980) PARM(&RTYP &RSEQ &RENT)
 
             ENDDO
ERROR:
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('SEC1980 - Country to Branch Tax Rates +
                          Report terminated abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
