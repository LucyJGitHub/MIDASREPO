/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Int. Accruals using N-T-R Extract')          */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Securities Trading Module                        */
/*                                                                   */
/*       SEC0910 - Midas SE Interest Accruals Using                  */
/*                 Net-Treasury-Report Extract                       */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD049139           Date 16Jun23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAS006  *CREATE    Date 21Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD049139 - Lending Fee are posting 1 day late for           */
/*                  auto settle fee on a calculated facility.        */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS006 - Hedge Accounting Phase B                           */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RSEQ &RLEV &RENT)                      */                 /*MD049139*/
             PGM        PARM(&RSEQ &RLEV &RENT &RUNCOND)                                /*MD049139*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RUNCOND) TYPE(*CHAR) LEN(6)                                /*MD049139*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD049139*/

/* Declare the variables to check the enhancements file */

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CAS006')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)

/* Send Pgm Message */

             CHGVAR     VAR(&MEM) VALUE('SEC0910 - Interest Accruals +
                          Report using Net-Treasury-Report Extract')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)

/* Clear switches */

             CHGJOB     SWS(00000000)

/** Determine if switchable feature CLE025 is switched ON then     */                   /*MD049139*/
/** check if program should run based on feature and parameter     */                   /*MD049139*/
                                                                                        /*MD049139*/
             RTVDTAARA  DTAARA(CLE025DTA) RTNVAR(&CLE025)                               /*MD049139*/
             IF         COND(((&CLE025 *EQ 'Y') *AND +
                              (&RUNCOND *EQ 'CLE025')) *OR +
                             ((&CLE025 *NE 'Y') *AND +
                              (&RUNCOND *NE 'CLE025'))) THEN(GOTO +
                        CMDLBL(ENDPGM))                                                 /*MD049139*/
                                                                                        /*MD049139*/
/* Check if enhancement CAS006 in installed */

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(ENDPGM))

/* If CAS006 is installed, clear output files */

               CLRPFM     FILE(IACNXD)

               CALL       PGM(SE0906)

/* If no errors on SE0906, call report program SE0907 */

               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)

/* Position file to the particular branch */

                 IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO)
                   OVRDBF     FILE(IACNX) POSITION(*KEY 1 IACNXDF &RENT)
                   OPNDBF     FILE(IACNX) OPTION(*ALL)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                     DLTOVR     FILE(IACNX)
                   ENDDO
                   CLOF       OPNID(IACNX)
                   MONMSG     MSGID(CPF0000)
                 ENDDO

                 CALL       PGM(SE0907) PARM(&RSEQ &RENT)
               ENDDO

/* Recover data from LDA for database error */

               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                             TOMSGQ(MOPERQ MRUNQ)
                  CHGVAR     VAR(&MEM) VALUE('SEC0910 - Job Terminated, +
                               Database in Error')
                  SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                  GOTO ENDPGM
               ENDDO

/* File controls out of balance */

               IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  CHGVAR     VAR(&MEM) VALUE('SEC0910 - File Controls +
                             out of Balance')
                  SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                  GOTO ENDPGM
               ENDDO

ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
