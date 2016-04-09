/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Control COB activity')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0512 - COB BATCH JOBS CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB012             Date 20May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 199151             Date 11Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      091688             DATE 10AUG95              */
/*                      S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB012 - Use 70 job streams in close of business.           */
/*       199151 - Incorrect parameter in call to QUSRJOBI results in */
/*                illegal characters being sent to screen, so that   */
/*                job crashes.  Replace with correct parameter.V5R1  */
/*       091688 - Rename the CBC0010 job to COBSCHED for ease        */
/*                of identification.                                 */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0512INT                                       */
/*                - CBC0512MPS                                       */
/*                - CBC0512MPE                                       */
/*                - CBC0512ERR                                       */
/*                - CBC0512END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MONI &SCED &ERROR)
 
/*/COPY WNCPYSRC,CBC0512INT                                          */
 
/* Declare variables to be returned */
 
             DCL        VAR(&MONI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCED) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
/* Declare work variables */
 
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(111)
/************DCL        VAR(&LENG) TYPE(*DEC) LEN(5 0)                                    /*199151*/
             DCL        VAR(&LENG) TYPE(*CHAR) LEN(4)                                     /*199151*/
             DCL        VAR(&INPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ACTY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&STS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INTR) TYPE(*CHAR) LEN(16)
/**********  DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(512) */                              /*CCB012*/
             DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(2000)                                /*CCB012*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*/COPY WNCPYSRC,CBC0512MPS                                          */
 
/* Access data area CBCTRL to read batch jobs information */
 
/**********  RTVDTAARA  DTAARA(CBCTRL (1 512)) RTNVAR(&CBCTRL) */                         /*CCB012*/
             RTVDTAARA  DTAARA(CBCTRL (1 2000)) RTNVAR(&CBCTRL)                           /*CCB012*/
 
/* Initialize work variables */
 
/************CHGVAR     VAR(&LENG) VALUE(111)                                             /*199151*/
             CHGVAR     VAR(%BIN(&LENG)) VALUE(111)                                       /*199151*/
             CHGVAR     VAR(&MONI) VALUE('N')
             CHGVAR     VAR(&SCED) VALUE('N')
             CHGVAR     VAR(%SST(&RTRN 1 111)) VALUE(' ')
             CHGVAR     VAR(%SST(&QUAL 1 26)) VALUE(' ')
             CHGVAR     VAR(%SST(&INTR 1 16)) VALUE(' ')
 
/* Request Work with Activity Information from API command */
 
             CHGVAR     VAR(&INPT) VALUE('JOBI0200')
 
/* Access job information for CBCMONB - Batch Monitor */
 
             CHGVAR     VAR(&QUAL) VALUE(%SST(&CBCTRL 1 26))
 
             IF         COND(%SST(&QUAL 1 26) *NE ' ') THEN(DO)
               CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT &QUAL +
                            &INTR)
               MONMSG     MSGID(CPF3C53) EXEC(CHGDTAARA DTAARA(CBCTRL +
                            (1 26)) VALUE(' '))
 
/* Avoid program failure if CBCMONB not active or not found */
/* Error message will be generated by RPG program */
 
               MONMSG     MSGID(CPF0000)
 
/* If the job is active return status to RPG program */
 
               IF         COND((%SST(&RTRN 51 8)) *EQ '*ACTIVE') +
                            THEN(CHGVAR VAR(&MONI) VALUE('Y'))
             ENDDO
 
/* Reinitialize work variables for next process */
 
             CHGVAR     VAR(%SST(&RTRN 1 111)) VALUE(' ')
             CHGVAR     VAR(%SST(&QUAL 1 26)) VALUE(' ')
             CHGVAR     VAR(%SST(&INTR 1 16)) VALUE(' ')
             CHGVAR     VAR(&INPT) VALUE('JOBI0200')
 
/**Retrieve*job*information*for*the*scheduler*-*CBC0010**/            /*091688*/
/* Retrieve job information for the scheduler - COBSCHED */           /*091688*/
 
             CHGVAR     VAR(&QUAL) VALUE(%SST(&CBCTRL 27 26))
 
             IF         COND(%SST(&QUAL 1 26) *NE ' ') THEN(DO)
               CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT &QUAL +
                            &INTR)
               MONMSG     MSGID(CPF3C53) EXEC(CHGDTAARA DTAARA(CBCTRL +
                            (27 26)) VALUE(' '))
 
/**Avoid*program*failure*if*CBC0010*not*active*or*not*found**/        /*091688*/
/* Avoid program failure if COBSCHED not active or not found */       /*091688*/
/* Error message will be generated by RPG program */
 
               MONMSG     MSGID(CPF0000)
 
               IF         COND((%SST(&RTRN 51 8)) *EQ '*ACTIVE') +
                            THEN(CHGVAR VAR(&SCED) VALUE('Y'))
             ENDDO
 
/*/COPY WNCPYSRC,CBC0512MPE                                          */
 
             GOTO       CMDLBL(ENDP)
ERROR:
/*/COPY WNCPYSRC,CBC0512ERR                                          */
 
/* No error should be fatal so just return error indicator on */
 
              CHGVAR     VAR(&ERROR) VALUE('E')
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0512END                                          */
 
             ENDPGM
