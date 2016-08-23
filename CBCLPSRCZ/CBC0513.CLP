/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Job control activity')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0513 - COB STREAMS ACTIVITY CONTROL                      */
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
/*                      S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB012 - Use 70 job streams.  Change to data areas CBRECV,  */
/*                CBTRAN and CBCTRL.                                 */
/*       199151 - Incorrect parameter in call to QUSRJOBI results in */
/*                illegal characters being sent to screen, so that   */
/*                job crashes.  Replace with correct parameter.V5R1  */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0513INT                                       */
/*                - CBC0513MPS                                       */
/*                - CBC0513MPE                                       */
/*                - CBC0513ERR                                       */
/*                - CBC0513END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NBR &ERROR)
 
/*/COPY WNCPYSRC,CBC0513INT                                          */
 
/* Declare variables to be returned */
 
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
 
/* Declare work variables */
 
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(111)
/*********** DCL        VAR(&STAT) TYPE(*CHAR) LEN(40) */                                 /*CCB012*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(280)                                   /*CCB012*/
             DCL        VAR(&INPT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ACTY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INTR) TYPE(*CHAR) LEN(16)
             DCL        VAR(&STS) TYPE(*CHAR) LEN(4)
/**********  DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(512) */                              /*CCB012*/
             DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(2000)                                /*CCB012*/
/**********  DCL        VAR(&CBRECV) TYPE(*CHAR) LEN(1024) */                             /*CCB012*/
             DCL        VAR(&CBRECV) TYPE(*CHAR) LEN(1099)                                /*CCB012*/
/************DCL        VAR(&LENG) TYPE(*DEC) LEN(5 0)                                    /*199151*/
             DCL        VAR(&LENG) TYPE(*CHAR) LEN(4)                                     /*199151*/
             DCL        VAR(&STREAM) TYPE(*DEC) LEN(2 0)
/*********** DCL        VAR(&X) TYPE(*DEC) LEN(3 0) */                                    /*CCB012*/
             DCL        VAR(&X) TYPE(*DEC) LEN(4 0)                                       /*CCB012*/
             DCL        VAR(&Y) TYPE(*DEC) LEN(2 0)
/*********** DCL        VAR(&Z) TYPE(*DEC) LEN(2 0) */                                    /*CCB012*/
             DCL        VAR(&Z) TYPE(*DEC) LEN(4 0)                                       /*CCB012*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  RTVDTAARA  DTAARA(CBCTRL (1 512)) RTNVAR(&CBCTRL) */                         /*CCB012*/
/**********  RTVDTAARA  DTAARA(CBRECV (1 1024)) RTNVAR(&CBRECV) */                        /*CCB012*/
             RTVDTAARA  DTAARA(CBCTRL (1 2000)) RTNVAR(&CBCTRL)                           /*CCB012*/
             RTVDTAARA  DTAARA(CBRECV (1 1099)) RTNVAR(&CBRECV)                           /*CCB012*/
 
/* Initialise work variables */
 
             CHGVAR     VAR(&STREAM) VALUE(&NBR)
             CHGVAR     VAR(&X) VALUE(53)
/************CHGVAR     VAR(&LENG) VALUE(111)                                             /*199151*/
             CHGVAR     VAR(%BIN(&LENG)) VALUE(111)                                       /*199151*/
             CHGVAR     VAR(&Y) VALUE(1)
             CHGVAR     VAR(&Z) VALUE(1)
 
/*/COPY WNCPYSRC,CBC0513MPS                                          */
 
LOOP:
/* Request Work with Jobs Activity from API command */
 
             CHGVAR     VAR(%SST(&RTRN 1 111)) VALUE(' ')
             CHGVAR     VAR(%SST(&QUAL 1 26)) VALUE(' ')
             CHGVAR     VAR(%SST(&INTR 1 16)) VALUE(' ')
             CHGVAR     VAR(&INPT) VALUE('JOBI0200')
 
/* Access job information */
 
             CHGVAR     VAR(&QUAL) VALUE(%SST(&CBCTRL &X 26))
 
             IF         COND((%SST(&QUAL 1 26)) *NE ' ') THEN(DO)
                CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT &QUAL +
                             &INTR)
                CHGVAR     VAR(&ACTY) VALUE(%SST(&RTRN 51 8))
                CHGVAR     VAR(&STS) VALUE(%SST(&RTRN 108 4))
                IF         COND(&STS *EQ '    ') THEN(CHGVAR +
                             VAR(&STS) VALUE('RUN '))
 
/* If the job is active then store job status */
 
                CHGVAR     VAR(%SST(&STAT &Z 4)) VALUE(&STS)
             ENDDO
 
/* Compute new position to access CBCCTRL              */
/* Increase position work field (Job + User + Job Nbr) */
 
             CHGVAR     VAR(&X) VALUE(&X + 26)
 
/* Compute new position to store status info */
/* The Job status is 4 char length          */
 
             CHGVAR     VAR(&Z) VALUE(&Y * 4)
             CHGVAR     VAR(&Z) VALUE(&Z + 1)
 
/* Increase counter */
 
             CHGVAR     VAR(&Y) VALUE(&Y + 1)
 
             IF         COND(&Y *GT &STREAM) THEN(GOTO CMDLBL(ENDLOOP))
 
             GOTO       CMDLBL(LOOP)
 
ENDLOOP:
/* Save Jobs status in data area */
 
/*********** CHGVAR     VAR(%SST(&CBRECV 809 40)) VALUE(&STAT) */                         /*CCB012*/
             CHGVAR     VAR(%SST(&CBRECV 809 280)) VALUE(&STAT)                           /*CCB012*/
             CHGDTAARA  DTAARA(CBRECV) VALUE(&CBRECV)
 
/*/COPY WNCPYSRC,CBC0513MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0513ERR                                          */
 
             CHGVAR     VAR(&ERROR) VALUE('E')
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0513END                                          */
 
             ENDPGM
